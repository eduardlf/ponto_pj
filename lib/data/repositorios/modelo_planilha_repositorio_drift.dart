import 'package:drift/drift.dart';

import '../../core/relogio.dart';
import '../../core/resultado.dart';
import '../../domain/entidades/modelo_planilha.dart';
import '../../domain/repositorios/repositorios.dart';
import '../local/banco_local.dart';
import 'escrita_segura.dart';

class ModeloPlanilhaRepositorioDrift implements ModeloPlanilhaRepositorio {
  final BancoLocal _banco;
  final Relogio _relogio;

  ModeloPlanilhaRepositorioDrift(this._banco, {required Relogio relogio}) : _relogio = relogio;

  @override
  Future<ModeloPlanilha?> buscarAtivo() async {
    final linha = await (_banco.select(_banco.modelosPlanilha)
          ..where((t) => t.ativo.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .getSingleOrNull();
    if (linha == null) return null;

    final colunas = await (_banco.select(_banco.mapeamentosColuna)
          ..where((t) => t.modeloId.equals(linha.id)))
        .get();
    final celulas = await (_banco.select(_banco.celulasFixas)
          ..where((t) => t.modeloId.equals(linha.id))
          ..orderBy([(t) => OrderingTerm(expression: t.id)]))
        .get();
    final textos = await (_banco.select(_banco.textosStatus)
          ..where((t) => t.modeloId.equals(linha.id)))
        .get();

    return ModeloPlanilha(
      id: linha.id,
      nome: linha.nome,
      caminhoArquivoBase: linha.caminhoArquivoBase,
      nomeArquivoOriginal: linha.nomeArquivoOriginal,
      hashArquivo: linha.hashArquivo,
      nomeAba: linha.nomeAba,
      linhaCabecalho: linha.linhaCabecalho,
      primeiraLinhaDados: linha.primeiraLinhaDados,
      ultimaLinhaDados: linha.ultimaLinhaDados,
      estrategia: linha.estrategiaLinha,
      formatoData: linha.formatoData,
      formatoHora: linha.formatoHora,
      diaInicioCompetencia: linha.diaInicioCompetencia,
      colunas: {for (final c in colunas) c.campo: c.indiceColuna},
      rotulosCabecalho: {
        for (final c in colunas)
          if (c.rotuloCabecalho != null) c.campo: c.rotuloCabecalho!,
      },
      celulasFixas: [
        for (final c in celulas)
          CelulaFixa(campo: c.campo, referencia: c.referenciaCelula, valorLivre: c.valorLivre),
      ],
      textosStatus: {for (final t in textos) t.status: t.texto},
      ativo: linha.ativo,
    );
  }

  /// RN-17: desativa o anterior e grava o novo na mesma transação. Uma falha no meio não
  /// deixa dois modelos ativos, nem nenhum. Sempre cria um registro novo: o histórico de
  /// envios continua apontando para o modelo que de fato gerou cada arquivo.
  @override
  Future<Resultado<ModeloPlanilha>> salvar(ModeloPlanilha modelo) async {
    final resultado = await escritaSegura<int>(_banco, () async {
      final agora = _relogio.agora();
      await _banco.update(_banco.modelosPlanilha).write(const ModelosPlanilhaCompanion(
            ativo: Value(false),
          ));
      final id = await _banco.into(_banco.modelosPlanilha).insert(ModelosPlanilhaCompanion.insert(
            nome: modelo.nome,
            caminhoArquivoBase: modelo.caminhoArquivoBase,
            nomeArquivoOriginal: modelo.nomeArquivoOriginal,
            hashArquivo: modelo.hashArquivo,
            nomeAba: modelo.nomeAba,
            linhaCabecalho: Value(modelo.linhaCabecalho),
            primeiraLinhaDados: modelo.primeiraLinhaDados,
            ultimaLinhaDados: Value(modelo.ultimaLinhaDados),
            estrategiaLinha: modelo.estrategia,
            formatoData: Value(modelo.formatoData),
            formatoHora: Value(modelo.formatoHora),
            escreverComoTexto: Value(modelo.escreverComoTexto),
            diaInicioCompetencia: Value(modelo.diaInicioCompetencia),
            ativo: true,
            criadoEm: Value(agora),
            atualizadoEm: Value(agora),
          ));
      for (final MapEntry(key: campo, value: indice) in modelo.colunas.entries) {
        await _banco.into(_banco.mapeamentosColuna).insert(MapeamentosColunaCompanion.insert(
              modeloId: id,
              campo: campo,
              indiceColuna: indice,
              rotuloCabecalho: Value(modelo.rotulosCabecalho[campo]),
            ));
      }
      for (final celula in modelo.celulasFixas) {
        await _banco.into(_banco.celulasFixas).insert(CelulasFixasCompanion.insert(
              modeloId: id,
              campo: celula.campo,
              referenciaCelula: celula.referencia,
              valorLivre: Value(celula.valorLivre),
            ));
      }
      for (final MapEntry(key: status, value: texto) in modelo.textosStatus.entries) {
        if (texto.trim().isEmpty) continue;
        await _banco.into(_banco.textosStatus).insert(
            TextosStatusCompanion.insert(modeloId: id, status: status, texto: texto.trim()));
      }
      return Sucesso(id);
    });

    return switch (resultado) {
      Sucesso() => Sucesso((await buscarAtivo())!),
      Erro(:final falha) => Erro(falha),
    };
  }
}
