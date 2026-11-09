import 'dart:isolate';
import 'dart:typed_data';

import 'package:xml/xml.dart';

import '../../core/datas_excel.dart';
import '../../core/falhas.dart';
import '../../core/formatadores.dart';
import '../../core/resultado.dart';
import '../../domain/contratos/contratos.dart';
import '../../domain/entidades/conteudo_planilha.dart';
import '../../domain/entidades/referencia_celula.dart';
import 'pacote_xlsx.dart';

/// Lê abas, dimensões e células de um `.xlsx` direto do XML, com `archive` e `xml` — os
/// mesmos pacotes da escrita (ADR-11). Não depende de pacote de planilha de alto nível.
class LeitorPlanilhaXml implements LeitorPlanilha {
  const LeitorPlanilhaXml();

  static const mensagemXls = 'Este arquivo é .xls, um formato antigo do Excel. Abra no Excel '
      'e salve como .xlsx para continuar.';
  static const mensagemIlegivel =
      'Não consegui ler esta planilha. Ela pode estar protegida por senha ou danificada.';
  static const mensagemVazia = 'Esta planilha está vazia.';

  @override
  Future<Resultado<EstruturaPlanilha>> ler(Uint8List bytes, {String? nomeArquivo}) async {
    final nome = nomeArquivo?.toLowerCase() ?? '';
    if (nome.endsWith('.xls')) return const Erro(FalhaFormatoPlanilha(mensagemXls));
    if (!PacoteXlsx.pareceZip(bytes)) {
      return const Erro(FalhaFormatoPlanilha(mensagemIlegivel));
    }
    try {
      final estrutura = await Isolate.run(() => lerEstrutura(bytes));
      if (estrutura.abas.every((aba) => aba.celulas.values.every((c) => c.vazia))) {
        return const Erro(FalhaFormatoPlanilha(mensagemVazia));
      }
      return Sucesso(estrutura);
    } catch (erro) {
      return Erro(FalhaFormatoPlanilha(mensagemIlegivel, causa: erro));
    }
  }

  /// Leitura síncrona, exposta para os testes e para quem já está fora da thread de UI.
  static EstruturaPlanilha lerEstrutura(Uint8List bytes) {
    final pacote = PacoteXlsx.ler(bytes);
    final sistema1904 = pacote.sistemaData1904;
    final textos = _lerTextosCompartilhados(pacote);
    final formatos = _lerFormatosDeData(pacote);

    return EstruturaPlanilha(
      sistemaData1904: sistema1904,
      abas: [
        for (final aba in pacote.abas())
          _lerAba(aba.nome, pacote.xmlDe(aba.caminho), textos, formatos, sistema1904),
      ],
    );
  }

  static List<String> _lerTextosCompartilhados(PacoteXlsx pacote) {
    final caminho = pacote.parteDoTipo(PacoteXlsx.tipoTextos) ?? 'xl/sharedStrings.xml';
    final documento = pacote.xmlDe(caminho);
    if (documento == null) return const [];
    return [
      for (final si in documento.rootElement.childElements.where((e) => e.localName == 'si'))
        _textoDeItem(si),
    ];
  }

  /// O texto de um item é o `<t>` direto ou a soma dos `<t>` de cada trecho `<r>`; o texto
  /// fonético (`<rPh>`) fica de fora.
  static String _textoDeItem(XmlElement item) {
    final texto = StringBuffer();
    for (final filho in item.childElements) {
      if (filho.localName == 't') {
        texto.write(filho.innerText);
      } else if (filho.localName == 'r') {
        for (final t in filho.childElements.where((e) => e.localName == 't')) {
          texto.write(t.innerText);
        }
      }
    }
    return texto.toString();
  }

  /// Para cada índice de estilo de célula, se o número é data, hora ou duração.
  static Map<int, _TipoNumero> _lerFormatosDeData(PacoteXlsx pacote) {
    final caminho = pacote.parteDoTipo(PacoteXlsx.tipoEstilos) ?? 'xl/styles.xml';
    final documento = pacote.xmlDe(caminho);
    if (documento == null) return const {};

    final personalizados = <int, String>{
      for (final formato in documento.findAllElements('numFmt', namespace: '*'))
        if (int.tryParse(formato.getAttribute('numFmtId') ?? '') case final id?)
          id: formato.getAttribute('formatCode') ?? '',
    };
    final xfs = documento.findAllElements('cellXfs', namespace: '*').firstOrNull;
    if (xfs == null) return const {};

    final tipos = <int, _TipoNumero>{};
    var indice = 0;
    for (final xf in xfs.childElements.where((e) => e.localName == 'xf')) {
      final id = int.tryParse(xf.getAttribute('numFmtId') ?? '0') ?? 0;
      final tipo = _classificarFormato(id, personalizados[id]);
      if (tipo != _TipoNumero.numero) tipos[indice] = tipo;
      indice++;
    }
    return tipos;
  }

  static _TipoNumero _classificarFormato(int id, String? codigo) {
    if (codigo == null) {
      if (id >= 14 && id <= 17) return _TipoNumero.data;
      if (id == 22) return _TipoNumero.dataHora;
      if (id >= 18 && id <= 21 || id == 45 || id == 47) return _TipoNumero.hora;
      if (id == 46) return _TipoNumero.duracao;
      return _TipoNumero.numero;
    }
    // Ignora textos entre aspas, caracteres escapados e seções entre colchetes que não são
    // de tempo decorrido, como [Red] ou [$-416].
    final limpo = codigo
        .replaceAll(RegExp(r'"[^"]*"'), '')
        .replaceAll(RegExp(r'\\.'), '')
        .replaceAll(RegExp(r'\[(?![hHmMsS]+\])[^\]]*\]'), '')
        .toLowerCase();
    if (limpo.contains('general') && !RegExp('[dyhs]').hasMatch(limpo)) {
      return _TipoNumero.numero;
    }
    if (RegExp(r'\[h+\]|\[m+\]').hasMatch(limpo)) return _TipoNumero.duracao;
    final temData = RegExp('[dy]').hasMatch(limpo);
    final temHora = RegExp('[hs]').hasMatch(limpo);
    if (temData && temHora) return _TipoNumero.dataHora;
    if (temData) return _TipoNumero.data;
    if (temHora) return _TipoNumero.hora;
    if (limpo.contains('m')) return _TipoNumero.data; // mm/yyyy já caiu acima; "mmm" sozinho
    return _TipoNumero.numero;
  }

  static AbaPlanilha _lerAba(String nome, XmlDocument? documento, List<String> textos,
      Map<int, _TipoNumero> formatos, bool sistema1904) {
    if (documento == null) {
      return AbaPlanilha(nome: nome, totalLinhas: 0, totalColunas: 0, celulas: const {});
    }

    var maxLinha = 0;
    var maxColuna = -1;
    final dimensao = documento.findAllElements('dimension', namespace: '*').firstOrNull;
    final faixa = dimensao?.getAttribute('ref')?.split(':');
    if (faixa != null) {
      final fim = ReferenciaCelula.deA1(faixa.last);
      if (fim != null) {
        maxLinha = fim.linha;
        maxColuna = fim.coluna;
      }
    }

    final celulas = <ReferenciaCelula, CelulaLida>{};
    final dados = documento.findAllElements('sheetData', namespace: '*').firstOrNull;
    var linhaImplicita = 0;
    for (final linha in dados?.childElements.where((e) => e.localName == 'row') ?? <XmlElement>[]) {
      final numeroLinha = int.tryParse(linha.getAttribute('r') ?? '') ?? linhaImplicita + 1;
      linhaImplicita = numeroLinha;
      var colunaImplicita = -1;
      for (final c in linha.childElements.where((e) => e.localName == 'c')) {
        final referencia = ReferenciaCelula.deA1(c.getAttribute('r') ?? '') ??
            ReferenciaCelula(numeroLinha, colunaImplicita + 1);
        colunaImplicita = referencia.coluna;
        if (referencia.linha > maxLinha) maxLinha = referencia.linha;
        if (referencia.coluna > maxColuna) maxColuna = referencia.coluna;

        final celula = _lerCelula(c, textos, formatos, sistema1904);
        if (celula != null) celulas[referencia] = celula;
      }
    }

    final mesclagens = <RegiaoMesclada>[
      for (final regiao in documento.findAllElements('mergeCell', namespace: '*'))
        if (regiao.getAttribute('ref')?.split(':') case [final de, final ate]
            when ReferenciaCelula.deA1(de) != null && ReferenciaCelula.deA1(ate) != null)
          RegiaoMesclada(ReferenciaCelula.deA1(de)!, ReferenciaCelula.deA1(ate)!),
    ];

    return AbaPlanilha(
      nome: nome,
      totalLinhas: maxLinha,
      totalColunas: maxColuna + 1,
      celulas: celulas,
      mesclagens: mesclagens,
    );
  }

  static CelulaLida? _lerCelula(
      XmlElement c, List<String> textos, Map<int, _TipoNumero> formatos, bool sistema1904) {
    final tipo = c.getAttribute('t');
    final temFormula = c.childElements.any((e) => e.localName == 'f');
    final valorTexto = c.childElements.where((e) => e.localName == 'v').firstOrNull?.innerText;

    switch (tipo) {
      case 's':
        final indice = int.tryParse(valorTexto ?? '');
        final texto = indice != null && indice < textos.length ? textos[indice] : '';
        return CelulaLida(texto: texto, valor: texto, temFormula: temFormula);
      case 'inlineStr':
        final item = c.childElements.where((e) => e.localName == 'is').firstOrNull;
        final texto = item == null ? '' : _textoDeItem(item);
        return CelulaLida(texto: texto, valor: texto, temFormula: temFormula);
      case 'str':
        return CelulaLida(texto: valorTexto ?? '', valor: valorTexto, temFormula: temFormula);
      case 'b':
        return CelulaLida(
            texto: valorTexto == '1' ? 'VERDADEIRO' : 'FALSO',
            valor: valorTexto == '1',
            temFormula: temFormula);
      case 'e':
        return CelulaLida(texto: valorTexto ?? '#ERRO', valor: valorTexto, temFormula: temFormula);
    }

    final estilo = int.tryParse(c.getAttribute('s') ?? '0') ?? 0;
    final formato = formatos[estilo] ?? _TipoNumero.numero;
    if (valorTexto == null || valorTexto.isEmpty) {
      // Célula vazia, mas já formatada como data ou hora: o wizard usa isso para sugerir
      // a escrita em valor nativo do Excel.
      if (temFormula || formato != _TipoNumero.numero) {
        return CelulaLida(
            texto: '', temFormula: temFormula, ehDataHora: formato != _TipoNumero.numero);
      }
      return null;
    }
    final numero = double.tryParse(valorTexto);
    if (numero == null) {
      return CelulaLida(texto: valorTexto, valor: valorTexto, temFormula: temFormula);
    }
    return CelulaLida(
      texto: _exibirNumero(numero, formato, sistema1904),
      valor: numero,
      temFormula: temFormula,
      ehDataHora: formato != _TipoNumero.numero,
    );
  }

  static String _exibirNumero(double numero, _TipoNumero formato, bool sistema1904) {
    switch (formato) {
      case _TipoNumero.data:
        return formatarDataCurta(dataDeSerial(numero, sistema1904: sistema1904));
      case _TipoNumero.hora:
        return formatarHora(duracaoDeFracao(numero - numero.floor()));
      case _TipoNumero.dataHora:
        return '${formatarDataCurta(dataDeSerial(numero, sistema1904: sistema1904))} '
            '${formatarHora(duracaoDeFracao(numero - numero.floor()))}';
      case _TipoNumero.duracao:
        return formatarDuracaoRelogio(duracaoDeFracao(numero));
      case _TipoNumero.numero:
        if (numero == numero.roundToDouble() && numero.abs() < 1e15) {
          return numero.toInt().toString();
        }
        return numero.toString().replaceAll('.', ',');
    }
  }
}

enum _TipoNumero { numero, data, hora, dataHora, duracao }
