import 'referencia_celula.dart';

/// Valor tipado de uma célula. O tipo é o que permite ao escritor decidir como serializar
/// (docs/10, seção 10.4).
sealed class ValorCelula {
  const ValorCelula();
}

final class TextoCelula extends ValorCelula {
  final String texto;
  const TextoCelula(this.texto);

  @override
  bool operator ==(Object other) => other is TextoCelula && other.texto == texto;

  @override
  int get hashCode => texto.hashCode;

  @override
  String toString() => texto;
}

final class NumeroCelula extends ValorCelula {
  final num valor;
  const NumeroCelula(this.valor);

  @override
  bool operator ==(Object other) => other is NumeroCelula && other.valor == valor;

  @override
  int get hashCode => valor.hashCode;

  @override
  String toString() => '$valor';
}

/// Vira número de série do Excel na escrita.
final class DataCelula extends ValorCelula {
  final DateTime data;
  const DataCelula(this.data);

  @override
  bool operator ==(Object other) => other is DataCelula && other.data == data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => data.toIso8601String();
}

/// Hora do dia ou duração; vira fração de dia na escrita (0,5 é 12:00).
final class HoraCelula extends ValorCelula {
  final Duration hora;
  const HoraCelula(this.hora);

  @override
  bool operator ==(Object other) => other is HoraCelula && other.hora == hora;

  @override
  int get hashCode => hora.hashCode;

  @override
  String toString() => '${hora.inMinutes} min';
}

/// Apaga o conteúdo da célula, preservando a formatação.
final class VaziaCelula extends ValorCelula {
  const VaziaCelula();

  @override
  bool operator ==(Object other) => other is VaziaCelula;

  @override
  int get hashCode => 0;

  @override
  String toString() => '';
}

/// O que escrever e onde. Não sabe nada sobre o formato do arquivo.
class PlanoDeEscrita {
  final String nomeAba;
  final Map<ReferenciaCelula, ValorCelula> celulas;

  PlanoDeEscrita({required this.nomeAba, Map<ReferenciaCelula, ValorCelula>? celulas})
      : celulas = celulas ?? {};
}

/// Saída do `PreenchedorPlanilha`.
class ResultadoPreenchimento {
  final PlanoDeEscrita plano;

  /// Dias cuja linha não foi encontrada na estratégia por data (RN-20).
  final List<DateTime> diasNaoResolvidos;

  /// Mensagens em português, prontas para exibir.
  final List<String> avisos;

  ResultadoPreenchimento({
    required this.plano,
    List<DateTime> diasNaoResolvidos = const [],
    List<String> avisos = const [],
  })  : diasNaoResolvidos = List.unmodifiable(diasNaoResolvidos),
        avisos = List.unmodifiable(avisos);
}
