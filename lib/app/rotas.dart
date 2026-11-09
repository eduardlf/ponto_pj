import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/extensoes/data_extensoes.dart';
import '../presentation/configuracoes/configuracoes_tela.dart';
import '../presentation/configuracoes/email_tela.dart';
import '../presentation/configuracoes/jornada_tela.dart';
import '../presentation/configuracoes/perfil_tela.dart';
import '../presentation/dia/dia_tela.dart';
import '../presentation/fechamento/fechamento_tela.dart';
import '../presentation/historico/historico_tela.dart';
import '../presentation/menu/menu_tela.dart';
import '../presentation/onboarding/onboarding_tela.dart';
import '../presentation/periodo/mes_tela.dart';
import '../presentation/periodo/semana_tela.dart';
import '../presentation/planilha_wizard/wizard_tela.dart';
import 'providers.dart';

/// Navegação (docs/09, seção 9.7). Três abas com pilha própria; o wizard, o fechamento e
/// os formulários de configuração abrem por cima, de qualquer lugar.
final rotasProvider = Provider<GoRouter>((ref) {
  final concluido = ValueNotifier<bool>(ref.read(onboardingConcluidoProvider));
  ref.listen<bool>(onboardingConcluidoProvider, (_, valor) => concluido.value = valor);

  final rotas = GoRouter(
    initialLocation: '/dia',
    refreshListenable: concluido,
    redirect: (context, state) {
      final local = state.matchedLocation;
      final noOnboarding = local == '/onboarding';
      // O wizard também é aberto de dentro do onboarding.
      if (!concluido.value && !noOnboarding && !local.startsWith('/planilha')) {
        return '/onboarding';
      }
      if (concluido.value && noOnboarding) return '/dia';
      return null;
    },
    routes: [
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingTela()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, concha) => _ConchaNavegacao(concha: concha),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/menu',
              builder: (_, __) => const MenuTela(),
              routes: [
                GoRoute(
                  path: 'semana',
                  builder: (_, estado) =>
                      SemanaTela(data: lerDataIso(estado.uri.queryParameters['data'] ?? '')),
                ),
                GoRoute(
                  path: 'mes',
                  builder: (_, estado) => MesTela(
                    ano: int.tryParse(estado.uri.queryParameters['ano'] ?? ''),
                    mes: int.tryParse(estado.uri.queryParameters['mes'] ?? ''),
                  ),
                ),
                GoRoute(path: 'historico', builder: (_, __) => const HistoricoTela()),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/dia',
              builder: (_, estado) =>
                  DiaTela(data: lerDataIso(estado.uri.queryParameters['data'] ?? '')),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/configuracoes', builder: (_, __) => const ConfiguracoesTela()),
          ]),
        ],
      ),
      GoRoute(path: '/perfil', builder: (_, __) => const PerfilTela()),
      GoRoute(
        path: '/jornada',
        builder: (_, __) => const JornadaTela(),
        routes: [
          GoRoute(
            path: ':dia',
            builder: (_, estado) =>
                JornadaDiaTela(diaSemana: int.tryParse(estado.pathParameters['dia'] ?? '') ?? 1),
          ),
        ],
      ),
      GoRoute(path: '/email', builder: (_, __) => const EmailTela()),
      GoRoute(path: '/planilha/wizard', builder: (_, __) => const WizardTela()),
      GoRoute(
        path: '/fechamento',
        builder: (_, estado) {
          final ano = int.tryParse(estado.uri.queryParameters['ano'] ?? '');
          final mes = int.tryParse(estado.uri.queryParameters['mes'] ?? '');
          return FechamentoTela(
            competenciaInicial: ano == null || mes == null ? null : (ano: ano, mes: mes),
          );
        },
      ),
    ],
  );

  ref.onDispose(() {
    rotas.dispose();
    concluido.dispose();
  });
  return rotas;
});

class _ConchaNavegacao extends StatelessWidget {
  final StatefulNavigationShell concha;

  const _ConchaNavegacao({required this.concha});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: concha,
      bottomNavigationBar: NavigationBar(
        selectedIndex: concha.currentIndex,
        onDestinationSelected: (indice) =>
            concha.goBranch(indice, initialLocation: indice == concha.currentIndex),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.menu), label: 'Menu'),
          NavigationDestination(
              icon: Icon(Icons.today_outlined), selectedIcon: Icon(Icons.today), label: 'Dia'),
          NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Ajustes'),
        ],
      ),
    );
  }
}
