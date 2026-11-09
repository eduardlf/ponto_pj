import 'package:drift/drift.dart';

import '../../domain/entidades/configuracao_email.dart';
import '../../domain/enums/enums.dart';
import 'conversores.dart';
import 'tabelas.dart';

part 'banco_local.g.dart';

/// Banco SQLite local (ADR-01). Esquema e dados iniciais em docs/06, seções 6.4 e 6.7.
@DriftDatabase(tables: [
  PerfisUsuario,
  PreferenciasApp,
  ConfiguracoesJornada,
  JornadasDiaSemana,
  TurnosPrevistos,
  DiasTrabalho,
  Marcacoes,
  Feriados,
  ModelosPlanilha,
  MapeamentosColuna,
  CelulasFixas,
  TextosStatus,
  ConfiguracoesEmail,
  EnviosMensais,
  ConfiguracoesNotificacao,
])
class BancoLocal extends _$BancoLocal {
  BancoLocal(super.executor);

  /// Toda alteração futura incrementa a versão e acrescenta um passo em `onUpgrade`, sem
  /// jamais recriar tabelas com dados de ponto (RNF-09).
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          await migrator.createAll();
          await _semear();
        },
        beforeOpen: (detalhes) async {
          // Sem isso o SQLite ignora as exclusões em cascata do diagrama ER.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Dados semeados na criação (docs/06, seção 6.7). `perfil_usuario` não é semeado: sua
  /// ausência é o que mostra a pendência "Seus dados". Feriados ficaram fora desta entrega.
  Future<void> _semear() async {
    final jornadaId = await into(configuracoesJornada).insert(
      ConfiguracoesJornadaCompanion.insert(),
    );
    for (var diaSemana = 1; diaSemana <= 7; diaSemana++) {
      final trabalha = diaSemana <= 5;
      final diaId = await into(jornadasDiaSemana).insert(JornadasDiaSemanaCompanion.insert(
        configuracaoId: jornadaId,
        diaSemana: diaSemana,
        trabalha: trabalha,
        cargaMinutos: trabalha ? 480 : 0,
      ));
      if (!trabalha) continue;
      await into(turnosPrevistos).insert(TurnosPrevistosCompanion.insert(
        jornadaDiaId: diaId,
        ordem: 1,
        horaEntrada: const Duration(hours: 8),
        horaSaida: const Duration(hours: 12),
      ));
      await into(turnosPrevistos).insert(TurnosPrevistosCompanion.insert(
        jornadaDiaId: diaId,
        ordem: 2,
        horaEntrada: const Duration(hours: 13),
        horaSaida: const Duration(hours: 17),
      ));
    }

    await into(configuracoesEmail).insert(ConfiguracoesEmailCompanion.insert(
      destinatarios: '',
      assuntoModelo: ConfiguracaoEmail.assuntoPadrao,
      corpoModelo: ConfiguracaoEmail.corpoPadrao,
      templateNomeArquivo: ConfiguracaoEmail.nomeArquivoPadrao,
    ));

    for (final tipo in TipoNotificacao.values) {
      final fechamento = tipo == TipoNotificacao.fechamentoMes;
      await into(configuracoesNotificacao).insert(ConfiguracoesNotificacaoCompanion.insert(
        tipo: tipo,
        hora: Value(fechamento ? 1140 : null),
        diaReferencia: Value(fechamento ? -1 : null),
      ));
    }

    await into(preferenciasApp).insert(
        PreferenciasAppCompanion.insert(chave: ChavesPreferencia.tema, valor: 'sistema'));
    await into(preferenciasApp).insert(PreferenciasAppCompanion.insert(
        chave: ChavesPreferencia.onboardingConcluido, valor: 'false'));
  }
}

/// Chaves previstas de `preferencia_app` (docs/06, seção 6.4).
abstract final class ChavesPreferencia {
  static const tema = 'tema';
  static const onboardingConcluido = 'onboarding_concluido';
}
