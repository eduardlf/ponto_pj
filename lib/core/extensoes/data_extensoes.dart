/// Datas civis (docs/06, seção 6.1, e ADR-08).
///
/// Uma data de ponto é um fato civil, não um instante. Internamente ela é sempre um
/// `DateTime` à meia-noite UTC: assim, somar dias nunca esbarra em horário de verão nem em
/// mudança de fuso. O "agora" do relógio continua local; [DataCivil.apenasData] converte.
DateTime dataCivil(int ano, int mes, int dia) => DateTime.utc(ano, mes, dia);

/// Lê uma data no formato ISO `AAAA-MM-DD`. Devolve nulo para texto inválido.
DateTime? lerDataIso(String texto) {
  final partes = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(texto.trim());
  if (partes == null) return null;
  final ano = int.parse(partes.group(1)!);
  final mes = int.parse(partes.group(2)!);
  final dia = int.parse(partes.group(3)!);
  final data = dataCivil(ano, mes, dia);
  if (data.month != mes || data.day != dia) return null;
  return data;
}

extension DataCivil on DateTime {
  /// A data civil deste instante, à meia-noite UTC.
  DateTime get apenasData => DateTime.utc(year, month, day);

  DateTime somarDias(int dias) => DateTime.utc(year, month, day + dias);

  bool mesmoDia(DateTime outra) =>
      year == outra.year && month == outra.month && day == outra.day;

  /// Compara apenas a parte de data, ignorando hora e fuso.
  int compararData(DateTime outra) => apenasData.compareTo(outra.apenasData);

  bool antesDe(DateTime outra) => compararData(outra) < 0;

  bool depoisDe(DateTime outra) => compararData(outra) > 0;

  DateTime get primeiroDiaDoMes => DateTime.utc(year, month, 1);

  DateTime get ultimoDiaDoMes => DateTime.utc(year, month + 1, 0);

  /// Segunda-feira da semana desta data.
  DateTime get inicioDaSemana => apenasData.somarDias(1 - weekday);

  /// Quantidade de dias de [this] até [outra]; negativa quando [outra] vem antes.
  int diasAte(DateTime outra) => outra.apenasData.difference(apenasData).inDays;

  /// Texto ISO `AAAA-MM-DD`, o formato persistido no banco.
  String get iso => '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';

  /// Hora do dia em minutos desde a meia-noite. Segundos são descartados, nunca
  /// arredondados (docs/12, seção 12.1).
  Duration get horaDoDia => Duration(minutes: hour * 60 + minute);
}

/// Todas as datas de [inicio] a [fim], inclusive.
List<DateTime> datasEntre(DateTime inicio, DateTime fim) {
  final total = inicio.diasAte(fim);
  if (total < 0) return const [];
  return [for (var i = 0; i <= total; i++) inicio.apenasData.somarDias(i)];
}
