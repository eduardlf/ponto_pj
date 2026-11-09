import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/extensoes/data_extensoes.dart';
import '../../core/falhas.dart';
import '../../core/resultado.dart';
import '../../domain/entidades/competencia.dart';
import '../../domain/entidades/conteudo_planilha.dart';
import '../../domain/entidades/dia_trabalho.dart';
import '../../domain/entidades/marcacao.dart';
import '../../domain/entidades/modelo_planilha.dart';
import '../../domain/entidades/plano_de_escrita.dart';
import '../../domain/enums/enums.dart';
import '../../domain/servicos/validador_modelo.dart';

/// O que o passo 5 mostra: o preenchimento real, feito pelo mesmo `PreenchedorPlanilha`
/// da geração (docs/10, seção 10.3).
class PreviaWizard {
  final Competencia competencia;

  /// Sem nenhum dia registrado, a prévia usa um mês fictício completo.
  final bool exemplo;
  final Resultado<ResultadoPreenchimento> resultado;

  const PreviaWizard({required this.competencia, required this.exemplo, required this.resultado});
}

class WizardEstado {
  static const totalPassos = 5;

  final int passo;
  final String? nomeArquivo;
  final Uint8List? bytes;
  final EstruturaPlanilha? estrutura;

  /// Modelo que está sendo editado; nulo quando é o primeiro.
  final ModeloPlanilha? anterior;
  final String? nomeAba;
  final int? linhaCabecalho;
  final int primeiraLinhaDados;
  final int? ultimaLinhaDados;
  final EstrategiaLinha estrategia;
  final int diaInicioCompetencia;
  final Map<CampoColuna, int> colunas;
  final Map<CampoCelulaFixa, String> celulasFixas;
  final String textoLivre;
  final Map<StatusDia, String> textosStatus;
  final FormatoData formatoData;
  final FormatoHora formatoHora;
  final Falha? falhaArquivo;
  final String? aviso;
  final bool ocupado;
  final PreviaWizard? previa;

  /// Verdadeiro depois de qualquer escolha do usuário: só então sair pede confirmação.
  final bool alterado;

  const WizardEstado({
    this.passo = 0,
    this.nomeArquivo,
    this.bytes,
    this.estrutura,
    this.anterior,
    this.nomeAba,
    this.linhaCabecalho,
    this.primeiraLinhaDados = 1,
    this.ultimaLinhaDados,
    this.estrategia = EstrategiaLinha.sequencial,
    this.diaInicioCompetencia = 1,
    this.colunas = const {},
    this.celulasFixas = const {},
    this.textoLivre = '',
    this.textosStatus = const {},
    this.formatoData = FormatoData.ddMmAaaa,
    this.formatoHora = FormatoHora.hhMm,
    this.falhaArquivo,
    this.aviso,
    this.ocupado = false,
    this.previa,
    this.alterado = false,
  });

  AbaPlanilha? get aba => nomeAba == null ? null : estrutura?.aba(nomeAba!);

  /// O modelo como seria salvo agora.
  ModeloPlanilha modelo({String caminho = '', String hash = ''}) => ModeloPlanilha(
        nome: nomeArquivo ?? 'Planilha',
        caminhoArquivoBase: caminho,
        nomeArquivoOriginal: nomeArquivo ?? 'planilha.xlsx',
        hashArquivo: hash,
        nomeAba: nomeAba ?? '',
        linhaCabecalho: linhaCabecalho,
        primeiraLinhaDados: primeiraLinhaDados,
        ultimaLinhaDados: ultimaLinhaDados,
        estrategia: estrategia,
        formatoData: formatoData,
        formatoHora: formatoHora,
        diaInicioCompetencia: diaInicioCompetencia,
        colunas: colunas,
        rotulosCabecalho: {
          for (final MapEntry(key: campo, value: coluna) in colunas.entries)
            if (linhaCabecalho != null && aba != null &&
                aba!.texto(linhaCabecalho!, coluna).trim().isNotEmpty)
              campo: aba!.texto(linhaCabecalho!, coluna).trim(),
        },
        celulasFixas: [
          for (final MapEntry(key: campo, value: referencia) in celulasFixas.entries)
            CelulaFixa(
              campo: campo,
              referencia: referencia,
              valorLivre: campo == CampoCelulaFixa.textoLivre ? textoLivre : null,
            ),
        ],
        textosStatus: textosStatus,
      );

  WizardEstado copiaCom({
    int? passo,
    String? nomeArquivo,
    Uint8List? bytes,
    EstruturaPlanilha? estrutura,
    String? nomeAba,
    int? linhaCabecalho,
    bool limparCabecalho = false,
    int? primeiraLinhaDados,
    int? ultimaLinhaDados,
    EstrategiaLinha? estrategia,
    int? diaInicioCompetencia,
    Map<CampoColuna, int>? colunas,
    Map<CampoCelulaFixa, String>? celulasFixas,
    String? textoLivre,
    Map<StatusDia, String>? textosStatus,
    FormatoData? formatoData,
    FormatoHora? formatoHora,
    Falha? falhaArquivo,
    bool limparFalha = false,
    String? aviso,
    bool limparAviso = false,
    bool? ocupado,
    PreviaWizard? previa,
    bool limparPrevia = false,
    bool? alterado,
  }) {
    return WizardEstado(
      passo: passo ?? this.passo,
      nomeArquivo: nomeArquivo ?? this.nomeArquivo,
      bytes: bytes ?? this.bytes,
      estrutura: estrutura ?? this.estrutura,
      anterior: anterior,
      nomeAba: nomeAba ?? this.nomeAba,
      linhaCabecalho: limparCabecalho ? null : (linhaCabecalho ?? this.linhaCabecalho),
      primeiraLinhaDados: primeiraLinhaDados ?? this.primeiraLinhaDados,
      ultimaLinhaDados: ultimaLinhaDados ?? this.ultimaLinhaDados,
      estrategia: estrategia ?? this.estrategia,
      diaInicioCompetencia: diaInicioCompetencia ?? this.diaInicioCompetencia,
      colunas: colunas ?? this.colunas,
      celulasFixas: celulasFixas ?? this.celulasFixas,
      textoLivre: textoLivre ?? this.textoLivre,
      textosStatus: textosStatus ?? this.textosStatus,
      formatoData: formatoData ?? this.formatoData,
      formatoHora: formatoHora ?? this.formatoHora,
      falhaArquivo: limparFalha ? null : (falhaArquivo ?? this.falhaArquivo),
      aviso: limparAviso ? null : (aviso ?? this.aviso),
      ocupado: ocupado ?? this.ocupado,
      previa: limparPrevia ? null : (previa ?? this.previa),
      alterado: alterado ?? this.alterado,
    );
  }
}

final wizardControllerProvider =
    AsyncNotifierProvider.autoDispose<WizardController, WizardEstado>(WizardController.new);

/// Wizard de mapeamento (UC-07, fluxo A2, sequência S1).
class WizardController extends AutoDisposeAsyncNotifier<WizardEstado> {
  @override
  Future<WizardEstado> build() async {
    final anterior = await ref.read(modeloPlanilhaRepositorioProvider).buscarAtivo();
    if (anterior == null) return const WizardEstado();

    // RF-31: editar o modelo salvo sem reimportar o arquivo.
    final bytes = await ref.read(armazenamentoProvider).lerBytes(anterior.caminhoArquivoBase);
    final base = WizardEstado(
      anterior: anterior,
      nomeArquivo: anterior.nomeArquivoOriginal,
      nomeAba: anterior.nomeAba,
      linhaCabecalho: anterior.linhaCabecalho,
      primeiraLinhaDados: anterior.primeiraLinhaDados,
      ultimaLinhaDados: anterior.ultimaLinhaDados,
      estrategia: anterior.estrategia,
      diaInicioCompetencia: anterior.diaInicioCompetencia,
      colunas: anterior.colunas,
      celulasFixas: {for (final c in anterior.celulasFixas) c.campo: c.referencia},
      textoLivre: anterior.celulasFixas
              .where((c) => c.campo == CampoCelulaFixa.textoLivre)
              .firstOrNull
              ?.valorLivre ??
          '',
      textosStatus: {
        for (final status in StatusDia.values)
          if (status != StatusDia.normal) status: anterior.textosStatus[status] ?? '',
      },
      formatoData: anterior.formatoData,
      formatoHora: anterior.formatoHora,
    );
    switch (bytes) {
      case Erro(:final falha):
        return base.copiaCom(falhaArquivo: falha);
      case Sucesso(valor: final conteudo):
        final estrutura =
            await ref.read(leitorPlanilhaProvider).ler(conteudo, nomeArquivo: anterior.nomeArquivoOriginal);
        return switch (estrutura) {
          Sucesso(:final valor) => base.copiaCom(bytes: conteudo, estrutura: valor),
          Erro(:final falha) => base.copiaCom(falhaArquivo: falha),
        };
    }
  }

  WizardEstado get _estado => state.requireValue;

  void _mudar(WizardEstado novo, {bool alterou = true}) =>
      state = AsyncData(alterou ? novo.copiaCom(alterado: true) : novo);

  // ── Passo 1: o arquivo ──────────────────────────────────────────────────────────────

  Future<void> escolherArquivo() async {
    final selecao = await ref.read(seletorArquivosProvider).escolherPlanilha();
    if (selecao case Erro(:final falha)) {
      _mudar(_estado.copiaCom(falhaArquivo: falha), alterou: false);
      return;
    }
    final arquivo = selecao.valorOuNulo;
    if (arquivo == null) return;
    await carregarArquivo(arquivo.nome, arquivo.bytes);
  }

  /// Lê o `.xlsx` escolhido. Com um modelo anterior compatível (mesma aba), o mapeamento é
  /// mantido (RF-32); senão, tudo é sugerido de novo a partir do arquivo.
  Future<void> carregarArquivo(String nome, Uint8List bytes) async {
    _mudar(_estado.copiaCom(ocupado: true, limparFalha: true, limparAviso: true), alterou: false);
    if (!nome.toLowerCase().endsWith('.xlsx') && !nome.toLowerCase().endsWith('.xls')) {
      _mudar(_estado.copiaCom(
          ocupado: false,
          falhaArquivo: const FalhaFormatoPlanilha('Escolha um arquivo do Excel, terminado em .xlsx.')));
      return;
    }
    final leitura = await ref.read(leitorPlanilhaProvider).ler(bytes, nomeArquivo: nome);
    switch (leitura) {
      case Erro(:final falha):
        _mudar(_estado.copiaCom(ocupado: false, falhaArquivo: falha), alterou: false);
      case Sucesso(valor: final estrutura):
        final atual = _estado;
        final manter = atual.anterior != null && estrutura.aba(atual.nomeAba ?? '') != null;
        var novo = atual.copiaCom(
          nomeArquivo: nome,
          bytes: bytes,
          estrutura: estrutura,
          ocupado: false,
          limparPrevia: true,
        );
        if (manter) {
          novo = novo.copiaCom(
              aviso: 'Mantive o mapeamento anterior. Confira nos próximos passos.');
        } else {
          final abaComConteudo = estrutura.abas
                  .where((a) => a.celulas.values.any((c) => !c.vazia))
                  .firstOrNull ??
              estrutura.abas.first;
          novo = _sugerir(novo.copiaCom(nomeAba: abaComConteudo.nome));
        }
        _mudar(novo);
    }
  }

  /// Sugestões a partir da aba e do cabeçalho (docs/10, seção 10.3).
  WizardEstado _sugerir(WizardEstado estado, {int? cabecalho}) {
    final aba = estado.aba;
    if (aba == null) return estado;
    final inferencia = ref.read(inferenciaPlanilhaProvider);
    final linhaCabecalho = cabecalho ?? inferencia.sugerirCabecalho(aba);
    final primeira = (linhaCabecalho ?? 0) + 1;
    final ultima = inferencia.sugerirUltimaLinha(aba, primeira);
    final colunas = linhaCabecalho == null
        ? <CampoColuna, int>{}
        : inferencia.sugerirColunas(aba,
            linhaCabecalho: linhaCabecalho, primeiraLinhaDados: primeira, ultimaLinhaDados: ultima);
    final formatos = inferencia.sugerirFormatos(aba, colunas, primeira);
    return estado.copiaCom(
      linhaCabecalho: linhaCabecalho,
      limparCabecalho: linhaCabecalho == null,
      primeiraLinhaDados: primeira,
      ultimaLinhaDados: ultima,
      colunas: colunas,
      celulasFixas: inferencia.sugerirCelulasFixas(aba, ateLinha: primeira - 1),
      formatoData: formatos.data,
      formatoHora: formatos.hora,
      textosStatus: inferencia.sugerirTextosStatus(colunas, formatos.hora),
      limparPrevia: true,
    );
  }

  // ── Passo 2: aba e linhas ───────────────────────────────────────────────────────────

  void escolherAba(String nome) => _mudar(_sugerir(_estado.copiaCom(nomeAba: nome)));

  void escolherCabecalho(int linha) => _mudar(_sugerir(_estado, cabecalho: linha));

  void definirLinhas({int? primeira, int? ultima}) => _mudar(_estado.copiaCom(
      primeiraLinhaDados: primeira, ultimaLinhaDados: ultima, limparPrevia: true));

  void definirEstrategia(EstrategiaLinha estrategia) =>
      _mudar(_estado.copiaCom(estrategia: estrategia, limparPrevia: true));

  void definirDiaInicio(int dia) =>
      _mudar(_estado.copiaCom(diaInicioCompetencia: dia.clamp(1, 28), limparPrevia: true));

  // ── Passo 3: colunas ────────────────────────────────────────────────────────────────

  void mapearColuna(CampoColuna campo, int? coluna) {
    final colunas = {..._estado.colunas};
    coluna == null ? colunas.remove(campo) : colunas[campo] = coluna;
    _mudar(_estado.copiaCom(colunas: colunas, limparPrevia: true));
  }

  // ── Passo 4: células fixas, textos e formatos ───────────────────────────────────────

  void definirCelulaFixa(CampoCelulaFixa campo, String? referencia) {
    final celulas = {..._estado.celulasFixas};
    referencia == null || referencia.trim().isEmpty
        ? celulas.remove(campo)
        : celulas[campo] = referencia.trim().toUpperCase();
    _mudar(_estado.copiaCom(celulasFixas: celulas, limparPrevia: true));
  }

  void definirTextoLivre(String texto) =>
      _mudar(_estado.copiaCom(textoLivre: texto, limparPrevia: true));

  void definirTextoStatus(StatusDia status, String texto) => _mudar(_estado.copiaCom(
      textosStatus: {..._estado.textosStatus, status: texto}, limparPrevia: true));

  void definirFormatos({FormatoData? data, FormatoHora? hora}) =>
      _mudar(_estado.copiaCom(formatoData: data, formatoHora: hora, limparPrevia: true));

  // ── Navegação e validação ───────────────────────────────────────────────────────────

  /// Erros que bloqueiam o avanço e alertas que só informam, do passo atual.
  ResultadoValidacao validacaoDoPasso() {
    final estado = _estado;
    final validador = ref.read(validadorModeloProvider);
    switch (estado.passo) {
      case 0:
        return ResultadoValidacao(erros: [
          if (estado.estrutura == null) 'Escolha a planilha que a empresa te mandou.',
        ]);
      case 1:
        return validador.validarLinhas(
          linhaCabecalho: estado.linhaCabecalho,
          primeiraLinhaDados: estado.primeiraLinhaDados,
          ultimaLinhaDados: estado.ultimaLinhaDados,
          aba: estado.aba,
        );
      case 2:
        return validador.validarColunas(estado.colunas,
            aba: estado.aba,
            primeiraLinhaDados: estado.primeiraLinhaDados,
            ultimaLinhaDados: estado.ultimaLinhaDados);
      case 3:
        return validador.validarCelulasFixas(estado.modelo().celulasFixas, aba: estado.aba);
      default:
        final previa = estado.previa;
        return ResultadoValidacao(erros: [
          if (previa == null) 'Montando a pré-visualização…',
          if (previa?.resultado.falhaOuNula case final falha?) falha.mensagem,
        ]);
    }
  }

  Future<void> avancar() async {
    if (!validacaoDoPasso().valido) return;
    final proximo = _estado.passo + 1;
    if (proximo >= WizardEstado.totalPassos) return;
    _mudar(_estado.copiaCom(passo: proximo, limparAviso: true), alterou: false);
    if (proximo == WizardEstado.totalPassos - 1) await gerarPrevia();
  }

  void voltar() {
    if (_estado.passo == 0) return;
    _mudar(_estado.copiaCom(passo: _estado.passo - 1, limparAviso: true), alterou: false);
  }

  /// Passo 5: usa a competência recente com mais dias registrados; sem nenhuma, um mês
  /// fictício completo.
  Future<void> gerarPrevia() async {
    final estado = _estado;
    final agora = ref.read(relogioProvider).agora();
    final atual = Competencia.contendo(agora.apenasData, diaInicio: estado.diaInicioCompetencia);
    final dias = ref.read(diaRepositorioProvider);

    var competencia = atual.anterior();
    var lista = await dias.buscarCompetencia(competencia);
    final listaAtual = await dias.buscarCompetencia(atual);
    if (listaAtual.where((d) => d.persistido).length > lista.where((d) => d.persistido).length) {
      competencia = atual;
      lista = listaAtual;
    }
    final exemplo = lista.every((d) => !d.persistido);
    final jornada = await ref.read(jornadaRepositorioProvider).buscarAtiva();
    final calculadora = ref.read(calculadoraProvider);
    if (exemplo) {
      lista = [
        for (final data in competencia.dias())
          calculadora.calcularDia(
            DiaTrabalho(
              data: data,
              marcacoes: jornada.paraData(data).trabalha
                  ? const [
                      Marcacao(hora: Duration(hours: 8)),
                      Marcacao(hora: Duration(hours: 12)),
                      Marcacao(hora: Duration(hours: 13)),
                      Marcacao(hora: Duration(hours: 17)),
                    ]
                  : const [],
            ),
            jornada,
          ),
      ];
    }

    final perfil = await ref.read(perfilRepositorioProvider).buscar();
    final resumo = calculadora.calcularPeriodo(lista, jornada, agora: agora);
    final resultado = ref.read(preenchedorProvider).preencher(
          modelo: estado.modelo(),
          competencia: competencia,
          dias: lista,
          perfil: perfil,
          resumo: resumo,
          dataGeracao: agora,
          aba: estado.aba,
          sistemaData1904: estado.estrutura?.sistemaData1904 ?? false,
        );
    state = AsyncData(_estado.copiaCom(
      previa: PreviaWizard(competencia: competencia, exemplo: exemplo, resultado: resultado),
    ));
  }

  /// Copia o arquivo para a área privada e grava o modelo em uma transação (RN-17).
  Future<Resultado<ModeloPlanilha>> salvar() async {
    final estado = _estado;
    final bytes = estado.bytes;
    if (bytes == null) {
      return const Erro(FalhaArquivo('Escolha a planilha que a empresa te mandou.'));
    }
    _mudar(estado.copiaCom(ocupado: true), alterou: false);
    final copia = await ref
        .read(armazenamentoProvider)
        .importarModelo(bytes, estado.nomeArquivo ?? 'planilha.xlsx');
    switch (copia) {
      case Erro(:final falha):
        _mudar(_estado.copiaCom(ocupado: false), alterou: false);
        return Erro(falha);
      case Sucesso(valor: final arquivo):
        final resultado = await ref
            .read(modeloPlanilhaRepositorioProvider)
            .salvar(estado.modelo(caminho: arquivo.caminho, hash: arquivo.hash));
        if (!resultado.ehSucesso) {
          await ref.read(armazenamentoProvider).excluir(arquivo.caminho);
        } else {
          ref.read(versaoDadosProvider.notifier).state++;
        }
        _mudar(_estado.copiaCom(ocupado: false, alterado: false), alterou: false);
        return resultado;
    }
  }
}
