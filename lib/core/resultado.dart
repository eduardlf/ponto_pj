import 'falhas.dart';

/// Resultado de uma operação que depende do mundo externo — arquivo, banco, sistema
/// operacional. Fluxo esperado não usa exceção (docs/09, seção 9.5).
sealed class Resultado<T> {
  const Resultado();

  R quando<R>({
    required R Function(T valor) sucesso,
    required R Function(Falha falha) erro,
  }) {
    return switch (this) {
      Sucesso<T>(:final valor) => sucesso(valor),
      Erro<T>(:final falha) => erro(falha),
    };
  }

  bool get ehSucesso => this is Sucesso<T>;

  T? get valorOuNulo => switch (this) {
        Sucesso<T>(:final valor) => valor,
        Erro<T>() => null,
      };

  Falha? get falhaOuNula => switch (this) {
        Sucesso<T>() => null,
        Erro<T>(:final falha) => falha,
      };
}

final class Sucesso<T> extends Resultado<T> {
  final T valor;
  const Sucesso(this.valor);
}

final class Erro<T> extends Resultado<T> {
  final Falha falha;
  const Erro(this.falha);
}
