import '../../core/extensoes/data_extensoes.dart';
import '../entidades/configuracao_jornada.dart';
import '../entidades/dia_trabalho.dart';
import '../entidades/marcacao.dart';
import '../entidades/resumo_periodo.dart';
import '../entidades/turno.dart';
import '../enums/enums.dart';
import 'gerador_pendencias.dart';

/// Único lugar do sistema onde se calculam horas (docs/12 e regra 2 do CLAUDE.md).
///
/// Todas as funções são puras: `agora` é sempre um parâmetro, nunca lido do relógio. Quando
/// `agora` é nulo, nenhum dia é tratado como "hoje".
abstract interface class CalculadoraPonto {
  /// RN-01 a RN-14 (docs/12, seção 12.3). Produz os campos persistidos do dia.
  DiaTrabalho calcularDia(DiaTrabalho dia, ConfiguracaoJornada jornada, {DateTime? agora});

  /// Reaplica RN-02 a um dia já gravado: o dia "em andamento" de ontem é inconsistente hoje.
  /// Não mexe na carga prevista nem no saldo gravados (RN-29).
  DiaTrabalho reavaliarConsistencia(DiaTrabalho dia, ConfiguracaoJornada jornada,
      {DateTime? agora});

  /// RN-06: quantidade par de marcações resulta em entrada; ímpar, em saída.
  TipoMarcacao proximoTipo(DiaTrabalho dia);

  /// Dia corrente com a última marcação sendo uma entrada (RN-02).
  bool emAndamento(DiaTrabalho dia, {DateTime? agora});

  /// Tempo desde a última entrada aberta; zero fora de andamento (docs/12, seção 12.2).
  Duration minutosEmCurso(DiaTrabalho dia, {DateTime? agora});

  /// Trabalhado somando o turno em curso. Valor vivo, nunca persistido.
  Duration trabalhadoAgora(DiaTrabalho dia, {DateTime? agora});

  /// Saldo calculado sobre [trabalhadoAgora]. Valor vivo, nunca persistido.
  Duration saldoAgora(DiaTrabalho dia, ConfiguracaoJornada jornada, {DateTime? agora});

  /// RN-16: hora da última entrada mais o que falta da carga; nulo fora de andamento.
  Duration? previsaoSaida(DiaTrabalho dia, ConfiguracaoJornada jornada, {DateTime? agora});

  /// Pares de marcações na ordem derivada (RN-07, RN-08).
  List<Turno> turnos(DiaTrabalho dia, ConfiguracaoJornada jornada);

  /// Intervalos entre turnos consecutivos (RN-09).
  List<Intervalo> intervalos(DiaTrabalho dia, ConfiguracaoJornada jornada);

  /// RF-05: carga de um dia da semana derivada dos turnos previstos.
  Duration cargaDosTurnos(List<TurnoPrevisto> turnos, {required bool permiteViradaDia});

  /// RF-07: carga total da semana configurada.
  Duration cargaSemanal(ConfiguracaoJornada jornada);

  /// RN-15: soma dos saldos desde o início do banco até [ate], inclusive. Usa o saldo vivo
  /// para o dia corrente e ignora dias futuros.
  Duration bancoAcumulado(List<DiaTrabalho> dias, ConfiguracaoJornada jornada,
      {required DateTime ate, DateTime? agora});

  /// RN-15 para um único dia: o banco até a véspera somado ao saldo de [dia], vivo quando
  /// ele é hoje. É o que deixa o banco da tela do Dia subir junto com o relógio. Um dia
  /// anterior a [inicioAcompanhamento] não soma nada.
  Duration bancoComDia(Duration bancoAteVespera, DiaTrabalho dia, ConfiguracaoJornada jornada,
      {DateTime? agora, DateTime? inicioAcompanhamento});

  /// Totais de um período (docs/12, seção 12.3). [bancoHoras] vem de [bancoAcumulado]. Dias
  /// futuros e dias anteriores a [inicioAcompanhamento] não somam trabalho nem saldo e não
  /// geram pendência.
  ResumoPeriodo calcularPeriodo(List<DiaTrabalho> dias, ConfiguracaoJornada jornada,
      {DateTime? agora, Duration bancoHoras, DateTime? inicioAcompanhamento});
}

class CalculadoraPontoPadrao implements CalculadoraPonto {
  static const _umDia = Duration(days: 1);

  final GeradorPendencias _pendencias;

  const CalculadoraPontoPadrao({GeradorPendencias pendencias = const GeradorPendencias()})
      : _pendencias = pendencias;

  @override
  DiaTrabalho calcularDia(DiaTrabalho dia, ConfiguracaoJornada jornada, {DateTime? agora}) {
    // 1. Carga prevista (RN-10).
    final jornadaDoDia = jornada.paraData(dia.data);
    final carga = jornadaDoDia.trabalha ? jornadaDoDia.carga : Duration.zero;

    // 2. Ordenação e tipagem (RN-01), e 4. turnos (RN-07, RN-08).
    final analise = _analisar(dia.marcacoes, jornada.permiteViradaDia);

    // 3. Consistência (RN-02).
    final inconsistente = _inconsistente(dia.data, analise, agora);

    // 5 e 6. Saldo (RN-11 a RN-13) e tolerância (RN-14).
    final saldo = _saldo(dia.status, analise.trabalhado, carga, jornada.tolerancia);

    return dia.copiaCom(
      marcacoes: analise.marcacoes,
      cargaPrevista: carga,
      minutosTrabalhados: analise.trabalhado,
      saldo: saldo,
      inconsistente: inconsistente,
    );
  }

  @override
  DiaTrabalho reavaliarConsistencia(DiaTrabalho dia, ConfiguracaoJornada jornada,
      {DateTime? agora}) {
    final analise = _analisar(dia.marcacoes, jornada.permiteViradaDia);
    return dia.copiaCom(
      marcacoes: analise.marcacoes,
      inconsistente: _inconsistente(dia.data, analise, agora),
    );
  }

  @override
  TipoMarcacao proximoTipo(DiaTrabalho dia) =>
      dia.marcacoes.length.isEven ? TipoMarcacao.entrada : TipoMarcacao.saida;

  @override
  bool emAndamento(DiaTrabalho dia, {DateTime? agora}) =>
      _emAndamento(dia.data, dia.marcacoes.length, agora);

  @override
  Duration minutosEmCurso(DiaTrabalho dia, {DateTime? agora}) {
    if (agora == null || !emAndamento(dia, agora: agora)) return Duration.zero;
    var decorrido = agora.horaDoDia - dia.marcacoes.last.hora;
    if (decorrido.isNegative) decorrido += _umDia;
    return decorrido;
  }

  @override
  Duration trabalhadoAgora(DiaTrabalho dia, {DateTime? agora}) =>
      dia.minutosTrabalhados + minutosEmCurso(dia, agora: agora);

  @override
  Duration saldoAgora(DiaTrabalho dia, ConfiguracaoJornada jornada, {DateTime? agora}) =>
      _saldo(dia.status, trabalhadoAgora(dia, agora: agora), dia.cargaPrevista,
          jornada.tolerancia);

  @override
  Duration? previsaoSaida(DiaTrabalho dia, ConfiguracaoJornada jornada, {DateTime? agora}) {
    if (!emAndamento(dia, agora: agora)) return null;
    final ultimaEntrada = dia.marcacoes.last.hora;
    var faltando = dia.cargaPrevista - dia.minutosTrabalhados;
    if (faltando.isNegative) faltando = Duration.zero;
    return ultimaEntrada + faltando;
  }

  @override
  List<Turno> turnos(DiaTrabalho dia, ConfiguracaoJornada jornada) =>
      _analisar(dia.marcacoes, jornada.permiteViradaDia).turnos;

  /// Cada saída seguida de uma entrada abre um intervalo, mesmo que o par seguinte ainda
  /// não tenha saída: no meio do expediente, o almoço já aconteceu.
  @override
  List<Intervalo> intervalos(DiaTrabalho dia, ConfiguracaoJornada jornada) {
    final sequencia = _analisar(dia.marcacoes, jornada.permiteViradaDia).marcacoes;
    return [
      for (var i = 1; i + 1 < sequencia.length; i += 2)
        Intervalo(
          inicio: sequencia[i].hora,
          fim: sequencia[i + 1].hora,
          duracao: _duracaoCircular(sequencia[i].hora, sequencia[i + 1].hora),
        ),
    ];
  }

  @override
  Duration cargaDosTurnos(List<TurnoPrevisto> turnos, {required bool permiteViradaDia}) {
    var total = Duration.zero;
    for (final turno in turnos) {
      if (turno.saida > turno.entrada) {
        total += turno.saida - turno.entrada;
      } else if (permiteViradaDia && turno.saida < turno.entrada) {
        total += turno.saida + _umDia - turno.entrada;
      }
    }
    return total;
  }

  @override
  Duration cargaSemanal(ConfiguracaoJornada jornada) => [
        for (var d = 1; d <= 7; d++) jornada.paraDiaSemana(d),
      ].where((d) => d.trabalha).fold(Duration.zero, (total, d) => total + d.carga);

  @override
  Duration bancoAcumulado(List<DiaTrabalho> dias, ConfiguracaoJornada jornada,
      {required DateTime ate, DateTime? agora}) {
    final inicio = jornada.dataInicioBanco;
    var total = Duration.zero;
    for (final dia in dias) {
      if (inicio != null && dia.data.antesDe(inicio)) continue;
      if (dia.data.depoisDe(ate)) continue;
      if (agora != null && dia.data.depoisDe(agora)) continue;
      total += _ehHoje(dia.data, agora) ? saldoAgora(dia, jornada, agora: agora) : dia.saldo;
    }
    return total;
  }

  @override
  Duration bancoComDia(Duration bancoAteVespera, DiaTrabalho dia, ConfiguracaoJornada jornada,
      {DateTime? agora, DateTime? inicioAcompanhamento}) {
    if (inicioAcompanhamento != null && dia.data.antesDe(inicioAcompanhamento)) {
      return bancoAteVespera;
    }
    return bancoAteVespera + bancoAcumulado([dia], jornada, ate: dia.data, agora: agora);
  }

  @override
  ResumoPeriodo calcularPeriodo(List<DiaTrabalho> dias, ConfiguracaoJornada jornada,
      {DateTime? agora,
      Duration bancoHoras = Duration.zero,
      DateTime? inicioAcompanhamento}) {
    var trabalhado = Duration.zero;
    var carga = Duration.zero;
    var saldo = Duration.zero;
    var diasUteis = 0;
    var diasTrabalhados = 0;
    final acompanhados = <DiaTrabalho>[];

    for (final dia in dias) {
      carga += dia.cargaPrevista;
      if (dia.cargaPrevista > Duration.zero) diasUteis++;
      // Dias futuros ainda não aconteceram, e dias antes do início do acompanhamento nunca
      // foram registrados no app: nenhum dos dois soma trabalho nem saldo.
      if (agora != null && dia.data.depoisDe(agora)) continue;
      if (inicioAcompanhamento != null && dia.data.antesDe(inicioAcompanhamento)) continue;
      acompanhados.add(dia);
      if (_ehHoje(dia.data, agora)) {
        trabalhado += trabalhadoAgora(dia, agora: agora);
        saldo += saldoAgora(dia, jornada, agora: agora);
      } else {
        trabalhado += dia.minutosTrabalhados;
        saldo += dia.saldo;
      }
      if (dia.minutosTrabalhados > Duration.zero) diasTrabalhados++;
    }

    return ResumoPeriodo(
      trabalhado: trabalhado,
      cargaPrevista: carga,
      saldo: saldo,
      bancoHoras: bancoHoras,
      diasUteis: diasUteis,
      diasTrabalhados: diasTrabalhados,
      pendencias: _pendencias.levantar(acompanhados, agora: agora),
    );
  }

  // ── Regras internas ────────────────────────────────────────────────────────────────────

  /// RN-01 e RN-08. Ordena por horário e, só com a virada de dia ligada, começa a sequência
  /// logo depois do maior intervalo entre horários consecutivos — é o que permite a um
  /// turno começar à noite e terminar depois da meia-noite.
  _Analise _analisar(List<Marcacao> marcacoes, bool permiteViradaDia) {
    final ordenadas = [...marcacoes]..sort((a, b) => a.hora.compareTo(b.hora));
    final sequencia = permiteViradaDia ? _rotacionarAposMaiorIntervalo(ordenadas) : ordenadas;

    final tipadas = [
      for (var i = 0; i < sequencia.length; i++)
        sequencia[i].copiaCom(
          ordem: i + 1,
          tipo: i.isEven ? TipoMarcacao.entrada : TipoMarcacao.saida,
        ),
    ];

    final turnos = <Turno>[];
    var trabalhado = Duration.zero;
    var parInvalido = false;
    for (var i = 0; i + 1 < tipadas.length; i += 2) {
      final entrada = tipadas[i].hora;
      final saida = tipadas[i + 1].hora;
      if (saida > entrada) {
        turnos.add(Turno(entrada: entrada, saida: saida, duracao: saida - entrada));
        trabalhado += saida - entrada;
      } else if (permiteViradaDia) {
        final duracao = saida + _umDia - entrada;
        turnos.add(Turno(entrada: entrada, saida: saida, duracao: duracao));
        trabalhado += duracao;
      } else {
        parInvalido = true;
        turnos.add(Turno(entrada: entrada, saida: saida, duracao: Duration.zero, valido: false));
      }
    }

    return _Analise(tipadas, turnos, trabalhado, parInvalido);
  }

  List<Marcacao> _rotacionarAposMaiorIntervalo(List<Marcacao> ordenadas) {
    if (ordenadas.length < 2) return ordenadas;
    // O intervalo que atravessa a meia-noite vence os empates: sem evidência de virada,
    // a ordem crescente é mantida.
    var maior = ordenadas.first.hora + _umDia - ordenadas.last.hora;
    var inicio = 0;
    for (var i = 0; i < ordenadas.length - 1; i++) {
      final intervalo = ordenadas[i + 1].hora - ordenadas[i].hora;
      if (intervalo > maior) {
        maior = intervalo;
        inicio = i + 1;
      }
    }
    return [...ordenadas.sublist(inicio), ...ordenadas.sublist(0, inicio)];
  }

  bool _inconsistente(DateTime data, _Analise analise, DateTime? agora) {
    final quantidade = analise.marcacoes.length;
    final impar = quantidade.isOdd && !_emAndamento(data, quantidade, agora);
    return impar || analise.parInvalido;
  }

  bool _emAndamento(DateTime data, int quantidadeMarcacoes, DateTime? agora) =>
      quantidadeMarcacoes.isOdd && _ehHoje(data, agora);

  bool _ehHoje(DateTime data, DateTime? agora) => agora != null && data.mesmoDia(agora);

  Duration _saldo(StatusDia status, Duration trabalhado, Duration carga, Duration tolerancia) {
    final bruto = switch (status) {
      StatusDia.folga ||
      StatusDia.feriado ||
      StatusDia.ferias ||
      StatusDia.atestado ||
      StatusDia.abono =>
        trabalhado, // RN-12: carga abonada
      StatusDia.falta => -carga, // RN-13
      StatusDia.normal || StatusDia.compensacao => trabalhado - carga, // RN-11
    };
    return bruto.abs() <= tolerancia ? Duration.zero : bruto; // RN-14
  }

  Duration _duracaoCircular(Duration inicio, Duration fim) =>
      fim >= inicio ? fim - inicio : fim + _umDia - inicio;
}

class _Analise {
  final List<Marcacao> marcacoes;
  final List<Turno> turnos;
  final Duration trabalhado;
  final bool parInvalido;

  const _Analise(this.marcacoes, this.turnos, this.trabalhado, this.parInvalido);
}
