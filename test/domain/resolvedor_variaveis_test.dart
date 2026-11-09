import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_pj/domain/entidades/competencia.dart';
import 'package:ponto_pj/domain/entidades/configuracao_email.dart';
import 'package:ponto_pj/domain/entidades/perfil_usuario.dart';
import 'package:ponto_pj/domain/entidades/resumo_periodo.dart';
import 'package:ponto_pj/domain/servicos/resolvedor_variaveis.dart';

import '../helpers/construtores.dart';

void main() {
  const resolvedor = ResolvedorVariaveis();

  ContextoVariaveis contexto({PerfilUsuario? perfil}) => ContextoVariaveis(
        perfil: perfil ??
            const PerfilUsuario(
              nome: 'Eduardo Feltes',
              matricula: '01234',
              cargo: 'Desenvolvedor',
              empresa: 'Acme Ltda',
            ),
        competencia: Competencia(2026, 5),
        resumo: ResumoPeriodo(
          trabalhado: min(10340),
          cargaPrevista: min(10080),
          saldo: min(260),
          bancoHoras: min(390),
          diasUteis: 21,
          diasTrabalhados: 21,
        ),
        dataGeracao: DateTime(2026, 6, 1, 19, 4),
      );

  test('todas as variáveis da tabela 11.1', () {
    const modelo = '{nome}|{primeiro_nome}|{matricula}|{cargo}|{empresa}|{competencia}|{mes}|'
        '{mes_extenso}|{ano}|{total_mes}|{saldo_mes}|{banco_horas}|{data_geracao}|'
        '{dias_trabalhados}';
    expect(
      resolvedor.resolver(modelo, contexto()),
      'Eduardo Feltes|Eduardo|01234|Desenvolvedor|Acme Ltda|maio/2026|05|maio|2026|'
      '172h 20m|+ 04h 20m|+ 06h 30m|01/06/2026|21',
    );
  });

  test('assunto padrão', () {
    expect(resolvedor.resolver(ConfiguracaoEmail.assuntoPadrao, contexto()),
        'Ponto - Eduardo Feltes - maio/2026');
  });

  test('variável desconhecida permanece literal', () {
    expect(resolvedor.resolver('Setor {setor} de {nome}', contexto()),
        'Setor {setor} de Eduardo Feltes');
  });

  test('origem vazia não deixa espaço duplicado', () {
    final semMatricula = contexto(perfil: const PerfilUsuario(nome: 'Eduardo Feltes'));
    expect(resolvedor.resolver('Ponto - {matricula} - {competencia}', semMatricula),
        'Ponto - - maio/2026');
    expect(resolvedor.resolver('{matricula} {nome}', semMatricula), 'Eduardo Feltes');
  });

  test('corpo multilinha preserva as quebras', () {
    final corpo = resolvedor.resolver(ConfiguracaoEmail.corpoPadrao, contexto());
    expect(corpo, contains('Segue em anexo o registro de ponto de maio/2026.\n\n'));
    expect(corpo, contains('Saldo do período: + 04h 20m'));
    expect(corpo, endsWith('Atenciosamente,\nEduardo Feltes'));
  });

  group('nome do arquivo', () {
    test('template padrão', () {
      expect(resolvedor.resolverNomeArquivo(ConfiguracaoEmail.nomeArquivoPadrao, contexto()),
          'Ponto_Eduardo_Feltes_05-2026.xlsx');
    });
    test('caracteres inválidos viram hífen e acento é preservado', () {
      final perfil = contexto(perfil: const PerfilUsuario(nome: 'João/Conceição: "RH"'));
      expect(resolvedor.resolverNomeArquivo('Ponto {nome}.xlsx', perfil),
          'Ponto_João-Conceição-_-RH.xlsx');
    });
    test('sem extensão recebe .xlsx', () {
      expect(resolvedor.resolverNomeArquivo('Ponto {mes}-{ano}', contexto()),
          'Ponto_05-2026.xlsx');
    });
    test('nome vazio cai para o padrão de segurança', () {
      final semMatricula = contexto(perfil: const PerfilUsuario(nome: 'Eduardo'));
      expect(resolvedor.resolverNomeArquivo('{matricula}.xlsx', semMatricula),
          'Ponto_2026-05.xlsx');
    });
  });
}
