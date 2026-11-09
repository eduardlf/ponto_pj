import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

import '../../core/datas_excel.dart';
import '../../core/falhas.dart';
import '../../core/resultado.dart';
import '../../domain/contratos/contratos.dart';
import '../../domain/entidades/plano_de_escrita.dart';
import '../../domain/entidades/referencia_celula.dart';
import 'pacote_xlsx.dart';

/// Escrita cirúrgica do `.xlsx` (docs/10, seção 10.5, e ADR-05).
///
/// Descompacta em memória e altera apenas a aba do plano. `styles.xml`, `sharedStrings.xml`
/// e todas as outras abas saem byte a byte iguais, porque literalmente são os mesmos dados.
/// Além da aba, só três arquivos podem mudar, e só para as fórmulas recalcularem ao abrir:
/// `workbook.xml` recebe `fullCalcOnLoad="1"` e, se existir `calcChain.xml`, ele é removido
/// junto com sua entrada em `[Content_Types].xml` e em `workbook.xml.rels`.
class EscritorXlsxZip implements EscritorXlsx {
  const EscritorXlsxZip();

  @override
  Future<Resultado<ArquivoEscrito>> aplicar(Uint8List modeloBase, PlanoDeEscrita plano) async {
    try {
      return Sucesso(await Isolate.run(() => aplicarSincrono(modeloBase, plano)));
    } on FalhaEscritaPlanilha catch (falha) {
      return Erro(falha);
    } catch (erro) {
      return Erro(FalhaEscritaPlanilha(
          'Não consegui montar a planilha. O arquivo modelo pode estar danificado.',
          causa: erro));
    }
  }

  /// Versão síncrona, exposta para os testes. Lança [FalhaEscritaPlanilha].
  static ArquivoEscrito aplicarSincrono(Uint8List modeloBase, PlanoDeEscrita plano) {
    final pacote = PacoteXlsx.ler(modeloBase);
    final aba = pacote.abas().where((a) => a.nome == plano.nomeAba).firstOrNull;
    if (aba == null) {
      throw FalhaEscritaPlanilha('A aba "${plano.nomeAba}" não existe mais na planilha modelo. '
          'Configure a planilha de novo.');
    }

    final alterados = <String, Uint8List>{};
    final removidos = <String>{};

    final planilha = pacote.xmlDe(aba.caminho)!;
    final escrita = _EscritaAba(planilha, sistema1904: pacote.sistemaData1904);
    escrita.aplicar(plano.celulas);
    alterados[aba.caminho] = _serializar(planilha);

    final caminhoPastaTrabalho = pacote.caminhoPastaTrabalho;
    final pastaTrabalho = pacote.xmlDe(caminhoPastaTrabalho)!;
    _marcarRecalculo(pastaTrabalho);
    alterados[caminhoPastaTrabalho] = _serializar(pastaTrabalho);

    final cadeia = pacote.parteDoTipo(PacoteXlsx.tipoCadeiaCalculo) ??
        (pacote.entrada('xl/calcChain.xml') != null ? 'xl/calcChain.xml' : null);
    if (cadeia != null) {
      removidos.add(cadeia);
      final caminhoRels = 'xl/_rels/${caminhoPastaTrabalho.split('/').last}.rels';
      final rels = pacote.xmlDe(caminhoRels);
      if (rels != null) {
        rels.findAllElements('Relationship')
            .where((r) => r.getAttribute('Type') == PacoteXlsx.tipoCadeiaCalculo)
            .toList()
            .forEach((r) => r.remove());
        alterados[caminhoRels] = _serializar(rels);
      }
      final tipos = pacote.xmlDe('[Content_Types].xml')!;
      tipos.findAllElements('Override')
          .where((o) => o.getAttribute('PartName') == '/$cadeia')
          .toList()
          .forEach((o) => o.remove());
      alterados['[Content_Types].xml'] = _serializar(tipos);
    }

    final novo = Archive();
    for (final entrada in pacote.arquivo.files) {
      if (!entrada.isFile || removidos.contains(entrada.name)) continue;
      final conteudo = alterados[entrada.name] ?? pacote.bytesDe(entrada.name)!;
      novo.addFile(ArchiveFile(entrada.name, conteudo.length, conteudo));
    }
    final bytes = ZipEncoder().encode(novo);
    if (bytes == null) throw const FalhaEscritaPlanilha('Não consegui montar a planilha.');
    return ArquivoEscrito(Uint8List.fromList(bytes), avisos: escrita.avisos());
  }

  static Uint8List _serializar(XmlDocument documento) =>
      Uint8List.fromList(utf8.encode(documento.toXmlString()));

  /// Sem isto, o total do mês mostraria o valor em cache de quando o modelo foi salvo vazio.
  static void _marcarRecalculo(XmlDocument pastaTrabalho) {
    final raiz = pastaTrabalho.rootElement;
    final existente = raiz.childElements.where((e) => e.localName == 'calcPr').firstOrNull;
    if (existente != null) {
      existente.setAttribute('fullCalcOnLoad', '1');
      return;
    }
    // calcPr vem depois de sheets/definedNames e antes do restante, pela ordem do esquema.
    const antes = {'fileVersion', 'fileSharing', 'workbookPr', 'workbookProtection',
        'bookViews', 'sheets', 'functionGroups', 'externalReferences', 'definedNames'};
    final calcPr = XmlElement(XmlName('calcPr', raiz.name.prefix),
        [XmlAttribute(XmlName('fullCalcOnLoad'), '1')]);
    final filhos = raiz.children;
    var posicao = filhos.length;
    for (var i = 0; i < filhos.length; i++) {
      final filho = filhos[i];
      if (filho is XmlElement && !antes.contains(filho.localName)) {
        posicao = i;
        break;
      }
    }
    filhos.insert(posicao, calcPr);
  }
}

/// Aplica o plano sobre o XML de uma aba, preservando o atributo `s` (o estilo) de cada
/// célula existente e a ordem de linhas e colunas exigida pelo formato.
class _EscritaAba {
  final XmlDocument documento;
  final bool sistema1904;
  final String? _prefixo;
  final XmlElement _dados;
  final Map<int, XmlElement> _linhas = {};
  final Map<int, Map<int, XmlElement>> _celulas = {};
  final Map<String, List<XmlElement>> _formulasCompartilhadas = {};
  final List<String> _formulasSubstituidas = [];

  _EscritaAba(this.documento, {required this.sistema1904})
      : _prefixo = documento.rootElement.name.prefix,
        _dados = _sheetData(documento) {
    _indexar();
  }

  static XmlElement _sheetData(XmlDocument documento) {
    final dados = documento.findAllElements('sheetData', namespace: '*').firstOrNull;
    if (dados == null) throw const FormatException('Aba sem sheetData');
    return dados;
  }

  /// Monta os índices de linha e célula. Linhas e células sem `r` recebem o endereço
  /// implícito por extenso, para que novas inserções fiquem na posição certa.
  void _indexar() {
    var linhaImplicita = 0;
    for (final linha in _filhos(_dados, 'row')) {
      final numero = int.tryParse(linha.getAttribute('r') ?? '') ?? linhaImplicita + 1;
      linha.setAttribute('r', '$numero');
      linhaImplicita = numero;
      _linhas[numero] = linha;
      final porColuna = _celulas.putIfAbsent(numero, () => {});
      var colunaImplicita = -1;
      for (final c in _filhos(linha, 'c')) {
        final referencia = ReferenciaCelula.deA1(c.getAttribute('r') ?? '') ??
            ReferenciaCelula(numero, colunaImplicita + 1);
        c.setAttribute('r', referencia.a1);
        colunaImplicita = referencia.coluna;
        porColuna[referencia.coluna] = c;
        final formula = _filho(c, 'f');
        if (formula?.getAttribute('t') == 'shared' && formula?.getAttribute('si') != null) {
          _formulasCompartilhadas.putIfAbsent(formula!.getAttribute('si')!, () => []).add(c);
        }
      }
    }
  }

  void aplicar(Map<ReferenciaCelula, ValorCelula> celulas) {
    final ordenadas = celulas.keys.toList()..sort();
    for (final referencia in ordenadas) {
      _escrever(_celula(referencia), referencia, celulas[referencia]!);
    }
    if (ordenadas.isNotEmpty) _ampliarDimensao(ordenadas.first, ordenadas.last, ordenadas);
  }

  List<String> avisos() {
    if (_formulasSubstituidas.isEmpty) return const [];
    if (_formulasSubstituidas.length == 1) {
      return ['A célula ${_formulasSubstituidas.single} tinha uma fórmula, que foi substituída '
          'pelo valor do app.'];
    }
    final exemplos = _formulasSubstituidas.take(4).join(', ');
    final reticencias = _formulasSubstituidas.length > 4 ? '…' : '';
    return ['${_formulasSubstituidas.length} células tinham fórmulas, que foram substituídas '
        'pelos valores do app ($exemplos$reticencias).'];
  }

  XmlElement _celula(ReferenciaCelula referencia) {
    final linha = _linhas[referencia.linha] ?? _inserirLinha(referencia.linha);
    final porColuna = _celulas.putIfAbsent(referencia.linha, () => {});
    final existente = porColuna[referencia.coluna];
    if (existente != null) return existente;

    // Célula nova: entra na posição certa, em ordem crescente de coluna, sem estilo.
    final nova = XmlElement(_nome('c'), [XmlAttribute(XmlName('r'), referencia.a1)]);
    final seguinte = _filhos(linha, 'c').where((c) {
      final ref = ReferenciaCelula.deA1(c.getAttribute('r') ?? '');
      return ref != null && ref.coluna > referencia.coluna;
    }).firstOrNull;
    _inserirAntes(linha, nova, seguinte);
    porColuna[referencia.coluna] = nova;
    // "spans" é só uma dica de desempenho; com uma coluna nova ela pode ficar errada.
    linha.removeAttribute('spans');
    return nova;
  }

  XmlElement _inserirLinha(int numero) {
    final nova = XmlElement(_nome('row'), [XmlAttribute(XmlName('r'), '$numero')]);
    final seguinte = _filhos(_dados, 'row').where((r) {
      return (int.tryParse(r.getAttribute('r') ?? '') ?? 0) > numero;
    }).firstOrNull;
    _inserirAntes(_dados, nova, seguinte);
    _linhas[numero] = nova;
    return nova;
  }

  void _escrever(XmlElement celula, ReferenciaCelula referencia, ValorCelula valor) {
    final formula = _filho(celula, 'f');
    if (formula != null) {
      _formulasSubstituidas.add(referencia.a1);
      final si = formula.getAttribute('si');
      final mestre = formula.getAttribute('t') == 'shared' && formula.getAttribute('ref') != null;
      if (mestre && si != null) {
        // As dependentes de uma fórmula compartilhada só existem através da célula mestre:
        // sem ela, ficariam corrompidas. Viram valores fixos, com o último resultado.
        for (final dependente in _formulasCompartilhadas[si] ?? const <XmlElement>[]) {
          if (!identical(dependente, celula)) _filho(dependente, 'f')?.remove();
        }
      }
    }

    for (final nome in const ['f', 'v', 'is']) {
      _filhosTodos(celula, nome).forEach((e) => e.remove());
    }
    celula.removeAttribute('t');
    celula.removeAttribute('cm');
    celula.removeAttribute('vm');

    final extensoes = _filho(celula, 'extLst');
    switch (valor) {
      case TextoCelula(:final texto):
        celula.setAttribute('t', 'inlineStr');
        final t = XmlElement(_nome('t'), [
          if (texto.trim() != texto || texto.contains('\n'))
            XmlAttribute(XmlName('space', 'xml'), 'preserve'),
        ], [XmlText(texto)]);
        _inserirAntes(celula, XmlElement(_nome('is'), const [], [t]), extensoes);
      case NumeroCelula(valor: final numero):
        _inserirAntes(celula, _valor(numero), extensoes);
      case DataCelula(:final data):
        _inserirAntes(celula, _valor(serialDeData(data, sistema1904: sistema1904)), extensoes);
      case HoraCelula(:final hora):
        _inserirAntes(celula, _valor(fracaoDoDia(hora)), extensoes);
      case VaziaCelula():
        break;
    }
  }

  XmlElement _valor(num numero) {
    final texto = numero == numero.roundToDouble() && numero.abs() < 1e15
        ? numero.round().toString()
        : numero.toString();
    return XmlElement(_nome('v'), const [], [XmlText(texto)]);
  }

  /// Amplia `<dimension>` quando o plano escreve fora da área declarada.
  void _ampliarDimensao(
      ReferenciaCelula primeira, ReferenciaCelula ultima, List<ReferenciaCelula> todas) {
    final dimensao = documento.findAllElements('dimension', namespace: '*').firstOrNull;
    if (dimensao == null) return;
    final partes = (dimensao.getAttribute('ref') ?? '').split(':');
    final inicio = ReferenciaCelula.deA1(partes.first);
    final fim = ReferenciaCelula.deA1(partes.last);
    if (inicio == null || fim == null) return;

    var minLinha = inicio.linha, minColuna = inicio.coluna;
    var maxLinha = fim.linha, maxColuna = fim.coluna;
    for (final ref in todas) {
      if (ref.linha < minLinha) minLinha = ref.linha;
      if (ref.linha > maxLinha) maxLinha = ref.linha;
      if (ref.coluna < minColuna) minColuna = ref.coluna;
      if (ref.coluna > maxColuna) maxColuna = ref.coluna;
    }
    final novoInicio = ReferenciaCelula(minLinha, minColuna).a1;
    final novoFim = ReferenciaCelula(maxLinha, maxColuna).a1;
    final ref = novoInicio == novoFim ? novoInicio : '$novoInicio:$novoFim';
    if (ref != dimensao.getAttribute('ref')) dimensao.setAttribute('ref', ref);
  }

  XmlName _nome(String local) => XmlName(local, _prefixo);

  static Iterable<XmlElement> _filhos(XmlElement pai, String nome) =>
      pai.childElements.where((e) => e.localName == nome);

  static List<XmlElement> _filhosTodos(XmlElement pai, String nome) =>
      _filhos(pai, nome).toList();

  static XmlElement? _filho(XmlElement pai, String nome) => _filhos(pai, nome).firstOrNull;

  static void _inserirAntes(XmlElement pai, XmlElement novo, XmlElement? referencia) {
    if (referencia == null) {
      pai.children.add(novo);
    } else {
      pai.children.insert(pai.children.indexOf(referencia), novo);
    }
  }
}
