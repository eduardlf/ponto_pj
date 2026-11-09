import '../entidades/conteudo_planilha.dart';
import '../entidades/referencia_celula.dart';
import '../enums/enums.dart';
import '../enums/rotulos.dart';

/// Sugestões do wizard de planilha (docs/10, seção 10.3). Uma sugestão não é uma decisão:
/// ela existe para que o caso comum se resolva com um toque de confirmação.
class InferenciaPlanilha {
  const InferenciaPlanilha();

  /// Passo 2: a primeira linha com 3 ou mais textos é o cabeçalho.
  int? sugerirCabecalho(AbaPlanilha aba) {
    final limite = aba.ultimaLinhaComConteudo.clamp(0, 200);
    for (var linha = 1; linha <= limite; linha++) {
      var textos = 0;
      for (var coluna = 0; coluna < aba.totalColunas; coluna++) {
        final celula = aba.celula(linha, coluna);
        if (celula != null && !celula.temFormula && celula.valor is String &&
            celula.texto.trim().isNotEmpty) {
          textos++;
        }
      }
      if (textos >= 3) return linha;
    }
    return null;
  }

  /// Passo 2: a área de dados vai até o fim do bloco contínuo de linhas com conteúdo,
  /// fórmula ou formatação de data a partir da primeira; sem bloco, 31 linhas.
  int sugerirUltimaLinha(AbaPlanilha aba, int primeiraLinhaDados) {
    var ultima = primeiraLinhaDados - 1;
    for (var linha = primeiraLinhaDados; linha <= aba.totalLinhas; linha++) {
      var temAlgo = false;
      for (var coluna = 0; coluna < aba.totalColunas && !temAlgo; coluna++) {
        final celula = aba.celula(linha, coluna);
        temAlgo = celula != null && (!celula.vazia || celula.ehDataHora);
      }
      if (!temAlgo) break;
      ultima = linha;
    }
    return ultima >= primeiraLinhaDados ? ultima : primeiraLinhaDados + 30;
  }

  /// Passo 3: associa campos a colunas pelo texto do cabeçalho, sem acento e sem caixa.
  /// Colunas com fórmula na área de dados nunca são sugeridas: escrever nelas apagaria o
  /// cálculo da empresa.
  Map<CampoColuna, int> sugerirColunas(AbaPlanilha aba,
      {required int linhaCabecalho, required int primeiraLinhaDados, int? ultimaLinhaDados}) {
    final sugestao = <CampoColuna, int>{};
    final entradas = <int>[];
    final saidas = <int>[];
    int? colunaDia;

    for (var coluna = 0; coluna < aba.totalColunas; coluna++) {
      final texto = normalizar(aba.texto(linhaCabecalho, coluna));
      if (texto.isEmpty) continue;
      if (_temFormulaNaArea(aba, coluna, primeiraLinhaDados, ultimaLinhaDados)) continue;

      if (texto == 'data' || texto.startsWith('data ') || texto == 'dt') {
        sugestao.putIfAbsent(CampoColuna.data, () => coluna);
      } else if (texto == 'dia') {
        colunaDia ??= coluna;
      } else if (RegExp(r'^(ent|e \d|e\d)').hasMatch(texto)) {
        entradas.add(coluna);
      } else if (RegExp(r'^(sai|s \d|s\d)').hasMatch(texto)) {
        saidas.add(coluna);
      } else if (texto.startsWith('saldo')) {
        sugestao.putIfAbsent(CampoColuna.saldoDia, () => coluna);
      } else if (texto.startsWith('total') && !texto.contains('mes')) {
        sugestao.putIfAbsent(CampoColuna.totalDia, () => coluna);
      } else if (texto.startsWith('obs')) {
        sugestao.putIfAbsent(CampoColuna.observacao, () => coluna);
      } else if (texto == 'status' || texto.startsWith('situacao') ||
          texto.startsWith('ocorrencia')) {
        sugestao.putIfAbsent(CampoColuna.status, () => coluna);
      } else if (const {'sem', 'semana', 'dia sem', 'dia semana', 'dia da semana'}
          .contains(texto)) {
        sugestao.putIfAbsent(CampoColuna.diaSemana, () => coluna);
      }
    }

    // "Dia" sozinho é a data quando não há outra coluna de data.
    if (!sugestao.containsKey(CampoColuna.data) && colunaDia != null) {
      sugestao[CampoColuna.data] = colunaDia;
    }
    const camposEntrada = [CampoColuna.entrada1, CampoColuna.entrada2, CampoColuna.entrada3];
    const camposSaida = [CampoColuna.saida1, CampoColuna.saida2, CampoColuna.saida3];
    for (var i = 0; i < entradas.length && i < 3; i++) {
      sugestao[camposEntrada[i]] = entradas[i];
    }
    for (var i = 0; i < saidas.length && i < 3; i++) {
      sugestao[camposSaida[i]] = saidas[i];
    }
    return sugestao;
  }

  /// Passo 4: células fixas pelos rótulos acima da tabela ("Nome:", "Matrícula:"...). A
  /// sugestão é a primeira célula vazia à direita do rótulo, pulando a mesclagem dele.
  Map<CampoCelulaFixa, String> sugerirCelulasFixas(AbaPlanilha aba, {required int ateLinha}) {
    final sugestao = <CampoCelulaFixa, String>{};
    for (var linha = 1; linha <= ateLinha; linha++) {
      for (var coluna = 0; coluna < aba.totalColunas; coluna++) {
        final celula = aba.celula(linha, coluna);
        if (celula == null || celula.valor is! String) continue;
        final campo = _campoDoRotulo(normalizar(celula.texto));
        if (campo == null || sugestao.containsKey(campo)) continue;

        final rotulo = ReferenciaCelula(linha, coluna);
        var proxima = (aba.mesclagemDe(rotulo)?.fim.coluna ?? coluna) + 1;
        while (proxima < aba.totalColunas) {
          final alvo = aba.celula(linha, proxima);
          if (alvo == null || (alvo.vazia && !alvo.temFormula)) {
            sugestao[campo] = ReferenciaCelula(linha, proxima).a1;
            break;
          }
          if (alvo.temFormula) break;
          proxima = (aba.mesclagemDe(ReferenciaCelula(linha, proxima))?.fim.coluna ?? proxima) + 1;
        }
      }
    }
    return sugestao;
  }

  /// Passo 4: valores nativos do Excel quando as células de destino já estão formatadas
  /// como data e hora — é o que mantém funcionando as fórmulas da empresa sobre os horários.
  ({FormatoData data, FormatoHora hora}) sugerirFormatos(
      AbaPlanilha aba, Map<CampoColuna, int> colunas, int primeiraLinhaDados) {
    bool formatada(CampoColuna campo) {
      final coluna = colunas[campo];
      return coluna != null && (aba.celula(primeiraLinhaDados, coluna)?.ehDataHora ?? false);
    }

    return (
      data: formatada(CampoColuna.data) ? FormatoData.dataExcel : FormatoData.ddMmAaaa,
      hora: formatada(CampoColuna.entrada1) ? FormatoHora.horaExcel : FormatoHora.hhMm,
    );
  }

  /// Textos padrão para os dias não trabalhados. Ficam em branco quando iriam parar sobre
  /// uma coluna de hora nativa do Excel, porque texto ali quebra a soma das horas.
  Map<StatusDia, String> sugerirTextosStatus(Map<CampoColuna, int> colunas, FormatoHora hora) {
    final vaiParaHoraNativa = !colunas.containsKey(CampoColuna.status) && hora.nativo;
    return {
      for (final status in StatusDia.values)
        if (status != StatusDia.normal)
          status: vaiParaHoraNativa ? '' : status.textoPadraoPlanilha,
    };
  }

  bool _temFormulaNaArea(AbaPlanilha aba, int coluna, int primeira, int? ultima) {
    final fim = ultima ?? (primeira + 30).clamp(primeira, aba.totalLinhas);
    for (var linha = primeira; linha <= fim; linha++) {
      if (aba.celula(linha, coluna)?.temFormula ?? false) return true;
    }
    return false;
  }

  CampoCelulaFixa? _campoDoRotulo(String rotulo) {
    if (rotulo.isEmpty || rotulo.length > 40) return null;
    if (rotulo == 'nome' || rotulo.startsWith('nome ') || rotulo == 'funcionario' ||
        rotulo == 'colaborador' || rotulo == 'empregado') {
      return CampoCelulaFixa.nome;
    }
    if (rotulo.startsWith('matricula') || rotulo.startsWith('codigo') || rotulo == 'cod' ||
        rotulo == 'chapa' || rotulo == 'registro') {
      return CampoCelulaFixa.matricula;
    }
    if (rotulo == 'cargo' || rotulo == 'funcao') return CampoCelulaFixa.cargo;
    if (rotulo == 'empresa' || rotulo.startsWith('razao social')) return CampoCelulaFixa.empresa;
    if (rotulo.startsWith('competencia') || rotulo == 'mes ano' || rotulo == 'periodo' ||
        rotulo.startsWith('mes de referencia') || rotulo == 'referencia') {
      return CampoCelulaFixa.competencia;
    }
    if (rotulo == 'mes') return CampoCelulaFixa.mes;
    if (rotulo == 'ano') return CampoCelulaFixa.ano;
    return null;
  }

  /// `"SAÍD. 1:"` → `"said 1"`.
  static String normalizar(String texto) {
    const deAcento = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
    const semAcento = 'aaaaaeeeeiiiiooooouuuucn';
    final minusculo = texto.toLowerCase();
    final buffer = StringBuffer();
    for (final caractere in minusculo.split('')) {
      final indice = deAcento.indexOf(caractere);
      buffer.write(indice >= 0 ? semAcento[indice] : caractere);
    }
    return buffer
        .toString()
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
