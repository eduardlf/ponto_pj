import '../enums/enums.dart';

/// Algo a conferir antes de fechar o mês. Calculado na leitura, nunca persistido.
class Pendencia {
  final DateTime data;
  final TipoPendencia tipo;
  final String descricao;

  const Pendencia({required this.data, required this.tipo, required this.descricao});

  @override
  bool operator ==(Object other) =>
      other is Pendencia && other.data == data && other.tipo == tipo;

  @override
  int get hashCode => Object.hash(data, tipo);
}

/// Totais de um período: dia, semana, mês ou competência.
class ResumoPeriodo {
  final Duration trabalhado;
  final Duration cargaPrevista;
  final Duration saldo;

  /// Banco acumulado até o último dia do período (RN-15).
  final Duration bancoHoras;

  /// Dias do período com carga prevista maior que zero.
  final int diasUteis;

  /// Dias com ao menos um par completo de marcações (variável `{dias_trabalhados}`).
  final int diasTrabalhados;
  final List<Pendencia> pendencias;

  ResumoPeriodo({
    required this.trabalhado,
    required this.cargaPrevista,
    required this.saldo,
    required this.bancoHoras,
    required this.diasUteis,
    required this.diasTrabalhados,
    List<Pendencia> pendencias = const [],
  }) : pendencias = List.unmodifiable(pendencias);

  factory ResumoPeriodo.vazio() => ResumoPeriodo(
        trabalhado: Duration.zero,
        cargaPrevista: Duration.zero,
        saldo: Duration.zero,
        bancoHoras: Duration.zero,
        diasUteis: 0,
        diasTrabalhados: 0,
      );
}
