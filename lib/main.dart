import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'data/local/banco_local.dart';
import 'data/repositorios/configuracao_repositorios_drift.dart';

/// Abre o banco, carrega o que o primeiro quadro precisa e sobe o app (docs/09, 9.6).
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final banco = BancoLocal(driftDatabase(
    name: 'ponto_pj',
    native: DriftNativeOptions(
      databasePath: () async =>
          p.join((await getApplicationDocumentsDirectory()).path, 'ponto_pj.db'),
    ),
  ));
  final preferencias = PreferenciasRepositorioDrift(banco);
  final onboardingConcluido = await preferencias.onboardingConcluido();
  final tema = await preferencias.tema();

  runApp(ProviderScope(
    overrides: [
      bancoLocalProvider.overrideWithValue(banco),
      onboardingConcluidoProvider.overrideWith((ref) => onboardingConcluido),
      temaProvider.overrideWith((ref) => tema),
    ],
    child: const PontoPjApp(),
  ));
}
