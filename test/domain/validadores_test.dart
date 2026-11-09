import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_pj/domain/entidades/conteudo_planilha.dart';
import 'package:ponto_pj/domain/entidades/dia_trabalho.dart';
import 'package:ponto_pj/domain/entidades/modelo_planilha.dart';
import 'package:ponto_pj/domain/entidades/referencia_celula.dart';
import 'package:ponto_pj/domain/enums/enums.dart';
import 'package:ponto_pj/domain/servicos/validador_marcacao.dart';
import 'package:ponto_pj/domain/servicos/validador_modelo.dart';

import '../helpers/construtores.dart';

void main() {
  group('ValidadorMarcacao', () {
    const validador = ValidadorMarcacao();
    final agora = DateTime(2026, 5, 7, 10);

    test('RN-03: horário futuro no dia de hoje é recusado', () {
      final falha = validador.validar(dia: diaCom(quinta, []), hora: h('14:00'), agora: agora);
      expect(falha?.mensagem, 'Não dá para registrar um horário que ainda não aconteceu.');
    });
    test('RN-03: o minuto atual é aceito', () {
      expect(validador.validar(dia: diaCom(quinta, []), hora: h('10:00'), agora: agora), isNull);
    });
    test('RN-03: data futura é recusada', () {
      final amanha = diaCom(quinta.add(const Duration(days: 1)), []);
      expect(validador.validar(dia: amanha, hora: h('08:00'), agora: agora), isNotNull);
    });
    test('RN-04 (V05): horário repetido é recusado', () {
      final falha =
          validador.validar(dia: diaCom(quinta, ['08:00']), hora: h('08:00'), agora: agora);
      expect(falha?.mensagem, 'Já existe uma marcação às 08:00 neste dia.');
    });
    test('RN-04: a própria marcação não conta na edição', () {
      final dia = diaCom(quinta, ['08:00']);
      final id = dia.marcacoes.single.id;
      expect(
          validador.validar(dia: dia, hora: h('08:00'), agora: agora, ignorarId: id), isNull);
    });
    test('dia fechado não aceita marcação', () {
      final fechado = DiaTrabalho(data: quinta, fechado: true);
      expect(validador.validar(dia: fechado, hora: h('08:00'), agora: agora), isNotNull);
    });
  });

  group('ValidadorModelo', () {
    const validador = ValidadorModelo();

    AbaPlanilha aba() => AbaPlanilha(
          nome: 'Horas',
          totalLinhas: 40,
          totalColunas: 11,
          celulas: {
            const ReferenciaCelula(6, 0): const CelulaLida(texto: 'DATA', valor: 'DATA'),
            const ReferenciaCelula(6, 3): const CelulaLida(texto: 'ENT', valor: 'ENT'),
            const ReferenciaCelula(7, 9): const CelulaLida(texto: '0:00', temFormula: true),
            const ReferenciaCelula(39, 10): const CelulaLida(texto: '0:00', temFormula: true),
          },
        );

    test('RN-18: sem a coluna de data não dá para continuar', () {
      final r = validador.validarColunas({CampoColuna.entrada1: 3});
      expect(r.valido, isFalse);
      expect(r.erros.single, startsWith('Escolha a coluna da data para continuar.'));
      expect(validador.validarColunas({CampoColuna.data: 0}).valido, isTrue);
    });
    test('observação e status na mesma coluna só alertam', () {
      final r = validador.validarColunas(
          {CampoColuna.data: 0, CampoColuna.observacao: 9, CampoColuna.status: 9});
      expect(r.valido, isTrue);
      expect(r.alertas.single, 'Observação e Status vão para a mesma coluna. O status tem '
          'prioridade.');
    });
    test('coluna com fórmula na área de dados alerta', () {
      final r = validador.validarColunas({CampoColuna.data: 0, CampoColuna.totalDia: 9},
          aba: aba(), primeiraLinhaDados: 7, ultimaLinhaDados: 37);
      expect(r.alertas.single, contains('A coluna J tem fórmulas'));
    });
    test('célula fixa sobre fórmula alerta e fora da aba bloqueia', () {
      final r = validador.validarCelulasFixas([
        const CelulaFixa(campo: CampoCelulaFixa.totalMes, referencia: 'K39'),
        const CelulaFixa(campo: CampoCelulaFixa.nome, referencia: 'Z99'),
        const CelulaFixa(campo: CampoCelulaFixa.matricula, referencia: '9Z'),
      ], aba: aba());
      expect(r.alertas.single, 'A célula K39 tem uma fórmula. Escrever nela vai apagá-la.');
      expect(r.erros, ['A célula Z99 não existe nesta aba.',
          '"9Z" não é uma célula. Use o formato B3.']);
    });
    test('linhas: dados depois do cabeçalho e cabeçalho com texto', () {
      expect(
          validador
              .validarLinhas(linhaCabecalho: 6, primeiraLinhaDados: 6, ultimaLinhaDados: null)
              .valido,
          isFalse);
      expect(
          validador
              .validarLinhas(
                  linhaCabecalho: 5, primeiraLinhaDados: 7, ultimaLinhaDados: 37, aba: aba())
              .erros,
          ['A linha de cabeçalho escolhida está vazia.']);
      expect(
          validador
              .validarLinhas(
                  linhaCabecalho: 6, primeiraLinhaDados: 7, ultimaLinhaDados: 37, aba: aba())
              .valido,
          isTrue);
    });
  });
}
