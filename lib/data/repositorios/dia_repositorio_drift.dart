import 'package:collection/collection.dart';
import 'package:drift/drift.dart';

import '../../core/extensoes/data_extensoes.dart';
import '../../core/falhas.dart';
import '../../core/relogio.dart';
import '../../core/resultado.dart';
import '../../domain/entidades/competencia.dart';
import '../../domain/entidades/configuracao_jornada.dart';
import '../../domain/entidades/dia_trabalho.dart';
import '../../domain/entidades/marcacao.dart';
import '../../domain/enums/enums.dart';
import '../../domain/repositorios/repositorios.dart';
import '../../domain/servicos/calculadora_ponto.dart';
import '../../domain/servicos/validador_marcacao.dart';
import '../local/banco_local.dart';
import 'escrita_segura.dart';

/// Dias e marcações. Toda escrita passa por aqui e termina com o recálculo do dia: é
/// impossível gravar uma marcação sem atualizar os campos derivados (R-06, ADR-06).
class DiaRepositorioDrift implements DiaRepositorio {
  final BancoLocal _banco;
  final JornadaRepositorio _jornadas;
  final CalculadoraPonto _calculadora;
  final Relogio _relogio;
  final ValidadorMarcacao _validador;

  DiaRepositorioDrift(
    this._banco, {
    required JornadaRepositorio jornadas,
    required CalculadoraPonto calculadora,
    required Relogio relogio,
    ValidadorMarcacao validador = const ValidadorMarcacao(),
  })  : _jornadas = jornadas,
        _calculadora = calculadora,
        _relogio = relogio,
        _validador = validador;

  // ── Leitura ──────────────────────────────────────────────────────────────────────────

  @override
  Future<DiaTrabalho> buscarPorData(DateTime data) async {
    final civil = data.apenasData;
    final jornada = await _jornadas.buscarAtiva();
    return _preparar(await _carregar(civil), civil, jornada, _relogio.agora());
  }

  @override
  Future<List<DiaTrabalho>> buscarIntervalo(DateTime inicio, DateTime fim) async {
    final de = inicio.apenasData;
    final ate = fim.apenasData;
    if (de.depoisDe(ate)) return const [];

    final jornada = await _jornadas.buscarAtiva();
    final agora = _relogio.agora();

    final linhas = await (_banco.select(_banco.diasTrabalho)
          ..where((t) => t.data.isBetweenValues(de.iso, ate.iso)))
        .get();
    final idsNoIntervalo = _banco.selectOnly(_banco.diasTrabalho)
      ..addColumns([_banco.diasTrabalho.id])
      ..where(_banco.diasTrabalho.data.isBetweenValues(de.iso, ate.iso));
    final marcacoes = await (_banco.select(_banco.marcacoes)
          ..where((t) => t.diaId.isInQuery(idsNoIntervalo))
          ..orderBy([(t) => OrderingTerm(expression: t.ordem)]))
        .get();
    final porDia = groupBy(marcacoes, (MarcacaoLinha m) => m.diaId);
    final porData = {
      for (final linha in linhas) linha.data: _paraEntidade(linha, porDia[linha.id] ?? const []),
    };

    return [
      for (final data in datasEntre(de, ate)) _preparar(porData[data], data, jornada, agora),
    ];
  }

  @override
  Future<List<DiaTrabalho>> buscarCompetencia(Competencia competencia) =>
      buscarIntervalo(competencia.primeiroDia(), competencia.ultimoDia());

  @override
  Future<DateTime?> primeiraDataRegistrada() async {
    final menor = _banco.diasTrabalho.data.min();
    final consulta = _banco.selectOnly(_banco.diasTrabalho)..addColumns([menor]);
    final texto = await consulta.map((linha) => linha.read(menor)).getSingleOrNull();
    return texto == null ? null : lerDataIso(texto);
  }

  @override
  Future<bool> existeRegistroEntre(DateTime inicio, DateTime fim) async {
    final total = _banco.diasTrabalho.id.count();
    final consulta = _banco.selectOnly(_banco.diasTrabalho)
      ..addColumns([total])
      ..where(_banco.diasTrabalho.data.isBetweenValues(inicio.apenasData.iso, fim.apenasData.iso));
    final quantidade = await consulta.map((linha) => linha.read(total)).getSingle();
    return (quantidade ?? 0) > 0;
  }

  // ── Escrita ──────────────────────────────────────────────────────────────────────────

  @override
  Future<Resultado<DiaTrabalho>> adicionarMarcacao(
      DateTime data, Duration hora, OrigemMarcacao origem) {
    return escritaSegura(_banco, () async {
      final civil = data.apenasData;
      final agora = _relogio.agora();
      final dia = await _carregar(civil) ?? DiaTrabalho.vazio(civil);
      final falha = _validador.validar(dia: dia, hora: hora, agora: agora);
      if (falha != null) return Erro(falha);

      final diaId = dia.id ?? await _inserirDia(civil);
      await _banco.into(_banco.marcacoes).insert(MarcacoesCompanion.insert(
            diaId: diaId,
            ordem: dia.marcacoes.length + 1,
            tipo: TipoMarcacao.entrada,
            hora: hora,
            origem: Value(origem),
            criadoEm: Value(agora),
          ));
      return Sucesso(await _recalcularEGravar(diaId, agora));
    });
  }

  @override
  Future<Resultado<DiaTrabalho>> editarMarcacao(int marcacaoId, Duration novaHora) {
    return escritaSegura(_banco, () async {
      final marcacao = await _buscarMarcacao(marcacaoId);
      if (marcacao == null) return const Erro(_marcacaoSumiu);
      final agora = _relogio.agora();
      final dia = await _carregarPorId(marcacao.diaId);
      final falha =
          _validador.validar(dia: dia, hora: novaHora, agora: agora, ignorarId: marcacaoId);
      if (falha != null) return Erro(falha);

      await (_banco.update(_banco.marcacoes)..where((t) => t.id.equals(marcacaoId)))
          .write(MarcacoesCompanion(hora: Value(novaHora), editada: const Value(true)));
      return Sucesso(await _recalcularEGravar(marcacao.diaId, agora));
    });
  }

  @override
  Future<Resultado<DiaTrabalho>> excluirMarcacao(int marcacaoId) {
    return escritaSegura(_banco, () async {
      final marcacao = await _buscarMarcacao(marcacaoId);
      if (marcacao == null) return const Erro(_marcacaoSumiu);
      final dia = await _carregarPorId(marcacao.diaId);
      if (dia.fechado) {
        return const Erro(
            FalhaValidacao('Este dia está fechado. Reabra o dia para alterar as marcações.'));
      }
      await (_banco.delete(_banco.marcacoes)..where((t) => t.id.equals(marcacaoId))).go();
      return Sucesso(await _recalcularEGravar(marcacao.diaId, _relogio.agora()));
    });
  }

  @override
  Future<Resultado<DiaTrabalho>> definirStatus(
      DateTime data, StatusDia status, String? observacao) {
    return escritaSegura(_banco, () async {
      final civil = data.apenasData;
      final dia = await _carregar(civil);
      if (dia?.fechado ?? false) {
        return const Erro(FalhaValidacao('Este dia está fechado. Reabra o dia para alterá-lo.'));
      }
      final texto = observacao?.trim();
      final diaId = dia?.id ?? await _inserirDia(civil);
      await (_banco.update(_banco.diasTrabalho)..where((t) => t.id.equals(diaId)))
          .write(DiasTrabalhoCompanion(
        status: Value(status),
        statusManual: const Value(true),
        observacao: Value(texto == null || texto.isEmpty ? null : texto),
      ));
      return Sucesso(await _recalcularEGravar(diaId, _relogio.agora()));
    });
  }

  @override
  Future<Resultado<int>> recalcularAPartirDe(DateTime data) {
    return escritaSegura(_banco, () async {
      final abertos = await (_banco.select(_banco.diasTrabalho)
            ..where((t) =>
                t.data.isBiggerOrEqualValue(data.apenasData.iso) & t.fechado.equals(false)))
          .get();
      final agora = _relogio.agora();
      for (final linha in abertos) {
        await _recalcularEGravar(linha.id, agora);
      }
      return Sucesso(abertos.length);
    });
  }

  // ── Internos ─────────────────────────────────────────────────────────────────────────

  static const _marcacaoSumiu =
      FalhaValidacao('Essa marcação não existe mais. Atualize a tela e tente de novo.');

  /// Dia sem registro é calculado na hora com a jornada atual; dia gravado mantém os
  /// valores persistidos e só reavalia a consistência, que depende de "agora".
  DiaTrabalho _preparar(
      DiaTrabalho? gravado, DateTime data, ConfiguracaoJornada jornada, DateTime agora) {
    return gravado == null
        ? _calculadora.calcularDia(DiaTrabalho.vazio(data), jornada, agora: agora)
        : _calculadora.reavaliarConsistencia(gravado, jornada, agora: agora);
  }

  Future<DiaTrabalho?> _carregar(DateTime data) async {
    final linha = await (_banco.select(_banco.diasTrabalho)
          ..where((t) => t.data.equalsValue(data)))
        .getSingleOrNull();
    if (linha == null) return null;
    return _paraEntidade(linha, await _marcacoesDoDia(linha.id));
  }

  Future<DiaTrabalho> _carregarPorId(int diaId) async {
    final linha = await (_banco.select(_banco.diasTrabalho)..where((t) => t.id.equals(diaId)))
        .getSingle();
    return _paraEntidade(linha, await _marcacoesDoDia(diaId));
  }

  Future<List<MarcacaoLinha>> _marcacoesDoDia(int diaId) => (_banco.select(_banco.marcacoes)
        ..where((t) => t.diaId.equals(diaId))
        ..orderBy([(t) => OrderingTerm(expression: t.ordem)]))
      .get();

  Future<MarcacaoLinha?> _buscarMarcacao(int id) =>
      (_banco.select(_banco.marcacoes)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> _inserirDia(DateTime data) => _banco.into(_banco.diasTrabalho).insert(
        DiasTrabalhoCompanion.insert(data: data, atualizadoEm: Value(_relogio.agora())),
      );

  /// RN-01, RN-05 e o cálculo de A5, gravados juntos. Um dia que volta a ficar vazio, sem
  /// status nem observação, deixa de existir no banco ("Sem registro", docs/08, E1).
  Future<DiaTrabalho> _recalcularEGravar(int diaId, DateTime agora) async {
    final jornada = await _jornadas.buscarAtiva();
    final dia = await _carregarPorId(diaId);
    final calculado = _calculadora.calcularDia(dia, jornada, agora: agora);

    final vazio = !calculado.temMarcacoes &&
        calculado.status == StatusDia.normal &&
        !calculado.temObservacao &&
        !calculado.fechado;
    if (vazio) {
      await (_banco.delete(_banco.diasTrabalho)..where((t) => t.id.equals(diaId))).go();
      return _calculadora.calcularDia(DiaTrabalho.vazio(dia.data), jornada, agora: agora);
    }

    for (final marcacao in calculado.marcacoes) {
      await (_banco.update(_banco.marcacoes)..where((t) => t.id.equals(marcacao.id!))).write(
          MarcacoesCompanion(ordem: Value(marcacao.ordem), tipo: Value(marcacao.tipo)));
    }
    await (_banco.update(_banco.diasTrabalho)..where((t) => t.id.equals(diaId)))
        .write(DiasTrabalhoCompanion(
      cargaPrevistaMinutos: Value(calculado.cargaPrevista.inMinutes),
      minutosTrabalhados: Value(calculado.minutosTrabalhados.inMinutes),
      saldoMinutos: Value(calculado.saldo.inMinutes),
      inconsistente: Value(calculado.inconsistente),
      atualizadoEm: Value(agora),
    ));
    return calculado;
  }

  DiaTrabalho _paraEntidade(DiaTrabalhoLinha linha, List<MarcacaoLinha> marcacoes) {
    return DiaTrabalho(
      id: linha.id,
      data: linha.data,
      status: linha.status,
      statusManual: linha.statusManual,
      observacao: linha.observacao,
      marcacoes: [
        for (final m in marcacoes)
          Marcacao(
            id: m.id,
            ordem: m.ordem,
            tipo: m.tipo,
            hora: m.hora,
            origem: m.origem,
            editada: m.editada,
          ),
      ],
      cargaPrevista: Duration(minutes: linha.cargaPrevistaMinutos),
      minutosTrabalhados: Duration(minutes: linha.minutosTrabalhados),
      saldo: Duration(minutes: linha.saldoMinutos),
      inconsistente: linha.inconsistente,
      fechado: linha.fechado,
    );
  }
}
