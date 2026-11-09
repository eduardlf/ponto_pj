import 'package:ponto_pj/core/extensoes/data_extensoes.dart';
import 'package:ponto_pj/domain/entidades/competencia.dart';
import 'package:ponto_pj/domain/entidades/configuracao_jornada.dart';
import 'package:ponto_pj/domain/entidades/dia_trabalho.dart';
import 'package:ponto_pj/domain/enums/enums.dart';
import 'package:ponto_pj/domain/servicos/calculadora_ponto.dart';

import '../helpers/construtores.dart';

/// Maio de 2026 (docs/14, seção 14.3): um mês fictício com todos os casos interessantes.
///
/// | Situação                               | Dias                              |
/// |----------------------------------------|-----------------------------------|
/// | Normal completo (08–12, 13–17)         | 04 13 15 18 19 21 25 26 27 28 29  |
/// | Inconsistente (falta a saída)          | 05                                |
/// | Saída antecipada (16:00)               | 06                                |
/// | Feriado com trabalho                   | 07                                |
/// | Hora extra (saída 18:00)               | 08                                |
/// | Sábado trabalhado                      | 09                                |
/// | Falta                                  | 11                                |
/// | Dia útil sem nenhum registro           | 12                                |
/// | Três turnos                            | 14                                |
/// | Atestado                               | 20                                |
/// | Turno que cruza a meia-noite           | 22                                |
/// | Feriado sem trabalho                   | 01                                |
/// | Fins de semana sem registro            | os demais                         |
///
/// Os totais abaixo foram calculados à mão. Se um refatoramento mudar algum deles, o teste
/// deve falhar — é exatamente o objetivo.
abstract final class MesExemplo {
  static final competencia = Competencia(2026, 5);

  /// Depois do fim do mês: nenhum dia é "hoje".
  static final agora = DateTime(2026, 6, 2, 9);

  /// A virada ligada é o que faz o dia 22 somar 8 h.
  static final jornada = jornadaPadrao(permiteViradaDia: true);

  static const trabalhadoMinutos = 8040; // 134h 00m
  static const saldoMinutos = -600; // - 10h 00m
  static const diasUteis = 21;
  static const diasTrabalhados = 18;

  static const _marcacoes = <int, List<String>>{
    4: _normal, 13: _normal, 15: _normal, 18: _normal, 19: _normal, 21: _normal, //
    25: _normal, 26: _normal, 27: _normal, 28: _normal, 29: _normal,
    5: ['08:00', '12:00', '13:00'],
    6: ['08:00', '12:00', '13:00', '16:00'],
    7: ['08:00', '12:00'],
    8: ['08:00', '12:00', '13:00', '18:00'],
    9: ['09:00', '13:00'],
    14: ['08:00', '12:00', '13:00', '17:00', '18:00', '20:00'],
    22: ['13:00', '17:00', '22:00', '02:00'],
  };

  static const _normal = ['08:00', '12:00', '13:00', '17:00'];

  static const _status = <int, StatusDia>{
    1: StatusDia.feriado,
    7: StatusDia.feriado,
    11: StatusDia.falta,
    20: StatusDia.atestado,
  };

  /// Os 31 dias, ainda sem cálculo.
  static List<DiaTrabalho> diasBrutos() => [
        for (var dia = 1; dia <= 31; dia++)
          diaCom(
            dataCivil(2026, 5, dia),
            _marcacoes[dia] ?? const [],
            status: _status[dia] ?? StatusDia.normal,
            observacao: dia == 7 ? 'Plantão' : null,
          ),
      ];

  /// Os 31 dias calculados pela calculadora real.
  static List<DiaTrabalho> dias({ConfiguracaoJornada? jornada}) {
    const calculadora = CalculadoraPontoPadrao();
    return diasBrutos()
        .map((d) => calculadora.calcularDia(d, jornada ?? MesExemplo.jornada, agora: agora))
        .toList();
  }
}
