import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/tema.dart';
import '../../core/extensoes/data_extensoes.dart';
import '../../core/formatadores.dart';
import '../../core/resultado.dart';
import '../../domain/entidades/competencia.dart';
import '../../domain/entidades/dia_trabalho.dart';
import '../../domain/entidades/marcacao.dart';
import '../../domain/enums/enums.dart';
import '../../domain/enums/rotulos.dart';
import '../comum/componentes.dart';
import '../comum/interacao.dart';
import 'dia_controller.dart';
import 'widgets/editar_dia_sheet.dart';
import 'widgets/linha_do_tempo.dart';

/// TL-06: a tela mais usada do app. Bater o ponto leva um toque (OE-1).
class DiaTela extends ConsumerWidget {
  /// Nula: hoje.
  final DateTime? data;

  const DiaTela({super.key, this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mensageiro próprio: o aviso com "Desfazer" aparece acima da barra de bater ponto, em
    // vez de cobri-la por 5 segundos (docs/04, princípio 1).
    return ScaffoldMessenger(
      child: Builder(builder: (context) => _construir(context, ref)),
    );
  }

  Widget _construir(BuildContext context, WidgetRef ref) {
    final hoje = ref.watch(relogioProvider).agora().apenasData;
    final dataTela = (data ?? hoje).apenasData;
    final provider = diaControllerProvider(dataTela);
    final estado = ref.watch(provider);
    final acoes = _AcoesDia(context, ref, dataTela);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dia'),
        actions: [
          IconButton(
            tooltip: 'Adicionar marcação com outro horário',
            icon: const Icon(Icons.more_time),
            onPressed: dataTela.depoisDe(hoje) ? null : acoes.adicionarManual,
          ),
          IconButton(
            tooltip: 'Status e observação do dia',
            icon: const Icon(Icons.edit_calendar_outlined),
            onPressed: estado.valueOrNull == null
                ? null
                : () => abrirEditarDia(context,
                    dia: estado.requireValue.dia,
                    salvar: ref.read(provider.notifier).definirStatus),
          ),
        ],
      ),
      body: ConteudoAssincrono(
        valor: estado,
        onTentarDeNovo: () => ref.invalidate(provider),
        construtor: (e) => _CorpoDia(estado: e, hoje: hoje, acoes: acoes),
      ),
      bottomNavigationBar: _BarraPonto(
        data: dataTela,
        hoje: hoje,
        dia: estado.valueOrNull?.dia,
        acoes: acoes,
      ),
    );
  }
}

/// Ações de marcação do fluxo A3, com confirmação, aviso e "Desfazer".
class _AcoesDia {
  final BuildContext context;
  final WidgetRef ref;
  final DateTime data;

  _AcoesDia(this.context, this.ref, this.data);

  DiaController get _controller => ref.read(diaControllerProvider(data).notifier);

  DiaTrabalho? get _dia => ref.read(diaControllerProvider(data)).valueOrNull?.dia;

  Future<bool> _confirmarDiaNaoTrabalhado() async {
    final dia = _dia;
    if (dia == null || !dia.status.abonaCarga && dia.status != StatusDia.falta) return true;
    return confirmar(
      context,
      titulo: 'Registrar mesmo assim?',
      mensagem: 'Este dia está marcado como ${dia.status.rotulo.toLowerCase()}. '
          'Você pode mudar o status depois, em "Status e observação do dia".',
      rotuloConfirmar: 'Registrar',
    );
  }

  Future<void> baterPonto() async {
    if (!await _confirmarDiaNaoTrabalhado()) return;
    final hora = ref.read(relogioProvider).agora().horaDoDia;
    _avisar(await _controller.baterPonto(), hora);
  }

  Future<void> adicionarManual() async {
    final agora = ref.read(relogioProvider).agora();
    final inicial = data.mesmoDia(agora) ? agora.horaDoDia : const Duration(hours: 8);
    final hora = await escolherHorario(context, inicial: inicial, titulo: 'Horário da marcação');
    if (hora == null || !context.mounted) return;
    if (!await _confirmarDiaNaoTrabalhado()) return;
    _avisar(await _controller.adicionar(hora), hora);
  }

  void _avisar(Resultado<DiaTrabalho> resultado, Duration hora) {
    if (!context.mounted) return;
    resultado.quando(
      sucesso: (dia) {
        final marcacao = dia.marcacoes.where((m) => m.hora == hora).firstOrNull;
        if (marcacao == null) return;
        final tipo = marcacao.tipo == TipoMarcacao.entrada ? 'Entrada' : 'Saída';
        mostrarMensagem(
          context,
          '$tipo registrada às ${formatarHora(hora)}.',
          rotuloAcao: 'Desfazer',
          aoAcionar: () => _controller.excluir(marcacao.id!),
          duracao: const Duration(seconds: 5),
        );
      },
      erro: (falha) => mostrarFalha(context, falha),
    );
  }

  Future<void> opcoes(Marcacao marcacao) async {
    final tipo = marcacao.tipo == TipoMarcacao.entrada ? 'Entrada' : 'Saída';
    final escolha = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('$tipo às ${formatarHora(marcacao.hora)}',
                  style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(marcacao.origem == OrigemMarcacao.automatica
                  ? 'Registrada pelo botão de bater ponto'
                  : 'Registrada manualmente'),
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Alterar horário'),
              onTap: () => Navigator.of(context).pop('editar'),
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: CoresPonto.de(context).debito),
              title: const Text('Excluir marcação'),
              onTap: () => Navigator.of(context).pop('excluir'),
            ),
          ],
        ),
      ),
    );
    if (!context.mounted) return;
    if (escolha == 'editar') await editar(marcacao);
    if (escolha == 'excluir') await excluir(marcacao);
  }

  Future<void> editar(Marcacao marcacao) async {
    final hora = await escolherHorario(context, inicial: marcacao.hora, titulo: 'Novo horário');
    if (hora == null || hora == marcacao.hora || !context.mounted) return;
    final resultado = await _controller.editar(marcacao.id!, hora);
    if (!context.mounted) return;
    resultado.quando(
      sucesso: (_) => mostrarMensagem(context, 'Horário alterado para ${formatarHora(hora)}.'),
      erro: (falha) => mostrarFalha(context, falha),
    );
  }

  /// Sempre devolve falso para o `Dismissible`: a lista se refaz sozinha com o dia
  /// recalculado.
  Future<bool> excluir(Marcacao marcacao) async {
    final confirmado = await confirmar(
      context,
      titulo: 'Excluir marcação',
      mensagem: 'Excluir a marcação das ${formatarHora(marcacao.hora)}? Isso recalcula o dia.',
      rotuloConfirmar: 'Excluir',
      destrutivo: true,
    );
    if (!confirmado || !context.mounted) return false;
    final resultado = await _controller.excluir(marcacao.id!);
    if (!context.mounted) return false;
    resultado.quando(
      sucesso: (_) => mostrarMensagem(
        context,
        'Marcação excluída.',
        rotuloAcao: 'Desfazer',
        aoAcionar: () => _controller.adicionar(marcacao.hora, origem: marcacao.origem),
        duracao: const Duration(seconds: 5),
      ),
      erro: (falha) => mostrarFalha(context, falha),
    );
    return false;
  }

  void irPara(DateTime novaData, DateTime hoje) =>
      context.go(novaData.mesmoDia(hoje) ? '/dia' : '/dia?data=${novaData.iso}');
}

class _CorpoDia extends ConsumerWidget {
  final DiaEstado estado;
  final DateTime hoje;
  final _AcoesDia acoes;

  const _CorpoDia({required this.estado, required this.hoje, required this.acoes});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ehHoje = estado.data.mesmoDia(hoje);
    final relogio = ref.watch(relogioProvider);
    final agora = ehHoje ? (ref.watch(pulsoProvider).valueOrNull ?? relogio.agora()) : relogio.agora();
    final calculadora = ref.watch(calculadoraProvider);
    final dia = estado.dia;
    final jornada = estado.jornada;
    final cores = CoresPonto.de(context);

    final emAndamento = calculadora.emAndamento(dia, agora: agora);
    final trabalhado = calculadora.trabalhadoAgora(dia, agora: agora);
    final saldo = calculadora.saldoAgora(dia, jornada, agora: agora);
    final banco = calculadora.bancoComDia(estado.bancoAteVespera, dia, jornada,
        agora: agora, inicioAcompanhamento: estado.inicioAcompanhamento);
    final previsao = calculadora.previsaoSaida(dia, jornada, agora: agora);
    final futuro = estado.data.depoisDe(hoje);
    final naoTrabalha = !jornada.paraData(estado.data).trabalha;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        if (estado.competenciaPendente case final competencia?) ...[
          _CartaoCompetenciaPendente(competencia: competencia),
          const SizedBox(height: 12),
        ],
        SeletorPeriodo(
          rotulo: formatarDataExtensa(estado.data),
          subtitulo: ehHoje ? 'Hoje' : null,
          rotuloAnterior: 'Dia anterior',
          rotuloProximo: 'Próximo dia',
          onAnterior: () => acoes.irPara(estado.data.somarDias(-1), hoje),
          onProximo: () => acoes.irPara(estado.data.somarDias(1), hoje),
          onHoje: ehHoje ? null : () => acoes.irPara(hoje, hoje),
          onTocar: () async {
            final escolhida = await escolherData(context,
                inicial: estado.data, titulo: 'Ir para o dia');
            if (escolhida != null) acoes.irPara(escolhida, hoje);
          },
        ),
        const SizedBox(height: 8),
        CartaoResumo(
          itens: [
            ItemResumo('Trab. no dia', formatarDuracao(trabalhado)),
            ItemResumo('Saldo do dia', formatarDuracaoComSinal(saldo),
                cor: cores.doSaldo(context, saldo)),
            ItemResumo('Banco', formatarDuracaoComSinal(banco), cor: cores.doSaldo(context, banco)),
          ],
          progresso: dia.cargaPrevista > Duration.zero
              ? trabalhado.inMinutes / dia.cargaPrevista.inMinutes
              : null,
          rotuloProgresso: 'Trabalhado ${formatarDuracao(trabalhado)} de '
              '${formatarDuracao(dia.cargaPrevista)} previstos',
        ),
        const SizedBox(height: 12),
        if (dia.status != StatusDia.normal) ...[
          _CartaoStatus(dia: dia),
          const SizedBox(height: 12),
        ] else if (dia.temObservacao) ...[
          FaixaAviso(texto: dia.observacao!, icone: Icons.notes_outlined),
          const SizedBox(height: 12),
        ],
        if (dia.inconsistente) ...[
          const FaixaAviso(texto: 'Faltou uma saída neste dia.'),
          const SizedBox(height: 12),
        ],
        if (dia.temMarcacoes)
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: LinhaDoTempoMarcacoes(
                marcacoes: dia.marcacoes,
                turnos: calculadora.turnos(dia, jornada),
                intervalos: calculadora.intervalos(dia, jornada),
                turnoEmCurso: emAndamento ? calculadora.minutosEmCurso(dia, agora: agora) : null,
                previsaoSaida: previsao,
                cargaCumprida: previsao != null && previsao <= agora.horaDoDia,
                onTocar: acoes.opcoes,
                onExcluir: acoes.excluir,
              ),
            ),
          )
        else if (futuro)
          const EstadoVazio(
            icone: Icons.event_outlined,
            titulo: 'Este dia ainda não chegou.',
            mensagem: 'Você já pode marcar férias ou folga em "Status e observação do dia".',
          )
        else if (naoTrabalha && dia.status == StatusDia.normal)
          EstadoVazio(
            icone: Icons.weekend_outlined,
            titulo: 'Você não trabalha neste dia.',
            rotuloAcao: 'Registrar mesmo assim',
            onAcao: acoes.adicionarManual,
          )
        else if (ehHoje)
          EstadoVazio(
            icone: Icons.touch_app_outlined,
            titulo: 'Nenhuma marcação hoje.',
            mensagem: 'Toque em "Marcar entrada" para registrar a entrada.',
            rotuloAcao: 'Marcar entrada agora',
            onAcao: acoes.baterPonto,
          )
        else
          EstadoVazio(
            icone: Icons.history_toggle_off,
            titulo: 'Nenhuma marcação neste dia.',
            rotuloAcao: 'Adicionar marcação',
            onAcao: acoes.adicionarManual,
          ),
      ],
    );
  }
}

class _CartaoStatus extends StatelessWidget {
  final DiaTrabalho dia;

  const _CartaoStatus({required this.dia});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final efeito = dia.status == StatusDia.falta
        ? 'A carga do dia é descontada do saldo.'
        : dia.status.abonaCarga
            ? 'Este dia não conta como débito.'
            : 'Conta como um dia normal.';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChipStatusDia(status: dia.status),
            const SizedBox(height: 8),
            Text(efeito, style: tema.textTheme.bodyMedium),
            if (dia.temObservacao) ...[
              const SizedBox(height: 8),
              Text(dia.observacao!,
                  style: tema.textTheme.bodyMedium
                      ?.copyWith(color: tema.colorScheme.onSurfaceVariant)),
            ],
          ],
        ),
      ),
    );
  }
}

class _CartaoCompetenciaPendente extends StatelessWidget {
  final Competencia competencia;

  const _CartaoCompetenciaPendente({required this.competencia});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      color: tema.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.outgoing_mail, color: tema.colorScheme.onPrimaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('O ponto de ${competencia.formatado()} ainda não foi enviado',
                      style: tema.textTheme.titleMedium
                          ?.copyWith(color: tema.colorScheme.onPrimaryContainer)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Que tal fechar o ponto agora? Leva menos de um minuto.',
                style: tema.textTheme.bodyMedium
                    ?.copyWith(color: tema.colorScheme.onPrimaryContainer)),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () =>
                  context.push('/fechamento?ano=${competencia.ano}&mes=${competencia.mes}'),
              child: const Text('Fechar o mês'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Relógio vivo e o botão de bater ponto, sempre ao alcance do polegar.
class _BarraPonto extends ConsumerWidget {
  final DateTime data;
  final DateTime hoje;
  final DiaTrabalho? dia;
  final _AcoesDia acoes;

  const _BarraPonto({required this.data, required this.hoje, required this.dia, required this.acoes});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final ehHoje = data.mesmoDia(hoje);
    final futuro = data.depoisDe(hoje);

    Widget botao;
    if (ehHoje) {
      final entrada = ref.watch(calculadoraProvider).proximoTipo(dia ?? DiaTrabalho.vazio(data)) ==
          TipoMarcacao.entrada;
      botao = Semantics(
        hint: 'Toque e segure para escolher outro horário',
        child: FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size(0, 56)),
          onPressed: dia == null ? null : acoes.baterPonto,
          onLongPress: dia == null ? null : acoes.adicionarManual,
          icon: Icon(entrada ? Icons.login : Icons.logout),
          label: Text(entrada ? 'Marcar entrada' : 'Marcar saída'),
        ),
      );
    } else {
      botao = FilledButton.icon(
        style: FilledButton.styleFrom(minimumSize: const Size(0, 56)),
        onPressed: futuro || dia == null ? null : acoes.adicionarManual,
        icon: const Icon(Icons.more_time),
        label: const Text('Adicionar marcação'),
      );
    }

    return BottomAppBar(
      height: 80,
      child: Row(
        children: [
          Expanded(
            child: ehHoje
                ? const _RelogioVivo()
                : Text(formatarDataCurta(data),
                    style: tema.textTheme.titleMedium?.copyWith(fontFeatures: algarismosTabulares)),
          ),
          botao,
        ],
      ),
    );
  }
}

class _RelogioVivo extends ConsumerWidget {
  const _RelogioVivo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agora = ref.watch(pulsoProvider).valueOrNull ?? ref.watch(relogioProvider).agora();
    return Semantics(
      label: 'Agora são ${formatarHora(agora.horaDoDia)}',
      excludeSemantics: true,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          formatarHoraComSegundos(agora),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 32, fontWeight: FontWeight.w600, fontFeatures: algarismosTabulares),
        ),
      ),
    );
  }
}
