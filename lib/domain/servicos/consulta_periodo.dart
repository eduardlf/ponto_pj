import '../../core/extensoes/data_extensoes.dart';
import '../../core/relogio.dart';
import '../entidades/configuracao_jornada.dart';
import '../entidades/dia_trabalho.dart';
import '../entidades/resumo_periodo.dart';
import '../repositorios/repositorios.dart';
import 'calculadora_ponto.dart';

/// Os dias de um período e seus totais, prontos para as visões de semana, mês e fechamento.
class PeriodoConsultado {
  final List<DiaTrabalho> dias;
  final ResumoPeriodo resumo;
  final ConfiguracaoJornada jornada;

  const PeriodoConsultado({required this.dias, required this.resumo, required this.jornada});
}

/// Junta repositórios e calculadora para responder "como está este período" (UC-08).
/// Não calcula nada por conta própria: só busca os dias e delega à `CalculadoraPonto`.
class ConsultaPeriodo {
  final DiaRepositorio _dias;
  final JornadaRepositorio _jornadas;
  final CalculadoraPonto _calculadora;
  final Relogio _relogio;

  const ConsultaPeriodo({
    required DiaRepositorio dias,
    required JornadaRepositorio jornadas,
    required CalculadoraPonto calculadora,
    required Relogio relogio,
  })  : _dias = dias,
        _jornadas = jornadas,
        _calculadora = calculadora,
        _relogio = relogio;

  Future<PeriodoConsultado> consultar(DateTime inicio, DateTime fim) async {
    final agora = _relogio.agora();
    final jornada = await _jornadas.buscarAtiva();
    final dias = await _dias.buscarIntervalo(inicio, fim);
    final acompanhamento = await inicioAcompanhamento(jornada: jornada, agora: agora);
    final banco = await bancoAte(fim, jornada: jornada, agora: agora);
    final resumo = _calculadora.calcularPeriodo(dias, jornada,
        agora: agora, bancoHoras: banco, inicioAcompanhamento: acompanhamento);
    return PeriodoConsultado(dias: dias, resumo: resumo, jornada: jornada);
  }

  /// Primeiro dia que conta para saldo, banco e pendências (RN-15): o início do banco
  /// definido na jornada ou, sem ele, o primeiro dia registrado. Sem registro nenhum, hoje —
  /// quem acabou de instalar o app não tem um mês inteiro de débito para trás.
  Future<DateTime> inicioAcompanhamento({ConfiguracaoJornada? jornada, DateTime? agora}) async {
    final configuracao = jornada ?? await _jornadas.buscarAtiva();
    return configuracao.dataInicioBanco ??
        await _dias.primeiraDataRegistrada() ??
        (agora ?? _relogio.agora()).apenasData;
  }

  /// Banco de horas acumulado até [data], inclusive (RN-15).
  Future<Duration> bancoAte(DateTime data,
      {ConfiguracaoJornada? jornada, DateTime? agora}) async {
    final instante = agora ?? _relogio.agora();
    final configuracao = jornada ?? await _jornadas.buscarAtiva();
    final inicio = await inicioAcompanhamento(jornada: configuracao, agora: instante);
    if (inicio.depoisDe(data)) return Duration.zero;
    // Dias futuros não somam; não há por que carregá-los.
    final limite = data.depoisDe(instante) ? instante.apenasData : data;
    final dias = await _dias.buscarIntervalo(inicio, limite);
    return _calculadora.bancoAcumulado(dias, configuracao, ate: data, agora: instante);
  }
}
