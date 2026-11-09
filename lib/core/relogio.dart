/// Única fonte de "agora" do aplicativo (docs/09, seção 9.8).
///
/// `DateTime.now()` só é chamado aqui. Todo o resto recebe o relógio por injeção, o que
/// permite aos testes fixar o instante e verificar "em andamento" e previsão de saída de
/// forma determinística.
abstract interface class Relogio {
  DateTime agora();
}

final class RelogioSistema implements Relogio {
  const RelogioSistema();

  @override
  DateTime agora() => DateTime.now();
}

/// Relógio parado em um instante, para testes e pré-visualizações.
final class RelogioFixo implements Relogio {
  final DateTime instante;

  const RelogioFixo(this.instante);

  @override
  DateTime agora() => instante;
}
