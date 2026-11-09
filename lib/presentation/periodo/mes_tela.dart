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
import 'periodo_provider.dart';

/// TL-08: o mês em calendário, com um indicador por dia (RF-17).
class MesTela extends ConsumerWidget {
  final int? ano;
  final int? mes;

  const MesTela({super.key, this.ano, this.mes});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hoje = ref.watch(relogioProvider).agora().apenasData;
    final primeiro = dataCivil(ano ?? hoje.year, mes ?? hoje.month, 1);
    final ultimo = primeiro.ultimoDiaDoMes;
    final intervalo = (inicio: primeiro, fim: ultimo);
    final periodo = ref.watch(periodoProvider(intervalo));
    final cores = CoresPonto.de(context);

    void irPara(DateTime d) => context.go('/menu/mes?ano=${d.year}&mes=${d.month}');

    return Scaffold(
      appBar: AppBar(title: const Text('Mês')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
        children: [
          SeletorPeriodo(
            rotulo: '${nomeMesCapitalizado(primeiro.month)} / ${primeiro.year}',
            rotuloAnterior: 'Mês anterior',
            rotuloProximo: 'Próximo mês',
            onAnterior: () => irPara(dataCivil(primeiro.year, primeiro.month - 1, 1)),
            onProximo: () => irPara(dataCivil(primeiro.year, primeiro.month + 1, 1)),
            onHoje: primeiro.month == hoje.month && primeiro.year == hoje.year
                ? null
                : () => irPara(hoje),
          ),
          const SizedBox(height: 8),
          ConteudoAssincrono(
            valor: periodo,
            onTentarDeNovo: () => ref.invalidate(periodoProvider(intervalo)),
            construtor: (p) {
              final pendentes = p.resumo.pendencias.map((x) => x.data).toSet();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CartaoResumo(itens: [
                    ItemResumo('Trab. no mês', formatarDuracao(p.resumo.trabalhado)),
                    ItemResumo('Saldo do mês', formatarDuracaoComSinal(p.resumo.saldo),
                        cor: cores.doSaldo(context, p.resumo.saldo)),
                    ItemResumo('Banco', formatarDuracaoComSinal(p.resumo.bancoHoras),
                        cor: cores.doSaldo(context, p.resumo.bancoHoras)),
                  ]),
                  const SizedBox(height: 12),
                  _Calendario(
                    primeiro: primeiro,
                    dias: {for (final d in p.dias) d.data: d},
                    pendentes: pendentes,
                    hoje: hoje,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 4,
                    children: [
                      _Legenda(icone: Icons.warning_amber_rounded, cor: cores.atencao, texto: 'Pendência'),
                      _Legenda(icone: Icons.celebration_outlined, cor: cores.atencao, texto: 'Status do dia'),
                      _Legenda(icone: Icons.circle, cor: cores.neutro, texto: 'Fim de semana ou sem trabalho'),
                    ],
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

class _Calendario extends StatelessWidget {
  final DateTime primeiro;
  final Map<DateTime, DiaTrabalho> dias;
  final Set<DateTime> pendentes;
  final DateTime hoje;

  const _Calendario(
      {required this.primeiro, required this.dias, required this.pendentes, required this.hoje});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    // A semana começa no domingo, como no calendário de parede (wireframe de TL-08).
    final deslocamento = primeiro.weekday % 7;
    final inicio = primeiro.somarDias(-deslocamento);
    final semanas = ((deslocamento + primeiro.ultimoDiaDoMes.day) / 7).ceil();
    const cabecalho = ['dom.', 'seg.', 'ter.', 'qua.', 'qui.', 'sex.', 'sáb.'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Row(
              children: [
                for (final nome in cabecalho)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(nome,
                          textAlign: TextAlign.center, style: tema.textTheme.labelSmall),
                    ),
                  ),
              ],
            ),
            for (var semana = 0; semana < semanas; semana++)
              Row(
                children: [
                  for (var d = 0; d < 7; d++)
                    Expanded(
                      child: _CelulaDia(
                        data: inicio.somarDias(semana * 7 + d),
                        dia: dias[inicio.somarDias(semana * 7 + d)],
                        doMes: inicio.somarDias(semana * 7 + d).month == primeiro.month,
                        pendente: pendentes.contains(inicio.somarDias(semana * 7 + d)),
                        hoje: inicio.somarDias(semana * 7 + d).mesmoDia(hoje),
                        futuro: inicio.somarDias(semana * 7 + d).depoisDe(hoje),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _CelulaDia extends StatelessWidget {
  final DateTime data;
  final DiaTrabalho? dia;
  final bool doMes;
  final bool pendente;
  final bool hoje;
  final bool futuro;

  const _CelulaDia({
    required this.data,
    required this.dia,
    required this.doMes,
    required this.pendente,
    required this.hoje,
    required this.futuro,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = CoresPonto.de(context);
    final dia = this.dia;
    final semCarga = dia != null && dia.cargaPrevista == Duration.zero;
    final status = dia?.status ?? StatusDia.normal;

    String? resumo;
    if (doMes && dia != null && !futuro && dia.minutosTrabalhados > Duration.zero) {
      final minutos = dia.minutosTrabalhados.inMinutes;
      resumo = '${minutos ~/ 60}h${minutos % 60 == 0 ? '' : (minutos % 60).toString().padLeft(2, '0')}';
    }

    final descricao = [
      formatarDataPorExtenso(data),
      if (status != StatusDia.normal) status.rotulo,
      if (resumo != null) 'trabalhado ${formatarDuracao(dia!.minutosTrabalhados)}',
      if (pendente) 'com pendência',
    ].join(', ');

    return Semantics(
      button: doMes,
      label: descricao,
      excludeSemantics: true,
      child: InkWell(
        onTap: doMes ? () => context.go('/dia?data=${data.iso}') : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: semCarga && doMes ? tema.colorScheme.surfaceContainerHighest : null,
            border: hoje ? Border.all(color: tema.colorScheme.primary, width: 2) : null,
          ),
          child: Opacity(
            opacity: doMes ? 1 : 0.4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${data.day}',
                    style: tema.textTheme.bodyMedium
                        ?.copyWith(fontWeight: hoje ? FontWeight.w800 : FontWeight.w500)),
                if (doMes && pendente)
                  Icon(Icons.warning_amber_rounded, size: 16, color: cores.atencao)
                else if (doMes && status != StatusDia.normal)
                  Icon(iconeDoStatus(status), size: 16, color: cores.atencao),
                if (resumo != null)
                  FittedBox(
                    child: Text(resumo,
                        style: tema.textTheme.labelSmall
                            ?.copyWith(fontFeatures: algarismosTabulares)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Legenda extends StatelessWidget {
  final IconData icone;
  final Color cor;
  final String texto;

  const _Legenda({required this.icone, required this.cor, required this.texto});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 14, color: cor),
          const SizedBox(width: 4),
          Text(texto, style: Theme.of(context).textTheme.bodySmall),
        ],
      );
}
