import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_pj/core/extensoes/data_extensoes.dart';
import 'package:ponto_pj/domain/entidades/configuracao_jornada.dart';
import 'package:ponto_pj/domain/entidades/dia_trabalho.dart';
import 'package:ponto_pj/domain/enums/enums.dart';
import 'package:ponto_pj/domain/servicos/calculadora_ponto.dart';

import '../helpers/construtores.dart';

/// Cada linha das tabelas de docs/12 é um teste (docs/14, seção 14.2).
void main() {
  const calculadora = CalculadoraPontoPadrao();

  DiaTrabalho calcular(DiaTrabalho dia, {ConfiguracaoJornada? jornada, DateTime? agora}) =>
      calculadora.calcularDia(dia, jornada ?? jornadaPadrao(), agora: agora ?? depois);

  void confere(DiaTrabalho dia,
      {required int trabalhado, required int saldo, required bool inconsistente}) {
    expect(dia.minutosTrabalhados, min(trabalhado), reason: 'trabalhado');
    expect(dia.saldo, min(saldo), reason: 'saldo');
    expect(dia.inconsistente, inconsistente, reason: 'inconsistente');
  }

  group('12.4 minutos trabalhados', () {
    final hojeQuinta = DateTime(2026, 5, 7, 14);

    test('C01 dia completo', () {
      confere(calcular(diaCom(quinta, ['08:00', '12:00', '13:00', '17:00'])),
          trabalhado: 480, saldo: 0, inconsistente: false);
    });
    test('C02 saída tardia', () {
      confere(calcular(diaCom(quinta, ['08:00', '12:00', '13:00', '17:30'])),
          trabalhado: 510, saldo: 30, inconsistente: false);
    });
    test('C03 saída antecipada', () {
      confere(calcular(diaCom(quinta, ['08:00', '12:00', '13:00', '16:30'])),
          trabalhado: 450, saldo: -30, inconsistente: false);
    });
    test('C04 turno único sem intervalo', () {
      confere(calcular(diaCom(quinta, ['08:00', '17:00'])),
          trabalhado: 540, saldo: 60, inconsistente: false);
    });
    test('C05 dia útil sem registro', () {
      confere(calcular(diaCom(quinta, [])), trabalhado: 0, saldo: -480, inconsistente: false);
    });
    test('C06 passado com marcação ímpar é inconsistente', () {
      confere(calcular(diaCom(quinta, ['08:00', '12:00', '13:00'])),
          trabalhado: 240, saldo: -240, inconsistente: true);
    });
    test('C07 hoje com uma entrada está em andamento', () {
      final dia = calcular(diaCom(quinta, ['08:00']), agora: hojeQuinta);
      confere(dia, trabalhado: 0, saldo: -480, inconsistente: false);
      expect(calculadora.emAndamento(dia, agora: hojeQuinta), isTrue);
    });
    test('C08 hoje com três marcações está em andamento', () {
      confere(calcular(diaCom(quinta, ['08:00', '12:00', '13:00']), agora: hojeQuinta),
          trabalhado: 240, saldo: -240, inconsistente: false);
    });
    test('C09 três turnos', () {
      confere(calcular(diaCom(quinta, ['08:00', '12:00', '13:00', '17:00', '18:00', '20:00'])),
          trabalhado: 600, saldo: 120, inconsistente: false);
    });
    test('C10 sábado: carga 0, tudo é crédito', () {
      final dia = calcular(diaCom(sabado, ['09:00', '13:00']));
      confere(dia, trabalhado: 240, saldo: 240, inconsistente: false);
      expect(dia.cargaPrevista, Duration.zero);
    });
    test('C11 sábado vazio', () {
      confere(calcular(diaCom(sabado, [])), trabalhado: 0, saldo: 0, inconsistente: false);
    });

    test('marcações fora de ordem produzem exatamente C01 (RN-01)', () {
      final dia = calcular(diaCom(quinta, ['13:00', '17:00', '08:00', '12:00']));
      confere(dia, trabalhado: 480, saldo: 0, inconsistente: false);
      expect(dia.marcacoes.map((m) => m.hora), [h('08:00'), h('12:00'), h('13:00'), h('17:00')]);
      expect(dia.marcacoes.map((m) => m.ordem), [1, 2, 3, 4]);
      expect(dia.marcacoes.map((m) => m.tipo), [
        TipoMarcacao.entrada,
        TipoMarcacao.saida,
        TipoMarcacao.entrada,
        TipoMarcacao.saida,
      ]);
    });

    test('13:00 seguida de 08:00 vira 08:00 entrada e 13:00 saída', () {
      final dia = calcular(diaCom(quinta, ['13:00', '08:00']));
      expect(dia.marcacoes.first.hora, h('08:00'));
      expect(dia.marcacoes.first.tipo, TipoMarcacao.entrada);
      expect(dia.marcacoes.last.tipo, TipoMarcacao.saida);
    });
  });

  group('12.5 virada de dia (RN-08)', () {
    final comVirada = jornadaPadrao(permiteViradaDia: true);

    test('V01 22:00 → 06:00 com virada soma 8 h', () {
      confere(calcular(diaCom(quinta, ['22:00', '06:00']), jornada: comVirada),
          trabalhado: 480, saldo: 0, inconsistente: false);
    });
    test('V02 sem virada os horários são lidos em ordem crescente', () {
      final dia = calcular(diaCom(quinta, ['22:00', '06:00']));
      confere(dia, trabalhado: 960, saldo: 480, inconsistente: false);
      expect(dia.marcacoes.first.hora, h('06:00'));
    });
    test('V03 dois turnos atravessando a meia-noite', () {
      confere(calcular(diaCom(quinta, ['22:00', '02:00', '03:00', '06:00']), jornada: comVirada),
          trabalhado: 420, saldo: -60, inconsistente: false);
    });
    test('V04 turno normal e turno virado', () {
      confere(calcular(diaCom(quinta, ['08:00', '12:00', '22:00', '02:00']), jornada: comVirada),
          trabalhado: 480, saldo: 0, inconsistente: false);
    });
    test('com virada, um dia comum continua em ordem crescente', () {
      final dia = calcular(diaCom(quinta, ['08:00', '12:00', '13:00', '17:00']), jornada: comVirada);
      confere(dia, trabalhado: 480, saldo: 0, inconsistente: false);
      expect(dia.marcacoes.first.hora, h('08:00'));
    });
    // V05 (08:00 duas vezes) é recusado antes do cálculo, por RN-04: ver validador_marcacao_test.
  });

  group('12.6 status e abono', () {
    void caso(String id, StatusDia status, List<String> horas,
        {required int trabalhado, required int saldo}) {
      test('$id ${status.name}', () {
        final dia = calcular(diaCom(quinta, horas, status: status));
        expect(dia.cargaPrevista, min(480));
        expect(dia.minutosTrabalhados, min(trabalhado));
        expect(dia.saldo, min(saldo));
      });
    }

    caso('S01', StatusDia.normal, ['08:00', '12:00', '13:00', '17:00'], trabalhado: 480, saldo: 0);
    caso('S02', StatusDia.folga, [], trabalhado: 0, saldo: 0);
    caso('S03', StatusDia.feriado, [], trabalhado: 0, saldo: 0);
    caso('S04', StatusDia.feriado, ['08:00', '12:00'], trabalhado: 240, saldo: 240);
    caso('S05', StatusDia.ferias, [], trabalhado: 0, saldo: 0);
    caso('S06', StatusDia.atestado, [], trabalhado: 0, saldo: 0);
    caso('S07', StatusDia.abono, ['08:00', '10:00'], trabalhado: 120, saldo: 120);
    caso('S08', StatusDia.falta, [], trabalhado: 0, saldo: -480);
    caso('S09', StatusDia.falta, ['08:00', '12:00'], trabalhado: 240, saldo: -480);
    caso('S10', StatusDia.compensacao, ['08:00', '12:00'], trabalhado: 240, saldo: -240);
  });

  group('12.7 tolerância (RN-14)', () {
    void caso(String id, String saida, int tolerancia, int saldoFinal) {
      test(id, () {
        final dia = calcular(diaCom(quinta, ['08:00', '12:00', '13:00', saida]),
            jornada: jornadaPadrao(tolerancia: min(tolerancia)));
        expect(dia.saldo, min(saldoFinal));
      });
    }

    caso('T01 +3 com tolerância 5', '17:03', 5, 0);
    caso('T02 −3 com tolerância 5', '16:57', 5, 0);
    caso('T03 +5 com tolerância 5 (inclusiva)', '17:05', 5, 0);
    caso('T04 +6 com tolerância 5', '17:06', 5, 6);
    caso('T05 −6 com tolerância 5', '16:54', 5, -6);
    caso('T06 +3 sem tolerância', '17:03', 0, 3);
  });

  group('12.8 previsão de saída (RN-16)', () {
    void caso(String id, DateTime data, List<String> horas, String agora, String? previsao) {
      test(id, () {
        final instante = DateTime(data.year, data.month, data.day)
            .add(h(agora));
        final dia = calcular(diaCom(data, horas), agora: instante);
        final resultado = calculadora.previsaoSaida(dia, jornadaPadrao(), agora: instante);
        expect(resultado, previsao == null ? isNull : h(previsao));
      });
    }

    caso('P01', quinta, ['08:00'], '09:30', '16:00');
    caso('P02 caso típico', quinta, ['08:00', '12:00', '13:00'], '14:00', '17:00');
    caso('P03 já passou: continua 17:00', quinta, ['08:00', '12:00', '13:00'], '17:30', '17:00');
    caso('P04 dia fechado', quinta, ['08:00', '12:00', '13:00', '17:00'], '17:30', null);
    caso('P05 última é saída', quinta, ['08:00', '12:00'], '12:30', null);
    caso('P06 entrada atrasada', quinta, ['09:00', '12:00', '13:00'], '14:00', '18:00');
    caso('P07 carga zero', sabado, ['08:00'], '10:00', '08:00');
  });

  group('valores vivos (12.2)', () {
    test('minutos em curso e saldo agora durante o expediente', () {
      final agora = DateTime(2026, 5, 7, 15, 30);
      final dia = calcular(diaCom(quinta, ['08:00', '12:00', '13:00']), agora: agora);
      expect(calculadora.minutosEmCurso(dia, agora: agora), min(150));
      expect(calculadora.trabalhadoAgora(dia, agora: agora), min(390));
      expect(calculadora.saldoAgora(dia, jornadaPadrao(), agora: agora), min(-90));
      // O persistido não depende do relógio.
      expect(dia.minutosTrabalhados, min(240));
    });

    test('fora de andamento os valores vivos são os persistidos', () {
      final dia = calcular(diaCom(quinta, ['08:00', '12:00']));
      expect(calculadora.minutosEmCurso(dia, agora: depois), Duration.zero);
      expect(calculadora.saldoAgora(dia, jornadaPadrao(), agora: depois), dia.saldo);
    });

    test('o dia em andamento vira inconsistente no dia seguinte', () {
      final ontem = calcular(diaCom(quinta, ['08:00']), agora: DateTime(2026, 5, 7, 9));
      expect(ontem.inconsistente, isFalse);
      final relido = calculadora.reavaliarConsistencia(ontem, jornadaPadrao(),
          agora: DateTime(2026, 5, 8, 9));
      expect(relido.inconsistente, isTrue);
      expect(relido.saldo, ontem.saldo);
    });

    test('próximo tipo alterna pela paridade (RN-06)', () {
      expect(calculadora.proximoTipo(diaCom(quinta, [])), TipoMarcacao.entrada);
      expect(calculadora.proximoTipo(diaCom(quinta, ['08:00'])), TipoMarcacao.saida);
      expect(calculadora.proximoTipo(diaCom(quinta, ['08:00', '12:00'])), TipoMarcacao.entrada);
    });
  });

  group('turnos e intervalos (RN-09)', () {
    test('dois turnos e um intervalo', () {
      final dia = calcular(diaCom(quinta, ['08:00', '12:00', '13:00', '17:00']));
      final turnos = calculadora.turnos(dia, jornadaPadrao());
      expect(turnos.map((t) => t.duracao), [min(240), min(240)]);
      final intervalos = calculadora.intervalos(dia, jornadaPadrao());
      expect(intervalos.single.duracao, min(60));
      expect(intervalos.single.inicio, h('12:00'));
    });

    test('o intervalo do almoço existe mesmo com o segundo turno aberto', () {
      final agora = DateTime(2026, 5, 7, 14);
      final dia = calcular(diaCom(quinta, ['08:00', '12:00', '13:00']), agora: agora);
      expect(calculadora.turnos(dia, jornadaPadrao()), hasLength(1));
      expect(calculadora.intervalos(dia, jornadaPadrao()).single.duracao, min(60));
    });

    test('carga derivada dos turnos previstos (RF-05)', () {
      final turnos = [
        TurnoPrevisto(ordem: 1, entrada: h('08:00'), saida: h('12:00')),
        TurnoPrevisto(ordem: 2, entrada: h('13:00'), saida: h('17:00')),
      ];
      expect(calculadora.cargaDosTurnos(turnos, permiteViradaDia: false), min(480));
      final noturno = [TurnoPrevisto(ordem: 1, entrada: h('22:00'), saida: h('06:00'))];
      expect(calculadora.cargaDosTurnos(noturno, permiteViradaDia: true), min(480));
      expect(calculadora.cargaDosTurnos(noturno, permiteViradaDia: false), Duration.zero);
    });

    test('carga semanal soma só os dias de trabalho (RF-07)', () {
      expect(calculadora.cargaSemanal(jornadaPadrao()), min(5 * 480));
    });
  });

  group('12.9 banco de horas (RN-15)', () {
    final agora = DateTime(2026, 5, 12, 12);
    late List<DiaTrabalho> semana;

    List<DiaTrabalho> montar(ConfiguracaoJornada jornada) => [
          diaCom(dataCivil(2026, 5, 4), ['08:00', '12:00', '13:00', '17:30']),
          diaCom(dataCivil(2026, 5, 5), ['08:00', '12:00', '13:00', '17:00']),
          diaCom(dataCivil(2026, 5, 6), ['08:00', '12:00', '13:00', '16:00']),
          diaCom(dataCivil(2026, 5, 7), [], status: StatusDia.feriado),
          diaCom(dataCivil(2026, 5, 8), ['08:00', '12:00', '13:00', '18:00']),
          diaCom(dataCivil(2026, 5, 9), ['09:00', '13:00']),
          diaCom(dataCivil(2026, 5, 10), []),
          diaCom(dataCivil(2026, 5, 11), [], status: StatusDia.falta),
        ].map((d) => calculadora.calcularDia(d, jornada, agora: agora)).toList();

    test('saldos do dia', () {
      semana = montar(jornadaPadrao());
      expect(semana.map((d) => d.saldo.inMinutes), [30, 0, -60, 0, 60, 240, 0, -480]);
    });

    test('banco acumulado sem data de início', () {
      final jornada = jornadaPadrao();
      semana = montar(jornada);
      final acumulado = [
        for (final dia in semana)
          calculadora.bancoAcumulado(semana, jornada, ate: dia.data, agora: agora).inMinutes,
      ];
      expect(acumulado, [30, 30, -30, -30, 30, 270, 270, -210]);
    });

    test('banco acumulado com início em 06/05', () {
      final jornada = jornadaPadrao(dataInicioBanco: dataCivil(2026, 5, 6));
      semana = montar(jornada);
      int ate(int dia) => calculadora
          .bancoAcumulado(semana, jornada, ate: dataCivil(2026, 5, dia), agora: agora)
          .inMinutes;
      expect([ate(6), ate(7), ate(8), ate(9), ate(11)], [-60, -60, 0, 240, -240]);
    });

    test('banco com o dia corrente usa o saldo vivo', () {
      final jornada = jornadaPadrao();
      final hoje = DateTime(2026, 5, 7, 10);
      final dia = calculadora.calcularDia(diaCom(quinta, ['08:00']), jornada, agora: hoje);
      // 2 h trabalhadas até agora contra 8 h de carga.
      expect(calculadora.bancoComDia(min(30), dia, jornada, agora: hoje), min(30 - 360));
    });

    test('dias antes do início do acompanhamento não somam nem geram pendência', () {
      final jornada = jornadaPadrao();
      final dias = montar(jornada);
      final inicio = dataCivil(2026, 5, 8);
      final resumo = calculadora.calcularPeriodo(dias, jornada,
          agora: agora, inicioAcompanhamento: inicio);
      // Só 08/05 (+60), 09/05 (+240), 10/05 e 11/05 (falta, −480).
      expect(resumo.saldo, min(60 + 240 - 480));
      expect(resumo.trabalhado, min(540 + 240));
      expect(resumo.diasUteis, 6, reason: 'dias úteis são propriedade do período');
      expect(resumo.pendencias, isEmpty);
      final antes = dias.first; // 04/05
      expect(calculadora.bancoComDia(min(15), antes, jornada,
          agora: agora, inicioAcompanhamento: inicio), min(15));
    });

    test('dias futuros não somam no banco nem no período', () {
      final jornada = jornadaPadrao();
      final hoje = DateTime(2026, 5, 6, 18);
      final dias = montar(jornada)
          .map((d) => calculadora.calcularDia(d, jornada, agora: hoje))
          .toList();
      expect(calculadora.bancoAcumulado(dias, jornada, ate: dataCivil(2026, 5, 11), agora: hoje),
          min(-30));
      final resumo = calculadora.calcularPeriodo(dias, jornada, agora: hoje);
      expect(resumo.saldo, min(-30));
      expect(resumo.diasUteis, 6);
    });
  });

  group('12.11 casos de borda', () {
    test('marcação à meia-noite é válida', () {
      final dia = calcular(diaCom(sabado, ['00:00', '04:00']));
      expect(dia.minutosTrabalhados, min(240));
      expect(dia.marcacoes.first.hora, Duration.zero);
    });
    test('23:59 seguida de 00:01 com virada resulta em 2 minutos', () {
      final dia = calcular(diaCom(sabado, ['23:59', '00:01']),
          jornada: jornadaPadrao(permiteViradaDia: true));
      expect(dia.minutosTrabalhados, min(2));
    });
    test('23:59 e 00:01 sem virada são lidos em ordem crescente', () {
      final dia = calcular(diaCom(sabado, ['23:59', '00:01']));
      expect(dia.minutosTrabalhados, min(1438));
    });
    test('o fuso de "agora" não muda o resultado', () {
      final local = calcular(diaCom(quinta, ['08:00']), agora: DateTime(2026, 5, 7, 10));
      final utc = calcular(diaCom(quinta, ['08:00']), agora: DateTime.utc(2026, 5, 7, 10));
      expect(local, utc);
    });
    test('calcularDia é pura: mesma entrada, mesma saída', () {
      final entrada = diaCom(quinta, ['08:00', '12:00', '13:00', '17:30']);
      expect(calcular(entrada), calcular(entrada));
    });
  });

  group('resumo do período', () {
    test('soma, conta dias úteis e trabalhados, e levanta pendências', () {
      final jornada = jornadaPadrao();
      final dias = [
        diaCom(dataCivil(2026, 5, 4), ['08:00', '12:00', '13:00', '17:00']),
        diaCom(dataCivil(2026, 5, 5), ['08:00', '12:00', '13:00']),
        diaCom(dataCivil(2026, 5, 6), []),
        diaCom(dataCivil(2026, 5, 7), ['08:00', '12:00'], status: StatusDia.falta),
        diaCom(dataCivil(2026, 5, 9), []),
      ].map((d) => calculadora.calcularDia(d, jornada, agora: depois)).toList();

      final resumo = calculadora.calcularPeriodo(dias, jornada, agora: depois);
      expect(resumo.trabalhado, min(480 + 240 + 240));
      expect(resumo.saldo, min(0 - 240 - 480 - 480));
      expect(resumo.diasUteis, 4);
      expect(resumo.diasTrabalhados, 3);
      expect(resumo.pendencias.map((p) => p.tipo), [
        TipoPendencia.marcacoesIncompletas,
        TipoPendencia.diaUtilSemRegistro,
        TipoPendencia.faltaComMarcacoes,
      ]);
    });
  });
}
