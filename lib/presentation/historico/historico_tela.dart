import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/tema.dart';
import '../../core/formatadores.dart';
import '../../domain/entidades/envio_mensal.dart';
import '../../domain/enums/enums.dart';
import '../../domain/enums/rotulos.dart';
import '../comum/componentes.dart';
import '../comum/interacao.dart';

/// Um envio e se o arquivo dele ainda existe no aparelho.
typedef ItemHistorico = ({EnvioMensal envio, bool arquivoExiste});

final historicoProvider = FutureProvider.autoDispose<List<ItemHistorico>>((ref) async {
  ref.watch(versaoDadosProvider);
  final envios = await ref.watch(envioRepositorioProvider).listar();
  final armazenamento = ref.watch(armazenamentoProvider);
  return [
    for (final envio in envios)
      (envio: envio, arquivoExiste: await armazenamento.existe(envio.caminhoArquivo)),
  ];
});

/// TL-23: competências geradas e enviadas (RF-42, RF-43).
class HistoricoTela extends ConsumerWidget {
  const HistoricoTela({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historico = ref.watch(historicoProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de envios')),
      body: ConteudoAssincrono(
        valor: historico,
        onTentarDeNovo: () => ref.invalidate(historicoProvider),
        construtor: (itens) => itens.isEmpty
            ? EstadoVazio(
                icone: Icons.inbox_outlined,
                titulo: 'Nenhuma planilha gerada ainda.',
                mensagem: 'Gere a primeira no fechamento do mês.',
                rotuloAcao: 'Fechar o mês',
                onAcao: () => context.push('/fechamento'),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: itens.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) => _ItemEnvio(item: itens[i]),
              ),
      ),
    );
  }
}

class _ItemEnvio extends ConsumerWidget {
  final ItemHistorico item;

  const _ItemEnvio({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final cores = CoresPonto.de(context);
    final envio = item.envio;
    final enviado = envio.status == StatusEnvio.enviado;
    final servico = ref.read(servicoArquivosExternosProvider);

    Future<void> excluirArquivo() async {
      final confirmado = await confirmar(
        context,
        titulo: 'Excluir o arquivo?',
        mensagem: 'O arquivo sai do aparelho, mas o registro de que ele foi '
            '${enviado ? 'enviado' : 'gerado'} continua no histórico.',
        rotuloConfirmar: 'Excluir',
        destrutivo: true,
      );
      if (!confirmado) return;
      final resultado = await ref.read(armazenamentoProvider).excluir(envio.caminhoArquivo);
      if (!context.mounted) return;
      resultado.quando(
        sucesso: (_) => ref.invalidate(historicoProvider),
        erro: (falha) => mostrarFalha(context, falha),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child: Text(formatarCompetencia(envio.competenciaAno, envio.competenciaMes),
                    style: tema.textTheme.titleMedium),
              ),
              Icon(enviado ? Icons.check_circle : Icons.hourglass_top,
                  size: 18, color: enviado ? cores.credito : cores.atencao),
              const SizedBox(width: 4),
              Text(envio.status.rotulo),
              PopupMenuButton<String>(
                tooltip: 'Mais opções',
                onSelected: (opcao) {
                  if (opcao == 'excluir') excluirArquivo();
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'excluir',
                    enabled: item.arquivoExiste,
                    child: const Text('Excluir o arquivo'),
                  ),
                ],
              ),
            ]),
            Text(item.arquivoExiste
                ? '${envio.nomeArquivo} · ${formatarTamanhoArquivo(envio.tamanhoBytes)}'
                : '${envio.nomeArquivo} · arquivo não disponível'),
            Text('Gerado em ${formatarDataHora(envio.geradoEm)} · '
                '${enviado ? 'Enviado em ${formatarDataHora(envio.enviadoEm!)}' : 'não confirmado'}',
                style: tema.textTheme.bodySmall),
            if (envio.observacao != null) ...[
              const SizedBox(height: 4),
              Text(envio.observacao!,
                  style: tema.textTheme.bodySmall?.copyWith(color: tema.colorScheme.onSurfaceVariant)),
            ],
            Wrap(spacing: 4, children: [
              TextButton(
                onPressed: item.arquivoExiste
                    ? () async {
                        final r = await servico.abrir(envio.caminhoArquivo);
                        if (r.falhaOuNula case final falha? when context.mounted) {
                          mostrarFalha(context, falha);
                        }
                      }
                    : null,
                child: const Text('Abrir'),
              ),
              TextButton(
                onPressed: item.arquivoExiste
                    ? () async {
                        final r = await servico.compartilhar(envio.caminhoArquivo);
                        if (r.falhaOuNula case final falha? when context.mounted) {
                          mostrarFalha(context, falha);
                        }
                      }
                    : null,
                child: const Text('Compartilhar'),
              ),
              TextButton(
                onPressed: () => context.push(
                    '/fechamento?ano=${envio.competenciaAno}&mes=${envio.competenciaMes}'),
                child: Text(enviado ? 'Regerar' : 'Enviar'),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
