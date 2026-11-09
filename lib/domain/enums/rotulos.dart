import 'enums.dart';

/// Nomes em português de gente para os valores do domínio (docs/04, princípio 5). Usados
/// pela interface e pelas mensagens que nascem no domínio.

extension RotuloStatusDia on StatusDia {
  String get rotulo => switch (this) {
        StatusDia.normal => 'Normal',
        StatusDia.folga => 'Folga',
        StatusDia.feriado => 'Feriado',
        StatusDia.ferias => 'Férias',
        StatusDia.atestado => 'Atestado',
        StatusDia.falta => 'Falta',
        StatusDia.abono => 'Abono',
        StatusDia.compensacao => 'Compensação',
      };

  /// Texto padrão escrito na planilha para dias não trabalhados (TL-19).
  String get textoPadraoPlanilha => switch (this) {
        StatusDia.normal => '',
        StatusDia.folga => 'FOLGA',
        StatusDia.feriado => 'FERIADO',
        StatusDia.ferias => 'FÉRIAS',
        StatusDia.atestado => 'ATESTADO',
        StatusDia.falta => 'FALTA',
        StatusDia.abono => 'ABONO',
        StatusDia.compensacao => 'COMPENSAÇÃO',
      };
}

extension RotuloCampoColuna on CampoColuna {
  String get rotulo => switch (this) {
        CampoColuna.data => 'Data',
        CampoColuna.diaSemana => 'Dia da semana',
        CampoColuna.entrada1 => '1ª entrada',
        CampoColuna.saida1 => '1ª saída',
        CampoColuna.entrada2 => '2ª entrada',
        CampoColuna.saida2 => '2ª saída',
        CampoColuna.entrada3 => '3ª entrada',
        CampoColuna.saida3 => '3ª saída',
        CampoColuna.totalDia => 'Total do dia',
        CampoColuna.saldoDia => 'Saldo do dia',
        CampoColuna.observacao => 'Observação',
        CampoColuna.status => 'Status do dia',
      };
}

extension RotuloCampoCelulaFixa on CampoCelulaFixa {
  String get rotulo => switch (this) {
        CampoCelulaFixa.nome => 'Nome',
        CampoCelulaFixa.matricula => 'Matrícula',
        CampoCelulaFixa.cargo => 'Cargo',
        CampoCelulaFixa.empresa => 'Empresa',
        CampoCelulaFixa.mes => 'Mês',
        CampoCelulaFixa.ano => 'Ano',
        CampoCelulaFixa.competencia => 'Mês/ano',
        CampoCelulaFixa.totalMes => 'Total do mês',
        CampoCelulaFixa.saldoMes => 'Saldo do mês',
        CampoCelulaFixa.bancoHoras => 'Banco de horas',
        CampoCelulaFixa.dataGeracao => 'Data de geração',
        CampoCelulaFixa.textoLivre => 'Texto livre',
      };
}

extension RotuloFormatoData on FormatoData {
  /// Exemplo do resultado para 07/05/2026 (docs/10, seção 10.2).
  String get rotulo => switch (this) {
        FormatoData.ddMmAaaa => '07/05/2026',
        FormatoData.ddMm => '07/05',
        FormatoData.dd => '7',
        FormatoData.aaaaMmDd => '2026-05-07',
        FormatoData.dataExcel => 'Data do Excel',
      };
}

extension RotuloFormatoHora on FormatoHora {
  /// Exemplo do resultado para 8h30 (docs/10, seção 10.2).
  String get rotulo => switch (this) {
        FormatoHora.hhMm => '08:30',
        FormatoHora.hhMmSs => '08:30:00',
        FormatoHora.decimal => '8,5',
        FormatoHora.horaExcel => 'Hora do Excel',
      };
}

extension RotuloStatusEnvio on StatusEnvio {
  String get rotulo => switch (this) {
        StatusEnvio.pendente => 'Pendente',
        StatusEnvio.gerado => 'Gerado',
        StatusEnvio.enviado => 'Enviado',
        StatusEnvio.cancelado => 'Cancelado',
      };
}
