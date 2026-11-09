import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_pj/app/providers.dart';
import 'package:ponto_pj/app/tema.dart';
import 'package:ponto_pj/core/extensoes/data_extensoes.dart';
import 'package:ponto_pj/core/relogio.dart';
import 'package:ponto_pj/core/resultado.dart';
import 'package:ponto_pj/data/local/banco_local.dart';
import 'package:ponto_pj/data/planilha/leitor_planilha_xml.dart';
import 'package:ponto_pj/data/repositorios/dia_repositorio_drift.dart';
import 'package:ponto_pj/data/repositorios/jornada_repositorio_drift.dart';
import 'package:ponto_pj/data/repositorios/modelo_planilha_repositorio_drift.dart';
import 'package:ponto_pj/domain/contratos/contratos.dart';
import 'package:ponto_pj/domain/entidades/modelo_planilha.dart';
import 'package:ponto_pj/domain/enums/enums.dart';
import 'package:ponto_pj/domain/servicos/calculadora_ponto.dart';
import 'package:ponto_pj/presentation/fechamento/fechamento_tela.dart';
import 'package:ponto_pj/presentation/planilha_wizard/wizard_controller.dart';
import 'package:ponto_pj/presentation/planilha_wizard/wizard_tela.dart';

import '../fixtures/modelo_exemplo.dart';
import '../helpers/banco_teste.dart';
import '../helpers/construtores.dart';

void main() {
  late BancoLocal banco;

  setUp(() => banco = abrirBancoDeTeste());
  tearDown(() => banco.close());

  group('TL-18 wizard, passo 3', () {
    Future<void> montar(WidgetTester tester) async {
      final estrutura = LeitorPlanilhaXml.lerEstrutura(ModeloExemplo.bytes());
      final estado = WizardEstado(
        passo: 2,
        nomeArquivo: 'ponto.xlsx',
        bytes: ModeloExemplo.bytes(),
        estrutura: estrutura,
        nomeAba: ModeloExemplo.aba,
        linhaCabecalho: 5,
        primeiraLinhaDados: 6,
        ultimaLinhaDados: 36,
      );
      await tester.pumpWidget(ProviderScope(
        overrides: [
          bancoLocalProvider.overrideWithValue(banco),
          wizardControllerProvider.overrideWith(() => _WizardFixo(estado)),
        ],
        child: MaterialApp(theme: temaClaro(), home: const WizardTela()),
      ));
      await tester.pumpAndSettle();
    }

    FilledButton continuar(WidgetTester tester) =>
        tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Continuar'));

    testWidgets('Continuar fica desabilitado sem a coluna de data, com a explicação',
        (tester) async {
      await montar(tester);
      expect(find.text('3 de 5'), findsOneWidget);
      expect(continuar(tester).onPressed, isNull);
      expect(
          find.text('Escolha a coluna da data para continuar. Sem ela o app não sabe onde '
              'escrever cada dia.'),
          findsOneWidget);
    });

    testWidgets('mapear a coluna de data habilita o Continuar', (tester) async {
      await montar(tester);
      await tester.tap(find.text('Data (obrigatória)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('A · DATA').last);
      await tester.pumpAndSettle();
      expect(continuar(tester).onPressed, isNotNull);
    });
  });

  group('TL-21 fechamento', () {
    final agora = DateTime(2026, 6, 2, 9);

    Future<void> montar(WidgetTester tester) async {
      final relogio = RelogioFixo(agora);
      final dias = DiaRepositorioDrift(banco,
          jornadas: JornadaRepositorioDrift(banco),
          calculadora: const CalculadoraPontoPadrao(),
          relogio: relogio);
      for (final hora in ['08:00', '12:00', '13:00']) {
        await dias.adicionarMarcacao(dataCivil(2026, 5, 5), h(hora), OrigemMarcacao.manual);
      }
      await ModeloPlanilhaRepositorioDrift(banco, relogio: relogio).salvar(ModeloPlanilha(
        nome: 'Ponto',
        caminhoArquivoBase: '/modelos/ponto.xlsx',
        nomeArquivoOriginal: 'ponto.xlsx',
        hashArquivo: 'x',
        nomeAba: ModeloExemplo.aba,
        linhaCabecalho: 5,
        primeiraLinhaDados: 6,
        ultimaLinhaDados: 36,
        colunas: const {CampoColuna.data: 0},
      ));

      await tester.pumpWidget(ProviderScope(
        overrides: [
          bancoLocalProvider.overrideWithValue(banco),
          relogioProvider.overrideWithValue(relogio),
          armazenamentoProvider.overrideWithValue(_ArmazenamentoComModelo()),
        ],
        child: MaterialApp(theme: temaClaro(), home: const FechamentoTela()),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('abre na competência que acabou de terminar e lista as pendências',
        (tester) async {
      await montar(tester);
      expect(find.text('Maio / 2026'), findsOneWidget);
      expect(find.text('Marcações incompletas'), findsOneWidget);
      expect(find.text('Dia útil sem registro'), findsWidgets);
    });

    testWidgets('gerar com pendências pede confirmação explícita (RN-19)', (tester) async {
      await montar(tester);
      await tester.scrollUntilVisible(find.text('Gerar planilha'), 200);
      await tester.tap(find.text('Gerar planilha'));
      await tester.pumpAndSettle();
      expect(find.text('Gerar com pendências?'), findsOneWidget);
      expect(find.textContaining('Quer gerar assim mesmo?'), findsOneWidget);
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(await banco.select(banco.enviosMensais).get(), isEmpty);
    });
  });
}

class _WizardFixo extends WizardController {
  final WizardEstado inicial;

  _WizardFixo(this.inicial);

  @override
  Future<WizardEstado> build() async => inicial;
}

/// Finge que a cópia do modelo está no aparelho; a geração em si é coberta nos testes do
/// escritor e do preenchedor.
class _ArmazenamentoComModelo implements ArmazenamentoArquivos {
  @override
  Future<bool> existe(String caminho) async => true;

  @override
  Future<Resultado<Uint8List>> lerBytes(String caminho) async => Sucesso(ModeloExemplo.bytes());

  @override
  String calcularHash(Uint8List bytes) => 'x';

  @override
  Future<Resultado<ArquivoImportado>> importarModelo(Uint8List bytes, String nomeOriginal) =>
      throw UnimplementedError();

  @override
  Future<Resultado<ArquivoGravado>> gravarGerado(String nomeArquivo, Uint8List bytes) =>
      throw UnimplementedError();

  @override
  Future<Resultado<void>> excluir(String caminho) => throw UnimplementedError();
}
