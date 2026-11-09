import '../../core/extensoes/data_extensoes.dart';
import '../../core/formatadores.dart';

/// O par mês/ano a que se refere um fechamento (RN-25).
///
/// Por padrão a competência cobre o mês civil. Quando a planilha da empresa fecha o período
/// em outro dia, [diaInicio] diz em que dia do mês anterior o período começa: com
/// `diaInicio = 26`, a competência 10/2026 vai de 26/09/2026 a 25/10/2026.
class Competencia implements Comparable<Competencia> {
  final int ano;
  final int mes;

  /// 1 a 28. O limite de 28 garante que o dia exista em todos os meses.
  final int diaInicio;

  Competencia(int ano, int mes, {this.diaInicio = 1})
      : assert(diaInicio >= 1 && diaInicio <= 28),
        // Normaliza meses fora de 1–12, para que anterior() e seguinte() sejam triviais.
        ano = DateTime.utc(ano, mes).year,
        mes = DateTime.utc(ano, mes).month;

  /// A competência que contém [data].
  factory Competencia.contendo(DateTime data, {int diaInicio = 1}) {
    if (diaInicio > 1 && data.day >= diaInicio) {
      return Competencia(data.year, data.month + 1, diaInicio: diaInicio);
    }
    return Competencia(data.year, data.month, diaInicio: diaInicio);
  }

  DateTime primeiroDia() => diaInicio == 1
      ? dataCivil(ano, mes, 1)
      : dataCivil(ano, mes - 1, diaInicio);

  DateTime ultimoDia() => diaInicio == 1
      ? dataCivil(ano, mes + 1, 0)
      : dataCivil(ano, mes, diaInicio - 1);

  /// A única fonte da quantidade de dias: nenhum cálculo assume 30 ou 31 (docs/12, 12.11).
  int totalDias() => primeiroDia().diasAte(ultimoDia()) + 1;

  List<DateTime> dias() => datasEntre(primeiroDia(), ultimoDia());

  bool contem(DateTime data) =>
      !data.antesDe(primeiroDia()) && !data.depoisDe(ultimoDia());

  /// Posição de [data] dentro do período, a partir de 1.
  int posicaoDe(DateTime data) => primeiroDia().diasAte(data) + 1;

  Competencia anterior() => Competencia(ano, mes - 1, diaInicio: diaInicio);

  Competencia seguinte() => Competencia(ano, mes + 1, diaInicio: diaInicio);

  /// `maio/2026`
  String formatado() => formatarCompetencia(ano, mes);

  /// `26/09 a 25/10/2026`, ou `01/05 a 31/05/2026` no mês civil.
  String periodoFormatado() =>
      '${formatarDiaMes(primeiroDia())} a ${formatarDataCurta(ultimoDia())}';

  @override
  int compareTo(Competencia other) =>
      ano != other.ano ? ano.compareTo(other.ano) : mes.compareTo(other.mes);

  @override
  bool operator ==(Object other) =>
      other is Competencia &&
      other.ano == ano &&
      other.mes == mes &&
      other.diaInicio == diaInicio;

  @override
  int get hashCode => Object.hash(ano, mes, diaInicio);

  @override
  String toString() => formatado();
}
