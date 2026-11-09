import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_pj/core/extensoes/data_extensoes.dart';
import 'package:ponto_pj/core/falhas.dart';
import 'package:ponto_pj/data/local/banco_local.dart';
import 'package:ponto_pj/data/repositorios/configuracao_repositorios_drift.dart';
import 'package:ponto_pj/data/repositorios/dia_repositorio_drift.dart';
import 'package:ponto_pj/data/repositorios/envio_repositorio_drift.dart';
import 'package:ponto_pj/data/repositorios/jornada_repositorio_drift.dart';
import 'package:ponto_pj/data/repositorios/modelo_planilha_repositorio_drift.dart';
import 'package:ponto_pj/domain/entidades/configuracao_email.dart';
import 'package:ponto_pj/domain/entidades/configuracao_jornada.dart';
import 'package:ponto_pj/domain/entidades/envio_mensal.dart';
import 'package:ponto_pj/domain/entidades/modelo_planilha.dart';
import 'package:ponto_pj/domain/entidades/perfil_usuario.dart';
import 'package:ponto_pj/domain/enums/enums.dart';
import 'package:ponto_pj/domain/servicos/calculadora_ponto.dart';
import 'package:ponto_pj/domain/servicos/consulta_periodo.dart';

import '../helpers/banco_teste.dart';
import '../helpers/construtores.dart';
import '../helpers/relogio_ajustavel.dart';

void main() {
  late BancoLocal banco;
  late RelogioAjustavel relogio;
  late JornadaRepositorioDrift jornadas;
  late DiaRepositorioDrift dias;

  final ontem = dataCivil(2026, 5, 6);

  setUp(() {
    banco = abrirBancoDeTeste();
    relogio = RelogioAjustavel(DateTime(2026, 5, 7, 18));
    jornadas = JornadaRepositorioDrift(banco);
    dias = DiaRepositorioDrift(banco,
        jornadas: jornadas, calculadora: const CalculadoraPontoPadrao(), relogio: relogio);
  });

  tearDown(() => banco.close());

  Future<void> marcar(DateTime data, List<String> horas) async {
    for (final hora in horas) {
      final resultado = await dias.adicionarMarcacao(data, h(hora), OrigemMarcacao.manual);
      expect(resultado.falhaOuNula, isNull, reason: 'marcação $hora');
    }
  }

  group('dados iniciais (docs/06, seção 6.7)', () {
    test('jornada padrão: segunda a sexta com 8 h em dois turnos', () async {
      final jornada = await jornadas.buscarAtiva();
      expect(jornada.nome, 'Jornada padrão');
      expect(jornada.tolerancia, Duration.zero);
      expect(jornada.permiteViradaDia, isFalse);
      expect(jornada.dias.map((d) => d.trabalha), [true, true, true, true, true, false, false]);
      final quinta = jornada.paraDiaSemana(4);
      expect(quinta.carga, min(480));
      expect(quinta.turnos.map((t) => (t.entrada, t.saida)),
          [(h('08:00'), h('12:00')), (h('13:00'), h('17:00'))]);
    });

    test('e-mail com os textos padrão e sem destinatário', () async {
      final email = await ConfiguracaoEmailRepositorioDrift(banco).buscar();
      expect(email.assuntoModelo, ConfiguracaoEmail.assuntoPadrao);
      expect(email.templateNomeArquivo, ConfiguracaoEmail.nomeArquivoPadrao);
      expect(email.temDestinatario, isFalse);
    });

    test('sem perfil, tema do sistema e onboarding pendente', () async {
      expect(await PerfilRepositorioDrift(banco, relogio: relogio).buscar(), isNull);
      final preferencias = PreferenciasRepositorioDrift(banco);
      expect(await preferencias.tema(), 'sistema');
      expect(await preferencias.onboardingConcluido(), isFalse);
      await preferencias.marcarOnboardingConcluido();
      expect(await preferencias.onboardingConcluido(), isTrue);
    });

    test('uma configuração de notificação por tipo; fechamento no último dia às 19:00', () async {
      final linhas = await banco.select(banco.configuracoesNotificacao).get();
      expect(linhas, hasLength(TipoNotificacao.values.length));
      final fechamento = linhas.singleWhere((l) => l.tipo == TipoNotificacao.fechamentoMes);
      expect((fechamento.diaReferencia, fechamento.hora, fechamento.ativa), (-1, 1140, false));
    });
  });

  group('DiaRepositorio', () {
    test('adicionar marcação recalcula e persiste os campos derivados', () async {
      await marcar(ontem, ['08:00', '12:00', '13:00', '17:30']);
      final linha = await (banco.select(banco.diasTrabalho)
            ..where((t) => t.data.equalsValue(ontem)))
          .getSingle();
      expect(linha.minutosTrabalhados, 510);
      expect(linha.saldoMinutos, 30);
      expect(linha.cargaPrevistaMinutos, 480);
      expect(linha.inconsistente, isFalse);
    });

    test('marcação fora de ordem é reordenada e retipada (RN-01)', () async {
      await marcar(ontem, ['13:00', '08:00']);
      final dia = await dias.buscarPorData(ontem);
      expect(dia.marcacoes.map((m) => (m.hora, m.tipo, m.ordem)), [
        (h('08:00'), TipoMarcacao.entrada, 1),
        (h('13:00'), TipoMarcacao.saida, 2),
      ]);
    });

    test('RN-04: horário repetido é recusado com a mensagem da regra', () async {
      await marcar(ontem, ['08:00']);
      final resultado = await dias.adicionarMarcacao(ontem, h('08:00'), OrigemMarcacao.manual);
      expect(resultado.falhaOuNula, isA<FalhaValidacao>());
      expect(resultado.falhaOuNula?.mensagem, 'Já existe uma marcação às 08:00 neste dia.');
    });

    test('RN-03: horário futuro é recusado e nada é gravado', () async {
      final hoje = relogio.agora().apenasData;
      final resultado = await dias.adicionarMarcacao(hoje, h('19:00'), OrigemMarcacao.manual);
      expect(resultado.falhaOuNula?.mensagem,
          'Não dá para registrar um horário que ainda não aconteceu.');
      expect(await banco.select(banco.diasTrabalho).get(), isEmpty);
    });

    test('excluir reordena as restantes e recalcula os tipos (RN-05)', () async {
      await marcar(ontem, ['08:00', '12:00', '13:00', '17:00']);
      final antes = await dias.buscarPorData(ontem);
      final doze = antes.marcacoes.firstWhere((m) => m.hora == h('12:00'));
      final depois = (await dias.excluirMarcacao(doze.id!)).valorOuNulo!;
      expect(depois.marcacoes.map((m) => (m.hora, m.tipo)), [
        (h('08:00'), TipoMarcacao.entrada),
        (h('13:00'), TipoMarcacao.saida),
        (h('17:00'), TipoMarcacao.entrada),
      ]);
      expect(depois.inconsistente, isTrue);
      expect(depois.minutosTrabalhados, min(300));
    });

    test('excluir a última marcação de um dia sem status remove o registro', () async {
      await marcar(ontem, ['08:00']);
      final unica = (await dias.buscarPorData(ontem)).marcacoes.single;
      final resultado = (await dias.excluirMarcacao(unica.id!)).valorOuNulo!;
      expect(resultado.persistido, isFalse);
      expect(resultado.saldo, min(-480));
      expect(await dias.primeiraDataRegistrada(), isNull);
    });

    test('editar marca a marcação como editada e reordena', () async {
      await marcar(ontem, ['08:00', '12:00']);
      final oito = (await dias.buscarPorData(ontem)).marcacoes.first;
      final dia = (await dias.editarMarcacao(oito.id!, h('13:00'))).valorOuNulo!;
      expect(dia.marcacoes.map((m) => m.hora), [h('12:00'), h('13:00')]);
      expect(dia.marcacoes.last.editada, isTrue);
      expect(dia.minutosTrabalhados, min(60));
    });

    test('status e observação recalculam o saldo (RN-13)', () async {
      final dia = (await dias.definirStatus(ontem, StatusDia.falta, '  Consulta  ')).valorOuNulo!;
      expect(dia.saldo, min(-480));
      expect(dia.observacao, 'Consulta');
      expect(dia.statusManual, isTrue);
      final folga = (await dias.definirStatus(ontem, StatusDia.folga, null)).valorOuNulo!;
      expect(folga.saldo, Duration.zero);
      expect(folga.observacao, isNull);
    });

    test('data sem registro devolve um dia vazio com a carga aplicada', () async {
      final dia = await dias.buscarPorData(ontem);
      expect(dia.persistido, isFalse);
      expect(dia.cargaPrevista, min(480));
      expect(dia.saldo, min(-480));
      expect((await dias.buscarPorData(dataCivil(2026, 5, 9))).cargaPrevista, Duration.zero);
    });

    test('intervalo devolve todos os dias, gravados ou não', () async {
      await marcar(ontem, ['08:00', '12:00']);
      final lista = await dias.buscarIntervalo(dataCivil(2026, 5, 4), dataCivil(2026, 5, 10));
      expect(lista.map((d) => d.data.day), [4, 5, 6, 7, 8, 9, 10]);
      expect(lista[2].minutosTrabalhados, min(240));
      expect(lista.where((d) => d.persistido), hasLength(1));
    });

    test('o dia em andamento ontem aparece inconsistente hoje', () async {
      relogio.instante = DateTime(2026, 5, 7, 9);
      await marcar(dataCivil(2026, 5, 7), ['08:00']);
      expect((await dias.buscarPorData(dataCivil(2026, 5, 7))).inconsistente, isFalse);
      relogio.instante = DateTime(2026, 5, 8, 9);
      expect((await dias.buscarPorData(dataCivil(2026, 5, 7))).inconsistente, isTrue);
    });

    test('excluir um dia apaga as marcações em cascata', () async {
      await marcar(ontem, ['08:00', '12:00']);
      await banco.delete(banco.diasTrabalho).go();
      expect(await banco.select(banco.marcacoes).get(), isEmpty);
    });

    test('primeira data registrada e existência de registro', () async {
      await marcar(dataCivil(2026, 5, 5), ['08:00', '12:00']);
      await marcar(ontem, ['08:00', '12:00']);
      expect(await dias.primeiraDataRegistrada(), dataCivil(2026, 5, 5));
      expect(await dias.existeRegistroEntre(dataCivil(2026, 5, 1), dataCivil(2026, 5, 5)), isTrue);
      expect(await dias.existeRegistroEntre(dataCivil(2026, 4, 1), dataCivil(2026, 4, 30)), isFalse);
    });

    test('mudança de jornada recalcula os dias abertos a partir da data (RN-29)', () async {
      await marcar(ontem, ['08:00', '12:00', '13:00', '17:00']);
      final jornada = await jornadas.buscarAtiva();
      final quarta = jornada.paraDiaSemana(3).copiaCom(carga: min(360), cargaManual: true);
      await jornadas.salvar(jornada.comDia(quarta));
      expect((await dias.buscarPorData(ontem)).saldo, Duration.zero, reason: 'não retroage');
      final recalculados = (await dias.recalcularAPartirDe(ontem)).valorOuNulo;
      expect(recalculados, 1);
      expect((await dias.buscarPorData(ontem)).saldo, min(120));
    });
  });

  test('jornada: salvar e reler preserva tolerância, virada, início do banco e turnos', () async {
    final jornada = await jornadas.buscarAtiva();
    final sabado = jornada.paraDiaSemana(6).copiaCom(
      trabalha: true,
      carga: min(240),
      turnos: [TurnoPrevisto(ordem: 1, entrada: h('08:00'), saida: h('12:00'))],
    );
    await jornadas.salvar(jornada.comDia(sabado).copiaCom(
          tolerancia: min(5),
          permiteViradaDia: true,
          dataInicioBanco: dataCivil(2026, 5, 1),
        ));
    final relida = await jornadas.buscarAtiva();
    expect(relida.tolerancia, min(5));
    expect(relida.permiteViradaDia, isTrue);
    expect(relida.dataInicioBanco, dataCivil(2026, 5, 1));
    expect(relida.paraDiaSemana(6).trabalha, isTrue);
    expect(relida.paraDiaSemana(6).turnos.single.entrada, h('08:00'));
    expect(relida.paraDiaSemana(1).turnos, hasLength(2));
  });

  test('salvar modelo desativa o anterior na mesma transação (RN-17)', () async {
    final repositorio = ModeloPlanilhaRepositorioDrift(banco, relogio: relogio);
    ModeloPlanilha modelo(String nome) => ModeloPlanilha(
          nome: nome,
          caminhoArquivoBase: '/modelos/$nome.xlsx',
          nomeArquivoOriginal: '$nome.xlsx',
          hashArquivo: 'hash-$nome',
          nomeAba: 'Horas',
          linhaCabecalho: 6,
          primeiraLinhaDados: 7,
          ultimaLinhaDados: 37,
          formatoData: FormatoData.dataExcel,
          formatoHora: FormatoHora.horaExcel,
          diaInicioCompetencia: 26,
          colunas: {CampoColuna.data: 0, CampoColuna.entrada1: 3},
          rotulosCabecalho: {CampoColuna.data: 'DATA', CampoColuna.entrada1: 'ENT'},
          celulasFixas: const [
            CelulaFixa(campo: CampoCelulaFixa.nome, referencia: 'D3'),
            CelulaFixa(campo: CampoCelulaFixa.textoLivre, referencia: 'A40', valorLivre: 'Ok'),
          ],
          textosStatus: {StatusDia.folga: 'FOLGA', StatusDia.falta: ''},
        );

    await repositorio.salvar(modelo('primeiro'));
    final salvo = (await repositorio.salvar(modelo('segundo'))).valorOuNulo!;

    final ativos = await (banco.select(banco.modelosPlanilha)..where((t) => t.ativo.equals(true)))
        .get();
    expect(ativos.single.nome, 'segundo');
    expect(salvo.nome, 'segundo');
    expect(salvo.escreverComoTexto, isFalse);
    expect(salvo.diaInicioCompetencia, 26);
    expect(salvo.colunas, {CampoColuna.data: 0, CampoColuna.entrada1: 3});
    expect(salvo.rotulosCabecalho[CampoColuna.entrada1], 'ENT');
    expect(salvo.celulasFixas.last.valorLivre, 'Ok');
    expect(salvo.textosStatus, {StatusDia.folga: 'FOLGA'});
  });

  test('envio: registrar a geração e só marcar como enviado na confirmação', () async {
    final repositorio = EnvioRepositorioDrift(banco);
    final envio = (await repositorio.registrarGeracao(EnvioMensal(
      competenciaAno: 2026,
      competenciaMes: 5,
      status: StatusEnvio.gerado,
      geradoEm: DateTime(2026, 6, 1, 19, 4),
      caminhoArquivo: '/geradas/1/Ponto.xlsx',
      nomeArquivo: 'Ponto.xlsx',
      tamanhoBytes: 24000,
    )))
        .valorOuNulo!;
    expect((await repositorio.listarDaCompetencia(2026, 5)).single.status, StatusEnvio.gerado);
    await repositorio.confirmarEnvio(envio.id!, DateTime(2026, 6, 1, 19, 6));
    final confirmado = (await repositorio.listar()).single;
    expect(confirmado.status, StatusEnvio.enviado);
    expect(confirmado.enviadoEm, DateTime(2026, 6, 1, 19, 6));
  });

  test('perfil e e-mail: salvar e reler', () async {
    final perfis = PerfilRepositorioDrift(banco, relogio: relogio);
    await perfis.salvar(const PerfilUsuario(nome: ' Eduardo ', matricula: '485', cargo: ' '));
    final perfil = (await perfis.buscar())!;
    expect((perfil.nome, perfil.matricula, perfil.cargo), ('Eduardo', '485', null));

    final emails = ConfiguracaoEmailRepositorioDrift(banco);
    await emails.salvar((await emails.buscar())
        .copiaCom(destinatarios: ['rh@empresa.com.br', 'gestor@empresa.com.br']));
    expect((await emails.buscar()).destinatarios, ['rh@empresa.com.br', 'gestor@empresa.com.br']);
  });

  test('quem acabou de instalar não tem o mês anterior inteiro como débito', () async {
    relogio.instante = DateTime(2026, 6, 2, 9);
    final consulta = ConsultaPeriodo(
      dias: dias,
      jornadas: jornadas,
      calculadora: const CalculadoraPontoPadrao(),
      relogio: relogio,
    );
    final maio = await consulta.consultar(dataCivil(2026, 5, 1), dataCivil(2026, 5, 31));
    expect(maio.resumo.saldo, Duration.zero);
    expect(maio.resumo.pendencias, isEmpty);
    expect(maio.resumo.bancoHoras, Duration.zero);
    expect(maio.resumo.diasUteis, 21);
    expect(await consulta.inicioAcompanhamento(), dataCivil(2026, 6, 2));
  });

  test('consulta de período com banco de horas desde o primeiro registro (RN-15)', () async {
    relogio.instante = DateTime(2026, 5, 12, 12);
    await marcar(dataCivil(2026, 5, 4), ['08:00', '12:00', '13:00', '17:30']);
    await marcar(dataCivil(2026, 5, 6), ['08:00', '12:00', '13:00', '16:00']);
    final consulta = ConsultaPeriodo(
      dias: dias,
      jornadas: jornadas,
      calculadora: const CalculadoraPontoPadrao(),
      relogio: relogio,
    );
    final periodo = await consulta.consultar(dataCivil(2026, 5, 4), dataCivil(2026, 5, 10));
    // 04: +30 · 05: sem registro, −480 · 06: −60 · 07 e 08: sem registro, −480 cada.
    expect(periodo.resumo.saldo, min(30 - 480 - 60 - 480 - 480));
    expect(periodo.resumo.bancoHoras, periodo.resumo.saldo);
    expect(periodo.resumo.pendencias.map((p) => p.data.day), [5, 7, 8]);
  });
}
