/// Formatação em português do Brasil (docs/12, seção 12.10).
///
/// Nenhum widget monta string de data, hora ou duração por conta própria: tudo passa por
/// aqui. Os nomes de dias e meses são literais, sem depender de inicialização de locale.
library;

const _mesesExtenso = [
  'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho', //
  'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
];

const _mesesAbreviados = [
  'jan.', 'fev.', 'mar.', 'abr.', 'mai.', 'jun.', //
  'jul.', 'ago.', 'set.', 'out.', 'nov.', 'dez.',
];

/// Índice 0 é segunda-feira, como em `DateTime.weekday - 1`.
const _diasSemanaAbreviados = ['seg.', 'ter.', 'qua.', 'qui.', 'sex.', 'sáb.', 'dom.'];

const _diasSemanaExtenso = [
  'segunda-feira', 'terça-feira', 'quarta-feira', 'quinta-feira', //
  'sexta-feira', 'sábado', 'domingo',
];

String _doisDigitos(int valor) => valor.toString().padLeft(2, '0');

/// 510 min → `08h 30m`. Nunca transborda para dias: 1500 min → `25h 00m`.
/// Duração negativa recebe o sinal, porque ela nunca aparece sem sinal na interface.
String formatarDuracao(Duration d) {
  final minutos = d.inMinutes;
  final texto = '${_doisDigitos(minutos.abs() ~/ 60)}h ${_doisDigitos(minutos.abs() % 60)}m';
  return minutos < 0 ? '- $texto' : texto;
}

/// +30 min → `+ 00h 30m`; −75 min → `- 01h 15m`; zero → `00h 00m`, sem sinal.
String formatarDuracaoComSinal(Duration d) {
  final minutos = d.inMinutes;
  if (minutos == 0) return formatarDuracao(Duration.zero);
  final texto = formatarDuracao(Duration(minutes: minutos.abs()));
  return minutos > 0 ? '+ $texto' : '- $texto';
}

/// Hora do dia: 510 min → `08:30`. Valores fora de 0–23:59 dão a volta no relógio.
String formatarHora(Duration horaDoDia) {
  final minutos = horaDoDia.inMinutes % (24 * 60);
  return '${_doisDigitos(minutos ~/ 60)}:${_doisDigitos(minutos % 60)}';
}

/// Relógio vivo: `17:30:22`.
String formatarHoraComSegundos(DateTime instante) =>
    '${_doisDigitos(instante.hour)}:${_doisDigitos(instante.minute)}:'
    '${_doisDigitos(instante.second)}';

/// Duração como relógio, sem limite de 24 h: `08:30`, `172:20`, `-00:30`, `08:30:00`.
String formatarDuracaoRelogio(Duration d, {bool comSegundos = false}) {
  final minutos = d.inMinutes;
  final texto = '${_doisDigitos(minutos.abs() ~/ 60)}:${_doisDigitos(minutos.abs() % 60)}'
      '${comSegundos ? ':00' : ''}';
  return minutos < 0 ? '-$texto' : texto;
}

/// Horas decimais com vírgula: 8h30 → `8,5`; 8h20 → `8,33`; 8h → `8`.
String formatarHorasDecimais(Duration d) {
  final horas = d.inMinutes / 60;
  var texto = horas.toStringAsFixed(2);
  texto = texto.replaceFirst(RegExp(r'\.?0+$'), '');
  return texto.replaceAll('.', ',');
}

/// `07/05/2026`
String formatarDataCurta(DateTime d) =>
    '${_doisDigitos(d.day)}/${_doisDigitos(d.month)}/${d.year.toString().padLeft(4, '0')}';

/// `07/05`
String formatarDiaMes(DateTime d) => '${_doisDigitos(d.day)}/${_doisDigitos(d.month)}';

/// `qui., 07 mai. 2026`
String formatarDataExtensa(DateTime d) =>
    '${_diasSemanaAbreviados[d.weekday - 1]}, ${_doisDigitos(d.day)} '
    '${_mesesAbreviados[d.month - 1]} ${d.year}';

/// `quinta-feira, 07/05/2026` — usado onde há espaço e leitor de tela.
String formatarDataPorExtenso(DateTime d) =>
    '${_diasSemanaExtenso[d.weekday - 1]}, ${formatarDataCurta(d)}';

/// `07/05/2026 às 19:04`
String formatarDataHora(DateTime instante) =>
    '${formatarDataCurta(instante)} às ${_doisDigitos(instante.hour)}:'
    '${_doisDigitos(instante.minute)}';

/// Competência por extenso: 2026-05 → `maio/2026`.
String formatarCompetencia(int ano, int mes) => '${nomeMes(mes)}/$ano';

/// `maio`
String nomeMes(int mes) => _mesesExtenso[mes - 1];

/// `Maio`
String nomeMesCapitalizado(int mes) {
  final nome = nomeMes(mes);
  return nome[0].toUpperCase() + nome.substring(1);
}

/// `qui.` — `weekday` segue `DateTime.weekday`: 1 é segunda, 7 é domingo.
String abreviacaoDiaSemana(int weekday) => _diasSemanaAbreviados[weekday - 1];

/// `quinta-feira`
String nomeDiaSemana(int weekday) => _diasSemanaExtenso[weekday - 1];

/// `24 KB`
String formatarTamanhoArquivo(int bytes) {
  if (bytes < 1024) return '$bytes B';
  final kb = (bytes / 1024).ceil();
  if (kb < 1024) return '$kb KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1).replaceAll('.', ',')} MB';
}
