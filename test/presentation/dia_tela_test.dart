import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_pj/app/providers.dart';
import 'package:ponto_pj/app/tema.dart';
import 'package:ponto_pj/core/extensoes/data_extensoes.dart';
import 'package:ponto_pj/core/relogio.dart';
import 'package:ponto_pj/core/resultado.dart';
import 'package:ponto_pj/data/local/banco_local.dart';
import 'package:ponto_pj/data/repositorios/dia_repositorio_drift.dart';
import 'package:ponto_pj/data/repositorios/jornada_repositorio_drift.dart';
import 'package:ponto_pj/domain/entidades/competencia.dart';
import 'package:ponto_pj/domain/entidades/dia_trabalho.dart';
import 'package:ponto_pj/domain/enums/enums.dart';
import 'package:ponto_pj/domain/repositorios/repositorios.dart';
import 'package:ponto_pj/domain/servicos/calculadora_ponto.dart';
import 'package:ponto_pj/presentation/dia/dia_tela.dart';

import '../helpers/banco_teste.dart';
import '../helpers/construtores.dart';

/// TL-06 (docs/14, seção 14.2): estado vazio, linha do tempo, inconsistência e o toque
/// único de bater o ponto.
void main() {
  final agora = DateTime(2026, 5, 7, 10);
  final ontem = dataCivil(2026, 5, 6);
  late BancoLocal banco;

  setUp(() => banco = abrirBancoDeTeste());
  tearDown(() => banco.close());

  Future<_DiaRepositorioEspiao> montar(WidgetTester tester,
      {DateTime? data, List<String> marcacoes = const []}) async {
    final fixo = RelogioFixo(agora);
    final real = DiaRepositorioDrift(banco,
        jornadas: JornadaRepositorioDrift(banco),
        calculadora: const CalculadoraPontoPadrao(),
        relogio: fixo);
    for (final hora in marcacoes) {
      await real.adicionarMarcacao(data ?? agora.apenasData, h(hora), OrigemMarcacao.manual);
    }
    final espiao = _DiaRepositorioEspiao(real);

    await tester.pumpWidget(ProviderScope(
      overrides: [
        bancoLocalProvider.overrideWithValue(banco),
        relogioProvider.overrideWithValue(fixo),
        pulsoProvider.overrideWith((ref) => Stream.value(agora)),
        diaRepositorioProvider.overrideWithValue(espiao),
      ],
      child: MaterialApp(theme: temaClaro(), home: DiaTela(data: data)),
    ));
    await tester.pumpAndSettle();
    return espiao;
  }

  testWidgets('estado vazio convida a marcar a entrada', (tester) async {
    await montar(tester);
    expect(find.text('Nenhuma marcação hoje.'), findsOneWidget);
    expect(find.text('Marcar entrada'), findsOneWidget);
    expect(find.text('- 08h 00m'), findsWidgets);
  });

  testWidgets('linha do tempo com dois turnos e o intervalo', (tester) async {
    await montar(tester, data: ontem, marcacoes: ['08:00', '12:00', '13:00', '17:30']);
    expect(find.text('Turno de 04h 00m'), findsOneWidget);
    expect(find.text('Turno de 04h 30m'), findsOneWidget);
    expect(find.text('Intervalo de 01h 00m'), findsOneWidget);
    expect(find.text('+ 00h 30m'), findsWidgets);
    expect(find.bySemanticsLabel('Entrada às 08:00, manual'), findsOneWidget);
  });

  testWidgets('dia inconsistente é sinalizado', (tester) async {
    await montar(tester, data: ontem, marcacoes: ['08:00', '12:00', '13:00']);
    expect(find.text('Faltou uma saída neste dia.'), findsOneWidget);
    expect(find.text('04h 00m'), findsWidgets);
  });

  testWidgets('em andamento mostra o turno em curso e a previsão de saída', (tester) async {
    await montar(tester, marcacoes: ['08:00']);
    expect(find.text('Em curso: 02h 00m'), findsOneWidget);
    expect(find.text('16:00'), findsOneWidget);
    expect(find.text('Previsão de saída'), findsOneWidget);
    expect(find.text('Marcar saída'), findsOneWidget);
  });

  testWidgets('bater o ponto chama o repositório uma única vez', (tester) async {
    final espiao = await montar(tester);
    await tester.tap(find.text('Marcar entrada'));
    await tester.pumpAndSettle();
    expect(espiao.adicoes, 1);
    expect(find.text('Entrada registrada às 10:00.'), findsOneWidget);
    expect(find.text('Marcar saída'), findsOneWidget);
  });
}

/// Repositório real que conta quantas marcações foram pedidas.
class _DiaRepositorioEspiao implements DiaRepositorio {
  final DiaRepositorio _real;
  var adicoes = 0;

  _DiaRepositorioEspiao(this._real);

  @override
  Future<Resultado<DiaTrabalho>> adicionarMarcacao(
      DateTime data, Duration hora, OrigemMarcacao origem) {
    adicoes++;
    return _real.adicionarMarcacao(data, hora, origem);
  }

  @override
  Future<DiaTrabalho> buscarPorData(DateTime data) => _real.buscarPorData(data);

  @override
  Future<List<DiaTrabalho>> buscarIntervalo(DateTime inicio, DateTime fim) =>
      _real.buscarIntervalo(inicio, fim);

  @override
  Future<List<DiaTrabalho>> buscarCompetencia(Competencia competencia) =>
      _real.buscarCompetencia(competencia);

  @override
  Future<DateTime?> primeiraDataRegistrada() => _real.primeiraDataRegistrada();

  @override
  Future<bool> existeRegistroEntre(DateTime inicio, DateTime fim) =>
      _real.existeRegistroEntre(inicio, fim);

  @override
  Future<Resultado<DiaTrabalho>> editarMarcacao(int marcacaoId, Duration novaHora) =>
      _real.editarMarcacao(marcacaoId, novaHora);

  @override
  Future<Resultado<DiaTrabalho>> excluirMarcacao(int marcacaoId) =>
      _real.excluirMarcacao(marcacaoId);

  @override
  Future<Resultado<DiaTrabalho>> definirStatus(
          DateTime data, StatusDia status, String? observacao) =>
      _real.definirStatus(data, status, observacao);

  @override
  Future<Resultado<int>> recalcularAPartirDe(DateTime data) => _real.recalcularAPartirDe(data);
}
