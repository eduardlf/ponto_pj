import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/tema.dart';
import '../../core/formatadores.dart';
import '../../core/resultado.dart';
import '../../domain/entidades/conteudo_planilha.dart';
import '../../domain/entidades/plano_de_escrita.dart';
import '../../domain/entidades/referencia_celula.dart';
import '../../domain/enums/enums.dart';
import '../../domain/enums/rotulos.dart';
import '../../domain/servicos/validador_modelo.dart';
import '../comum/componentes.dart';
import '../comum/grade_planilha.dart';
import '../comum/interacao.dart';
import 'wizard_controller.dart';

/// TL-16 a TL-20: o app aprende o formato da planilha da empresa (UC-07, fluxo A2).
/// Devolve `true` ao salvar um modelo.
class WizardTela extends ConsumerWidget {
  const WizardTela({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(wizardControllerProvider);
    return estado.when(
      skipLoadingOnReload: true,
      data: (e) => _Moldura(estado: e),
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Modelo de planilha')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Scaffold(
        appBar: AppBar(title: const Text('Modelo de planilha')),
        body: const EstadoVazio(
          icone: Icons.error_outline,
          titulo: 'Não consegui abrir o assistente.',
          mensagem: 'Volte e tente de novo.',
        ),
      ),
    );
  }
}

class _Moldura extends ConsumerWidget {
  final WizardEstado estado;

  const _Moldura({required this.estado});

  static const _titulos = [
    'Envie a planilha que a empresa te mandou',
    'Onde os dias começam',
    'Diga o que vai em cada coluna',
    'Os dados que aparecem uma vez só',
    'Assim vai ficar a sua planilha',
  ];

  Future<void> _sair(BuildContext context) async {
    final navegador = Navigator.of(context);
    if (estado.alterado) {
      final sair = await confirmar(
        context,
        titulo: 'Sair do assistente?',
        mensagem: 'Sair agora descarta a configuração da planilha. Você terá que começar de novo.',
        rotuloConfirmar: 'Sair',
        destrutivo: true,
      );
      if (!sair) return;
    }
    navegador.pop(false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(wizardControllerProvider.notifier);
    final validacao = controller.validacaoDoPasso();
    final ultimo = estado.passo == WizardEstado.totalPassos - 1;
    final tema = Theme.of(context);

    Future<void> salvar() async {
      final navegador = Navigator.of(context);
      final resultado = await controller.salvar();
      if (!context.mounted) return;
      resultado.quando(
        sucesso: (_) {
          mostrarMensagem(context, 'Planilha configurada. Ela será usada no fechamento do mês.');
          navegador.pop(true);
        },
        erro: (falha) => mostrarFalha(context, falha),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (saiu, _) {
        if (saiu) return;
        estado.passo > 0 ? controller.voltar() : _sair(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Modelo de planilha'),
          leading: IconButton(
            tooltip: 'Sair do assistente',
            icon: const Icon(Icons.close),
            onPressed: () => _sair(context),
          ),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text('${estado.passo + 1} de ${WizardEstado.totalPassos}'),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: (estado.passo + 1) / WizardEstado.totalPassos,
              backgroundColor: tema.colorScheme.primary,
              color: tema.colorScheme.onPrimary,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            Semantics(
              header: true,
              child: Text(_titulos[estado.passo], style: tema.textTheme.titleLarge),
            ),
            const SizedBox(height: 8),
            // O motivo de "Continuar" estar desabilitado aparece no topo, à vista.
            _Validacao(validacao: validacao, mostrarErros: estado.passo != 0),
            switch (estado.passo) {
              0 => _PassoArquivo(estado: estado),
              1 => _PassoLinhas(estado: estado),
              2 => _PassoColunas(estado: estado),
              3 => _PassoCelulas(estado: estado),
              _ => _PassoPrevia(estado: estado),
            },
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                OutlinedButton(
                  onPressed: estado.passo == 0 ? () => _sair(context) : controller.voltar,
                  child: Text(estado.passo == 0 ? 'Cancelar' : 'Voltar'),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: !validacao.valido || estado.ocupado
                      ? null
                      : (ultimo ? salvar : controller.avancar),
                  child: Text(ultimo ? 'Salvar modelo' : 'Continuar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Validacao extends StatelessWidget {
  final ResultadoValidacao validacao;
  final bool mostrarErros;

  const _Validacao({required this.validacao, required this.mostrarErros});

  @override
  Widget build(BuildContext context) {
    final cores = CoresPonto.de(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (mostrarErros)
          for (final erro in validacao.erros)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                Icon(Icons.block, color: cores.debito),
                const SizedBox(width: 8),
                Expanded(child: Text(erro)),
              ]),
            ),
        for (final alerta in validacao.alertas)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: FaixaAviso(texto: alerta),
          ),
      ],
    );
  }
}

// ── Passo 1 ────────────────────────────────────────────────────────────────────────────

class _PassoArquivo extends ConsumerWidget {
  final WizardEstado estado;

  const _PassoArquivo({required this.estado});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final controller = ref.read(wizardControllerProvider.notifier);
    final estrutura = estado.estrutura;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('O app vai aprender o formato dela e preencher sozinho todo mês. '
            'O arquivo original nunca é alterado.'),
        const SizedBox(height: 16),
        Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: estado.ocupado ? null : controller.escolherArquivo,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(Icons.upload_file, size: 48, color: tema.colorScheme.primary),
                  const SizedBox(height: 8),
                  Text(estrutura == null
                      ? 'Toque para escolher um arquivo .xlsx'
                      : 'Toque para trocar o arquivo'),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (estado.ocupado) const Center(child: CircularProgressIndicator()),
        if (estado.falhaArquivo case final falha?)
          FaixaAviso(texto: falha.mensagem, icone: Icons.error_outline),
        if (estrutura != null) ...[
          Row(children: [
            Icon(Icons.check_circle, color: CoresPonto.de(context).credito),
            const SizedBox(width: 8),
            Expanded(child: Text(estado.nomeArquivo ?? '', style: tema.textTheme.titleMedium)),
          ]),
          for (final aba in estrutura.abas)
            Padding(
              padding: const EdgeInsets.only(left: 32, top: 4),
              child: Text('${aba.nome} · ${aba.ultimaLinhaComConteudo} linhas · '
                  '${aba.ultimaColunaComConteudo + 1} colunas'),
            ),
        ],
        if (estado.aviso case final aviso?) ...[
          const SizedBox(height: 12),
          FaixaAviso(texto: aviso, icone: Icons.info_outline),
        ],
      ],
    );
  }
}

// ── Passo 2 ────────────────────────────────────────────────────────────────────────────

class _PassoLinhas extends ConsumerWidget {
  final WizardEstado estado;

  const _PassoLinhas({required this.estado});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(wizardControllerProvider.notifier);
    final estrutura = estado.estrutura!;
    final aba = estado.aba;
    final tema = Theme.of(context);
    final cabecalho = estado.linhaCabecalho;
    final primeira = estado.primeiraLinhaDados;
    final ultima = estado.ultimaLinhaDados;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (estrutura.abas.length > 1) ...[
          DropdownButtonFormField<String>(
            value: estado.nomeAba,
            decoration: const InputDecoration(labelText: 'Aba'),
            items: [
              for (final a in estrutura.abas) DropdownMenuItem(value: a.nome, child: Text(a.nome)),
            ],
            onChanged: (nome) => nome == null ? null : controller.escolherAba(nome),
          ),
          const SizedBox(height: 16),
        ],
        const Text('Toque na linha com os títulos das colunas:'),
        const SizedBox(height: 8),
        if (aba != null)
          GradePlanilha(
            aba: aba,
            modo: ModoSelecao.linha,
            linhaInicial: cabecalho,
            linhasMarcadas: {
              if (cabecalho != null) cabecalho: 'cabeçalho',
              primeira: 'primeira linha de dados',
              if (ultima != null) ultima: 'última linha de dados',
            },
            aoTocarLinha: controller.escolherCabecalho,
          ),
        const SizedBox(height: 12),
        Text('Cabeçalho: ${cabecalho == null ? 'não definido' : 'linha $cabecalho'}',
            style: tema.textTheme.titleSmall),
        _CampoNumero(
          rotulo: 'Primeira linha de dados',
          valor: primeira,
          minimo: 1,
          aoMudar: (v) => controller.definirLinhas(primeira: v),
        ),
        _CampoNumero(
          rotulo: 'Última linha de dados',
          valor: ultima ?? primeira + 30,
          minimo: primeira,
          aoMudar: (v) => controller.definirLinhas(ultima: v),
        ),
        const TituloSecao('Como os dias são organizados?'),
        RadioListTile<EstrategiaLinha>(
          value: EstrategiaLinha.sequencial,
          groupValue: estado.estrategia,
          onChanged: (v) => controller.definirEstrategia(v!),
          title: const Text('Uma linha por dia, na ordem'),
          subtitle: Text('Dia 1 na linha $primeira, dia 2 na ${primeira + 1}...'),
        ),
        RadioListTile<EstrategiaLinha>(
          value: EstrategiaLinha.porData,
          groupValue: estado.estrategia,
          onChanged: (v) => controller.definirEstrategia(v!),
          title: const Text('Procurar a data na coluna'),
          subtitle: const Text('Para planilhas que já vêm com as datas: escrevo onde a data bate.'),
        ),
        const TituloSecao('Em que dia começa o período da planilha?'),
        RadioListTile<bool>(
          value: true,
          groupValue: estado.diaInicioCompetencia == 1,
          onChanged: (_) => controller.definirDiaInicio(1),
          title: const Text('No dia 1: o mês do calendário'),
        ),
        RadioListTile<bool>(
          value: false,
          groupValue: estado.diaInicioCompetencia == 1,
          onChanged: (_) => controller.definirDiaInicio(26),
          title: const Text('Em outro dia do mês anterior'),
          subtitle: const Text('Para empresas que fecham o ponto antes do fim do mês.'),
        ),
        if (estado.diaInicioCompetencia > 1)
          _CampoNumero(
            rotulo: 'Dia de início do período',
            valor: estado.diaInicioCompetencia,
            minimo: 2,
            maximo: 28,
            aoMudar: controller.definirDiaInicio,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(_exemploPeriodo(estado.diaInicioCompetencia),
              style: tema.textTheme.bodySmall?.copyWith(color: tema.colorScheme.onSurfaceVariant)),
        ),
      ],
    );
  }

  String _exemploPeriodo(int diaInicio) {
    if (diaInicio == 1) return 'A competência de outubro vai de 01/10 a 31/10.';
    final fim = (diaInicio - 1).toString().padLeft(2, '0');
    final inicio = diaInicio.toString().padLeft(2, '0');
    return 'A competência de outubro vai de $inicio/09 a $fim/10.';
  }
}

class _CampoNumero extends StatelessWidget {
  final String rotulo;
  final int valor;
  final int minimo;
  final int maximo;
  final ValueChanged<int> aoMudar;

  const _CampoNumero({
    required this.rotulo,
    required this.valor,
    required this.aoMudar,
    this.minimo = 1,
    this.maximo = 100000,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(rotulo),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Diminuir $rotulo',
            onPressed: valor > minimo ? () => aoMudar(valor - 1) : null,
            icon: const Icon(Icons.remove),
          ),
          Text('$valor', style: const TextStyle(fontFeatures: algarismosTabulares)),
          IconButton(
            tooltip: 'Aumentar $rotulo',
            onPressed: valor < maximo ? () => aoMudar(valor + 1) : null,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

// ── Passo 3 ────────────────────────────────────────────────────────────────────────────

class _PassoColunas extends ConsumerWidget {
  final WizardEstado estado;

  const _PassoColunas({required this.estado});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(wizardControllerProvider.notifier);
    final aba = estado.aba!;
    final cabecalho = estado.linhaCabecalho;
    final colunas = (aba.ultimaColunaComConteudo + 1).clamp(1, 60);
    final cores = CoresPonto.de(context);

    String rotuloColuna(int c) {
      final titulo = cabecalho == null ? '' : aba.texto(cabecalho, c).trim();
      final exemplo = aba.texto(estado.primeiraLinhaDados, c).trim();
      final letra = ReferenciaCelula.letraDaColuna(c);
      if (titulo.isNotEmpty) return '$letra · $titulo';
      return exemplo.isEmpty ? letra : '$letra · ex.: $exemplo';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Escolhi pelo texto do cabeçalho. Confira e corrija o que precisar. '
            'Só a data é obrigatória.'),
        const SizedBox(height: 16),
        for (final campo in CampoColuna.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int?>(
                    value: estado.colunas[campo],
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: campo == CampoColuna.data ? '${campo.rotulo} (obrigatória)' : campo.rotulo,
                    ),
                    items: [
                      const DropdownMenuItem<int?>(value: null, child: Text('— não usar')),
                      for (var c = 0; c < colunas; c++)
                        DropdownMenuItem<int?>(
                          value: c,
                          child: Text(rotuloColuna(c), overflow: TextOverflow.ellipsis),
                        ),
                    ],
                    onChanged: (c) => controller.mapearColuna(campo, c),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 24,
                  child: estado.colunas.containsKey(campo)
                      ? Icon(Icons.check_circle, color: cores.credito, semanticLabel: 'mapeado')
                      : null,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ── Passo 4 ────────────────────────────────────────────────────────────────────────────

class _PassoCelulas extends ConsumerWidget {
  final WizardEstado estado;

  const _PassoCelulas({required this.estado});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(wizardControllerProvider.notifier);
    final aba = estado.aba!;
    final tema = Theme.of(context);
    final textoNaHora = !estado.colunas.containsKey(CampoColuna.status) && estado.formatoHora.nativo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Toque em "escolher" e depois na célula da planilha onde o valor vai. '
            'Deixe em branco o que a planilha não tem.'),
        const SizedBox(height: 8),
        for (final campo in CampoCelulaFixa.values) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(campo.rotulo),
            subtitle: Text(estado.celulasFixas[campo] ?? 'Não usar'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () async {
                    final escolhida = await _escolherCelula(context, aba, campo.rotulo,
                        ReferenciaCelula.deA1(estado.celulasFixas[campo] ?? ''));
                    if (escolhida != null) controller.definirCelulaFixa(campo, escolhida.a1);
                  },
                  child: const Text('escolher'),
                ),
                if (estado.celulasFixas.containsKey(campo))
                  IconButton(
                    tooltip: 'Não usar ${campo.rotulo}',
                    icon: const Icon(Icons.clear),
                    onPressed: () => controller.definirCelulaFixa(campo, null),
                  ),
              ],
            ),
          ),
          if (campo == CampoCelulaFixa.textoLivre && estado.celulasFixas.containsKey(campo))
            TextFormField(
              initialValue: estado.textoLivre,
              decoration: const InputDecoration(labelText: 'Texto a escrever'),
              onChanged: controller.definirTextoLivre,
            ),
        ],
        const TituloSecao('O que escrever nos dias não trabalhados?'),
        if (textoNaHora)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: FaixaAviso(
              icone: Icons.info_outline,
              texto: 'Sem coluna de status, o texto iria na coluna da 1ª entrada, que tem hora '
                  'do Excel: isso quebra as somas da planilha. Por isso deixei em branco.',
            ),
          ),
        for (final status in StatusDia.values.where((s) => s != StatusDia.normal))
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextFormField(
              key: ValueKey('texto-${status.name}'),
              initialValue: estado.textosStatus[status] ?? '',
              decoration: InputDecoration(
                labelText: status.rotulo,
                hintText: 'Em branco: escreve os horários, se houver',
              ),
              onChanged: (t) => controller.definirTextoStatus(status, t),
            ),
          ),
        const TituloSecao('Formatos'),
        DropdownButtonFormField<FormatoData>(
          value: estado.formatoData,
          decoration: const InputDecoration(labelText: 'Formato da data'),
          items: [
            for (final f in FormatoData.values) DropdownMenuItem(value: f, child: Text(f.rotulo)),
          ],
          onChanged: (f) => controller.definirFormatos(data: f),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<FormatoHora>(
          value: estado.formatoHora,
          decoration: const InputDecoration(labelText: 'Formato da hora'),
          items: [
            for (final f in FormatoHora.values) DropdownMenuItem(value: f, child: Text(f.rotulo)),
          ],
          onChanged: (f) => controller.definirFormatos(hora: f),
        ),
        const SizedBox(height: 8),
        Text('"Data do Excel" e "Hora do Excel" mantêm funcionando as fórmulas que a empresa '
            'colocou na planilha. A pré-visualização mostra a diferença.',
            style: tema.textTheme.bodySmall?.copyWith(color: tema.colorScheme.onSurfaceVariant)),
      ],
    );
  }

  Future<ReferenciaCelula?> _escolherCelula(
      BuildContext context, AbaPlanilha aba, String rotulo, ReferenciaCelula? atual) {
    return Navigator.of(context).push<ReferenciaCelula>(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => _EscolhaCelula(aba: aba, rotulo: rotulo, atual: atual),
    ));
  }
}

class _EscolhaCelula extends StatefulWidget {
  final AbaPlanilha aba;
  final String rotulo;
  final ReferenciaCelula? atual;

  const _EscolhaCelula({required this.aba, required this.rotulo, this.atual});

  @override
  State<_EscolhaCelula> createState() => _EscolhaCelulaState();
}

class _EscolhaCelulaState extends State<_EscolhaCelula> {
  late ReferenciaCelula? _selecionada = widget.atual;
  late final _digitada = TextEditingController(text: widget.atual?.a1 ?? '');

  @override
  void dispose() {
    _digitada.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Onde vai: ${widget.rotulo}'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.onPrimary),
            onPressed: _selecionada == null ? null : () => Navigator.of(context).pop(_selecionada),
            child: const Text('Usar'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Toque na célula da planilha:'),
          const SizedBox(height: 8),
          GradePlanilha(
            aba: widget.aba,
            modo: ModoSelecao.celula,
            altura: 420,
            linhaInicial: widget.atual?.linha ?? 1,
            celulasMarcadas: {if (_selecionada != null) _selecionada!},
            aoTocarCelula: (ref) => setState(() {
              _selecionada = ref;
              _digitada.text = ref.a1;
            }),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _digitada,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Ou digite a célula',
              hintText: 'Ex.: D3',
            ),
            onChanged: (texto) => setState(() => _selecionada = ReferenciaCelula.deA1(texto)),
          ),
        ],
      ),
    );
  }
}

// ── Passo 5 ────────────────────────────────────────────────────────────────────────────

class _PassoPrevia extends ConsumerWidget {
  final WizardEstado estado;

  const _PassoPrevia({required this.estado});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previa = estado.previa;
    if (previa == null) return const Center(child: CircularProgressIndicator());
    final tema = Theme.of(context);
    final cores = CoresPonto.de(context);
    final aba = estado.aba!;

    return switch (previa.resultado) {
      Erro(:final falha) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FaixaAviso(texto: falha.mensagem, icone: Icons.error_outline),
            const SizedBox(height: 8),
            const Text('Volte ao passo 2 e confira a primeira e a última linha de dados.'),
          ],
        ),
      Sucesso(valor: final preenchimento) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(previa.exemplo
                ? 'Com dados de exemplo de ${previa.competencia.formatado()}, porque ainda não '
                    'há dias registrados.'
                : 'Com os seus dados de ${previa.competencia.formatado()} '
                    '(${previa.competencia.periodoFormatado()}).'),
            const SizedBox(height: 12),
            GradePlanilha(
              aba: aba,
              altura: 420,
              linhaInicial: 1,
              valoresSobrepostos: {
                for (final MapEntry(:key, :value) in preenchimento.plano.celulas.entries)
                  key: textoDoValor(value),
              },
            ),
            const SizedBox(height: 4),
            Text('Em verde, o que o app escreve. O resto continua como está no arquivo.',
                style: tema.textTheme.bodySmall),
            const SizedBox(height: 16),
            _Conferido(
              cor: cores.credito,
              texto: estado.estrategia == EstrategiaLinha.sequencial
                  ? '${previa.competencia.totalDias()} dias couberam nas linhas '
                      '${estado.primeiraLinhaDados} a '
                      '${estado.primeiraLinhaDados + previa.competencia.totalDias() - 1}'
                  : '${previa.competencia.totalDias() - preenchimento.diasNaoResolvidos.length} '
                      'de ${previa.competencia.totalDias()} dias encontrados pela data',
            ),
            _Conferido(cor: cores.credito, texto: 'A coluna da data está mapeada'),
            for (final aviso in preenchimento.avisos)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: FaixaAviso(texto: aviso),
              ),
          ],
        ),
    };
  }
}

class _Conferido extends StatelessWidget {
  final Color cor;
  final String texto;

  const _Conferido({required this.cor, required this.texto});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(children: [
          Icon(Icons.check, color: cor),
          const SizedBox(width: 8),
          Expanded(child: Text(texto)),
        ]),
      );
}

/// Como um valor do plano aparece na grade.
String textoDoValor(ValorCelula valor) => switch (valor) {
      TextoCelula(:final texto) => texto,
      NumeroCelula(valor: final numero) => '$numero',
      DataCelula(:final data) => formatarDataCurta(data),
      HoraCelula(:final hora) => formatarDuracaoRelogio(hora),
      VaziaCelula() => '',
    };
