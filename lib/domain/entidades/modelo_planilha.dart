import 'package:collection/collection.dart';

import '../enums/enums.dart';

/// Valor que aparece uma única vez na planilha, endereçado por referência A1.
class CelulaFixa {
  final CampoCelulaFixa campo;

  /// Formato A1, ex.: `C3`.
  final String referencia;

  /// Conteúdo fixo, usado apenas quando [campo] é [CampoCelulaFixa.textoLivre].
  final String? valorLivre;

  const CelulaFixa({required this.campo, required this.referencia, this.valorLivre});

  @override
  bool operator ==(Object other) =>
      other is CelulaFixa &&
      other.campo == campo &&
      other.referencia == referencia &&
      other.valorLivre == valorLivre;

  @override
  int get hashCode => Object.hash(campo, referencia, valorLivre);
}

/// O arquivo `.xlsx` da empresa somado ao mapeamento que ensina o app a preenchê-lo
/// (docs/10, seção 10.2).
class ModeloPlanilha {
  final int? id;
  final String nome;
  final String caminhoArquivoBase;
  final String nomeArquivoOriginal;
  final String hashArquivo;
  final String nomeAba;

  /// Linhas em base 1.
  final int? linhaCabecalho;
  final int primeiraLinhaDados;
  final int? ultimaLinhaDados;
  final EstrategiaLinha estrategia;
  final FormatoData formatoData;
  final FormatoHora formatoHora;

  /// Dia do mês anterior em que o período da competência começa; 1 é o mês civil (RN-25).
  final int diaInicioCompetencia;

  /// Índice de coluna em base 0 por campo.
  final Map<CampoColuna, int> colunas;

  /// Texto lido do cabeçalho de cada coluna mapeada, para exibir e comparar.
  final Map<CampoColuna, String> rotulosCabecalho;
  final List<CelulaFixa> celulasFixas;
  final Map<StatusDia, String> textosStatus;
  final bool ativo;

  ModeloPlanilha({
    this.id,
    required this.nome,
    required this.caminhoArquivoBase,
    required this.nomeArquivoOriginal,
    required this.hashArquivo,
    required this.nomeAba,
    this.linhaCabecalho,
    required this.primeiraLinhaDados,
    this.ultimaLinhaDados,
    this.estrategia = EstrategiaLinha.sequencial,
    this.formatoData = FormatoData.ddMmAaaa,
    this.formatoHora = FormatoHora.hhMm,
    this.diaInicioCompetencia = 1,
    Map<CampoColuna, int> colunas = const {},
    Map<CampoColuna, String> rotulosCabecalho = const {},
    List<CelulaFixa> celulasFixas = const [],
    Map<StatusDia, String> textosStatus = const {},
    this.ativo = true,
  })  : colunas = Map.unmodifiable(colunas),
        rotulosCabecalho = Map.unmodifiable(rotulosCabecalho),
        celulasFixas = List.unmodifiable(celulasFixas),
        textosStatus = Map.unmodifiable(textosStatus);

  /// Verdadeiro escreve tudo como texto; falso usa valores nativos do Excel em pelo menos
  /// um dos formatos (`modelo_planilha.escrever_como_texto`).
  bool get escreverComoTexto => !formatoData.nativo && !formatoHora.nativo;

  /// Texto para o status, ou nulo quando nada deve ser escrito.
  String? textoDoStatus(StatusDia status) {
    final texto = textosStatus[status]?.trim();
    return texto == null || texto.isEmpty ? null : texto;
  }

  ModeloPlanilha copiaCom({
    int? id,
    String? nome,
    String? caminhoArquivoBase,
    String? nomeArquivoOriginal,
    String? hashArquivo,
    String? nomeAba,
    int? linhaCabecalho,
    bool limparLinhaCabecalho = false,
    int? primeiraLinhaDados,
    int? ultimaLinhaDados,
    bool limparUltimaLinhaDados = false,
    EstrategiaLinha? estrategia,
    FormatoData? formatoData,
    FormatoHora? formatoHora,
    int? diaInicioCompetencia,
    Map<CampoColuna, int>? colunas,
    Map<CampoColuna, String>? rotulosCabecalho,
    List<CelulaFixa>? celulasFixas,
    Map<StatusDia, String>? textosStatus,
    bool? ativo,
  }) {
    return ModeloPlanilha(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      caminhoArquivoBase: caminhoArquivoBase ?? this.caminhoArquivoBase,
      nomeArquivoOriginal: nomeArquivoOriginal ?? this.nomeArquivoOriginal,
      hashArquivo: hashArquivo ?? this.hashArquivo,
      nomeAba: nomeAba ?? this.nomeAba,
      linhaCabecalho: limparLinhaCabecalho ? null : (linhaCabecalho ?? this.linhaCabecalho),
      primeiraLinhaDados: primeiraLinhaDados ?? this.primeiraLinhaDados,
      ultimaLinhaDados:
          limparUltimaLinhaDados ? null : (ultimaLinhaDados ?? this.ultimaLinhaDados),
      estrategia: estrategia ?? this.estrategia,
      formatoData: formatoData ?? this.formatoData,
      formatoHora: formatoHora ?? this.formatoHora,
      diaInicioCompetencia: diaInicioCompetencia ?? this.diaInicioCompetencia,
      colunas: colunas ?? this.colunas,
      rotulosCabecalho: rotulosCabecalho ?? this.rotulosCabecalho,
      celulasFixas: celulasFixas ?? this.celulasFixas,
      textosStatus: textosStatus ?? this.textosStatus,
      ativo: ativo ?? this.ativo,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ModeloPlanilha &&
      other.id == id &&
      other.nome == nome &&
      other.caminhoArquivoBase == caminhoArquivoBase &&
      other.nomeArquivoOriginal == nomeArquivoOriginal &&
      other.hashArquivo == hashArquivo &&
      other.nomeAba == nomeAba &&
      other.linhaCabecalho == linhaCabecalho &&
      other.primeiraLinhaDados == primeiraLinhaDados &&
      other.ultimaLinhaDados == ultimaLinhaDados &&
      other.estrategia == estrategia &&
      other.formatoData == formatoData &&
      other.formatoHora == formatoHora &&
      other.diaInicioCompetencia == diaInicioCompetencia &&
      const MapEquality<CampoColuna, int>().equals(other.colunas, colunas) &&
      const MapEquality<CampoColuna, String>()
          .equals(other.rotulosCabecalho, rotulosCabecalho) &&
      const ListEquality<CelulaFixa>().equals(other.celulasFixas, celulasFixas) &&
      const MapEquality<StatusDia, String>().equals(other.textosStatus, textosStatus) &&
      other.ativo == ativo;

  @override
  int get hashCode => Object.hash(id, nome, hashArquivo, nomeAba, primeiraLinhaDados,
      estrategia, formatoData, formatoHora, diaInicioCompetencia, ativo);
}
