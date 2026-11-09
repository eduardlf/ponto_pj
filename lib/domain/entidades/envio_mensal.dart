import '../enums/enums.dart';

/// Registro de uma competência gerada e, eventualmente, enviada (RN-24).
class EnvioMensal {
  final int? id;

  /// Modelo usado na geração; nulo se ele foi excluído depois.
  final int? modeloId;
  final int competenciaAno;
  final int competenciaMes;
  final StatusEnvio status;
  final DateTime geradoEm;
  final String caminhoArquivo;
  final String nomeArquivo;
  final int tamanhoBytes;

  /// Preenchido apenas pela confirmação explícita do usuário (RN-23).
  final DateTime? enviadoEm;

  /// Pendências confirmadas ou dias que ficaram de fora (RN-20).
  final String? observacao;

  const EnvioMensal({
    this.id,
    this.modeloId,
    required this.competenciaAno,
    required this.competenciaMes,
    required this.status,
    required this.geradoEm,
    required this.caminhoArquivo,
    required this.nomeArquivo,
    required this.tamanhoBytes,
    this.enviadoEm,
    this.observacao,
  });

  bool daCompetencia(int ano, int mes) => competenciaAno == ano && competenciaMes == mes;

  EnvioMensal copiaCom({int? id, StatusEnvio? status, DateTime? enviadoEm}) {
    return EnvioMensal(
      id: id ?? this.id,
      modeloId: modeloId,
      competenciaAno: competenciaAno,
      competenciaMes: competenciaMes,
      status: status ?? this.status,
      geradoEm: geradoEm,
      caminhoArquivo: caminhoArquivo,
      nomeArquivo: nomeArquivo,
      tamanhoBytes: tamanhoBytes,
      enviadoEm: enviadoEm ?? this.enviadoEm,
      observacao: observacao,
    );
  }
}
