import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/extensoes/data_extensoes.dart';
import '../../core/falhas.dart';
import '../../core/resultado.dart';
import '../../domain/entidades/competencia.dart';
import '../../domain/entidades/configuracao_email.dart';
import '../../domain/entidades/dia_trabalho.dart';
import '../../domain/entidades/envio_mensal.dart';
import '../../domain/entidades/modelo_planilha.dart';
import '../../domain/entidades/perfil_usuario.dart';
import '../../domain/entidades/resumo_periodo.dart';
import '../../domain/enums/enums.dart';
import '../../domain/servicos/resolvedor_variaveis.dart';

class FechamentoEstado {
  final Competencia competencia;
  final List<DiaTrabalho> dias;
  final ResumoPeriodo resumo;
  final ModeloPlanilha? modelo;
  final PerfilUsuario? perfil;
  final ConfiguracaoEmail email;

  /// Envios desta competência, o mais recente primeiro (RN-24).
  final List<EnvioMensal> envios;
  final bool arquivoBaseExiste;

  const FechamentoEstado({
    required this.competencia,
    required this.dias,
    required this.resumo,
    required this.modelo,
    required this.perfil,
    required this.email,
    required this.envios,
    required this.arquivoBaseExiste,
  });

  EnvioMensal? get ultimoEnvio => envios.firstOrNull;

  bool get enviado => envios.any((e) => e.status == StatusEnvio.enviado);

  ContextoVariaveis contexto(DateTime dataGeracao) => ContextoVariaveis(
      perfil: perfil, competencia: competencia, resumo: resumo, dataGeracao: dataGeracao);

}

/// O envio criado e os avisos da geração, em português, prontos para exibir.
typedef GeracaoConcluida = ({EnvioMensal envio, List<String> avisos});

/// Nulo: a competência padrão (até 10 dias depois do fim do período, a anterior).
typedef ChaveCompetencia = ({int ano, int mes})?;

final fechamentoControllerProvider = AsyncNotifierProvider.autoDispose
    .family<FechamentoController, FechamentoEstado, ChaveCompetencia>(FechamentoController.new);

/// Fechamento do mês: gerar e enviar (UC-10, UC-11, fluxo A4, sequências S2 e S3).
class FechamentoController extends AutoDisposeFamilyAsyncNotifier<FechamentoEstado, ChaveCompetencia> {
  @override
  Future<FechamentoEstado> build(ChaveCompetencia arg) async {
    ref.watch(versaoDadosProvider);
    final modelo = await ref.watch(modeloPlanilhaRepositorioProvider).buscarAtivo();
    final diaInicio = modelo?.diaInicioCompetencia ?? 1;
    final competencia = arg == null
        ? _competenciaPadrao(diaInicio)
        : Competencia(arg.ano, arg.mes, diaInicio: diaInicio);

    final periodo = await ref
        .watch(consultaPeriodoProvider)
        .consultar(competencia.primeiroDia(), competencia.ultimoDia());
    return FechamentoEstado(
      competencia: competencia,
      dias: periodo.dias,
      resumo: periodo.resumo,
      modelo: modelo,
      perfil: await ref.watch(perfilRepositorioProvider).buscar(),
      email: await ref.watch(configuracaoEmailRepositorioProvider).buscar(),
      envios: await ref
          .watch(envioRepositorioProvider)
          .listarDaCompetencia(competencia.ano, competencia.mes),
      arquivoBaseExiste:
          modelo != null && await ref.watch(armazenamentoProvider).existe(modelo.caminhoArquivoBase),
    );
  }

  /// UC-10, passo 2: até o 10º dia depois do fim do período, a competência anterior.
  Competencia _competenciaPadrao(int diaInicio) {
    final hoje = ref.read(relogioProvider).agora().apenasData;
    final atual = Competencia.contendo(hoje, diaInicio: diaInicio);
    final anterior = atual.anterior();
    return anterior.ultimoDia().diasAte(hoje) <= 10 ? anterior : atual;
  }

  /// RN-18 a RN-22 e RN-24. Nenhum arquivo parcial nem registro fica para trás em caso de
  /// falha (RNF-06); o arquivo modelo nunca é alterado.
  Future<Resultado<GeracaoConcluida>> gerar() async {
    final estado = state.requireValue;
    final modelo = estado.modelo;
    if (modelo == null) {
      return const Erro(FalhaMapeamento('Configure a planilha da empresa antes de fechar o mês.'));
    }
    final armazenamento = ref.read(armazenamentoProvider);
    final avisos = <String>[];

    final base = await armazenamento.lerBytes(modelo.caminhoArquivoBase);
    if (base case Erro(:final falha)) return Erro(falha);
    final bytes = base.valorOuNulo!;
    if (armazenamento.calcularHash(bytes) != modelo.hashArquivo) {
      avisos.add('O arquivo modelo mudou desde que você configurou. Confira se o mapeamento '
          'ainda está certo.');
    }

    final leitura = await ref.read(leitorPlanilhaProvider).ler(bytes,
        nomeArquivo: modelo.nomeArquivoOriginal);
    if (leitura case Erro(:final falha)) return Erro(falha);
    final estrutura = leitura.valorOuNulo!;

    final agora = ref.read(relogioProvider).agora();
    final preenchimento = ref.read(preenchedorProvider).preencher(
          modelo: modelo,
          competencia: estado.competencia,
          dias: estado.dias,
          perfil: estado.perfil,
          resumo: estado.resumo,
          dataGeracao: agora,
          aba: estrutura.aba(modelo.nomeAba),
          sistemaData1904: estrutura.sistemaData1904,
        );
    if (preenchimento case Erro(:final falha)) return Erro(falha);
    final plano = preenchimento.valorOuNulo!;
    avisos.addAll(plano.avisos);

    final escrita = await ref.read(escritorXlsxProvider).aplicar(bytes, plano.plano);
    if (escrita case Erro(:final falha)) return Erro(falha);
    final arquivo = escrita.valorOuNulo!;
    avisos.addAll(arquivo.avisos);

    final nome = ref
        .read(resolvedorVariaveisProvider)
        .resolverNomeArquivo(estado.email.templateNomeArquivo, estado.contexto(agora));
    final gravacao = await armazenamento.gravarGerado(nome, arquivo.bytes);
    if (gravacao case Erro(:final falha)) return Erro(falha);
    final gravado = gravacao.valorOuNulo!;

    final pendencias = estado.resumo.pendencias.length;
    final registro = await ref.read(envioRepositorioProvider).registrarGeracao(EnvioMensal(
          modeloId: modelo.id,
          competenciaAno: estado.competencia.ano,
          competenciaMes: estado.competencia.mes,
          status: StatusEnvio.gerado,
          geradoEm: agora,
          caminhoArquivo: gravado.caminho,
          nomeArquivo: nome,
          tamanhoBytes: gravado.tamanhoBytes,
          observacao: [
            if (pendencias > 0) 'Gerado com $pendencias pendência${pendencias == 1 ? '' : 's'}.',
            ...avisos,
          ].join(' ').trim().ifEmptyNull,
        ));
    if (registro case Erro(:final falha)) {
      await armazenamento.excluir(gravado.caminho);
      return Erro(falha);
    }

    ref.read(versaoDadosProvider.notifier).state++;
    return Sucesso((envio: registro.valorOuNulo!, avisos: avisos));
  }

  /// Abre o cliente de e-mail; sucesso significa só que ele ABRIU (RN-23).
  Future<Resultado<void>> abrirEmail(EnvioMensal envio) {
    final estado = state.requireValue;
    final resolvedor = ref.read(resolvedorVariaveisProvider);
    final contexto = estado.contexto(envio.geradoEm);
    return ref.read(servicoEmailProvider).abrirComposicao(
          destinatarios: estado.email.destinatarios,
          copia: estado.email.copia,
          assunto: resolvedor.resolver(estado.email.assuntoModelo, contexto),
          corpo: resolvedor.resolver(estado.email.corpoModelo, contexto),
          caminhoAnexo: envio.caminhoArquivo,
        );
  }

  Future<Resultado<void>> compartilhar(EnvioMensal envio) {
    final estado = state.requireValue;
    final resolvedor = ref.read(resolvedorVariaveisProvider);
    final contexto = estado.contexto(envio.geradoEm);
    return ref.read(servicoArquivosExternosProvider).compartilhar(
          envio.caminhoArquivo,
          assunto: resolvedor.resolver(estado.email.assuntoModelo, contexto),
          texto: resolvedor.resolver(estado.email.corpoModelo, contexto),
        );
  }

  Future<Resultado<void>> abrirArquivo(EnvioMensal envio) =>
      ref.read(servicoArquivosExternosProvider).abrir(envio.caminhoArquivo);

  /// Só a confirmação explícita do usuário marca como enviado (RN-23, ADR-09).
  Future<Resultado<void>> confirmarEnvio(EnvioMensal envio) async {
    final resultado = await ref
        .read(envioRepositorioProvider)
        .confirmarEnvio(envio.id!, ref.read(relogioProvider).agora());
    if (resultado.ehSucesso) ref.read(versaoDadosProvider.notifier).state++;
    return resultado;
  }
}

extension on String {
  String? get ifEmptyNull => isEmpty ? null : this;
}
