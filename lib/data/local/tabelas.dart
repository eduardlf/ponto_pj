import 'package:drift/drift.dart';

import '../../domain/enums/enums.dart';
import 'conversores.dart';

/// Tabelas do banco local, exatamente como no dicionário de dados de docs/06, seção 6.4.

@DataClassName('PerfilUsuarioLinha')
class PerfisUsuario extends Table {
  @override
  String get tableName => 'perfil_usuario';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get matricula => text().nullable()();
  TextColumn get cargo => text().nullable()();
  TextColumn get empresa => text().nullable()();
  TextColumn get email => text().nullable()();
  DateTimeColumn get criadoEm => dateTime().named('criado_em').withDefault(currentDateAndTime)();
  DateTimeColumn get atualizadoEm =>
      dateTime().named('atualizado_em').withDefault(currentDateAndTime)();
}

@DataClassName('PreferenciaAppLinha')
class PreferenciasApp extends Table {
  @override
  String get tableName => 'preferencia_app';

  TextColumn get chave => text()();
  TextColumn get valor => text()();

  @override
  Set<Column> get primaryKey => {chave};
}

@DataClassName('ConfiguracaoJornadaLinha')
class ConfiguracoesJornada extends Table {
  @override
  String get tableName => 'configuracao_jornada';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text().withDefault(const Constant('Jornada padrão'))();
  BoolColumn get ativa => boolean().withDefault(const Constant(true))();
  IntColumn get toleranciaMinutos =>
      integer().named('tolerancia_minutos').withDefault(const Constant(0))();
  BoolColumn get permiteViradaDia =>
      boolean().named('permite_virada_dia').withDefault(const Constant(false))();
  TextColumn get dataInicioBanco =>
      text().named('data_inicio_banco').map(const ConversorData()).nullable()();
  DateTimeColumn get criadoEm => dateTime().named('criado_em').withDefault(currentDateAndTime)();
}

@DataClassName('JornadaDiaSemanaLinha')
class JornadasDiaSemana extends Table {
  @override
  String get tableName => 'jornada_dia_semana';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get configuracaoId => integer()
      .named('configuracao_id')
      .references(ConfiguracoesJornada, #id, onDelete: KeyAction.cascade)();
  IntColumn get diaSemana => integer().named('dia_semana')();
  BoolColumn get trabalha => boolean()();
  IntColumn get cargaMinutos => integer().named('carga_minutos')();
  BoolColumn get cargaManual =>
      boolean().named('carga_manual').withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {configuracaoId, diaSemana},
      ];
}

@DataClassName('TurnoPrevistoLinha')
class TurnosPrevistos extends Table {
  @override
  String get tableName => 'turno_previsto';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get jornadaDiaId => integer()
      .named('jornada_dia_id')
      .references(JornadasDiaSemana, #id, onDelete: KeyAction.cascade)();
  IntColumn get ordem => integer()();
  IntColumn get horaEntrada => integer().named('hora_entrada').map(const ConversorMinutos())();
  IntColumn get horaSaida => integer().named('hora_saida').map(const ConversorMinutos())();
}

@DataClassName('DiaTrabalhoLinha')
class DiasTrabalho extends Table {
  @override
  String get tableName => 'dia_trabalho';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get data => text().map(const ConversorData()).unique()();
  TextColumn get status => text()
      .map(const ConversorEnum<StatusDia>(StatusDia.values))
      .withDefault(const Constant('NORMAL'))();
  BoolColumn get statusManual =>
      boolean().named('status_manual').withDefault(const Constant(false))();
  TextColumn get observacao => text().nullable()();
  IntColumn get cargaPrevistaMinutos =>
      integer().named('carga_prevista_minutos').withDefault(const Constant(0))();
  IntColumn get minutosTrabalhados =>
      integer().named('minutos_trabalhados').withDefault(const Constant(0))();
  IntColumn get saldoMinutos => integer().named('saldo_minutos').withDefault(const Constant(0))();
  BoolColumn get inconsistente => boolean().withDefault(const Constant(false))();
  BoolColumn get fechado => boolean().withDefault(const Constant(false))();
  DateTimeColumn get atualizadoEm =>
      dateTime().named('atualizado_em').withDefault(currentDateAndTime)();
}

@DataClassName('MarcacaoLinha')
@TableIndex(name: 'idx_marcacao_dia_ordem', columns: {#diaId, #ordem})
class Marcacoes extends Table {
  @override
  String get tableName => 'marcacao';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get diaId =>
      integer().named('dia_id').references(DiasTrabalho, #id, onDelete: KeyAction.cascade)();
  IntColumn get ordem => integer()();
  TextColumn get tipo => text().map(const ConversorEnum<TipoMarcacao>(TipoMarcacao.values))();
  IntColumn get hora => integer().map(const ConversorMinutos())();
  TextColumn get origem => text()
      .map(const ConversorEnum<OrigemMarcacao>(OrigemMarcacao.values))
      .withDefault(const Constant('MANUAL'))();
  BoolColumn get editada => boolean().withDefault(const Constant(false))();
  DateTimeColumn get criadoEm => dateTime().named('criado_em').withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {diaId, hora}, // RN-04
      ];
}

@DataClassName('FeriadoLinha')
@TableIndex(name: 'idx_feriado_data', columns: {#data})
class Feriados extends Table {
  @override
  String get tableName => 'feriado';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get data => text().map(const ConversorData())();
  TextColumn get descricao => text()();
  BoolColumn get recorrenteAnual =>
      boolean().named('recorrente_anual').withDefault(const Constant(true))();
  TextColumn get abrangencia => text()
      .map(const ConversorEnum<AbrangenciaFeriado>(AbrangenciaFeriado.values))
      .withDefault(const Constant('NACIONAL'))();
}

@DataClassName('ModeloPlanilhaLinha')
class ModelosPlanilha extends Table {
  @override
  String get tableName => 'modelo_planilha';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get caminhoArquivoBase => text().named('caminho_arquivo_base')();
  TextColumn get nomeArquivoOriginal => text().named('nome_arquivo_original')();
  TextColumn get hashArquivo => text().named('hash_arquivo')();
  TextColumn get nomeAba => text().named('nome_aba')();
  IntColumn get linhaCabecalho => integer().named('linha_cabecalho').nullable()();
  IntColumn get primeiraLinhaDados => integer().named('primeira_linha_dados')();
  IntColumn get ultimaLinhaDados => integer().named('ultima_linha_dados').nullable()();
  TextColumn get estrategiaLinha => text()
      .named('estrategia_linha')
      .map(const ConversorEnum<EstrategiaLinha>(EstrategiaLinha.values))();
  TextColumn get formatoData => text()
      .named('formato_data')
      .map(const ConversorEnum<FormatoData>(FormatoData.values))
      .withDefault(const Constant('DD_MM_AAAA'))();
  TextColumn get formatoHora => text()
      .named('formato_hora')
      .map(const ConversorEnum<FormatoHora>(FormatoHora.values))
      .withDefault(const Constant('HH_MM'))();
  BoolColumn get escreverComoTexto =>
      boolean().named('escrever_como_texto').withDefault(const Constant(true))();
  IntColumn get diaInicioCompetencia =>
      integer().named('dia_inicio_competencia').withDefault(const Constant(1))();
  BoolColumn get ativo => boolean()();
  DateTimeColumn get criadoEm => dateTime().named('criado_em').withDefault(currentDateAndTime)();
  DateTimeColumn get atualizadoEm =>
      dateTime().named('atualizado_em').withDefault(currentDateAndTime)();
}

@DataClassName('MapeamentoColunaLinha')
class MapeamentosColuna extends Table {
  @override
  String get tableName => 'mapeamento_coluna';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get modeloId => integer()
      .named('modelo_id')
      .references(ModelosPlanilha, #id, onDelete: KeyAction.cascade)();
  TextColumn get campo => text().map(const ConversorEnum<CampoColuna>(CampoColuna.values))();
  IntColumn get indiceColuna => integer().named('indice_coluna')();
  TextColumn get rotuloCabecalho => text().named('rotulo_cabecalho').nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {modeloId, campo},
      ];
}

@DataClassName('CelulaFixaLinha')
class CelulasFixas extends Table {
  @override
  String get tableName => 'celula_fixa';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get modeloId => integer()
      .named('modelo_id')
      .references(ModelosPlanilha, #id, onDelete: KeyAction.cascade)();
  TextColumn get campo =>
      text().map(const ConversorEnum<CampoCelulaFixa>(CampoCelulaFixa.values))();
  TextColumn get referenciaCelula => text().named('referencia_celula')();
  TextColumn get valorLivre => text().named('valor_livre').nullable()();
}

@DataClassName('TextoStatusLinha')
class TextosStatus extends Table {
  @override
  String get tableName => 'texto_status';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get modeloId => integer()
      .named('modelo_id')
      .references(ModelosPlanilha, #id, onDelete: KeyAction.cascade)();
  TextColumn get status => text().map(const ConversorEnum<StatusDia>(StatusDia.values))();
  TextColumn get texto => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {modeloId, status},
      ];
}

@DataClassName('ConfiguracaoEmailLinha')
class ConfiguracoesEmail extends Table {
  @override
  String get tableName => 'configuracao_email';

  IntColumn get id => integer().autoIncrement()();

  /// E-mails separados por ponto e vírgula.
  TextColumn get destinatarios => text()();
  TextColumn get copia => text().nullable()();
  TextColumn get assuntoModelo => text().named('assunto_modelo')();
  TextColumn get corpoModelo => text().named('corpo_modelo')();
  TextColumn get templateNomeArquivo => text().named('template_nome_arquivo')();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();
}

@DataClassName('EnvioMensalLinha')
@TableIndex(name: 'idx_envio_competencia', columns: {#competenciaAno, #competenciaMes})
class EnviosMensais extends Table {
  @override
  String get tableName => 'envio_mensal';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get modeloId => integer()
      .named('modelo_id')
      .nullable()
      .references(ModelosPlanilha, #id, onDelete: KeyAction.setNull)();
  IntColumn get competenciaAno => integer().named('competencia_ano')();
  IntColumn get competenciaMes => integer().named('competencia_mes')();
  TextColumn get status => text().map(const ConversorEnum<StatusEnvio>(StatusEnvio.values))();
  DateTimeColumn get geradoEm => dateTime().named('gerado_em')();
  TextColumn get caminhoArquivo => text().named('caminho_arquivo')();
  TextColumn get nomeArquivo => text().named('nome_arquivo')();
  IntColumn get tamanhoBytes => integer().named('tamanho_bytes')();
  DateTimeColumn get enviadoEm => dateTime().named('enviado_em').nullable()();
  TextColumn get observacao => text().nullable()();
}

@DataClassName('ConfiguracaoNotificacaoLinha')
class ConfiguracoesNotificacao extends Table {
  @override
  String get tableName => 'configuracao_notificacao';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get tipo =>
      text().map(const ConversorEnum<TipoNotificacao>(TipoNotificacao.values)).unique()();
  BoolColumn get ativa => boolean().withDefault(const Constant(false))();
  IntColumn get hora => integer().nullable()();
  IntColumn get antecedenciaMinutos =>
      integer().named('antecedencia_minutos').withDefault(const Constant(0))();
  IntColumn get diaReferencia => integer().named('dia_referencia').nullable()();
}
