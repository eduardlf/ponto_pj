import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/extensoes/data_extensoes.dart';
import '../../core/formatadores.dart';
import '../../domain/entidades/configuracao_email.dart';
import '../../domain/entidades/configuracao_jornada.dart';
import '../comum/componentes.dart';
import '../comum/interacao.dart';
import '../configuracoes/perfil_tela.dart';

/// TL-01 a TL-05 (UC-01, fluxo A1). Nenhuma etapa é obrigatória: quem só quer bater ponto
/// chega à aba Dia em dois toques, e o que ficou para depois vira cartão nas Configurações.
class OnboardingTela extends ConsumerStatefulWidget {
  const OnboardingTela({super.key});

  @override
  ConsumerState<OnboardingTela> createState() => _OnboardingTelaState();
}

class _OnboardingTelaState extends ConsumerState<OnboardingTela> {
  static const _total = 5;
  var _passo = 0;

  void _avancar() => _passo == _total - 1 ? _concluir() : setState(() => _passo++);

  Future<void> _concluir() async {
    await ref.read(preferenciasRepositorioProvider).marcarOnboardingConcluido();
    ref.read(onboardingConcluidoProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    final passos = [
      _BoasVindas(aoComecar: _avancar, aoPular: _concluir),
      _Perfil(aoContinuar: _avancar),
      _JornadaRapida(aoContinuar: _avancar),
      _Planilha(aoContinuar: _avancar),
      _Email(aoConcluir: _concluir),
    ];
    return PopScope(
      canPop: _passo == 0,
      onPopInvokedWithResult: (saiu, _) {
        if (!saiu) setState(() => _passo--);
      },
      child: Scaffold(
        appBar: _passo == 0
            ? null
            : AppBar(
                title: Text('Configuração · ${_passo + 1} de $_total'),
                leading: IconButton(
                  tooltip: 'Voltar',
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => setState(() => _passo--),
                ),
              ),
        body: SafeArea(child: passos[_passo]),
      ),
    );
  }
}

class _BoasVindas extends StatelessWidget {
  final VoidCallback aoComecar;
  final VoidCallback aoPular;

  const _BoasVindas({required this.aoComecar, required this.aoPular});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    Widget item(IconData icone, String texto) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icone, color: tema.colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(child: Text(texto, style: tema.textTheme.bodyLarge)),
          ]),
        );

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 32),
        Icon(Icons.punch_clock_outlined, size: 64, color: tema.colorScheme.primary),
        const SizedBox(height: 16),
        Text('Ponto PJ', style: tema.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('Você bate o ponto no celular. No fim do mês, o app preenche a planilha da sua '
            'empresa e deixa o e-mail pronto para o RH.',
            style: tema.textTheme.titleMedium),
        const SizedBox(height: 32),
        item(Icons.touch_app_outlined, 'Bater o ponto leva um toque.'),
        item(Icons.table_view, 'Nada de copiar horários para a planilha: o app faz isso.'),
        item(Icons.outgoing_mail,
            'Se o mês acabar e a planilha não tiver sido enviada, o app avisa assim que você o '
            'abre.'),
        item(Icons.lock_outline, 'Seus dados ficam só no aparelho.'),
        const SizedBox(height: 24),
        FilledButton(onPressed: aoComecar, child: const Text('Começar')),
        const SizedBox(height: 8),
        TextButton(onPressed: aoPular, child: const Text('Pular e configurar depois')),
      ],
    );
  }
}

class _Perfil extends ConsumerWidget {
  final VoidCallback aoContinuar;

  const _Perfil({required this.aoContinuar});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = ref.watch(perfilAtualProvider);
    return ConteudoAssincrono(
      valor: perfil,
      construtor: (p) => FormularioPerfil(
        inicial: p,
        rotuloSalvar: 'Continuar',
        aoSalvar: (novo) async {
          final resultado = await salvarPerfil(ref, novo);
          if (!context.mounted) return false;
          resultado.quando(sucesso: (_) => aoContinuar(), erro: (f) => mostrarFalha(context, f));
          return resultado.ehSucesso;
        },
        acaoSecundaria: TextButton(onPressed: aoContinuar, child: const Text('Pular esta etapa')),
      ),
    );
  }
}

/// TL-03: atalho para montar a semana padrão em poucos toques.
class _JornadaRapida extends ConsumerStatefulWidget {
  final VoidCallback aoContinuar;

  const _JornadaRapida({required this.aoContinuar});

  @override
  ConsumerState<_JornadaRapida> createState() => _JornadaRapidaState();
}

class _JornadaRapidaState extends ConsumerState<_JornadaRapida> {
  ConfiguracaoJornada? _jornada;
  final _dias = <int>{1, 2, 3, 4, 5};
  var _turnos = const [
    TurnoPrevisto(ordem: 1, entrada: Duration(hours: 8), saida: Duration(hours: 12)),
    TurnoPrevisto(ordem: 2, entrada: Duration(hours: 13), saida: Duration(hours: 17)),
  ];
  var _salvando = false;

  @override
  void initState() {
    super.initState();
    ref.read(jornadaRepositorioProvider).buscarAtiva().then((jornada) {
      if (!mounted) return;
      final referencia = jornada.dias.where((d) => d.trabalha && d.turnos.isNotEmpty).firstOrNull;
      setState(() {
        _jornada = jornada;
        _dias
          ..clear()
          ..addAll(jornada.dias.where((d) => d.trabalha).map((d) => d.diaSemana));
        if (referencia != null) _turnos = [...referencia.turnos];
      });
    });
  }

  Future<void> _salvar() async {
    final jornada = _jornada;
    if (jornada == null) return;
    setState(() => _salvando = true);
    final calculadora = ref.read(calculadoraProvider);
    final carga = calculadora.cargaDosTurnos(_turnos, permiteViradaDia: jornada.permiteViradaDia);
    final nova = jornada.copiaCom(dias: [
      for (var d = 1; d <= 7; d++)
        _dias.contains(d)
            ? JornadaDiaSemana(id: jornada.paraDiaSemana(d).id, diaSemana: d, trabalha: true,
                carga: carga, turnos: _turnos)
            : JornadaDiaSemana.semTrabalho(d),
    ]);
    final resultado = await ref.read(jornadaRepositorioProvider).salvar(nova);
    if (resultado.ehSucesso) {
      await ref
          .read(diaRepositorioProvider)
          .recalcularAPartirDe(ref.read(relogioProvider).agora().apenasData);
      ref.read(versaoDadosProvider.notifier).state++;
    }
    if (!mounted) return;
    setState(() => _salvando = false);
    resultado.quando(sucesso: (_) => widget.aoContinuar(), erro: (f) => mostrarFalha(context, f));
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final carga = ref.watch(calculadoraProvider).cargaDosTurnos(_turnos, permiteViradaDia: false);
    final invalido = _turnos.any((t) => t.saida <= t.entrada);

    Widget horario(int i, bool entrada) {
      final turno = _turnos[i];
      final hora = entrada ? turno.entrada : turno.saida;
      return OutlinedButton(
        onPressed: () async {
          final escolhida = await escolherHorario(context,
              inicial: hora, titulo: entrada ? 'Entrada' : 'Saída');
          if (escolhida == null) return;
          setState(() => _turnos = [..._turnos]
            ..[i] = entrada ? turno.copiaCom(entrada: escolhida) : turno.copiaCom(saida: escolhida));
        },
        child: Text('${entrada ? 'Entra' : 'Sai'} ${formatarHora(hora)}'),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Sua jornada', style: tema.textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('Com ela o app calcula o saldo e prevê a hora de saída. Dá para ajustar '
            'cada dia depois, nas configurações.'),
        const TituloSecao('Em quais dias você trabalha?'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (var d = 1; d <= 7; d++)
            FilterChip(
              label: Text(abreviacaoDiaSemana(d)),
              selected: _dias.contains(d),
              onSelected: (marcado) =>
                  setState(() => marcado ? _dias.add(d) : _dias.remove(d)),
            ),
        ]),
        const TituloSecao('Seu horário'),
        for (var i = 0; i < _turnos.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Wrap(spacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
              Text(_turnos.length > 1 ? (i == 0 ? 'Manhã' : 'Tarde') : 'Turno'),
              horario(i, true),
              horario(i, false),
            ]),
          ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Tenho intervalo de almoço'),
          value: _turnos.length > 1,
          onChanged: (sim) => setState(() => _turnos = sim
              ? [
                  _turnos.first.copiaCom(saida: const Duration(hours: 12)),
                  const TurnoPrevisto(
                      ordem: 2, entrada: Duration(hours: 13), saida: Duration(hours: 17)),
                ]
              : [_turnos.first.copiaCom(saida: _turnos.last.saida)]),
        ),
        if (invalido)
          const FaixaAviso(texto: 'A saída de um turno precisa ser depois da entrada.')
        else
          Text('${formatarDuracao(carga)} por dia · '
              '${formatarDuracao(carga * _dias.length)} por semana'),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _jornada == null || _salvando || invalido ? null : _salvar,
          child: const Text('Continuar'),
        ),
        const SizedBox(height: 8),
        TextButton(onPressed: widget.aoContinuar, child: const Text('Pular: manter 8 h de segunda a sexta')),
      ],
    );
  }
}

class _Planilha extends StatelessWidget {
  final VoidCallback aoContinuar;

  const _Planilha({required this.aoContinuar});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Sua planilha', style: tema.textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('Mostre ao app a planilha de ponto que a empresa te manda. Ele aprende onde '
            'vai cada coisa e, no fim do mês, preenche tudo sozinho.'),
        const SizedBox(height: 8),
        const Text('Ainda não tem o arquivo? Sem problema: o registro do dia a dia funciona '
            'normalmente e você configura a planilha até o fechamento do mês.'),
        const SizedBox(height: 24),
        FilledButton.icon(
          icon: const Icon(Icons.upload_file),
          label: const Text('Configurar agora'),
          onPressed: () async {
            final configurou = await context.push<bool>('/planilha/wizard');
            if (configurou == true) aoContinuar();
          },
        ),
        const SizedBox(height: 8),
        TextButton(onPressed: aoContinuar, child: const Text('Agora não')),
      ],
    );
  }
}

class _Email extends ConsumerStatefulWidget {
  final VoidCallback aoConcluir;

  const _Email({required this.aoConcluir});

  @override
  ConsumerState<_Email> createState() => _EmailState();
}

class _EmailState extends ConsumerState<_Email> {
  final _para = TextEditingController();
  String? _erro;

  @override
  void dispose() {
    _para.dispose();
    super.dispose();
  }

  Future<void> _concluir() async {
    final enderecos = ConfiguracaoEmail.separarEnderecos(_para.text);
    final invalido = enderecos.where((e) => !ConfiguracaoEmail.enderecoValido(e)).firstOrNull;
    if (enderecos.isEmpty || invalido != null) {
      setState(() => _erro = enderecos.isEmpty
          ? 'Informe ao menos um e-mail, ou pule esta etapa.'
          : '"$invalido" não parece um e-mail válido.');
      return;
    }
    final repositorio = ref.read(configuracaoEmailRepositorioProvider);
    final atual = await repositorio.buscar();
    final resultado = await repositorio.salvar(atual.copiaCom(destinatarios: enderecos));
    if (!mounted) return;
    resultado.quando(
      sucesso: (_) => widget.aoConcluir(),
      erro: (falha) => mostrarFalha(context, falha),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Seu e-mail', style: tema.textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('Para quem a planilha vai no fim do mês? O assunto e a mensagem já vêm '
            'prontos e podem ser mudados depois.'),
        const SizedBox(height: 16),
        TextField(
          controller: _para,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'E-mail do RH ou do gestor',
            hintText: 'rh@empresa.com.br',
            errorText: _erro,
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(onPressed: _concluir, child: const Text('Concluir')),
        const SizedBox(height: 8),
        TextButton(onPressed: widget.aoConcluir, child: const Text('Pular e concluir')),
      ],
    );
  }
}
