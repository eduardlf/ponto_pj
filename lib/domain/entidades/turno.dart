/// Período trabalhado entre uma entrada e a saída seguinte. Não é persistido: é derivado
/// das marcações pela `CalculadoraPonto` (docs/06, seção 6.5).
class Turno {
  final Duration entrada;
  final Duration saida;
  final Duration duracao;

  /// Falso quando o par não pode ser somado (RN-08): o dia fica inconsistente.
  final bool valido;

  const Turno({
    required this.entrada,
    required this.saida,
    required this.duracao,
    this.valido = true,
  });
}

/// Período entre a saída de um turno e a entrada do turno seguinte (RN-09).
class Intervalo {
  final Duration inicio;
  final Duration fim;
  final Duration duracao;

  const Intervalo({required this.inicio, required this.fim, required this.duracao});
}
