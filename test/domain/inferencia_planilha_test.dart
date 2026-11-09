import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_pj/data/planilha/leitor_planilha_xml.dart';
import 'package:ponto_pj/domain/entidades/conteudo_planilha.dart';
import 'package:ponto_pj/domain/entidades/referencia_celula.dart';
import 'package:ponto_pj/domain/enums/enums.dart';
import 'package:ponto_pj/domain/servicos/inferencia_planilha.dart';

import '../fixtures/modelo_exemplo.dart';

void main() {
  const inferencia = InferenciaPlanilha();

  /// A estrutura da planilha real "DEMONSTRATIVO DAS HORAS CONTRATADAS": rótulos mesclados
  /// em A2:C4, cabeçalho na linha 6, fórmulas em B, C, J e K, datas e horas já formatadas.
  AbaPlanilha planilhaHoras() {
    CelulaLida texto(String t) => CelulaLida(texto: t, valor: t);
    const formula = CelulaLida(texto: '0', temFormula: true);
    const dataHoraVazia = CelulaLida(texto: '', ehDataHora: true);
    final celulas = <ReferenciaCelula, CelulaLida>{
      const ReferenciaCelula(1, 0): texto('DEMONSTRATIVO DAS HORAS CONTRATADAS'),
      const ReferenciaCelula(2, 0): texto('Código SICLA:'),
      const ReferenciaCelula(3, 0): texto('Nome:'),
      const ReferenciaCelula(4, 0): texto('Competência:'),
      const ReferenciaCelula(4, 3): dataHoraVazia,
    };
    const cabecalho = ['DATA', 'SEM', 'DIA', 'ENT', 'SAI', 'ENT', 'SAI', 'ENT', 'SAI',
        'TOTAL DIA', 'ACUMULADO'];
    for (var c = 0; c < cabecalho.length; c++) {
      celulas[ReferenciaCelula(6, c)] = texto(cabecalho[c]);
    }
    for (var linha = 7; linha <= 37; linha++) {
      celulas[ReferenciaCelula(linha, 0)] = dataHoraVazia;
      for (final c in [1, 2, 9, 10]) {
        celulas[ReferenciaCelula(linha, c)] = formula;
      }
      for (var c = 3; c <= 8; c++) {
        celulas[ReferenciaCelula(linha, c)] = dataHoraVazia;
      }
    }
    celulas[const ReferenciaCelula(39, 9)] = texto('TOTAL HORAS');
    celulas[const ReferenciaCelula(39, 10)] = formula;
    return AbaPlanilha(
      nome: 'Horas',
      totalLinhas: 1000,
      totalColunas: 11,
      celulas: celulas,
      mesclagens: [
        for (final linha in [2, 3, 4])
          RegiaoMesclada(ReferenciaCelula(linha, 0), ReferenciaCelula(linha, 2)),
        const RegiaoMesclada(ReferenciaCelula(3, 3), ReferenciaCelula(3, 10)),
        const RegiaoMesclada(ReferenciaCelula(4, 3), ReferenciaCelula(4, 4)),
      ],
    );
  }

  group('planilha real de horas contratadas', () {
    final aba = planilhaHoras();

    test('cabeçalho na linha 6 e dados de 7 a 37', () {
      expect(inferencia.sugerirCabecalho(aba), 6);
      expect(inferencia.sugerirUltimaLinha(aba, 7), 37);
    });

    test('colunas: data em A e os três pares de D a I; fórmulas ficam de fora', () {
      final colunas =
          inferencia.sugerirColunas(aba, linhaCabecalho: 6, primeiraLinhaDados: 7, ultimaLinhaDados: 37);
      expect(colunas, {
        CampoColuna.data: 0,
        CampoColuna.entrada1: 3,
        CampoColuna.saida1: 4,
        CampoColuna.entrada2: 5,
        CampoColuna.saida2: 6,
        CampoColuna.entrada3: 7,
        CampoColuna.saida3: 8,
      });
    });

    test('células fixas ao lado dos rótulos mesclados', () {
      expect(inferencia.sugerirCelulasFixas(aba, ateLinha: 5), {
        CampoCelulaFixa.matricula: 'D2',
        CampoCelulaFixa.nome: 'D3',
        CampoCelulaFixa.competencia: 'D4',
      });
    });

    test('formatos nativos e textos de status em branco, para não quebrar as somas', () {
      final colunas =
          inferencia.sugerirColunas(aba, linhaCabecalho: 6, primeiraLinhaDados: 7, ultimaLinhaDados: 37);
      final formatos = inferencia.sugerirFormatos(aba, colunas, 7);
      expect(formatos.data, FormatoData.dataExcel);
      expect(formatos.hora, FormatoHora.horaExcel);
      expect(inferencia.sugerirTextosStatus(colunas, formatos.hora).values.toSet(), {''});
    });
  });

  test('planilha de teste: cabeçalho com acento e observação', () {
    final aba = LeitorPlanilhaXml.lerEstrutura(ModeloExemplo.bytes()).aba('Maio')!;
    expect(inferencia.sugerirCabecalho(aba), 5);
    expect(inferencia.sugerirUltimaLinha(aba, 6), 36);
    final colunas = inferencia.sugerirColunas(aba, linhaCabecalho: 5, primeiraLinhaDados: 6);
    expect(colunas, {
      CampoColuna.data: 0,
      CampoColuna.entrada1: 2,
      CampoColuna.saida1: 3,
      CampoColuna.entrada2: 4,
      CampoColuna.saida2: 5,
      CampoColuna.observacao: 6,
    });
    expect(inferencia.sugerirCelulasFixas(aba, ateLinha: 4),
        {CampoCelulaFixa.nome: 'B3', CampoCelulaFixa.matricula: 'F3'});
    expect(inferencia.sugerirFormatos(aba, colunas, 6).hora, FormatoHora.horaExcel);
  });

  test('textos de status padrão quando há coluna de status', () {
    final textos = inferencia.sugerirTextosStatus(
        {CampoColuna.data: 0, CampoColuna.status: 5}, FormatoHora.horaExcel);
    expect(textos[StatusDia.folga], 'FOLGA');
    expect(textos.containsKey(StatusDia.normal), isFalse);
  });

  test('normalização remove acento, caixa e pontuação', () {
    expect(InferenciaPlanilha.normalizar(' SAÍD. 1: '), 'said 1');
    expect(InferenciaPlanilha.normalizar('Competência'), 'competencia');
  });
}
