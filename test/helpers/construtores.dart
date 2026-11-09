import 'package:ponto_pj/core/extensoes/data_extensoes.dart';
import 'package:ponto_pj/domain/entidades/configuracao_jornada.dart';
import 'package:ponto_pj/domain/entidades/dia_trabalho.dart';
import 'package:ponto_pj/domain/entidades/marcacao.dart';
import 'package:ponto_pj/domain/enums/enums.dart';

/// `'08:30'` → 510 min.
Duration h(String hora) {
  final partes = hora.split(':');
  return Duration(hours: int.parse(partes[0]), minutes: int.parse(partes[1]));
}

Duration min(int minutos) => Duration(minutes: minutos);

/// Jornada das tabelas de docs/12: segunda a sexta, 08:00–12:00 e 13:00–17:00.
ConfiguracaoJornada jornadaPadrao({
  Duration tolerancia = Duration.zero,
  bool permiteViradaDia = false,
  DateTime? dataInicioBanco,
}) {
  return ConfiguracaoJornada(
    tolerancia: tolerancia,
    permiteViradaDia: permiteViradaDia,
    dataInicioBanco: dataInicioBanco,
    dias: [
      for (var d = 1; d <= 5; d++)
        JornadaDiaSemana(
          diaSemana: d,
          trabalha: true,
          carga: min(480),
          turnos: [
            TurnoPrevisto(ordem: 1, entrada: h('08:00'), saida: h('12:00')),
            TurnoPrevisto(ordem: 2, entrada: h('13:00'), saida: h('17:00')),
          ],
        ),
      JornadaDiaSemana.semTrabalho(6),
      JornadaDiaSemana.semTrabalho(7),
    ],
  );
}

/// Dia com marcações informadas como texto, na ordem dada (a calculadora ordena).
DiaTrabalho diaCom(
  DateTime data,
  List<String> horas, {
  StatusDia status = StatusDia.normal,
  String? observacao,
}) {
  return DiaTrabalho(
    data: data,
    status: status,
    statusManual: status != StatusDia.normal,
    observacao: observacao,
    marcacoes: [
      for (var i = 0; i < horas.length; i++) Marcacao(id: i + 1, hora: h(horas[i])),
    ],
  );
}

/// Quinta-feira, 07/05/2026 — o dia das tabelas de docs/12.
final quinta = dataCivil(2026, 5, 7);

/// Sábado, 09/05/2026.
final sabado = dataCivil(2026, 5, 9);

/// Um instante bem depois das datas de teste: nenhum dia é "hoje".
final depois = DateTime(2026, 6, 15, 12);
