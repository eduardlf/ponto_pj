import 'package:collection/collection.dart';

import '../enums/enums.dart';
import 'marcacao.dart';

/// Um dia de ponto: registro histórico autossuficiente (docs/06, seção 6.2).
///
/// Guarda a carga prevista que valia no momento do cálculo, e não um ponteiro para a
/// jornada. Os campos [minutosTrabalhados], [saldo] e [inconsistente] são derivados e só
/// são produzidos pela `CalculadoraPonto`.
class DiaTrabalho {
  final int? id;

  /// Data civil, à meia-noite UTC.
  final DateTime data;
  final StatusDia status;
  final bool statusManual;
  final String? observacao;
  final List<Marcacao> marcacoes;
  final Duration cargaPrevista;
  final Duration minutosTrabalhados;
  final Duration saldo;
  final bool inconsistente;
  final bool fechado;

  DiaTrabalho({
    this.id,
    required this.data,
    this.status = StatusDia.normal,
    this.statusManual = false,
    this.observacao,
    List<Marcacao> marcacoes = const [],
    this.cargaPrevista = Duration.zero,
    this.minutosTrabalhados = Duration.zero,
    this.saldo = Duration.zero,
    this.inconsistente = false,
    this.fechado = false,
  }) : marcacoes = List.unmodifiable(marcacoes);

  /// Um dia sem nenhum registro no banco.
  factory DiaTrabalho.vazio(DateTime data) => DiaTrabalho(data: data);

  /// Verdadeiro quando o dia já existe no banco.
  bool get persistido => id != null;

  bool get temMarcacoes => marcacoes.isNotEmpty;

  bool get temObservacao => observacao != null && observacao!.trim().isNotEmpty;

  DiaTrabalho copiaCom({
    int? id,
    DateTime? data,
    StatusDia? status,
    bool? statusManual,
    String? observacao,
    bool limparObservacao = false,
    List<Marcacao>? marcacoes,
    Duration? cargaPrevista,
    Duration? minutosTrabalhados,
    Duration? saldo,
    bool? inconsistente,
    bool? fechado,
  }) {
    return DiaTrabalho(
      id: id ?? this.id,
      data: data ?? this.data,
      status: status ?? this.status,
      statusManual: statusManual ?? this.statusManual,
      observacao: limparObservacao ? null : (observacao ?? this.observacao),
      marcacoes: marcacoes ?? this.marcacoes,
      cargaPrevista: cargaPrevista ?? this.cargaPrevista,
      minutosTrabalhados: minutosTrabalhados ?? this.minutosTrabalhados,
      saldo: saldo ?? this.saldo,
      inconsistente: inconsistente ?? this.inconsistente,
      fechado: fechado ?? this.fechado,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is DiaTrabalho &&
      other.id == id &&
      other.data == data &&
      other.status == status &&
      other.statusManual == statusManual &&
      other.observacao == observacao &&
      const ListEquality<Marcacao>().equals(other.marcacoes, marcacoes) &&
      other.cargaPrevista == cargaPrevista &&
      other.minutosTrabalhados == minutosTrabalhados &&
      other.saldo == saldo &&
      other.inconsistente == inconsistente &&
      other.fechado == fechado;

  @override
  int get hashCode => Object.hash(
        id,
        data,
        status,
        statusManual,
        observacao,
        const ListEquality<Marcacao>().hash(marcacoes),
        cargaPrevista,
        minutosTrabalhados,
        saldo,
        inconsistente,
        fechado,
      );
}
