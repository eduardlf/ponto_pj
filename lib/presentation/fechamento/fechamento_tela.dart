import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/tema.dart';
import '../../core/extensoes/data_extensoes.dart';
import '../../core/falhas.dart';
import '../../core/formatadores.dart';
import '../../core/resultado.dart';
import '../../domain/entidades/envio_mensal.dart';
import '../../domain/enums/enums.dart';
import '../comum/componentes.dart';
import '../comum/interacao.dart';
import 'fechamento_controller.dart';

/// TL-21: resumo, pendências, geração e envio, sem trocar de tela (fluxo A4).
class FechamentoTela extends ConsumerStatefulWidget {
  final ChaveCompetencia competenciaInicial;

  const FechamentoTela({super.key, this.competenciaInicial});

  @override
  ConsumerState<FechamentoTela> createState() => _FechamentoTelaState();
}

class _FechamentoTelaState extends ConsumerState<FechamentoTela> {
  late ChaveCompetencia _chave = widget.competenciaInicial;
  var _gerando = false;

  /// Avisos da última geração feita nesta tela; somem ao trocar de competência.
  var _avisos = const <String>[];

  @override
  Widget build(BuildContext context) {
    final provider = fechamentoControllerProvider(_chave);
    final estado = ref.watch(provider);
    return Scaffold(
      appBar: AppBar(title: const Text('Fechamento do mês')),
      body: ConteudoAssincrono(
        valor: estado,
        onTentarDeNovo: () => ref.invalidate(provider),
        construtor: (e) => _conteudo(context, e, ref.read(provider.notifier)),
      ),
    );
  }

  Widget _conteudo(BuildContext context, FechamentoEstado e, FechamentoController controller) {
    final cores = CoresPonto.de(context);
    final resolvedor = ref.read(resolvedorVariaveisProvider);
    final agora = ref.read(relogioProvider).agora();
    final competencia = e.competencia;
    final ultimo = e.ultimoEnvio;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        SeletorPeriodo(
          rotulo: '${nomeMesCapitalizado(competencia.mes)} / ${competencia.ano}',
          subtitulo: competencia.periodoFormatado(),
          rotuloAnterior: 'Competência anterior',
          rotuloProximo: 'Próxima competência',
          onAnterior: () => setState(() {
            _chave = (ano: competencia.anterior().ano, mes: competencia.anterior().mes);
            _avisos = const [];
          }),
          onProximo: () => setState(() {
            _chave = (ano: competencia.seguinte().ano, mes: competencia.seguinte().mes);
            _avisos = const [];
          }),
        ),
        const SizedBox(height: 8),
        CartaoResumo(itens: [
          ItemResumo('Dias', '${competencia.totalDias()} · ${e.resumo.diasUteis} úteis'),
          ItemResumo('Trabalhado', formatarDuracao(e.resumo.trabalhado)),
          ItemResumo('Saldo', formatarDuracaoComSinal(e.resumo.saldo),
              cor: cores.doSaldo(context, e.resumo.saldo)),
        ]),
        const TituloSecao('Antes de gerar, confira'),
        if (e.resumo.pendencias.isEmpty)
          Row(children: [
            Icon(Icons.check_circle_outline, color: cores.credito),
            const SizedBox(width: 8),
            const Text('Nenhuma pendência'),
          ])
        else
          Card(
            child: Column(children: [
              for (final pendencia in e.resumo.pendencias)
                ListTile(
                  leading: Icon(Icons.warning_amber_rounded, color: cores.atencao),
                  title: Text(formatarDiaMes(pendencia.data),
                      style: const TextStyle(fontFeatures: algarismosTabulares)),
                  subtitle: Text(pendencia.descricao),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/dia?data=${pendencia.data.iso}'),
                ),
            ]),
          ),
        const TituloSecao('Configuração em uso'),
        Card(
          child: Column(children: [
            ListTile(
              leading: const Icon(Icons.table_chart_outlined),
              title: const Text('Modelo'),
              subtitle: Text(e.modelo?.nomeArquivoOriginal ?? 'Nenhuma planilha configurada'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/planilha/wizard'),
            ),
            ListTile(
              leading: const Icon(Icons.alternate_email),
              title: const Text('Para'),
              subtitle: Text(e.email.temDestinatario
                  ? e.email.destinatarios.join(', ')
                  : 'Ninguém ainda'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/email'),
            ),
            ListTile(
              leading: const Icon(Icons.subject),
              title: const Text('Assunto'),
              subtitle: Text(resolvedor.resolver(e.email.assuntoModelo, e.contexto(agora))),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        if (e.modelo == null)
          FaixaAviso(
            texto: 'Configure a planilha da empresa antes de fechar o mês.',
            acao: TextButton(
              onPressed: () => context.push('/planilha/wizard'),
              child: const Text('Configurar'),
            ),
          )
        else if (!e.arquivoBaseExiste)
          FaixaAviso(
            texto: 'A planilha modelo não está mais no aparelho. Importe o arquivo de novo.',
            acao: TextButton(
              onPressed: () => context.push('/planilha/wizard'),
              child: const Text('Importar'),
            ),
          )
        else
          FilledButton.icon(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
            onPressed: _gerando ? null : () => _gerar(context, e, controller),
            icon: _gerando
                ? const SizedBox.square(
                    dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.table_view),
            label: Text(_gerando
                ? 'Gerando…'
                : (ultimo == null ? 'Gerar planilha' : 'Gerar de novo')),
          ),
        for (final aviso in _avisos)
          Padding(padding: const EdgeInsets.only(top: 8), child: FaixaAviso(texto: aviso)),
        if (ultimo != null) ...[
          const SizedBox(height: 16),
          _CartaoEnvio(
            envio: ultimo,
            aoAbrir: () async {
              final resultado = await controller.abrirArquivo(ultimo);
              if (context.mounted) _avisarFalha(context, resultado);
            },
            aoCompartilhar: () => _compartilharEPerguntar(context, ultimo, controller),
            aoEnviar: () => _enviar(context, e, ultimo, controller),
            aoConfirmar: () => _confirmar(context, ultimo, controller),
          ),
        ],
      ],
    );
  }

  void _avisarFalha(BuildContext context, Resultado<void> resultado) {
    if (resultado case Erro(:final falha)) mostrarFalha(context, falha);
  }

  Future<void> _gerar(
      BuildContext context, FechamentoEstado e, FechamentoController controller) async {
    final pendencias = e.resumo.pendencias.length;
    if (pendencias > 0) {
      final seguir = await confirmar(
        context,
        titulo: 'Gerar com pendências?',
        mensagem: 'Este mês tem $pendencias pendência${pendencias == 1 ? '' : 's'}. '
            'Quer gerar assim mesmo?',
        rotuloConfirmar: 'Gerar assim mesmo',
      );
      if (!seguir) return;
    }
    setState(() => _gerando = true);
    final resultado = await controller.gerar();
    if (!context.mounted) return;
    setState(() => _gerando = false);
    resultado.quando(
      sucesso: (geracao) {
        setState(() => _avisos = geracao.avisos);
        mostrarMensagem(context, 'Planilha gerada. Confira antes de enviar.');
      },
      erro: (falha) => mostrarFalha(context, falha),
    );
  }

  /// Pré-visualiza, abre o cliente de e-mail e, na volta, pergunta (RN-23).
  Future<void> _enviar(BuildContext context, FechamentoEstado e, EnvioMensal envio,
      FechamentoController controller) async {
    if (!e.email.temDestinatario) {
      mostrarMensagem(context, 'Diga para quem a planilha vai antes de enviar.');
      context.push('/email');
      return;
    }
    final resolvedor = ref.read(resolvedorVariaveisProvider);
    final contexto = e.contexto(envio.geradoEm);
    final abrir = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conferir o e-mail'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Para: ${e.email.destinatarios.join(', ')}'),
              if (e.email.copia.isNotEmpty) Text('Cópia: ${e.email.copia.join(', ')}'),
              const SizedBox(height: 8),
              Text('Assunto: ${resolvedor.resolver(e.email.assuntoModelo, contexto)}',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(resolvedor.resolver(e.email.corpoModelo, contexto)),
              const SizedBox(height: 8),
              Row(children: [
                const Icon(Icons.attach_file, size: 18),
                const SizedBox(width: 4),
                Expanded(child: Text(envio.nomeArquivo)),
              ]),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Abrir e-mail')),
        ],
      ),
    );
    if (abrir != true || !context.mounted) return;

    final resultado = await controller.abrirEmail(envio);
    if (!context.mounted) return;
    if (resultado case Erro(:final falha)) {
      if (falha is! FalhaSistemaOperacional) return mostrarFalha(context, falha);
      final compartilhar = await confirmar(
        context,
        titulo: 'Sem app de e-mail',
        mensagem: falha.mensagem,
        rotuloConfirmar: 'Compartilhar',
        rotuloCancelar: 'Fechar',
      );
      if (compartilhar && context.mounted) {
        await _compartilharEPerguntar(context, envio, controller);
      }
      return;
    }
    await _perguntarSeEnviou(context, envio, controller);
  }

  Future<void> _compartilharEPerguntar(
      BuildContext context, EnvioMensal envio, FechamentoController controller) async {
    final resultado = await controller.compartilhar(envio);
    if (!context.mounted) return;
    if (resultado case Erro(:final falha)) return mostrarFalha(context, falha);
    if (envio.status != StatusEnvio.enviado) await _perguntarSeEnviou(context, envio, controller);
  }

  Future<void> _perguntarSeEnviou(
      BuildContext context, EnvioMensal envio, FechamentoController controller) async {
    final enviou = await confirmar(
      context,
      titulo: 'Você conseguiu enviar?',
      mensagem: 'O app não consegue confirmar isso sozinho.',
      rotuloConfirmar: 'Enviei',
      rotuloCancelar: 'Ainda não',
    );
    if (enviou && context.mounted) await _confirmar(context, envio, controller);
  }

  Future<void> _confirmar(
      BuildContext context, EnvioMensal envio, FechamentoController controller) async {
    final resultado = await controller.confirmarEnvio(envio);
    if (!context.mounted) return;
    resultado.quando(
      sucesso: (_) => mostrarMensagem(context, 'Pronto! Competência marcada como enviada.'),
      erro: (falha) => mostrarFalha(context, falha),
    );
  }
}

class _CartaoEnvio extends StatelessWidget {
  final EnvioMensal envio;
  final VoidCallback aoAbrir;
  final VoidCallback aoCompartilhar;
  final VoidCallback aoEnviar;
  final VoidCallback aoConfirmar;

  const _CartaoEnvio({
    required this.envio,
    required this.aoAbrir,
    required this.aoCompartilhar,
    required this.aoEnviar,
    required this.aoConfirmar,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = CoresPonto.de(context);
    final enviado = envio.status == StatusEnvio.enviado;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Icon(enviado ? Icons.mark_email_read_outlined : Icons.check_circle_outline,
                  color: cores.credito),
              const SizedBox(width: 8),
              Expanded(
                child: Text(enviado ? 'Enviado' : 'Planilha gerada',
                    style: tema.textTheme.titleMedium),
              ),
            ]),
            const SizedBox(height: 4),
            Text('${envio.nomeArquivo} · ${formatarTamanhoArquivo(envio.tamanhoBytes)}'),
            Text('Gerada em ${formatarDataHora(envio.geradoEm)}'
                '${enviado ? ' · Enviada em ${formatarDataHora(envio.enviadoEm!)}' : ''}',
                style: tema.textTheme.bodySmall),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: [
              OutlinedButton.icon(
                  onPressed: aoAbrir, icon: const Icon(Icons.visibility_outlined), label: const Text('Abrir')),
              OutlinedButton.icon(
                  onPressed: aoCompartilhar, icon: const Icon(Icons.share_outlined), label: const Text('Compartilhar')),
            ]),
            const SizedBox(height: 8),
            FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              onPressed: aoEnviar,
              icon: const Icon(Icons.send_outlined),
              label: Text(enviado ? 'Enviar de novo' : 'Enviar por e-mail'),
            ),
            if (!enviado) ...[
              const SizedBox(height: 12),
              FaixaAviso(
                icone: Icons.help_outline,
                texto: 'Você já enviou esta planilha? O app não consegue confirmar isso sozinho.',
                acao: TextButton(onPressed: aoConfirmar, child: const Text('Enviei')),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
