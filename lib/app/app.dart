import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';
import 'rotas.dart';
import 'tema.dart';

/// O app em português do Brasil, com tema claro e escuro (RNF-04, RNF-07).
class PontoPjApp extends ConsumerWidget {
  const PontoPjApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = ref.watch(temaProvider);
    return MaterialApp.router(
      title: 'Ponto PJ',
      debugShowCheckedModeBanner: false,
      theme: temaClaro(),
      darkTheme: temaEscuro(),
      themeMode: switch (tema) {
        'claro' => ThemeMode.light,
        'escuro' => ThemeMode.dark,
        _ => ThemeMode.system,
      },
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: ref.watch(rotasProvider),
    );
  }
}
