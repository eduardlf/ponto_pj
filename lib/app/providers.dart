import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../core/relogio.dart';
import '../data/local/banco_local.dart';
import '../data/planilha/escritor_xlsx_zip.dart';
import '../data/planilha/leitor_planilha_xml.dart';
import '../data/repositorios/configuracao_repositorios_drift.dart';
import '../data/repositorios/dia_repositorio_drift.dart';
import '../data/repositorios/envio_repositorio_drift.dart';
import '../data/repositorios/jornada_repositorio_drift.dart';
import '../data/repositorios/modelo_planilha_repositorio_drift.dart';
import '../data/servicos/armazenamento_arquivos_local.dart';
import '../data/servicos/servicos_sistema.dart';
import '../domain/contratos/contratos.dart';
import '../domain/repositorios/repositorios.dart';
import '../domain/servicos/calculadora_ponto.dart';
import '../domain/servicos/consulta_periodo.dart';
import '../domain/servicos/inferencia_planilha.dart';
import '../domain/servicos/preenchedor_planilha.dart';
import '../domain/servicos/resolvedor_variaveis.dart';
import '../domain/servicos/validador_modelo.dart';

/// Providers raiz (docs/09, seção 9.6). É o único ponto em que `data/` encontra a
/// interface: as telas só enxergam os contratos do domínio.

final bancoLocalProvider = Provider<BancoLocal>(
  (ref) => throw UnimplementedError('Sobrescrito em main.dart após a abertura do banco'),
);

final relogioProvider = Provider<Relogio>((ref) => const RelogioSistema());

// ── Domínio ────────────────────────────────────────────────────────────────────────────

final calculadoraProvider = Provider<CalculadoraPonto>((ref) => const CalculadoraPontoPadrao());
final preenchedorProvider = Provider<PreenchedorPlanilha>((ref) => const PreenchedorPlanilhaPadrao());
final resolvedorVariaveisProvider = Provider((ref) => const ResolvedorVariaveis());
final validadorModeloProvider = Provider((ref) => const ValidadorModelo());
final inferenciaPlanilhaProvider = Provider((ref) => const InferenciaPlanilha());

// ── Repositórios ───────────────────────────────────────────────────────────────────────

final jornadaRepositorioProvider =
    Provider<JornadaRepositorio>((ref) => JornadaRepositorioDrift(ref.watch(bancoLocalProvider)));

final diaRepositorioProvider = Provider<DiaRepositorio>((ref) => DiaRepositorioDrift(
      ref.watch(bancoLocalProvider),
      jornadas: ref.watch(jornadaRepositorioProvider),
      calculadora: ref.watch(calculadoraProvider),
      relogio: ref.watch(relogioProvider),
    ));

final perfilRepositorioProvider = Provider<PerfilRepositorio>((ref) =>
    PerfilRepositorioDrift(ref.watch(bancoLocalProvider), relogio: ref.watch(relogioProvider)));

final modeloPlanilhaRepositorioProvider = Provider<ModeloPlanilhaRepositorio>((ref) =>
    ModeloPlanilhaRepositorioDrift(ref.watch(bancoLocalProvider),
        relogio: ref.watch(relogioProvider)));

final configuracaoEmailRepositorioProvider = Provider<ConfiguracaoEmailRepositorio>(
    (ref) => ConfiguracaoEmailRepositorioDrift(ref.watch(bancoLocalProvider)));

final envioRepositorioProvider =
    Provider<EnvioRepositorio>((ref) => EnvioRepositorioDrift(ref.watch(bancoLocalProvider)));

final preferenciasRepositorioProvider = Provider<PreferenciasRepositorio>(
    (ref) => PreferenciasRepositorioDrift(ref.watch(bancoLocalProvider)));

final consultaPeriodoProvider = Provider((ref) => ConsultaPeriodo(
      dias: ref.watch(diaRepositorioProvider),
      jornadas: ref.watch(jornadaRepositorioProvider),
      calculadora: ref.watch(calculadoraProvider),
      relogio: ref.watch(relogioProvider),
    ));

// ── Serviços de sistema ────────────────────────────────────────────────────────────────

final leitorPlanilhaProvider = Provider<LeitorPlanilha>((ref) => const LeitorPlanilhaXml());
final escritorXlsxProvider = Provider<EscritorXlsx>((ref) => const EscritorXlsxZip());
final armazenamentoProvider = Provider<ArmazenamentoArquivos>((ref) => ArmazenamentoArquivosLocal(
      pastaBase: getApplicationSupportDirectory,
      relogio: ref.watch(relogioProvider),
    ));
final servicoEmailProvider = Provider<ServicoEmail>((ref) => const ServicoEmailAndroid());
final servicoArquivosExternosProvider =
    Provider<ServicoArquivosExternos>((ref) => const ServicoArquivosExternosAndroid());
final seletorArquivosProvider = Provider<SeletorArquivos>((ref) => const SeletorArquivosSistema());

// ── Estado global do app ───────────────────────────────────────────────────────────────

/// Incrementado depois de qualquer escrita: as telas que mostram dados o observam e se
/// recarregam, sem precisar saber quem escreveu.
final versaoDadosProvider = StateProvider<int>((ref) => 0);

/// Bate a cada segundo, para o relógio vivo e os valores vivos do dia (docs/12, 12.2).
final pulsoProvider = StreamProvider.autoDispose<DateTime>((ref) {
  final relogio = ref.watch(relogioProvider);
  return Stream.periodic(const Duration(seconds: 1), (_) => relogio.agora());
});

/// Carregado em main.dart antes do primeiro quadro, para o redirecionamento do onboarding.
final onboardingConcluidoProvider = StateProvider<bool>((ref) => false);

/// `sistema`, `claro` ou `escuro` (RF-02).
final temaProvider = StateProvider<String>((ref) => 'sistema');
