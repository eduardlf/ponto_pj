import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/extensoes/data_extensoes.dart';
import '../../core/resultado.dart';
import '../../domain/entidades/competencia.dart';
import '../../domain/entidades/configuracao_jornada.dart';
import '../../domain/entidades/dia_trabalho.dart';
import '../../domain/enums/enums.dart';

class DiaEstado {
  final DateTime data;
  final DiaTrabalho dia;
  final ConfiguracaoJornada jornada;

  /// Banco de horas até a véspera; o do dia é somado ao vivo pela calculadora.
  final Duration bancoAteVespera;

  /// Dias antes desta data nunca foram registrados no app e não entram no banco (RN-15).
  final DateTime inicioAcompanhamento;

  /// Competência que terminou sem envio confirmado (R-03): um lembrete que não depende de
  /// notificação. Só aparece no dia de hoje.
  final Competencia? competenciaPendente;

  const DiaEstado({
    required this.data,
    required this.dia,
    required this.jornada,
    required this.bancoAteVespera,
    required this.inicioAcompanhamento,
    this.competenciaPendente,
  });
}

final diaControllerProvider =
    AsyncNotifierProvider.autoDispose.family<DiaController, DiaEstado, DateTime>(DiaController.new);

/// Registro do dia (UC-04, UC-05, UC-06 e o fluxo A3).
class DiaController extends AutoDisposeFamilyAsyncNotifier<DiaEstado, DateTime> {
  @override
  Future<DiaEstado> build(DateTime arg) async {
    ref.watch(versaoDadosProvider);
    final data = arg.apenasData;
    final jornada = await ref.watch(jornadaRepositorioProvider).buscarAtiva();
    final dia = await ref.watch(diaRepositorioProvider).buscarPorData(data);
    final consulta = ref.watch(consultaPeriodoProvider);
    final banco = await consulta.bancoAte(data.somarDias(-1), jornada: jornada);
    return DiaEstado(
      data: data,
      dia: dia,
      jornada: jornada,
      bancoAteVespera: banco,
      inicioAcompanhamento: await consulta.inicioAcompanhamento(jornada: jornada),
      competenciaPendente: await _competenciaPendente(data),
    );
  }

  Future<Competencia?> _competenciaPendente(DateTime data) async {
    final hoje = ref.read(relogioProvider).agora().apenasData;
    if (!data.mesmoDia(hoje)) return null;
    final modelo = await ref.read(modeloPlanilhaRepositorioProvider).buscarAtivo();
    final anterior =
        Competencia.contendo(hoje, diaInicio: modelo?.diaInicioCompetencia ?? 1).anterior();
    final temRegistro = await ref
        .read(diaRepositorioProvider)
        .existeRegistroEntre(anterior.primeiroDia(), anterior.ultimoDia());
    if (!temRegistro) return null;
    final envios =
        await ref.read(envioRepositorioProvider).listarDaCompetencia(anterior.ano, anterior.mes);
    return envios.any((e) => e.status == StatusEnvio.enviado) ? null : anterior;
  }

  /// RN-06: o tipo vem da paridade; a hora é a do relógio, sem segundos.
  Future<Resultado<DiaTrabalho>> baterPonto() {
    final agora = ref.read(relogioProvider).agora();
    return _depois(ref
        .read(diaRepositorioProvider)
        .adicionarMarcacao(agora.apenasData, agora.horaDoDia, OrigemMarcacao.automatica));
  }

  Future<Resultado<DiaTrabalho>> adicionar(Duration hora,
          {OrigemMarcacao origem = OrigemMarcacao.manual}) =>
      _depois(ref.read(diaRepositorioProvider).adicionarMarcacao(arg, hora, origem));

  Future<Resultado<DiaTrabalho>> editar(int marcacaoId, Duration hora) =>
      _depois(ref.read(diaRepositorioProvider).editarMarcacao(marcacaoId, hora));

  Future<Resultado<DiaTrabalho>> excluir(int marcacaoId) =>
      _depois(ref.read(diaRepositorioProvider).excluirMarcacao(marcacaoId));

  Future<Resultado<DiaTrabalho>> definirStatus(StatusDia status, String? observacao) =>
      _depois(ref.read(diaRepositorioProvider).definirStatus(arg, status, observacao));

  Future<Resultado<DiaTrabalho>> _depois(Future<Resultado<DiaTrabalho>> escrita) async {
    final resultado = await escrita;
    if (resultado.ehSucesso) ref.read(versaoDadosProvider.notifier).state++;
    return resultado;
  }
}
