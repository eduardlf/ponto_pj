import '../enums/enums.dart';

/// Uma batida de ponto. [ordem] e [tipo] são sempre derivados da ordenação por horário
/// (RN-01), nunca informados pelo usuário.
class Marcacao {
  final int? id;
  final int ordem;
  final TipoMarcacao tipo;

  /// Minutos desde a meia-noite.
  final Duration hora;
  final OrigemMarcacao origem;
  final bool editada;

  const Marcacao({
    this.id,
    this.ordem = 0,
    this.tipo = TipoMarcacao.entrada,
    required this.hora,
    this.origem = OrigemMarcacao.manual,
    this.editada = false,
  });

  Marcacao copiaCom({
    int? id,
    int? ordem,
    TipoMarcacao? tipo,
    Duration? hora,
    OrigemMarcacao? origem,
    bool? editada,
  }) {
    return Marcacao(
      id: id ?? this.id,
      ordem: ordem ?? this.ordem,
      tipo: tipo ?? this.tipo,
      hora: hora ?? this.hora,
      origem: origem ?? this.origem,
      editada: editada ?? this.editada,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Marcacao &&
      other.id == id &&
      other.ordem == ordem &&
      other.tipo == tipo &&
      other.hora == hora &&
      other.origem == origem &&
      other.editada == editada;

  @override
  int get hashCode => Object.hash(id, ordem, tipo, hora, origem, editada);
}
