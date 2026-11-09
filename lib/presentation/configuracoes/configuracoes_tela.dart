import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/formatadores.dart';
import '../comum/componentes.dart';
import 'configuracoes_controller.dart';

/// TL-12: índice de toda a configuração, com as pendências no topo.
class ConfiguracoesTela extends ConsumerWidget {
  const ConfiguracoesTela({super.key});

  static const _temas = {'sistema': 'Automático, como o aparelho', 'claro': 'Claro', 'escuro': 'Escuro'};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumo = ref.watch(resumoConfiguracoesProvider);
    final calculadora = ref.watch(calculadoraProvider);
    final tema = ref.watch(temaProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ConteudoAssincrono(
        valor: resumo,
        onTentarDeNovo: () => ref.invalidate(resumoConfiguracoesProvider),
        construtor: (r) => ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            for (final pendencia in r.pendencias)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: FaixaAviso(
                  icone: Icons.pending_actions_outlined,
                  texto: '${pendencia.titulo}: ${pendencia.explicacao}',
                  acao: TextButton(
                    onPressed: () => context.push(pendencia.rota),
                    child: const Text('Resolver'),
                  ),
                ),
              ),
            const TituloSecao('Você e seu horário'),
            ListTile(
              leading: const Icon(Icons.badge_outlined),
              title: const Text('Seus dados'),
              subtitle: Text(r.perfil?.nome ?? 'Ainda não preenchidos'),
              onTap: () => context.push('/perfil'),
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Jornada de trabalho'),
              subtitle: Text('${formatarDuracao(calculadora.cargaSemanal(r.jornada))} por semana'),
              onTap: () => context.push('/jornada'),
            ),
            const TituloSecao('Fechamento do mês'),
            ListTile(
              leading: const Icon(Icons.table_chart_outlined),
              title: const Text('Modelo de planilha'),
              subtitle: Text(r.modelo == null
                  ? 'Nenhuma planilha configurada'
                  : '${r.modelo!.nomeArquivoOriginal} · aba ${r.modelo!.nomeAba}'),
              onTap: () => context.push('/planilha/wizard'),
            ),
            ListTile(
              leading: const Icon(Icons.alternate_email),
              title: const Text('E-mail'),
              subtitle: Text(r.email.temDestinatario
                  ? r.email.destinatarios.join(', ')
                  : 'Nenhum destinatário'),
              onTap: () => context.push('/email'),
            ),
            const TituloSecao('Aparência'),
            ListTile(
              leading: const Icon(Icons.contrast),
              title: const Text('Tema'),
              subtitle: Text(_temas[tema] ?? _temas['sistema']!),
              onTap: () => _escolherTema(context, ref, tema),
            ),
            const TituloSecao('Privacidade'),
            const ListTile(
              leading: Icon(Icons.lock_outline),
              title: Text('Seus dados ficam só neste aparelho'),
              subtitle: Text('O app não usa internet. O único dado que sai é a planilha que '
                  'você mesmo envia.'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _escolherTema(BuildContext context, WidgetRef ref, String atual) async {
    final escolhido = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Tema'),
        children: [
          for (final MapEntry(key: valor, value: rotulo) in _temas.entries)
            RadioListTile<String>(
              value: valor,
              groupValue: atual,
              title: Text(rotulo),
              onChanged: (v) => Navigator.of(context).pop(v),
            ),
        ],
      ),
    );
    if (escolhido == null || escolhido == atual) return;
    ref.read(temaProvider.notifier).state = escolhido;
    await ref.read(preferenciasRepositorioProvider).definirTema(escolhido);
  }
}
