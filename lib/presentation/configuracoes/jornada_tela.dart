import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/extensoes/data_extensoes.dart';
import '../../core/formatadores.dart';
import '../../core/resultado.dart';
import '../../domain/entidades/configuracao_jornada.dart';
import '../comum/componentes.dart';
import '../comum/interacao.dart';

class JornadaEdicao {
  final ConfiguracaoJornada jornada;
  final bool alterada;

  const JornadaEdicao(this.jornada, {this.alterada = false});
}

final jornadaEdicaoProvider =
    AsyncNotifierProvider.autoDispose<JornadaEdicaoController, JornadaEdicao>(
        JornadaEdicaoController.new);

/// Cópia de trabalho da jornada (UC-03): TL-13 e TL-14 editam a mesma cópia, e nada é
/// gravado até "Salvar".
class JornadaEdicaoController extends AutoDisposeAsyncNotifier<JornadaEdicao> {
  @override
  Future<JornadaEdicao> build() async =>
      JornadaEdicao(await ref.read(jornadaRepositorioProvider).buscarAtiva());

  void alterar(ConfiguracaoJornada jornada) =>
      state = AsyncData(JornadaEdicao(jornada, alterada: true));

  /// Grava e recalcula os dias abertos a partir de hoje (RN-29): o passado não muda.
  Future<Resultado<void>> salvar() async {
    final atual = state.requireValue.jornada;
    final resultado = await ref.read(jornadaRepositorioProvider).salvar(atual);
    switch (resultado) {
      case Erro(:final falha):
        return Erro(falha);
      case Sucesso(valor: final salva):
        final hoje = ref.read(relogioProvider).agora().apenasData;
        await ref.read(diaRepositorioProvider).recalcularAPartirDe(hoje);
        ref.read(versaoDadosProvider.notifier).state++;
        state = AsyncData(JornadaEdicao(salva));
        return const Sucesso(null);
    }
  }
}

/// `08:00–12:00 · 13:00–17:00`, ou "Não trabalha".
String descreverTurnos(JornadaDiaSemana dia) => dia.trabalha
    ? (dia.turnos.isEmpty
        ? 'Sem horários definidos'
        : dia.turnos.map((t) => '${formatarHora(t.entrada)}–${formatarHora(t.saida)}').join(' · '))
    : 'Não trabalha';

/// TL-13: os sete dias, tolerância, virada de dia e total semanal (RF-04, RF-06, RF-07).
class JornadaTela extends ConsumerWidget {
  const JornadaTela({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edicao = ref.watch(jornadaEdicaoProvider);
    final controller = ref.read(jornadaEdicaoProvider.notifier);
    final calculadora = ref.watch(calculadoraProvider);
    final alterada = edicao.valueOrNull?.alterada ?? false;

    Future<void> salvar() async {
      final resultado = await controller.salvar();
      if (!context.mounted) return;
      resultado.quando(
        sucesso: (_) => mostrarMensagem(context, 'Jornada salva. Vale de hoje em diante.'),
        erro: (falha) => mostrarFalha(context, falha),
      );
    }

    return ProtecaoSaida(
      alterado: alterada,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Jornada de trabalho'),
          actions: [
            TextButton(
              onPressed: alterada ? salvar : null,
              style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary),
              child: const Text('Salvar'),
            ),
          ],
        ),
        body: ConteudoAssincrono(
          valor: edicao,
          onTentarDeNovo: () => ref.invalidate(jornadaEdicaoProvider),
          construtor: (e) {
            final jornada = e.jornada;
            return ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                const TituloSecao('Dias da semana'),
                for (var d = 1; d <= 7; d++)
                  ListTile(
                    title: Text(_capitalizar(nomeDiaSemana(d))),
                    subtitle: Text(descreverTurnos(jornada.paraDiaSemana(d))),
                    trailing: Text(
                      jornada.paraDiaSemana(d).trabalha
                          ? formatarDuracao(jornada.paraDiaSemana(d).carga)
                          : '—',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    onTap: () => context.push('/jornada/$d'),
                  ),
                ListTile(
                  title: const Text('Total da semana'),
                  trailing: Text(formatarDuracao(calculadora.cargaSemanal(jornada)),
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                const TituloSecao('Cálculo'),
                ListTile(
                  title: const Text('Tolerância'),
                  subtitle: const Text('Saldo do dia dentro desta margem conta como zero.'),
                  trailing: _Contador(
                    valor: jornada.tolerancia.inMinutes,
                    sufixo: 'min',
                    rotulo: 'Tolerância',
                    aoMudar: (v) =>
                        controller.alterar(jornada.copiaCom(tolerancia: Duration(minutes: v))),
                  ),
                ),
                SwitchListTile(
                  title: const Text('Turnos podem passar da meia-noite'),
                  subtitle: const Text('Ligue só se você trabalha à noite. Desligado, um '
                      'horário digitado errado aparece como pendência em vez de virar um turno '
                      'enorme.'),
                  value: jornada.permiteViradaDia,
                  onChanged: (v) => controller.alterar(jornada.copiaCom(permiteViradaDia: v)),
                ),
                ListTile(
                  title: const Text('Banco de horas a partir de'),
                  subtitle: Text(jornada.dataInicioBanco == null
                      ? 'Desde o primeiro dia registrado'
                      : formatarDataCurta(jornada.dataInicioBanco!)),
                  trailing: jornada.dataInicioBanco == null
                      ? const Icon(Icons.edit_calendar_outlined)
                      : IconButton(
                          tooltip: 'Contar desde o primeiro dia registrado',
                          icon: const Icon(Icons.clear),
                          onPressed: () =>
                              controller.alterar(jornada.copiaCom(limparDataInicioBanco: true)),
                        ),
                  onTap: () async {
                    final data = await escolherData(context,
                        inicial: jornada.dataInicioBanco ??
                            ref.read(relogioProvider).agora().apenasData,
                        titulo: 'Início do banco de horas');
                    if (data != null) controller.alterar(jornada.copiaCom(dataInicioBanco: data));
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

String _capitalizar(String texto) => texto[0].toUpperCase() + texto.substring(1);

class _Contador extends StatelessWidget {
  final int valor;
  final String sufixo;
  final String rotulo;
  final ValueChanged<int> aoMudar;

  const _Contador(
      {required this.valor, required this.sufixo, required this.rotulo, required this.aoMudar});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Diminuir $rotulo',
          onPressed: valor > 0 ? () => aoMudar(valor - 1) : null,
          icon: const Icon(Icons.remove),
        ),
        Text('$valor $sufixo'),
        IconButton(
          tooltip: 'Aumentar $rotulo',
          onPressed: valor < 60 ? () => aoMudar(valor + 1) : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

/// TL-14: turnos previstos e carga de um dia da semana (RF-04, RF-05).
class JornadaDiaTela extends ConsumerStatefulWidget {
  final int diaSemana;

  const JornadaDiaTela({super.key, required this.diaSemana});

  @override
  ConsumerState<JornadaDiaTela> createState() => _JornadaDiaTelaState();
}

class _JornadaDiaTelaState extends ConsumerState<JornadaDiaTela> {
  JornadaDiaSemana? _dia;

  @override
  Widget build(BuildContext context) {
    final edicao = ref.watch(jornadaEdicaoProvider);
    final calculadora = ref.watch(calculadoraProvider);
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(_capitalizar(nomeDiaSemana(widget.diaSemana)))),
      body: ConteudoAssincrono(
        valor: edicao,
        construtor: (e) {
          final dia = _dia ??= e.jornada.paraDiaSemana(widget.diaSemana);
          final virada = e.jornada.permiteViradaDia;
          final cargaTurnos = calculadora.cargaDosTurnos(dia.turnos, permiteViradaDia: virada);
          final invalidos = dia.turnos
              .where((t) => t.saida == t.entrada || (!virada && t.saida < t.entrada))
              .toList();

          void mudar(JornadaDiaSemana novo) => setState(() {
                _dia = novo.cargaManual
                    ? novo
                    : novo.copiaCom(
                        carga: calculadora.cargaDosTurnos(novo.turnos, permiteViradaDia: virada));
              });

          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              SwitchListTile(
                title: const Text('Trabalho neste dia'),
                value: dia.trabalha,
                onChanged: (v) => mudar(dia.copiaCom(trabalha: v)),
              ),
              if (dia.trabalha) ...[
                const TituloSecao('Turnos previstos'),
                for (var i = 0; i < dia.turnos.length; i++)
                  ListTile(
                    title: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: [
                        OutlinedButton(
                          onPressed: () async {
                            final hora = await escolherHorario(context,
                                inicial: dia.turnos[i].entrada, titulo: 'Entrada');
                            if (hora != null) {
                              mudar(dia.copiaCom(turnos: [...dia.turnos]
                                ..[i] = dia.turnos[i].copiaCom(entrada: hora)));
                            }
                          },
                          child: Text('Entrada ${formatarHora(dia.turnos[i].entrada)}'),
                        ),
                        OutlinedButton(
                          onPressed: () async {
                            final hora = await escolherHorario(context,
                                inicial: dia.turnos[i].saida, titulo: 'Saída');
                            if (hora != null) {
                              mudar(dia.copiaCom(turnos: [...dia.turnos]
                                ..[i] = dia.turnos[i].copiaCom(saida: hora)));
                            }
                          },
                          child: Text('Saída ${formatarHora(dia.turnos[i].saida)}'),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      tooltip: 'Remover o turno ${i + 1}',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => mudar(dia.copiaCom(turnos: [...dia.turnos]..removeAt(i))),
                    ),
                  ),
                if (invalidos.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: FaixaAviso(texto: 'A saída de um turno precisa ser depois da entrada.'),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar turno'),
                    onPressed: () {
                      final inicio = dia.turnos.isEmpty
                          ? const Duration(hours: 8)
                          : dia.turnos.last.saida + const Duration(hours: 1);
                      final entrada = Duration(minutes: inicio.inMinutes % (24 * 60));
                      final saida = Duration(minutes: (entrada.inMinutes + 240) % (24 * 60));
                      mudar(dia.copiaCom(turnos: [
                        ...dia.turnos,
                        TurnoPrevisto(ordem: dia.turnos.length + 1, entrada: entrada, saida: saida),
                      ]));
                    },
                  ),
                ),
                const TituloSecao('Carga horária'),
                SwitchListTile(
                  title: const Text('Definir a carga manualmente'),
                  subtitle: Text(dia.cargaManual
                      ? 'Os turnos servem só de referência.'
                      : 'Calculada pelos turnos: ${formatarDuracao(cargaTurnos)}'),
                  value: dia.cargaManual,
                  onChanged: (v) => mudar(dia.copiaCom(cargaManual: v)),
                ),
                ListTile(
                  title: const Text('Carga do dia'),
                  trailing: dia.cargaManual
                      ? OutlinedButton(
                          onPressed: () async {
                            final carga = await escolherHorario(context,
                                inicial: dia.carga, titulo: 'Carga do dia (horas e minutos)');
                            if (carga != null) mudar(dia.copiaCom(carga: carga));
                          },
                          child: Text(formatarDuracao(dia.carga)),
                        )
                      : Text(formatarDuracao(dia.carga), style: tema.textTheme.titleMedium),
                ),
              ],
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: invalidos.isNotEmpty
                      ? null
                      : () {
                          final ordenados = [...dia.turnos]
                            ..sort((a, b) => a.entrada.compareTo(b.entrada));
                          ref.read(jornadaEdicaoProvider.notifier).alterar(e.jornada.comDia(
                                dia.copiaCom(turnos: [
                                  for (var i = 0; i < ordenados.length; i++)
                                    ordenados[i].copiaCom(ordem: i + 1),
                                ]),
                              ));
                          context.pop();
                        },
                  child: const Text('Aplicar'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
