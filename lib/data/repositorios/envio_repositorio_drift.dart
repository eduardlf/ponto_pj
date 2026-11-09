import 'package:drift/drift.dart';

import '../../core/resultado.dart';
import '../../domain/entidades/envio_mensal.dart';
import '../../domain/enums/enums.dart';
import '../../domain/repositorios/repositorios.dart';
import '../local/banco_local.dart';
import 'escrita_segura.dart';

class EnvioRepositorioDrift implements EnvioRepositorio {
  final BancoLocal _banco;

  EnvioRepositorioDrift(this._banco);

  @override
  Future<List<EnvioMensal>> listar() async {
    final linhas = await (_banco.select(_banco.enviosMensais)
          ..orderBy([(t) => OrderingTerm.desc(t.geradoEm), (t) => OrderingTerm.desc(t.id)]))
        .get();
    return linhas.map(_paraEntidade).toList();
  }

  @override
  Future<List<EnvioMensal>> listarDaCompetencia(int ano, int mes) async {
    final linhas = await (_banco.select(_banco.enviosMensais)
          ..where((t) => t.competenciaAno.equals(ano) & t.competenciaMes.equals(mes))
          ..orderBy([(t) => OrderingTerm.desc(t.geradoEm), (t) => OrderingTerm.desc(t.id)]))
        .get();
    return linhas.map(_paraEntidade).toList();
  }

  @override
  Future<Resultado<EnvioMensal>> registrarGeracao(EnvioMensal envio) {
    return escritaSegura(_banco, () async {
      final id = await _banco.into(_banco.enviosMensais).insert(EnviosMensaisCompanion.insert(
            modeloId: Value(envio.modeloId),
            competenciaAno: envio.competenciaAno,
            competenciaMes: envio.competenciaMes,
            status: envio.status,
            geradoEm: envio.geradoEm,
            caminhoArquivo: envio.caminhoArquivo,
            nomeArquivo: envio.nomeArquivo,
            tamanhoBytes: envio.tamanhoBytes,
            observacao: Value(envio.observacao),
          ));
      return Sucesso(envio.copiaCom(id: id));
    });
  }

  @override
  Future<Resultado<void>> confirmarEnvio(int envioId, DateTime enviadoEm) {
    return escritaSegura(_banco, () async {
      await (_banco.update(_banco.enviosMensais)..where((t) => t.id.equals(envioId))).write(
          EnviosMensaisCompanion(
              status: const Value(StatusEnvio.enviado), enviadoEm: Value(enviadoEm)));
      return const Sucesso(null);
    });
  }

  EnvioMensal _paraEntidade(EnvioMensalLinha linha) => EnvioMensal(
        id: linha.id,
        modeloId: linha.modeloId,
        competenciaAno: linha.competenciaAno,
        competenciaMes: linha.competenciaMes,
        status: linha.status,
        geradoEm: linha.geradoEm,
        caminhoArquivo: linha.caminhoArquivo,
        nomeArquivo: linha.nomeArquivo,
        tamanhoBytes: linha.tamanhoBytes,
        enviadoEm: linha.enviadoEm,
        observacao: linha.observacao,
      );
}
