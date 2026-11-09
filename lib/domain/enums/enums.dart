/// Enumerações do domínio (docs/06, seção 6.3).
///
/// Os valores seguem a convenção do Dart (`porData`); no banco eles são gravados com o nome
/// da constante em caixa alta (`POR_DATA`), pelo conversor de `data/local/conversores.dart`.
library;

enum StatusDia {
  normal,
  folga,
  feriado,
  ferias,
  atestado,
  falta,
  abono,
  compensacao;

  /// Status em que a carga prevista é abonada (RN-12).
  bool get abonaCarga => switch (this) {
        folga || feriado || ferias || atestado || abono => true,
        normal || falta || compensacao => false,
      };
}

enum TipoMarcacao { entrada, saida }

enum OrigemMarcacao { automatica, manual, importada }

enum EstrategiaLinha { sequencial, porData }

/// Campos escritos uma vez por dia, cada um em uma coluna da planilha.
enum CampoColuna {
  data,
  diaSemana,
  entrada1,
  saida1,
  entrada2,
  saida2,
  entrada3,
  saida3,
  totalDia,
  saldoDia,
  observacao,
  status;

  /// Colunas de horário, na ordem em que as marcações são escritas.
  static const horarios = [entrada1, saida1, entrada2, saida2, entrada3, saida3];
}

enum CampoCelulaFixa {
  nome,
  matricula,
  cargo,
  empresa,
  mes,
  ano,
  competencia,
  totalMes,
  saldoMes,
  bancoHoras,
  dataGeracao,
  textoLivre,
}

enum StatusEnvio { pendente, gerado, enviado, cancelado }

enum TipoNotificacao {
  inicioJornada,
  inicioIntervalo,
  fimIntervalo,
  fimJornada,
  diaIncompleto,
  fechamentoMes,
}

enum AbrangenciaFeriado { nacional, estadual, municipal, empresa }

/// Existe apenas no domínio: pendências são calculadas na leitura e nunca persistidas.
enum TipoPendencia { marcacoesIncompletas, diaUtilSemRegistro, faltaComMarcacoes }

enum FormatoData {
  ddMmAaaa,
  ddMm,
  dd,
  aaaaMmDd,
  dataExcel;

  bool get nativo => this == dataExcel;
}

enum FormatoHora {
  hhMm,
  hhMmSs,
  decimal,
  horaExcel;

  bool get nativo => this == horaExcel;
}
