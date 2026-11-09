import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/tema.dart';
import '../../core/extensoes/data_extensoes.dart';
import '../../core/formatadores.dart';
import '../../domain/entidades/dia_trabalho.dart';
import '../../domain/enums/enums.dart';
import '../../domain/enums/rotulos.dart';
import '../comum/componentes.dart';
import '../comum/interacao.dart';
import 'periodo_provider.dart';

/// TL-07: os sete dias da semana, de segunda a domingo (RF-16).
class SemanaTela extends ConsumerWidget {
  /// Qualquer data da semana; nula é a semana de hoje.
  final DateTime? data;

  const SemanaTela({super.key, this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hoje = ref.watch(relogioProvider).agora().apenasData;
    final inicio = (data ?? hoje).inicioDaSemana;
    final fim = inicio.somarDias(6);
    final periodo = ref.watch(periodoProvider((inicio: inicio, fim: fim)));
    final cores = CoresPonto.de(context);

    void irPara(DateTime d) => context.go('/menu/semana?data=${d.iso}');

    return Scaffold(
      appBar: AppBar(title: const Text('Semana')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          SeletorPeriodo(
            rotulo: '${formatarDiaMes(inicio)} a ${formatarDiaMes(fim)}',
            subtitulo: '${inicio.year}',
            rotuloAnterior: 'Semana anterior',
            rotuloProximo: 'Próxima semana',
            onAnterior: () => irPara(inicio.somarDias(-7)),
            onProximo: () => irPara(inicio.somarDias(7)),
            onHoje: hoje.antesDe(inicio) || hoje.depoisDe(fim) ? () => irPara(hoje) : null,
            onTocar: () async {
              final escolhida =
                  await escolherData(context, inicial: inicio, titulo: 'Ir para a semana');
              if (escolhida != null) irPara(escolhida);
            },
          ),
          const SizedBox(height: 8),
          ConteudoAssincrono(
            valor: periodo,
            onTentarDeNovo: () => ref.invalidate(periodoProvider((inicio: inicio, fim: fim))),
            construtor: (p) {
              final pendentes = p.resumo.pendencias.map((x) => x.data).toSet();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CartaoResumo(itens: [
                    ItemResumo('Trab. na semana', formatarDuracao(p.resumo.trabalhado)),
                    ItemResumo('Saldo da semana', formatarDuracaoComSinal(p.resumo.saldo),
                        cor: cores.doSaldo(context, p.resumo.saldo)),
                    ItemResumo('Banco', formatarDuracaoComSinal(p.resumo.bancoHoras),
                        cor: cores.doSaldo(context, p.resumo.bancoHoras)),
                  ]),
                  const SizedBox(height: 12),
                  Card(
                    child: Column(
                      children: [
                        for (final dia in p.dias)
                          _LinhaDia(
                            dia: dia,
                            futuro: dia.data.depoisDe(hoje),
                            pendente: pendentes.contains(dia.data),
                            hoje: dia.data.mesmoDia(hoje),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LinhaDia extends StatelessWidget {
  final DiaTrabalho dia;
  final bool futuro;
  final bool pendente;
  final bool hoje;

  const _LinhaDia({required this.dia, required this.futuro, required this.pendente, required this.hoje});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = CoresPonto.de(context);
    final horarios = dia.marcacoes.map((m) => formatarHora(m.hora)).join(' · ');
    final descricao = dia.status != StatusDia.normal
        ? '${dia.status.rotulo}${horarios.isEmpty ? '' : ' · $horarios'}'
        : (horarios.isEmpty ? (futuro ? '' : 'Sem marcações') : horarios);

    return ListTile(
      onTap: () => context.go('/dia?data=${dia.data.iso}'),
      leading: SizedBox(
        width: 44,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(abreviacaoDiaSemana(dia.data.weekday), style: tema.textTheme.labelSmall),
            Text('${dia.data.day}',
                style: tema.textTheme.titleMedium?.copyWith(
                    fontWeight: hoje ? FontWeight.w800 : FontWeight.w500,
                    color: hoje ? tema.colorScheme.primary : null)),
          ],
        ),
      ),
      title: Text(descricao, style: const TextStyle(fontFeatures: algarismosTabulares)),
      subtitle: pendente
          ? Row(children: [
              Icon(Icons.warning_amber_rounded, size: 16, color: cores.atencao),
              const SizedBox(width: 4),
              Flexible(child: Text(dia.inconsistente ? 'Marcações incompletas' : 'Pendente')),
            ])
          : null,
      trailing: futuro
          ? null
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatarDuracao(dia.minutosTrabalhados),
                    style: const TextStyle(fontFeatures: algarismosTabulares)),
                Text(formatarDuracaoComSinal(dia.saldo),
                    style: TextStyle(
                        color: cores.doSaldo(context, dia.saldo),
                        fontFeatures: algarismosTabulares)),
              ],
            ),
    );
  }
}
