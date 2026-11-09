import 'package:collection/collection.dart';
import 'package:drift/drift.dart';

import '../../core/resultado.dart';
import '../../domain/entidades/configuracao_jornada.dart';
import '../../domain/repositorios/repositorios.dart';
import '../local/banco_local.dart';
import 'escrita_segura.dart';

class JornadaRepositorioDrift implements JornadaRepositorio {
  final BancoLocal _banco;

  JornadaRepositorioDrift(this._banco);

  @override
  Future<ConfiguracaoJornada> buscarAtiva() async {
    final configuracao = await (_banco.select(_banco.configuracoesJornada)
          ..where((t) => t.ativa.equals(true))
          ..limit(1))
        .getSingleOrNull();
    if (configuracao == null) {
      // Só acontece com um banco adulterado: a jornada padrão é semeada na criação.
      return ConfiguracaoJornada(
          dias: [for (var d = 1; d <= 7; d++) JornadaDiaSemana.semTrabalho(d)]);
    }

    final dias = await (_banco.select(_banco.jornadasDiaSemana)
          ..where((t) => t.configuracaoId.equals(configuracao.id)))
        .get();
    final turnos = await (_banco.select(_banco.turnosPrevistos)
          ..where((t) => t.jornadaDiaId.isIn(dias.map((d) => d.id)))
          ..orderBy([(t) => OrderingTerm(expression: t.ordem)]))
        .get();
    final turnosPorDia = groupBy(turnos, (TurnoPrevistoLinha t) => t.jornadaDiaId);

    return ConfiguracaoJornada(
      id: configuracao.id,
      nome: configuracao.nome,
      tolerancia: Duration(minutes: configuracao.toleranciaMinutos),
      permiteViradaDia: configuracao.permiteViradaDia,
      dataInicioBanco: configuracao.dataInicioBanco,
      dias: [
        for (final dia in dias.sortedBy<num>((d) => d.diaSemana))
          JornadaDiaSemana(
            id: dia.id,
            diaSemana: dia.diaSemana,
            trabalha: dia.trabalha,
            carga: Duration(minutes: dia.cargaMinutos),
            cargaManual: dia.cargaManual,
            turnos: [
              for (final t in turnosPorDia[dia.id] ?? const <TurnoPrevistoLinha>[])
                TurnoPrevisto(ordem: t.ordem, entrada: t.horaEntrada, saida: t.horaSaida),
            ],
          ),
      ],
    );
  }

  @override
  Future<Resultado<ConfiguracaoJornada>> salvar(ConfiguracaoJornada jornada) async {
    final resultado = await escritaSegura(_banco, () async {
      final atual = await (_banco.select(_banco.configuracoesJornada)
            ..where((t) => t.ativa.equals(true))
            ..limit(1))
          .getSingleOrNull();
      final configuracaoId = atual?.id ??
          await _banco.into(_banco.configuracoesJornada).insert(
                ConfiguracoesJornadaCompanion.insert(),
              );

      await (_banco.update(_banco.configuracoesJornada)
            ..where((t) => t.id.equals(configuracaoId)))
          .write(ConfiguracoesJornadaCompanion(
        nome: Value(jornada.nome),
        toleranciaMinutos: Value(jornada.tolerancia.inMinutes),
        permiteViradaDia: Value(jornada.permiteViradaDia),
        dataInicioBanco: Value(jornada.dataInicioBanco),
      ));

      for (var diaSemana = 1; diaSemana <= 7; diaSemana++) {
        final dia = jornada.paraDiaSemana(diaSemana);
        final existente = await (_banco.select(_banco.jornadasDiaSemana)
              ..where((t) =>
                  t.configuracaoId.equals(configuracaoId) & t.diaSemana.equals(diaSemana)))
            .getSingleOrNull();
        final valores = JornadasDiaSemanaCompanion(
          configuracaoId: Value(configuracaoId),
          diaSemana: Value(diaSemana),
          trabalha: Value(dia.trabalha),
          cargaMinutos: Value(dia.trabalha ? dia.carga.inMinutes : 0),
          cargaManual: Value(dia.cargaManual),
        );
        final diaId = existente?.id ??
            await _banco.into(_banco.jornadasDiaSemana).insert(valores);
        if (existente != null) {
          await (_banco.update(_banco.jornadasDiaSemana)..where((t) => t.id.equals(diaId)))
              .write(valores);
        }
        await (_banco.delete(_banco.turnosPrevistos)..where((t) => t.jornadaDiaId.equals(diaId)))
            .go();
        final turnos = dia.turnos.sortedBy<num>((t) => t.ordem);
        for (var i = 0; i < turnos.length; i++) {
          await _banco.into(_banco.turnosPrevistos).insert(TurnosPrevistosCompanion.insert(
                jornadaDiaId: diaId,
                ordem: i + 1,
                horaEntrada: turnos[i].entrada,
                horaSaida: turnos[i].saida,
              ));
        }
      }
      return const Sucesso(null);
    });

    return switch (resultado) {
      Sucesso() => Sucesso(await buscarAtiva()),
      Erro(:final falha) => Erro(falha),
    };
  }
}
