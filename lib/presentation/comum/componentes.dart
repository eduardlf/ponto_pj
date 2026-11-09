import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/tema.dart';
import '../../domain/enums/enums.dart';
import '../../domain/enums/rotulos.dart';

/// Setas ‹ › com o rótulo do período; tocar no rótulo abre o seletor (docs/04, 4.5).
class SeletorPeriodo extends StatelessWidget {
  final String rotulo;
  final String? subtitulo;
  final String rotuloAnterior;
  final String rotuloProximo;
  final VoidCallback onAnterior;
  final VoidCallback onProximo;
  final VoidCallback? onTocar;
  final VoidCallback? onHoje;

  const SeletorPeriodo({
    super.key,
    required this.rotulo,
    this.subtitulo,
    required this.rotuloAnterior,
    required this.rotuloProximo,
    required this.onAnterior,
    required this.onProximo,
    this.onTocar,
    this.onHoje,
  });

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    return Row(
      children: [
        IconButton(
          tooltip: rotuloAnterior,
          onPressed: onAnterior,
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTocar,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(rotulo,
                      textAlign: TextAlign.center,
                      style: texto.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  if (subtitulo != null)
                    Text(subtitulo!, textAlign: TextAlign.center, style: texto.bodySmall),
                ],
              ),
            ),
          ),
        ),
        if (onHoje != null)
          TextButton(onPressed: onHoje, child: const Text('Hoje')),
        IconButton(
          tooltip: rotuloProximo,
          onPressed: onProximo,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class ItemResumo {
  final String rotulo;
  final String valor;
  final Color? cor;

  const ItemResumo(this.rotulo, this.valor, {this.cor});
}

/// Trio trabalhado / saldo / banco de horas, com barra de progresso opcional.
class CartaoResumo extends StatelessWidget {
  final List<ItemResumo> itens;
  final double? progresso;
  final String? rotuloProgresso;

  const CartaoResumo({super.key, required this.itens, this.progresso, this.rotuloProgresso});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 16,
              runSpacing: 12,
              children: [
                for (final item in itens)
                  Semantics(
                    label: '${item.rotulo}: ${item.valor}',
                    excludeSemantics: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.rotulo, style: tema.textTheme.labelMedium?.copyWith(
                            color: tema.colorScheme.onSurfaceVariant)),
                        const SizedBox(height: 4),
                        Text(item.valor,
                            style: tema.textTheme.titleMedium?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: item.cor,
                              fontFeatures: algarismosTabulares,
                            )),
                      ],
                    ),
                  ),
              ],
            ),
            if (progresso != null) ...[
              const SizedBox(height: 12),
              Semantics(
                label: rotuloProgresso,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: progresso!.clamp(0, 1), minHeight: 8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

IconData iconeDoStatus(StatusDia status) => switch (status) {
      StatusDia.normal => Icons.work_outline,
      StatusDia.folga => Icons.weekend_outlined,
      StatusDia.feriado => Icons.celebration_outlined,
      StatusDia.ferias => Icons.beach_access_outlined,
      StatusDia.atestado => Icons.medical_services_outlined,
      StatusDia.falta => Icons.event_busy_outlined,
      StatusDia.abono => Icons.verified_outlined,
      StatusDia.compensacao => Icons.swap_horiz,
    };

/// Status do dia com ícone e cor: o ícone garante leitura sem depender da cor.
class ChipStatusDia extends StatelessWidget {
  final StatusDia status;

  const ChipStatusDia({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final cores = CoresPonto.de(context);
    final cor = status == StatusDia.falta ? cores.debito : cores.atencao;
    return Chip(
      avatar: Icon(iconeDoStatus(status), size: 18, color: cor),
      label: Text(status.rotulo),
      side: BorderSide(color: cor),
      visualDensity: VisualDensity.compact,
    );
  }
}

/// Ilustração simples, frase e ação sugerida.
class EstadoVazio extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String? mensagem;
  final String? rotuloAcao;
  final VoidCallback? onAcao;

  const EstadoVazio({
    super.key,
    required this.icone,
    required this.titulo,
    this.mensagem,
    this.rotuloAcao,
    this.onAcao,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          ExcludeSemantics(
            child: Icon(icone, size: 48, color: tema.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Text(titulo, textAlign: TextAlign.center, style: tema.textTheme.titleMedium),
          if (mensagem != null) ...[
            const SizedBox(height: 4),
            Text(mensagem!,
                textAlign: TextAlign.center,
                style: tema.textTheme.bodyMedium
                    ?.copyWith(color: tema.colorScheme.onSurfaceVariant)),
          ],
          if (rotuloAcao != null && onAcao != null) ...[
            const SizedBox(height: 16),
            FilledButton(onPressed: onAcao, child: Text(rotuloAcao!)),
          ],
        ],
      ),
    );
  }
}

/// Faixa de aviso com ícone, para pendências e dias inconsistentes.
class FaixaAviso extends StatelessWidget {
  final String texto;
  final IconData icone;
  final Widget? acao;

  const FaixaAviso({
    super.key,
    required this.texto,
    this.icone = Icons.warning_amber_rounded,
    this.acao,
  });

  @override
  Widget build(BuildContext context) {
    final cor = CoresPonto.de(context).atencao;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: cor),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(icone, color: cor),
          const SizedBox(width: 12),
          Expanded(child: Text(texto)),
          if (acao != null) acao!,
        ],
      ),
    );
  }
}

/// Carregando, erro ou conteúdo. Mantém o conteúdo anterior durante a recarga, para que a
/// tela não pisque a cada alteração.
class ConteudoAssincrono<T> extends StatelessWidget {
  final AsyncValue<T> valor;
  final Widget Function(T dados) construtor;
  final VoidCallback? onTentarDeNovo;

  const ConteudoAssincrono({
    super.key,
    required this.valor,
    required this.construtor,
    this.onTentarDeNovo,
  });

  @override
  Widget build(BuildContext context) {
    return valor.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: construtor,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => EstadoVazio(
        icone: Icons.error_outline,
        titulo: 'Não consegui carregar os dados.',
        mensagem: 'Tente de novo em instantes.',
        rotuloAcao: onTentarDeNovo == null ? null : 'Tentar de novo',
        onAcao: onTentarDeNovo,
      ),
    );
  }
}

/// Para telas cujo conteúdo traz o próprio `Scaffold`: enquanto carregam ou se falham, ainda
/// mostram a barra com o título e o botão de voltar.
class TelaAssincrona<T> extends StatelessWidget {
  final String titulo;
  final AsyncValue<T> valor;
  final Widget Function(T dados) construtor;
  final VoidCallback? onTentarDeNovo;

  const TelaAssincrona({
    super.key,
    required this.titulo,
    required this.valor,
    required this.construtor,
    this.onTentarDeNovo,
  });

  @override
  Widget build(BuildContext context) {
    return valor.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: construtor,
      loading: () => Scaffold(
        appBar: AppBar(title: Text(titulo)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Scaffold(
        appBar: AppBar(title: Text(titulo)),
        body: EstadoVazio(
          icone: Icons.error_outline,
          titulo: 'Não consegui carregar os dados.',
          mensagem: 'Tente de novo em instantes.',
          rotuloAcao: onTentarDeNovo == null ? null : 'Tentar de novo',
          onAcao: onTentarDeNovo,
        ),
      ),
    );
  }
}

/// Título de seção dentro de listas.
class TituloSecao extends StatelessWidget {
  final String texto;

  const TituloSecao(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Semantics(
        header: true,
        child: Text(texto,
            style: tema.textTheme.titleSmall?.copyWith(color: tema.colorScheme.primary)),
      ),
    );
  }
}
