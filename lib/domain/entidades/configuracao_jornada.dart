import 'package:collection/collection.dart';

/// Horário esperado de um turno, usado na carga do dia e na previsão de saída.
class TurnoPrevisto {
  final int ordem;
  final Duration entrada;
  final Duration saida;

  const TurnoPrevisto({required this.ordem, required this.entrada, required this.saida});

  TurnoPrevisto copiaCom({int? ordem, Duration? entrada, Duration? saida}) => TurnoPrevisto(
        ordem: ordem ?? this.ordem,
        entrada: entrada ?? this.entrada,
        saida: saida ?? this.saida,
      );

  @override
  bool operator ==(Object other) =>
      other is TurnoPrevisto &&
      other.ordem == ordem &&
      other.entrada == entrada &&
      other.saida == saida;

  @override
  int get hashCode => Object.hash(ordem, entrada, saida);
}

/// O esperado em um dia da semana. [diaSemana] segue `DateTime.weekday`: 1 é segunda-feira,
/// 7 é domingo (docs/06, seção 6.3).
class JornadaDiaSemana {
  final int? id;
  final int diaSemana;
  final bool trabalha;
  final Duration carga;

  /// Verdadeiro quando o usuário sobrescreveu a carga derivada dos turnos (RF-05).
  final bool cargaManual;
  final List<TurnoPrevisto> turnos;

  JornadaDiaSemana({
    this.id,
    required this.diaSemana,
    required this.trabalha,
    required this.carga,
    this.cargaManual = false,
    List<TurnoPrevisto> turnos = const [],
  })  : assert(diaSemana >= 1 && diaSemana <= 7),
        turnos = List.unmodifiable(turnos);

  factory JornadaDiaSemana.semTrabalho(int diaSemana) =>
      JornadaDiaSemana(diaSemana: diaSemana, trabalha: false, carga: Duration.zero);

  JornadaDiaSemana copiaCom({
    int? id,
    bool? trabalha,
    Duration? carga,
    bool? cargaManual,
    List<TurnoPrevisto>? turnos,
  }) {
    return JornadaDiaSemana(
      id: id ?? this.id,
      diaSemana: diaSemana,
      trabalha: trabalha ?? this.trabalha,
      carga: carga ?? this.carga,
      cargaManual: cargaManual ?? this.cargaManual,
      turnos: turnos ?? this.turnos,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is JornadaDiaSemana &&
      other.id == id &&
      other.diaSemana == diaSemana &&
      other.trabalha == trabalha &&
      other.carga == carga &&
      other.cargaManual == cargaManual &&
      const ListEquality<TurnoPrevisto>().equals(other.turnos, turnos);

  @override
  int get hashCode => Object.hash(id, diaSemana, trabalha, carga, cargaManual,
      const ListEquality<TurnoPrevisto>().hash(turnos));
}

/// Parâmetros globais de cálculo e a semana de trabalho.
class ConfiguracaoJornada {
  final int? id;
  final String nome;
  final Duration tolerancia;
  final bool permiteViradaDia;

  /// Data a partir da qual o banco de horas acumula (RN-15). Nula: desde o primeiro dia
  /// registrado.
  final DateTime? dataInicioBanco;
  final List<JornadaDiaSemana> dias;

  ConfiguracaoJornada({
    this.id,
    this.nome = 'Jornada padrão',
    this.tolerancia = Duration.zero,
    this.permiteViradaDia = false,
    this.dataInicioBanco,
    required List<JornadaDiaSemana> dias,
  }) : dias = List.unmodifiable(dias);

  /// A jornada do dia da semana da data informada.
  JornadaDiaSemana paraData(DateTime data) => paraDiaSemana(data.weekday);

  JornadaDiaSemana paraDiaSemana(int diaSemana) =>
      dias.firstWhereOrNull((d) => d.diaSemana == diaSemana) ??
      JornadaDiaSemana.semTrabalho(diaSemana);

  ConfiguracaoJornada copiaCom({
    int? id,
    String? nome,
    Duration? tolerancia,
    bool? permiteViradaDia,
    DateTime? dataInicioBanco,
    bool limparDataInicioBanco = false,
    List<JornadaDiaSemana>? dias,
  }) {
    return ConfiguracaoJornada(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      tolerancia: tolerancia ?? this.tolerancia,
      permiteViradaDia: permiteViradaDia ?? this.permiteViradaDia,
      dataInicioBanco:
          limparDataInicioBanco ? null : (dataInicioBanco ?? this.dataInicioBanco),
      dias: dias ?? this.dias,
    );
  }

  /// Substitui a jornada de um dia da semana, mantendo as demais.
  ConfiguracaoJornada comDia(JornadaDiaSemana dia) => copiaCom(
        dias: [
          for (var d = 1; d <= 7; d++) d == dia.diaSemana ? dia : paraDiaSemana(d),
        ],
      );

  @override
  bool operator ==(Object other) =>
      other is ConfiguracaoJornada &&
      other.id == id &&
      other.nome == nome &&
      other.tolerancia == tolerancia &&
      other.permiteViradaDia == permiteViradaDia &&
      other.dataInicioBanco == dataInicioBanco &&
      const ListEquality<JornadaDiaSemana>().equals(other.dias, dias);

  @override
  int get hashCode => Object.hash(id, nome, tolerancia, permiteViradaDia, dataInicioBanco,
      const ListEquality<JornadaDiaSemana>().hash(dias));
}
