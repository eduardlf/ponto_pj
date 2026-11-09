import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_pj/core/extensoes/data_extensoes.dart';
import 'package:ponto_pj/domain/enums/enums.dart';
import 'package:ponto_pj/domain/servicos/calculadora_ponto.dart';

import '../fixtures/mes_exemplo.dart';
import '../helpers/construtores.dart';

void main() {
  const calculadora = CalculadoraPontoPadrao();

  test('os totais de maio/2026 batem com o cálculo à mão', () {
    final dias = MesExemplo.dias();
    final resumo = calculadora.calcularPeriodo(dias, MesExemplo.jornada, agora: MesExemplo.agora);

    expect(dias, hasLength(MesExemplo.competencia.totalDias()));
    expect(resumo.trabalhado, min(MesExemplo.trabalhadoMinutos));
    expect(resumo.saldo, min(MesExemplo.saldoMinutos));
    expect(resumo.diasUteis, MesExemplo.diasUteis);
    expect(resumo.diasTrabalhados, MesExemplo.diasTrabalhados);
  });

  test('as duas pendências do mês são o dia 05 e o dia 12', () {
    final resumo = calculadora.calcularPeriodo(MesExemplo.dias(), MesExemplo.jornada,
        agora: MesExemplo.agora);
    expect(resumo.pendencias.map((p) => (p.data, p.tipo)), [
      (dataCivil(2026, 5, 5), TipoPendencia.marcacoesIncompletas),
      (dataCivil(2026, 5, 12), TipoPendencia.diaUtilSemRegistro),
    ]);
  });

  test('o turno do dia 22 atravessa a meia-noite', () {
    final dia22 = MesExemplo.dias()[21];
    expect(dia22.minutosTrabalhados, min(480));
    expect(dia22.marcacoes.map((m) => m.hora), [h('13:00'), h('17:00'), h('22:00'), h('02:00')]);
  });
}
