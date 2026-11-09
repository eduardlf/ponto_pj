import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_pj/core/extensoes/data_extensoes.dart';
import 'package:ponto_pj/domain/entidades/competencia.dart';
import 'package:ponto_pj/domain/entidades/referencia_celula.dart';

void main() {
  group('Competencia no mês civil', () {
    test('maio/2026 tem 31 dias', () {
      final c = Competencia(2026, 5);
      expect(c.primeiroDia(), dataCivil(2026, 5, 1));
      expect(c.ultimoDia(), dataCivil(2026, 5, 31));
      expect(c.totalDias(), 31);
      expect(c.formatado(), 'maio/2026');
    });
    test('fevereiro de 2028 é bissexto', () => expect(Competencia(2028, 2).totalDias(), 29));
    test('fevereiro de 2026 tem 28 dias', () => expect(Competencia(2026, 2).totalDias(), 28));
    test('anterior e seguinte atravessam o ano', () {
      expect(Competencia(2026, 1).anterior(), Competencia(2025, 12));
      expect(Competencia(2026, 12).seguinte(), Competencia(2027, 1));
    });
    test('contendo a data', () {
      expect(Competencia.contendo(dataCivil(2026, 5, 31)), Competencia(2026, 5));
    });
  });

  group('Competencia com início no dia 26 (planilha que fecha no dia 25)', () {
    final outubro = Competencia(2026, 10, diaInicio: 26);

    test('vai de 26/09 a 25/10', () {
      expect(outubro.primeiroDia(), dataCivil(2026, 9, 26));
      expect(outubro.ultimoDia(), dataCivil(2026, 10, 25));
      expect(outubro.totalDias(), 30);
      expect(outubro.periodoFormatado(), '26/09 a 25/10/2026');
    });
    test('janeiro começa em 26 de dezembro do ano anterior', () {
      final janeiro = Competencia(2026, 1, diaInicio: 26);
      expect(janeiro.primeiroDia(), dataCivil(2025, 12, 26));
      expect(janeiro.totalDias(), 31);
    });
    test('a data define a competência pelo dia de corte', () {
      expect(Competencia.contendo(dataCivil(2026, 10, 25), diaInicio: 26), outubro);
      expect(Competencia.contendo(dataCivil(2026, 9, 26), diaInicio: 26), outubro);
      expect(Competencia.contendo(dataCivil(2026, 12, 26), diaInicio: 26),
          Competencia(2027, 1, diaInicio: 26));
    });
    test('posição do dia dentro do período', () {
      expect(outubro.posicaoDe(dataCivil(2026, 9, 26)), 1);
      expect(outubro.posicaoDe(dataCivil(2026, 10, 1)), 6);
      expect(outubro.contem(dataCivil(2026, 10, 26)), isFalse);
    });
  });

  group('ReferenciaCelula', () {
    test('A1 para linha e coluna', () {
      expect(ReferenciaCelula.deA1('C3'), const ReferenciaCelula(3, 2));
      expect(ReferenciaCelula.deA1(r'$B$2'), const ReferenciaCelula(2, 1));
      expect(ReferenciaCelula.deA1('aa10'), const ReferenciaCelula(10, 26));
    });
    test('letras de coluna: Z, AA, AB e o limite XFD', () {
      expect(ReferenciaCelula.letraDaColuna(0), 'A');
      expect(ReferenciaCelula.letraDaColuna(25), 'Z');
      expect(ReferenciaCelula.letraDaColuna(26), 'AA');
      expect(ReferenciaCelula.letraDaColuna(27), 'AB');
      expect(ReferenciaCelula.letraDaColuna(701), 'ZZ');
      expect(ReferenciaCelula.letraDaColuna(702), 'AAA');
      expect(ReferenciaCelula.indiceDaColuna('XFD'), 16383);
    });
    test('ida e volta para todas as colunas', () {
      for (var i = 0; i < ReferenciaCelula.maxColunas; i++) {
        expect(ReferenciaCelula.indiceDaColuna(ReferenciaCelula.letraDaColuna(i)), i);
      }
    });
    test('textos inválidos', () {
      expect(ReferenciaCelula.deA1('3C'), isNull);
      expect(ReferenciaCelula.deA1('C0'), isNull);
      expect(ReferenciaCelula.deA1('XFE1'), isNull);
      expect(ReferenciaCelula.deA1(''), isNull);
    });
    test('ordem por linha e depois por coluna', () {
      final refs = [
        const ReferenciaCelula(2, 0),
        const ReferenciaCelula(1, 3),
        const ReferenciaCelula(1, 1),
      ]..sort();
      expect(refs.map((r) => r.a1), ['B1', 'D1', 'A2']);
    });
  });
}
