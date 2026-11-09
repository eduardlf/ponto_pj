import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_pj/core/datas_excel.dart';
import 'package:ponto_pj/core/extensoes/data_extensoes.dart';
import 'package:ponto_pj/core/resultado.dart';
import 'package:ponto_pj/domain/entidades/competencia.dart';
import 'package:ponto_pj/domain/entidades/conteudo_planilha.dart';
import 'package:ponto_pj/domain/entidades/dia_trabalho.dart';
import 'package:ponto_pj/domain/entidades/modelo_planilha.dart';
import 'package:ponto_pj/domain/entidades/perfil_usuario.dart';
import 'package:ponto_pj/domain/entidades/plano_de_escrita.dart';
import 'package:ponto_pj/domain/entidades/referencia_celula.dart';
import 'package:ponto_pj/domain/entidades/resumo_periodo.dart';
import 'package:ponto_pj/domain/enums/enums.dart';
import 'package:ponto_pj/domain/servicos/calculadora_ponto.dart';
import 'package:ponto_pj/domain/servicos/preenchedor_planilha.dart';

import '../fixtures/mes_exemplo.dart';
import '../helpers/construtores.dart';

/// Casos de docs/14, seção 14.2 — preenchimento.
void main() {
  const preenchedor = PreenchedorPlanilhaPadrao();
  const calculadora = CalculadoraPontoPadrao();
  const perfil = PerfilUsuario(nome: 'Eduardo Feltes', matricula: '485');
  final geracao = DateTime(2026, 6, 1, 19, 4);

  /// Estrutura da seção 10.1: cabeçalho na linha 5, dados de 6 a 36.
  ModeloPlanilha modelo({
    EstrategiaLinha estrategia = EstrategiaLinha.sequencial,
    int? ultima = 36,
    Map<CampoColuna, int>? colunas,
    List<CelulaFixa> celulas = const [],
    Map<StatusDia, String> textos = const {},
    FormatoData formatoData = FormatoData.ddMm,
    FormatoHora formatoHora = FormatoHora.hhMm,
    int diaInicio = 1,
  }) {
    return ModeloPlanilha(
      nome: 'Ponto',
      caminhoArquivoBase: '/modelo.xlsx',
      nomeArquivoOriginal: 'modelo.xlsx',
      hashArquivo: 'abc',
      nomeAba: 'Maio',
      linhaCabecalho: 5,
      primeiraLinhaDados: 6,
      ultimaLinhaDados: ultima,
      estrategia: estrategia,
      formatoData: formatoData,
      formatoHora: formatoHora,
      diaInicioCompetencia: diaInicio,
      colunas: colunas ??
          {
            CampoColuna.data: 0,
            CampoColuna.entrada1: 2,
            CampoColuna.saida1: 3,
            CampoColuna.entrada2: 4,
            CampoColuna.saida2: 5,
            CampoColuna.totalDia: 7,
          },
      celulasFixas: celulas,
      textosStatus: textos,
    );
  }

  ResumoPeriodo resumo(List<DiaTrabalho> dias) =>
      calculadora.calcularPeriodo(dias, MesExemplo.jornada, agora: MesExemplo.agora);

  ResultadoPreenchimento preencher(ModeloPlanilha m,
      {List<DiaTrabalho>? dias, Competencia? competencia, AbaPlanilha? aba}) {
    final lista = dias ?? MesExemplo.dias();
    final resultado = preenchedor.preencher(
      modelo: m,
      competencia: competencia ?? MesExemplo.competencia,
      dias: lista,
      perfil: perfil,
      resumo: resumo(lista),
      dataGeracao: geracao,
      aba: aba,
    );
    return (resultado as Sucesso<ResultadoPreenchimento>).valor;
  }

  ValorCelula? em(ResultadoPreenchimento r, String a1) =>
      r.plano.celulas[ReferenciaCelula.deA1(a1)!];

  group('estratégia sequencial', () {
    test('dia 1 na primeira linha de dados e dia 31 na linha 36', () {
      final r = preencher(modelo());
      expect(em(r, 'A6'), const TextoCelula('01/05'));
      expect(em(r, 'A36'), const TextoCelula('31/05'));
      expect(em(r, 'C7'), const VaziaCelula()); // 02/05, sábado sem registro
      expect(em(r, 'C9'), const TextoCelula('08:00')); // 04/05
      expect(em(r, 'F9'), const TextoCelula('17:00'));
      expect(em(r, 'H9'), const TextoCelula('08:00')); // total do dia
      expect(r.plano.nomeAba, 'Maio');
    });

    test('RN-21: 31 dias em 28 linhas falha antes de qualquer escrita', () {
      final resultado = preenchedor.preencher(
        modelo: modelo(ultima: 33),
        competencia: MesExemplo.competencia,
        dias: MesExemplo.dias(),
        perfil: perfil,
        resumo: ResumoPeriodo.vazio(),
        dataGeracao: geracao,
      );
      expect(resultado.falhaOuNula?.mensagem,
          'A competência tem 31 dias, mas a planilha só tem 28 linhas livres a partir da '
          'linha 6. Confira a primeira linha de dados.');
    });

    test('sem última linha não há limite', () {
      expect(preencher(modelo(ultima: null)).plano.celulas, isNotEmpty);
    });

    test('período de 26 a 25: o dia 26 do mês anterior vai na primeira linha', () {
      final outubro = Competencia(2026, 10, diaInicio: 26);
      final dias = outubro.dias().map((d) => calculadora.calcularDia(
          diaCom(d, d.weekday <= 5 ? ['08:00', '12:00'] : []), MesExemplo.jornada,
          agora: DateTime(2026, 11, 1)));
      final r = preencher(modelo(diaInicio: 26, formatoData: FormatoData.ddMmAaaa),
          dias: dias.toList(), competencia: outubro);
      expect(em(r, 'A6'), const TextoCelula('26/09/2026'));
      expect(em(r, 'A35'), const TextoCelula('25/10/2026'));
      expect(em(r, 'A36'), isNull); // o período tem 30 dias: a 31ª linha fica intocada
    });
  });

  group('estratégia por data', () {
    AbaPlanilha abaComDatas({bool pularDia15 = false}) {
      final celulas = <ReferenciaCelula, CelulaLida>{};
      var linha = 6;
      for (final data in MesExemplo.competencia.dias()) {
        if (pularDia15 && data.day == 15) continue;
        // Uma linha de subtotal no meio, como em planilhas com totais semanais.
        if (data.day == 8) {
          celulas[ReferenciaCelula(linha, 0)] = const CelulaLida(texto: 'Subtotal');
          linha++;
        }
        celulas[ReferenciaCelula(linha, 0)] = CelulaLida(
          texto: formatarData(data),
          valor: serialDeData(data).toDouble(),
          ehDataHora: true,
        );
        linha++;
      }
      return AbaPlanilha(nome: 'Maio', totalLinhas: 40, totalColunas: 8, celulas: celulas);
    }

    test('índice montado: a data no meio da planilha é encontrada', () {
      final r = preencher(modelo(estrategia: EstrategiaLinha.porData, ultima: 40),
          aba: abaComDatas());
      expect(em(r, 'C9'), const TextoCelula('08:00')); // 04/05 na linha 9
      expect(em(r, 'C14'), const TextoCelula('08:00')); // 08/05 pula o subtotal da linha 13
      expect(em(r, 'A13'), isNull);
      expect(r.diasNaoResolvidos, isEmpty);
    });

    test('RN-20: data ausente vai para os não resolvidos e os demais seguem', () {
      final r = preencher(modelo(estrategia: EstrategiaLinha.porData, ultima: 40),
          aba: abaComDatas(pularDia15: true));
      expect(r.diasNaoResolvidos, [dataCivil(2026, 5, 15)]);
      expect(r.avisos,
          contains('Não achei a linha do dia 15/05 na planilha. Esse dia ficou de fora.'));
      expect(em(r, 'C19'), const TextoCelula('08:00')); // 14/05 continua escrito
    });

    test('datas em texto também são reconhecidas', () {
      final aba = AbaPlanilha(nome: 'Maio', totalLinhas: 8, totalColunas: 8, celulas: {
        const ReferenciaCelula(6, 0): const CelulaLida(texto: '04/05/2026', valor: '04/05/2026'),
        const ReferenciaCelula(7, 0): const CelulaLida(texto: '05/05', valor: '05/05'),
        const ReferenciaCelula(8, 0): const CelulaLida(texto: '6', valor: 6.0),
      });
      final r = preencher(modelo(estrategia: EstrategiaLinha.porData, ultima: 8), aba: aba);
      expect(em(r, 'C6'), const TextoCelula('08:00'));
      expect(em(r, 'C7'), const TextoCelula('08:00'));
      expect(em(r, 'F8'), const TextoCelula('16:00'));
      expect(r.diasNaoResolvidos, hasLength(28));
    });
  });

  test('campo não mapeado não gera célula nem exceção', () {
    final r = preencher(modelo());
    expect(r.plano.celulas.keys.where((ref) => ref.coluna == 8), isEmpty);
  });

  test('coluna compartilhada: o status tem prioridade e a observação é concatenada', () {
    final r = preencher(modelo(
      colunas: {CampoColuna.data: 0, CampoColuna.observacao: 9, CampoColuna.status: 9},
      textos: {StatusDia.feriado: 'FERIADO'},
    ));
    expect(em(r, 'J12'), const TextoCelula('FERIADO — Plantão')); // 07/05
    expect(em(r, 'J6'), const TextoCelula('FERIADO')); // 01/05, sem observação
    expect(em(r, 'J9'), const VaziaCelula()); // dia normal sem observação
  });

  test('mais marcações que colunas: escreve as que cabem e avisa', () {
    final r = preencher(modelo()); // mapeia só até a 2ª saída
    expect(em(r, 'F19'), const TextoCelula('17:00')); // 14/05, três turnos
    expect(r.avisos, contains('O dia 14/05 tem 6 marcações, mas a planilha comporta 4. '
        'As últimas ficaram de fora.'));
  });

  test('dia não trabalhado: texto do status e colunas de horário limpas', () {
    final r = preencher(modelo(textos: {StatusDia.atestado: 'ATESTADO'}));
    expect(em(r, 'C25'), const TextoCelula('ATESTADO')); // 20/05, sem coluna de status
    expect(em(r, 'D25'), const VaziaCelula());
    expect(em(r, 'F25'), const VaziaCelula());
  });

  test('status sem texto configurado escreve as marcações normalmente', () {
    final r = preencher(modelo());
    expect(em(r, 'C12'), const TextoCelula('08:00')); // 07/05, feriado trabalhado
  });

  group('células fixas', () {
    test('perfil, competência e totais', () {
      final r = preencher(modelo(celulas: const [
        CelulaFixa(campo: CampoCelulaFixa.nome, referencia: 'B3'),
        CelulaFixa(campo: CampoCelulaFixa.matricula, referencia: 'F3'),
        CelulaFixa(campo: CampoCelulaFixa.competencia, referencia: 'E2'),
        CelulaFixa(campo: CampoCelulaFixa.mes, referencia: 'A1'),
        CelulaFixa(campo: CampoCelulaFixa.ano, referencia: 'B1'),
        CelulaFixa(campo: CampoCelulaFixa.totalMes, referencia: 'H38'),
        CelulaFixa(campo: CampoCelulaFixa.saldoMes, referencia: 'H39'),
        CelulaFixa(campo: CampoCelulaFixa.dataGeracao, referencia: 'H40'),
        CelulaFixa(campo: CampoCelulaFixa.textoLivre, referencia: 'A41', valorLivre: 'Visto'),
      ]));
      expect(em(r, 'B3'), const TextoCelula('Eduardo Feltes'));
      expect(em(r, 'F3'), const TextoCelula('485'));
      expect(em(r, 'E2'), const TextoCelula('maio/2026'));
      expect(em(r, 'A1'), const TextoCelula('maio'));
      expect(em(r, 'B1'), const TextoCelula('2026'));
      expect(em(r, 'H38'), const TextoCelula('134:00'));
      expect(em(r, 'H39'), const TextoCelula('-10:00'));
      expect(em(r, 'H40'), const TextoCelula('01/06/2026'));
      expect(em(r, 'A41'), const TextoCelula('Visto'));
    });

    test('origem vazia é pulada, preservando o conteúdo original', () {
      final r = preencher(modelo(celulas: const [
        CelulaFixa(campo: CampoCelulaFixa.cargo, referencia: 'B4'),
        CelulaFixa(campo: CampoCelulaFixa.textoLivre, referencia: 'B5'),
      ]));
      expect(em(r, 'B4'), isNull);
      expect(em(r, 'B5'), isNull);
    });

    test('valores nativos: competência vira data e ano vira número', () {
      final r = preencher(modelo(
        formatoData: FormatoData.dataExcel,
        formatoHora: FormatoHora.horaExcel,
        celulas: const [
          CelulaFixa(campo: CampoCelulaFixa.competencia, referencia: 'D4'),
          CelulaFixa(campo: CampoCelulaFixa.ano, referencia: 'E4'),
          CelulaFixa(campo: CampoCelulaFixa.totalMes, referencia: 'K39'),
        ],
      ));
      expect(em(r, 'D4'), DataCelula(dataCivil(2026, 5, 1)));
      expect(em(r, 'E4'), const NumeroCelula(2026));
      expect(em(r, 'K39'), HoraCelula(min(8040)));
    });
  });

  group('formatos de data (07/05/2026, linha 12)', () {
    void caso(FormatoData formato, ValorCelula esperado) {
      test(formato.name, () {
        expect(em(preencher(modelo(formatoData: formato)), 'A12'), esperado);
      });
    }

    caso(FormatoData.ddMmAaaa, const TextoCelula('07/05/2026'));
    caso(FormatoData.ddMm, const TextoCelula('07/05'));
    caso(FormatoData.dd, const TextoCelula('7'));
    caso(FormatoData.aaaaMmDd, const TextoCelula('2026-05-07'));
    caso(FormatoData.dataExcel, DataCelula(dataCivil(2026, 5, 7)));
  });

  group('formatos de hora (06/05, saída às 16:00 e 07:00 de trabalho)', () {
    void caso(FormatoHora formato, ValorCelula entrada, ValorCelula total) {
      test(formato.name, () {
        final r = preencher(modelo(formatoHora: formato));
        expect(em(r, 'C11'), entrada);
        expect(em(r, 'H11'), total);
      });
    }

    caso(FormatoHora.hhMm, const TextoCelula('08:00'), const TextoCelula('07:00'));
    caso(FormatoHora.hhMmSs, const TextoCelula('08:00:00'), const TextoCelula('07:00:00'));
    caso(FormatoHora.decimal, const TextoCelula('8'), const TextoCelula('7'));
    caso(FormatoHora.horaExcel, HoraCelula(h('08:00')), HoraCelula(h('07:00')));
  });

  test('saldo do dia sai com sinal', () {
    final r = preencher(modelo(colunas: {CampoColuna.data: 0, CampoColuna.saldoDia: 8}));
    expect(em(r, 'I13'), const TextoCelula('+01:00')); // 08/05, hora extra
    expect(em(r, 'I11'), const TextoCelula('-01:00')); // 06/05, saída antecipada
    expect(em(r, 'I9'), const TextoCelula('00:00'));
  });

  test('dia da semana em português, sem ponto', () {
    final r = preencher(modelo(colunas: {CampoColuna.data: 0, CampoColuna.diaSemana: 1}));
    expect(em(r, 'B6'), const TextoCelula('sex'));
    expect(em(r, 'B7'), const TextoCelula('sáb'));
  });
}

String formatarData(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
