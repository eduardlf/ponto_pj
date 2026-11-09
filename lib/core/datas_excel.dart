/// Conversões entre datas e horas e os números que o Excel usa por baixo da formatação.
///
/// Data é um número de série de dias; hora do dia é a fração do dia (0,5 é 12:00).
library;

final _base1900 = DateTime.utc(1899, 12, 30);
final _base1904 = DateTime.utc(1904, 1, 1);

/// 07/05/2026 → 46149 no sistema de 1900, o padrão do Excel no Windows.
int serialDeData(DateTime data, {bool sistema1904 = false}) {
  final civil = DateTime.utc(data.year, data.month, data.day);
  return civil.difference(sistema1904 ? _base1904 : _base1900).inDays;
}

/// Inverso de [serialDeData]; a parte fracionária (hora) é descartada.
DateTime dataDeSerial(num serial, {bool sistema1904 = false}) {
  final base = sistema1904 ? _base1904 : _base1900;
  return DateTime.utc(base.year, base.month, base.day + serial.floor());
}

/// 08:30 → 0,354166…
double fracaoDoDia(Duration duracao) => duracao.inMinutes / (24 * 60);

/// Inverso de [fracaoDoDia], arredondado ao minuto.
Duration duracaoDeFracao(num fracao) => Duration(minutes: (fracao * 24 * 60).round());
