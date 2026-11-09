import '../../core/extensoes/data_extensoes.dart';
import '../../core/falhas.dart';
import '../../core/formatadores.dart';
import '../entidades/dia_trabalho.dart';

/// Regras de entrada de uma marcação: RN-03, RN-04 e o dia fechado (RF-15).
class ValidadorMarcacao {
  const ValidadorMarcacao();

  /// Devolve a falha que impede gravar [hora] em [dia], ou nulo quando ela é válida.
  /// [ignorarId] exclui a própria marcação na edição.
  FalhaValidacao? validar({
    required DiaTrabalho dia,
    required Duration hora,
    required DateTime agora,
    int? ignorarId,
  }) {
    assert(hora >= Duration.zero && hora < const Duration(days: 1));

    if (dia.fechado) {
      return const FalhaValidacao('Este dia está fechado. Reabra o dia para alterar as marcações.');
    }

    final futuro = dia.data.depoisDe(agora) ||
        (dia.data.mesmoDia(agora) && hora > agora.horaDoDia);
    if (futuro) {
      return const FalhaValidacao('Não dá para registrar um horário que ainda não aconteceu.');
    }

    final duplicada = dia.marcacoes.any((m) => m.hora == hora && m.id != ignorarId);
    if (duplicada) {
      return FalhaValidacao('Já existe uma marcação às ${formatarHora(hora)} neste dia.');
    }

    return null;
  }
}
