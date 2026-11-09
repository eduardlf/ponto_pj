import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_pj/core/falhas.dart';
import 'package:ponto_pj/data/planilha/leitor_planilha_xml.dart';

import '../fixtures/modelo_exemplo.dart';

void main() {
  const leitor = LeitorPlanilhaXml();

  test('abas, cabeçalho com acento, fórmulas e dimensões', () async {
    final resultado = await leitor.ler(ModeloExemplo.bytes(), nomeArquivo: 'ponto.xlsx');
    final estrutura = resultado.valorOuNulo!;
    expect(estrutura.abas.map((a) => a.nome), ['Maio', 'Instruções']);
    expect(estrutura.sistemaData1904, isFalse);

    final aba = estrutura.aba('Maio')!;
    expect(aba.totalLinhas, 39);
    expect(aba.totalColunas, 8);
    expect(aba.texto(5, 0), 'DATA');
    expect(aba.texto(5, 3), 'SAÍDA 1');
    expect(aba.texto(3, 4), 'Matrícula:');
    expect(aba.celula(38, 7)!.temFormula, isTrue);
    expect(aba.celula(10, 7)!.temFormula, isTrue);
    expect(aba.texto(38, 7), '00:00');
    expect(aba.ultimaLinhaComConteudo, 39);
  });

  test('.xls antigo é recusado com orientação', () async {
    final resultado = await leitor.ler(ModeloExemplo.bytes(), nomeArquivo: 'ponto.xls');
    expect(resultado.falhaOuNula?.mensagem, LeitorPlanilhaXml.mensagemXls);
  });

  test('arquivo que não é zip é ilegível', () async {
    final resultado = await leitor.ler(Uint8List.fromList(List.filled(64, 7)),
        nomeArquivo: 'ponto.xlsx');
    expect(resultado.falhaOuNula, isA<FalhaFormatoPlanilha>());
    expect(resultado.falhaOuNula?.mensagem, LeitorPlanilhaXml.mensagemIlegivel);
  });

  test('.xlsx protegido por senha (OLE2) é ilegível', () async {
    final ole2 = Uint8List.fromList([0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1, 0, 0]);
    final resultado = await leitor.ler(ole2, nomeArquivo: 'ponto.xlsx');
    expect(resultado.falhaOuNula?.mensagem, LeitorPlanilhaXml.mensagemIlegivel);
  });

  test('zip sem as partes de uma planilha é ilegível', () async {
    final quebrado = ModeloExemplo.bytes(substituir: {'xl/workbook.xml': null});
    final resultado = await leitor.ler(quebrado, nomeArquivo: 'ponto.xlsx');
    expect(resultado.falhaOuNula?.mensagem, LeitorPlanilhaXml.mensagemIlegivel);
  });

  test('planilha sem conteúdo é recusada', () async {
    const vazia = '<?xml version="1.0" encoding="UTF-8"?><worksheet '
        'xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetData/></worksheet>';
    final bytes = ModeloExemplo.bytes(substituir: {
      'xl/worksheets/sheet1.xml': vazia,
      'xl/worksheets/sheet2.xml': vazia,
    });
    final resultado = await leitor.ler(bytes, nomeArquivo: 'ponto.xlsx');
    expect(resultado.falhaOuNula?.mensagem, LeitorPlanilhaXml.mensagemVazia);
  });
}
