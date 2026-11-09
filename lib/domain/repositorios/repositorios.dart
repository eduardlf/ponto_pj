/// Contratos de repositório (docs/09, seção 9.4). Somente interfaces: as implementações
/// vivem em `data/repositorios/`.
library;

import '../../core/resultado.dart';
import '../entidades/competencia.dart';
import '../entidades/configuracao_email.dart';
import '../entidades/configuracao_jornada.dart';
import '../entidades/dia_trabalho.dart';
import '../entidades/envio_mensal.dart';
import '../entidades/modelo_planilha.dart';
import '../entidades/perfil_usuario.dart';
import '../enums/enums.dart';

abstract interface class DiaRepositorio {
  /// Nunca nulo: uma data sem registro devolve um dia vazio, já com a carga prevista da
  /// jornada aplicada.
  Future<DiaTrabalho> buscarPorData(DateTime data);

  /// Todos os dias de [inicio] a [fim], inclusive, com ou sem registro.
  Future<List<DiaTrabalho>> buscarIntervalo(DateTime inicio, DateTime fim);

  Future<List<DiaTrabalho>> buscarCompetencia(Competencia competencia);

  /// Data do primeiro dia gravado, de onde o banco de horas começa quando a jornada não
  /// define o início (RN-15).
  Future<DateTime?> primeiraDataRegistrada();

  /// Se existe algum dia gravado entre as datas, inclusive.
  Future<bool> existeRegistroEntre(DateTime inicio, DateTime fim);

  /// Valida RN-03 e RN-04, grava, reordena (RN-01) e recalcula o dia.
  Future<Resultado<DiaTrabalho>> adicionarMarcacao(
      DateTime data, Duration hora, OrigemMarcacao origem);

  Future<Resultado<DiaTrabalho>> editarMarcacao(int marcacaoId, Duration novaHora);

  /// Remove e recalcula os tipos das restantes (RN-05).
  Future<Resultado<DiaTrabalho>> excluirMarcacao(int marcacaoId);

  /// Status e observação definidos pelo usuário (RF-13).
  Future<Resultado<DiaTrabalho>> definirStatus(
      DateTime data, StatusDia status, String? observacao);

  /// Recalcula os dias abertos a partir de [data], depois de uma mudança na jornada
  /// (RN-29). Devolve quantos dias foram recalculados.
  Future<Resultado<int>> recalcularAPartirDe(DateTime data);
}

abstract interface class JornadaRepositorio {
  Future<ConfiguracaoJornada> buscarAtiva();

  Future<Resultado<ConfiguracaoJornada>> salvar(ConfiguracaoJornada jornada);
}

abstract interface class PerfilRepositorio {
  /// Nulo enquanto o usuário não preencher os próprios dados.
  Future<PerfilUsuario?> buscar();

  Future<Resultado<void>> salvar(PerfilUsuario perfil);
}

abstract interface class ModeloPlanilhaRepositorio {
  Future<ModeloPlanilha?> buscarAtivo();

  /// Desativa o modelo anterior e grava o novo na mesma transação (RN-17).
  Future<Resultado<ModeloPlanilha>> salvar(ModeloPlanilha modelo);
}

abstract interface class ConfiguracaoEmailRepositorio {
  Future<ConfiguracaoEmail> buscar();

  Future<Resultado<void>> salvar(ConfiguracaoEmail configuracao);
}

abstract interface class EnvioRepositorio {
  /// Mais recentes primeiro.
  Future<List<EnvioMensal>> listar();

  Future<List<EnvioMensal>> listarDaCompetencia(int ano, int mes);

  /// Cria o registro de uma geração; regerar cria outro e preserva o anterior (RN-24).
  Future<Resultado<EnvioMensal>> registrarGeracao(EnvioMensal envio);

  /// Só é chamado pela confirmação explícita do usuário (RN-23).
  Future<Resultado<void>> confirmarEnvio(int envioId, DateTime enviadoEm);
}

abstract interface class PreferenciasRepositorio {
  Future<bool> onboardingConcluido();

  Future<void> marcarOnboardingConcluido();

  /// `sistema`, `claro` ou `escuro`.
  Future<String> tema();

  Future<void> definirTema(String tema);
}
