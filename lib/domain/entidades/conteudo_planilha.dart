import 'referencia_celula.dart';

/// Uma célula como foi lida do arquivo, para exibir na grade do wizard e para localizar
/// datas na estratégia por data.
class CelulaLida {
  /// Texto como a pessoa veria na planilha: datas e horas já formatadas.
  final String texto;

  /// `String`, `double`, `bool` ou nulo.
  final Object? valor;
  final bool temFormula;

  /// Número com formato de data ou hora: [valor] é um número de série do Excel.
  final bool ehDataHora;

  const CelulaLida({
    required this.texto,
    this.valor,
    this.temFormula = false,
    this.ehDataHora = false,
  });

  bool get vazia => texto.trim().isEmpty && !temFormula;
}

/// Região de células mescladas, como `A3:C3`.
class RegiaoMesclada {
  final ReferenciaCelula inicio;
  final ReferenciaCelula fim;

  const RegiaoMesclada(this.inicio, this.fim);

  bool contem(ReferenciaCelula ref) =>
      ref.linha >= inicio.linha &&
      ref.linha <= fim.linha &&
      ref.coluna >= inicio.coluna &&
      ref.coluna <= fim.coluna;
}

/// Uma aba lida do `.xlsx`, sem nenhuma dependência de pacote de planilha.
class AbaPlanilha {
  final String nome;

  /// Maior linha (base 1) e quantidade de colunas com conteúdo ou formatação declarada.
  final int totalLinhas;
  final int totalColunas;

  /// Células com valor, fórmula ou formato de data e hora (estas podem estar vazias).
  final Map<ReferenciaCelula, CelulaLida> celulas;
  final List<RegiaoMesclada> mesclagens;

  AbaPlanilha({
    required this.nome,
    required this.totalLinhas,
    required this.totalColunas,
    required Map<ReferenciaCelula, CelulaLida> celulas,
    List<RegiaoMesclada> mesclagens = const [],
  })  : celulas = Map.unmodifiable(celulas),
        mesclagens = List.unmodifiable(mesclagens);

  CelulaLida? celula(int linha, int coluna) => celulas[ReferenciaCelula(linha, coluna)];

  /// A região mesclada que contém a célula, se houver.
  RegiaoMesclada? mesclagemDe(ReferenciaCelula ref) {
    for (final regiao in mesclagens) {
      if (regiao.contem(ref)) return regiao;
    }
    return null;
  }

  String texto(int linha, int coluna) => celula(linha, coluna)?.texto ?? '';

  /// Última linha que tem algum texto ou fórmula; a grade não precisa ir além dela.
  int get ultimaLinhaComConteudo {
    var ultima = 0;
    for (final MapEntry(:key, :value) in celulas.entries) {
      if (!value.vazia && key.linha > ultima) ultima = key.linha;
    }
    return ultima;
  }

  /// Última coluna (base 0) que tem algum texto ou fórmula.
  int get ultimaColunaComConteudo {
    var ultima = -1;
    for (final MapEntry(:key, :value) in celulas.entries) {
      if (!value.vazia && key.coluna > ultima) ultima = key.coluna;
    }
    return ultima;
  }

  bool contem(ReferenciaCelula referencia) =>
      referencia.linha <= totalLinhas && referencia.coluna < totalColunas;
}

/// Estrutura de um `.xlsx`: suas abas e o sistema de datas da pasta de trabalho.
class EstruturaPlanilha {
  final List<AbaPlanilha> abas;

  /// Pastas criadas no Mac antigo contam os dias a partir de 1904.
  final bool sistemaData1904;

  EstruturaPlanilha({required List<AbaPlanilha> abas, this.sistemaData1904 = false})
      : abas = List.unmodifiable(abas);

  AbaPlanilha? aba(String nome) {
    for (final aba in abas) {
      if (aba.nome == nome) return aba;
    }
    return null;
  }
}
