import 'package:ponto_pj/core/relogio.dart';

/// Relógio que o teste avança à vontade — para simular a virada da meia-noite.
class RelogioAjustavel implements Relogio {
  DateTime instante;

  RelogioAjustavel(this.instante);

  @override
  DateTime agora() => instante;
}
