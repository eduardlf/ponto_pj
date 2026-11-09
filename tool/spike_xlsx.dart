// Spike S-01 (docs/13): preenche uma planilha real de ponto com o pipeline de produção —
// CalculadoraPonto, PreenchedorPlanilha e EscritorXlsxZip — para conferir o resultado no
// Excel e no LibreOffice. Não é código de produção.
//
// Uso: dart run tool/spike_xlsx.dart <modelo.xlsx> <saida.xlsx>
//
// O mapeamento abaixo é o da planilha "DEMONSTRATIVO DAS HORAS CONTRATADAS": aba "Horas",
// datas na coluna A a partir da linha 7, horários de D a I, código em D2, nome em D3,
// competência em D4 e período de 26 do mês anterior a 25 do mês da competência.

import 'dart:io';

import 'package:ponto_pj/core/extensoes/data_extensoes.dart';
import 'package:ponto_pj/core/resultado.dart';
import 'package:ponto_pj/data/planilha/escritor_xlsx_zip.dart';
import 'package:ponto_pj/domain/entidades/competencia.dart';
import 'package:ponto_pj/domain/entidades/configuracao_jornada.dart';
import 'package:ponto_pj/domain/entidades/dia_trabalho.dart';
import 'package:ponto_pj/domain/entidades/marcacao.dart';
import 'package:ponto_pj/domain/entidades/modelo_planilha.dart';
import 'package:ponto_pj/domain/entidades/perfil_usuario.dart';
import 'package:ponto_pj/domain/enums/enums.dart';
import 'package:ponto_pj/domain/servicos/calculadora_ponto.dart';
import 'package:ponto_pj/domain/servicos/preenchedor_planilha.dart';

Future<void> main(List<String> argumentos) async {
  if (argumentos.length != 2) {
    stderr.writeln('Uso: dart run tool/spike_xlsx.dart <modelo.xlsx> <saida.xlsx>');
    exitCode = 64;
    return;
  }

  final modelo = ModeloPlanilha(
    nome: 'Horas',
    caminhoArquivoBase: argumentos[0],
    nomeArquivoOriginal: 'modelo.xlsx',
    hashArquivo: '',
    nomeAba: 'Horas',
    linhaCabecalho: 6,
    primeiraLinhaDados: 7,
    ultimaLinhaDados: 37,
    formatoData: FormatoData.dataExcel,
    formatoHora: FormatoHora.horaExcel,
    diaInicioCompetencia: 26,
    colunas: const {
      CampoColuna.data: 0,
      CampoColuna.entrada1: 3,
      CampoColuna.saida1: 4,
      CampoColuna.entrada2: 5,
      CampoColuna.saida2: 6,
      CampoColuna.entrada3: 7,
      CampoColuna.saida3: 8,
    },
    celulasFixas: const [
      CelulaFixa(campo: CampoCelulaFixa.matricula, referencia: 'D2'),
      CelulaFixa(campo: CampoCelulaFixa.nome, referencia: 'D3'),
      CelulaFixa(campo: CampoCelulaFixa.competencia, referencia: 'D4'),
    ],
  );

  final jornada = ConfiguracaoJornada(dias: [
    for (var d = 1; d <= 5; d++)
      JornadaDiaSemana(diaSemana: d, trabalha: true, carga: const Duration(hours: 8)),
    JornadaDiaSemana.semTrabalho(6),
    JornadaDiaSemana.semTrabalho(7),
  ]);
  const calculadora = CalculadoraPontoPadrao();
  final competencia = Competencia(2026, 10, diaInicio: 26);
  final agora = DateTime(2026, 10, 27, 9);

  Duration hm(int h, int m) => Duration(hours: h, minutes: m);
  final dias = [
    for (final data in competencia.dias())
      calculadora.calcularDia(
        DiaTrabalho(
          data: data,
          marcacoes: data.weekday > 5
              ? const []
              : [
                  Marcacao(hora: hm(8, data.day % 3 * 5)),
                  Marcacao(hora: hm(12, 0)),
                  Marcacao(hora: hm(13, 0)),
                  Marcacao(hora: hm(17, data.day % 4 * 10)),
                ],
        ),
        jornada,
        agora: agora,
      ),
  ];

  final resultado = const PreenchedorPlanilhaPadrao().preencher(
    modelo: modelo,
    competencia: competencia,
    dias: dias,
    perfil: const PerfilUsuario(nome: 'Pessoa de Teste', matricula: '485'),
    resumo: calculadora.calcularPeriodo(dias, jornada, agora: agora),
    dataGeracao: agora.apenasData,
  );
  final plano = switch (resultado) {
    Sucesso(:final valor) => valor.plano,
    Erro(:final falha) => throw StateError(falha.mensagem),
  };

  final saida = EscritorXlsxZip.aplicarSincrono(await File(argumentos[0]).readAsBytes(), plano);
  await File(argumentos[1]).writeAsBytes(saida.bytes);
  stdout.writeln('${plano.celulas.length} células escritas em ${argumentos[1]}');
  for (final aviso in saida.avisos) {
    stdout.writeln('Aviso: $aviso');
  }
}
