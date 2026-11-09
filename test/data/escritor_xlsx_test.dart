import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_pj/core/datas_excel.dart';
import 'package:ponto_pj/core/extensoes/data_extensoes.dart';
import 'package:ponto_pj/core/falhas.dart';
import 'package:ponto_pj/data/planilha/escritor_xlsx_zip.dart';
import 'package:ponto_pj/data/planilha/leitor_planilha_xml.dart';
import 'package:ponto_pj/domain/entidades/plano_de_escrita.dart';
import 'package:ponto_pj/domain/entidades/referencia_celula.dart';
import 'package:xml/xml.dart';

import '../fixtures/modelo_exemplo.dart';
import '../helpers/construtores.dart';

/// Os testes mais importantes do projeto (docs/14, seção 14.2): protegem contra a falha
/// silenciosa que só apareceria na caixa de entrada do RH.
void main() {
  final modelo = ModeloExemplo.bytes();

  Map<String, Uint8List> entradas(Uint8List bytes) => {
        for (final f in ZipDecoder().decodeBytes(bytes).files)
          if (f.isFile) f.name: Uint8List.fromList(f.content as List<int>),
      };

  XmlDocument xml(Uint8List bytes, String caminho) =>
      XmlDocument.parse(utf8.decode(entradas(bytes)[caminho]!));

  XmlElement celula(Uint8List bytes, String a1) => xml(bytes, 'xl/worksheets/sheet1.xml')
      .findAllElements('c')
      .firstWhere((c) => c.getAttribute('r') == a1);

  Uint8List aplicar(Map<String, ValorCelula> celulas, {List<String>? avisos}) {
    final resultado = EscritorXlsxZip.aplicarSincrono(
      modelo,
      PlanoDeEscrita(nomeAba: ModeloExemplo.aba, celulas: {
        for (final MapEntry(:key, :value) in celulas.entries) ReferenciaCelula.deA1(key)!: value,
      }),
    );
    avisos?.addAll(resultado.avisos);
    return resultado.bytes;
  }

  /// Um mês típico: datas nativas, horários nativos, nome e matrícula.
  Uint8List mesPreenchido({List<String>? avisos}) => aplicar({
        'B3': const TextoCelula('Eduardo Feltes'),
        'F3': const TextoCelula('485'),
        for (var dia = 1; dia <= 31; dia++) ...{
          'A${dia + 5}': DataCelula(dataCivil(2026, 5, dia)),
          'C${dia + 5}': HoraCelula(h('08:00')),
          'D${dia + 5}': HoraCelula(h('12:00')),
          'E${dia + 5}': HoraCelula(h('13:00')),
          'F${dia + 5}': HoraCelula(h('17:00')),
        },
      }, avisos: avisos);

  group('preservação', () {
    test('styles.xml é byte a byte idêntico ao original', () {
      expect(entradas(mesPreenchido())['xl/styles.xml'], entradas(modelo)['xl/styles.xml']);
    });

    test('sharedStrings.xml é byte a byte idêntico ao original', () {
      expect(entradas(mesPreenchido())['xl/sharedStrings.xml'],
          entradas(modelo)['xl/sharedStrings.xml']);
    });

    test('toda entrada que não é a aba alvo nem o recálculo continua idêntica', () {
      final antes = entradas(modelo);
      final depois = entradas(mesPreenchido());
      const podemMudar = {
        'xl/worksheets/sheet1.xml',
        'xl/workbook.xml',
        'xl/_rels/workbook.xml.rels',
        '[Content_Types].xml',
      };
      for (final nome in antes.keys) {
        if (podemMudar.contains(nome) || nome == 'xl/calcChain.xml') continue;
        expect(depois[nome], antes[nome], reason: nome);
      }
      expect(depois['xl/worksheets/sheet2.xml'], antes['xl/worksheets/sheet2.xml']);
    });

    test('mesclagens, colunas e margens continuam no XML da aba', () {
      final aba = xml(mesPreenchido(), 'xl/worksheets/sheet1.xml');
      expect(aba.findAllElements('mergeCell').single.getAttribute('ref'), 'A1:H2');
      expect(aba.findAllElements('col').single.getAttribute('width'), '12');
      expect(aba.findAllElements('pageMargins'), hasLength(1));
    });
  });

  group('escrita de células', () {
    test('texto vira inlineStr e o estilo original é preservado', () {
      final bytes = aplicar({'B9': const TextoCelula('seg')});
      final c = celula(bytes, 'B9');
      expect(c.getAttribute('t'), 'inlineStr');
      expect(c.getAttribute('s'), '${ModeloExemplo.estiloTexto}');
      expect(c.findElements('is').single.innerText, 'seg');
    });

    test('valor nativo fica sem t, com <v> numérico e o estilo preservado', () {
      final bytes = aplicar({
        'C9': HoraCelula(h('08:30')),
        'A9': DataCelula(dataCivil(2026, 5, 4)),
      });
      final hora = celula(bytes, 'C9');
      expect(hora.getAttribute('t'), isNull);
      expect(hora.getAttribute('s'), '${ModeloExemplo.estiloHoraAlternada}');
      expect(double.parse(hora.findElements('v').single.innerText), closeTo(0.3541666, 1e-6));
      final data = celula(bytes, 'A9');
      expect(data.findElements('v').single.innerText, '${serialDeData(dataCivil(2026, 5, 4))}');
      expect(data.getAttribute('s'), '${ModeloExemplo.estiloData}');
    });

    test('célula inexistente é inserida em ordem crescente de coluna', () {
      final bytes = aplicar({'D3': const TextoCelula('x')});
      final linha = xml(bytes, 'xl/worksheets/sheet1.xml')
          .findAllElements('row')
          .firstWhere((r) => r.getAttribute('r') == '3');
      expect(linha.findElements('c').map((c) => c.getAttribute('r')), ['A3', 'B3', 'D3', 'E3', 'F3']);
      expect(linha.getAttribute('spans'), isNull);
    });

    test('linha inexistente é inserida em ordem crescente de linha', () {
      final bytes = aplicar({'B4': const TextoCelula('maio/2026')});
      final linhas = xml(bytes, 'xl/worksheets/sheet1.xml')
          .findAllElements('row')
          .map((r) => int.parse(r.getAttribute('r')!))
          .toList();
      expect(linhas.take(5), [1, 2, 3, 4, 5]);
      expect(linhas, orderedEquals([...linhas]..sort()));
    });

    test('célula vazia perde o valor e mantém o estilo', () {
      final preenchido = aplicar({'C9': const TextoCelula('FOLGA')});
      final limpo = EscritorXlsxZip.aplicarSincrono(
        preenchido,
        PlanoDeEscrita(nomeAba: ModeloExemplo.aba, celulas: {
          ReferenciaCelula.deA1('C9')!: const VaziaCelula(),
        }),
      ).bytes;
      final c = celula(limpo, 'C9');
      expect(c.children, isEmpty);
      expect(c.getAttribute('t'), isNull);
      expect(c.getAttribute('s'), '${ModeloExemplo.estiloHoraAlternada}');
    });

    test('escrever fora da área amplia a dimensão da aba', () {
      final bytes = aplicar({'J40': const TextoCelula('ok')});
      final dimensao = xml(bytes, 'xl/worksheets/sheet1.xml').findAllElements('dimension').single;
      expect(dimensao.getAttribute('ref'), 'A1:J40');
    });
  });

  group('fórmulas', () {
    test('sobrescrever uma fórmula remove o <f> e produz aviso', () {
      final avisos = <String>[];
      final bytes = aplicar({'H38': const NumeroCelula(10)}, avisos: avisos);
      expect(celula(bytes, 'H38').findElements('f'), isEmpty);
      expect(celula(bytes, 'H38').findElements('v').single.innerText, '10');
      expect(avisos.single, 'A célula H38 tinha uma fórmula, que foi substituída pelo valor do '
          'app.');
    });

    test('sobrescrever a mestre de uma fórmula compartilhada não deixa dependentes órfãs', () {
      final bytes = aplicar({'H6': const TextoCelula('8:00')});
      final aba = xml(bytes, 'xl/worksheets/sheet1.xml');
      final compartilhadas =
          aba.findAllElements('f').where((f) => f.getAttribute('t') == 'shared');
      expect(compartilhadas, isEmpty);
      expect(celula(bytes, 'H7').findElements('v').single.innerText, '0');
    });

    test('fórmulas não sobrescritas continuam no arquivo', () {
      final bytes = mesPreenchido();
      expect(celula(bytes, 'H38').findElements('f').single.innerText, 'SUM(H6:H36)');
      expect(celula(bytes, 'H6').findElements('f').single.getAttribute('ref'), 'H6:H36');
    });

    test('recálculo: calcChain removido e fullCalcOnLoad marcado', () {
      final bytes = mesPreenchido();
      final todas = entradas(bytes);
      expect(todas.containsKey('xl/calcChain.xml'), isFalse);
      expect(utf8.decode(todas['[Content_Types].xml']!), isNot(contains('calcChain')));
      expect(utf8.decode(todas['xl/_rels/workbook.xml.rels']!), isNot(contains('calcChain')));
      final calcPr = xml(bytes, 'xl/workbook.xml').findAllElements('calcPr').single;
      expect(calcPr.getAttribute('fullCalcOnLoad'), '1');
      expect(calcPr.getAttribute('calcId'), '191029');
    });

    test('sem calcPr, ele é criado na posição certa do esquema', () {
      final semCalcPr = ModeloExemplo.bytes(substituir: {
        'xl/workbook.xml': ModeloExemplo.partes()['xl/workbook.xml']!
            .replaceFirst('<calcPr calcId="191029"/>', ''),
        'xl/calcChain.xml': null,
      });
      final bytes = EscritorXlsxZip.aplicarSincrono(semCalcPr,
          PlanoDeEscrita(nomeAba: ModeloExemplo.aba, celulas: {
            ReferenciaCelula.deA1('B3')!: const TextoCelula('x'),
          })).bytes;
      final filhos = xml(bytes, 'xl/workbook.xml').rootElement.childElements.map((e) => e.localName);
      expect(filhos, ['workbookPr', 'bookViews', 'sheets', 'calcPr']);
    });
  });

  test('escape de XML: "P&D <urgente>" produz um arquivo válido', () {
    final bytes = aplicar({'G9': const TextoCelula('P&D <urgente> "já"')});
    final estrutura = LeitorPlanilhaXml.lerEstrutura(bytes);
    expect(estrutura.aba(ModeloExemplo.aba)!.texto(9, 6), 'P&D <urgente> "já"');
  });

  test('texto com espaço nas pontas recebe xml:space="preserve"', () {
    final bytes = aplicar({'G9': const TextoCelula(' Natal ')});
    final t = celula(bytes, 'G9').findAllElements('t').single;
    expect(t.getAttribute('xml:space'), 'preserve');
  });

  test('o arquivo gerado é relido com os valores nas células esperadas', () {
    final estrutura = LeitorPlanilhaXml.lerEstrutura(mesPreenchido());
    final aba = estrutura.aba(ModeloExemplo.aba)!;
    expect(aba.texto(3, 1), 'Eduardo Feltes');
    expect(aba.texto(6, 0), '01/05/2026');
    expect(aba.celula(6, 0)!.ehDataHora, isTrue);
    expect(aba.texto(36, 0), '31/05/2026');
    expect(aba.texto(6, 2), '08:00');
    expect(aba.texto(36, 5), '17:00');
    expect(aba.texto(5, 3), 'SAÍDA 1');
    expect(estrutura.aba('Instruções')!.texto(1, 0), 'Preencha só as colunas de horário.');
  });

  test('aba inexistente vira falha com mensagem para a pessoa', () {
    expect(
      () => EscritorXlsxZip.aplicarSincrono(modelo, PlanoDeEscrita(nomeAba: 'Junho')),
      throwsA(isA<FalhaEscritaPlanilha>().having((f) => f.mensagem, 'mensagem',
          contains('A aba "Junho" não existe mais'))),
    );
  });

  test('a versão assíncrona devolve Resultado em vez de lançar', () async {
    final resultado = await const EscritorXlsxZip()
        .aplicar(Uint8List.fromList([1, 2, 3]), PlanoDeEscrita(nomeAba: 'Maio'));
    expect(resultado.falhaOuNula, isA<FalhaEscritaPlanilha>());
  });
}
