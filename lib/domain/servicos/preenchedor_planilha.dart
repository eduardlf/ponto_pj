import '../../core/datas_excel.dart';
import '../../core/extensoes/data_extensoes.dart';
import '../../core/falhas.dart';
import '../../core/formatadores.dart';
import '../../core/resultado.dart';
import '../entidades/competencia.dart';
import '../entidades/conteudo_planilha.dart';
import '../entidades/dia_trabalho.dart';
import '../entidades/modelo_planilha.dart';
import '../entidades/perfil_usuario.dart';
import '../entidades/plano_de_escrita.dart';
import '../entidades/referencia_celula.dart';
import '../entidades/resumo_periodo.dart';
import '../enums/enums.dart';

/// Decide O QUE escrever e ONDE (docs/10, seção 10.4). Dart puro, sem tocar em arquivo: a
/// pré-visualização do wizard e a geração real usam exatamente este mesmo código.
abstract interface class PreenchedorPlanilha {
  /// [aba] é o conteúdo lido da aba do modelo; obrigatório na estratégia por data, que
  /// procura cada dia na coluna de data.
  Resultado<ResultadoPreenchimento> preencher({
    required ModeloPlanilha modelo,
    required Competencia competencia,
    required List<DiaTrabalho> dias,
    required PerfilUsuario? perfil,
    required ResumoPeriodo resumo,
    required DateTime dataGeracao,
    AbaPlanilha? aba,
    bool sistemaData1904 = false,
  });
}

class PreenchedorPlanilhaPadrao implements PreenchedorPlanilha {
  const PreenchedorPlanilhaPadrao();

  @override
  Resultado<ResultadoPreenchimento> preencher({
    required ModeloPlanilha modelo,
    required Competencia competencia,
    required List<DiaTrabalho> dias,
    required PerfilUsuario? perfil,
    required ResumoPeriodo resumo,
    required DateTime dataGeracao,
    AbaPlanilha? aba,
    bool sistemaData1904 = false,
  }) {
    final colunaData = modelo.colunas[CampoColuna.data];
    if (colunaData == null) {
      return const Erro(FalhaMapeamento(
          'Escolha a coluna da data para continuar. Sem ela o app não sabe onde escrever '
          'cada dia.'));
    }

    // 1. Validação prévia: falha antes de escrever qualquer coisa (RN-21).
    final sequencial = modelo.estrategia == EstrategiaLinha.sequencial;
    final ultima = modelo.ultimaLinhaDados;
    if (sequencial && ultima != null) {
      final disponiveis = ultima - modelo.primeiraLinhaDados + 1;
      if (competencia.totalDias() > disponiveis) {
        return Erro(FalhaMapeamento(
            'A competência tem ${competencia.totalDias()} dias, mas a planilha só tem '
            '$disponiveis linhas livres a partir da linha ${modelo.primeiraLinhaDados}. '
            'Confira a primeira linha de dados.'));
      }
    }

    // 2. Índice de datas, apenas na estratégia por data. Construído uma única vez.
    final indiceDatas = <DateTime, int>{};
    if (!sequencial) {
      if (aba == null) {
        return const Erro(FalhaMapeamento(
            'Não consegui ler as datas da planilha modelo. Importe o arquivo de novo.'));
      }
      final fim = ultima ?? aba.totalLinhas;
      for (var linha = modelo.primeiraLinhaDados; linha <= fim; linha++) {
        final celula = aba.celula(linha, colunaData);
        final data = celula == null
            ? null
            : interpretarData(celula, competencia, sistemaData1904: sistemaData1904);
        if (data != null) indiceDatas.putIfAbsent(data, () => linha);
      }
    }

    final escrita = _Escrita(modelo, PlanoDeEscrita(nomeAba: modelo.nomeAba));
    final naoResolvidos = <DateTime>[];
    final avisos = <String>[];

    // 3. Um dia de cada vez.
    for (final dia in dias) {
      if (!competencia.contem(dia.data)) continue;
      final linha = sequencial
          ? modelo.primeiraLinhaDados + competencia.posicaoDe(dia.data) - 1
          : indiceDatas[dia.data];
      if (linha == null) {
        naoResolvidos.add(dia.data);
        avisos.add('Não achei a linha do dia ${formatarDiaMes(dia.data)} na planilha. '
            'Esse dia ficou de fora.');
        continue;
      }
      final aviso = _escreverDia(escrita, linha, dia);
      if (aviso != null) avisos.add(aviso);
    }

    // 4. Células fixas: puladas quando o dado de origem é vazio.
    for (final celula in modelo.celulasFixas) {
      final referencia = ReferenciaCelula.deA1(celula.referencia);
      if (referencia == null) continue;
      final valor = _valorCelulaFixa(escrita, celula, perfil, competencia, resumo, dataGeracao);
      if (valor != null) escrita.plano.celulas[referencia] = valor;
    }

    return Sucesso(ResultadoPreenchimento(
      plano: escrita.plano,
      diasNaoResolvidos: naoResolvidos,
      avisos: avisos,
    ));
  }

  /// Escreve uma linha. Devolve o aviso de truncamento, se houver.
  String? _escreverDia(_Escrita escrita, int linha, DiaTrabalho dia) {
    final modelo = escrita.modelo;
    String? aviso;

    escrita.coluna(linha, CampoColuna.data, escrita.data(dia.data));
    escrita.coluna(
        linha, CampoColuna.diaSemana, TextoCelula(_diaSemanaSemPonto(dia.data.weekday)));

    final textoStatus =
        dia.status == StatusDia.normal ? null : modelo.textoDoStatus(dia.status);
    final colunaStatus = modelo.colunas[CampoColuna.status];

    if (textoStatus != null) {
      // Dia não trabalhado: o texto vai na coluna de status ou, sem ela, sobre a primeira
      // coluna de horário; as demais colunas de horário são limpas.
      final colunaAlvo = colunaStatus ?? modelo.colunas[CampoColuna.entrada1];
      for (final campo in CampoColuna.horarios) {
        final coluna = modelo.colunas[campo];
        if (coluna != null && coluna != colunaAlvo) {
          escrita.em(linha, coluna, const VaziaCelula());
        }
      }
      if (colunaAlvo != null) escrita.em(linha, colunaAlvo, TextoCelula(textoStatus));
    } else {
      // Marcações em pares, na ordem: ENTRADA_1, SAIDA_1, ENTRADA_2... As colunas que
      // sobram são limpas, para que nada do modelo se misture ao dia.
      final marcacoes = dia.marcacoes;
      var foraDaPlanilha = false;
      for (var i = 0; i < marcacoes.length; i++) {
        final cabe =
            i < CampoColuna.horarios.length && modelo.colunas.containsKey(CampoColuna.horarios[i]);
        if (!cabe) foraDaPlanilha = true;
      }
      for (var i = 0; i < CampoColuna.horarios.length; i++) {
        final campo = CampoColuna.horarios[i];
        escrita.coluna(linha, campo,
            i < marcacoes.length ? escrita.hora(marcacoes[i].hora) : const VaziaCelula());
      }
      if (foraDaPlanilha) {
        final capacidade = CampoColuna.horarios.where(modelo.colunas.containsKey).length;
        aviso = 'O dia ${formatarDiaMes(dia.data)} tem ${marcacoes.length} marcações, mas a '
            'planilha comporta $capacidade. As últimas ficaram de fora.';
      }
    }

    escrita.coluna(linha, CampoColuna.totalDia, escrita.duracao(dia.minutosTrabalhados));
    escrita.coluna(
        linha, CampoColuna.saldoDia, escrita.duracao(dia.saldo, comSinal: true));

    // Status e observação. Na coluna compartilhada, o status tem prioridade e a observação
    // é concatenada: "FERIADO — Natal".
    final colunaObservacao = modelo.colunas[CampoColuna.observacao];
    final observacao = dia.temObservacao ? dia.observacao!.trim() : null;
    if (colunaStatus != null && colunaStatus != colunaObservacao) {
      escrita.em(linha, colunaStatus,
          textoStatus != null ? TextoCelula(textoStatus) : const VaziaCelula());
    }
    if (colunaObservacao != null) {
      String? texto = observacao;
      if (colunaObservacao == colunaStatus && textoStatus != null) {
        texto = observacao == null ? textoStatus : '$textoStatus — $observacao';
      }
      escrita.em(linha, colunaObservacao, texto != null ? TextoCelula(texto) : const VaziaCelula());
    }

    return aviso;
  }

  ValorCelula? _valorCelulaFixa(
    _Escrita escrita,
    CelulaFixa celula,
    PerfilUsuario? perfil,
    Competencia competencia,
    ResumoPeriodo resumo,
    DateTime dataGeracao,
  ) {
    final modelo = escrita.modelo;
    ValorCelula? texto(String? valor) =>
        valor == null || valor.trim().isEmpty ? null : TextoCelula(valor.trim());

    return switch (celula.campo) {
      CampoCelulaFixa.nome => texto(perfil?.nome),
      CampoCelulaFixa.matricula => texto(perfil?.matricula),
      CampoCelulaFixa.cargo => texto(perfil?.cargo),
      CampoCelulaFixa.empresa => texto(perfil?.empresa),
      CampoCelulaFixa.mes => TextoCelula(nomeMes(competencia.mes)),
      CampoCelulaFixa.ano => modelo.escreverComoTexto
          ? TextoCelula('${competencia.ano}')
          : NumeroCelula(competencia.ano),
      CampoCelulaFixa.competencia => modelo.formatoData.nativo
          ? DataCelula(dataCivil(competencia.ano, competencia.mes, 1))
          : TextoCelula(competencia.formatado()),
      CampoCelulaFixa.totalMes => escrita.duracao(resumo.trabalhado),
      CampoCelulaFixa.saldoMes => escrita.duracao(resumo.saldo, comSinal: true),
      CampoCelulaFixa.bancoHoras => escrita.duracao(resumo.bancoHoras, comSinal: true),
      CampoCelulaFixa.dataGeracao => switch (modelo.formatoData) {
          FormatoData.dataExcel => DataCelula(dataGeracao.apenasData),
          FormatoData.aaaaMmDd => TextoCelula(dataGeracao.iso),
          _ => TextoCelula(formatarDataCurta(dataGeracao)),
        },
      CampoCelulaFixa.textoLivre => texto(celula.valorLivre),
    };
  }

  String _diaSemanaSemPonto(int weekday) => abreviacaoDiaSemana(weekday).replaceAll('.', '');
}

/// Lê a data de uma célula da coluna de data: número de série do Excel ou texto em
/// `07/05/2026`, `07/05`, `2026-05-07` ou só o dia. Datas sem ano, ou só com o dia, são
/// procuradas dentro da competência.
DateTime? interpretarData(CelulaLida celula, Competencia competencia,
    {bool sistemaData1904 = false}) {
  final valor = celula.valor;
  if (valor is num) {
    if (!celula.ehDataHora && valor >= 1 && valor <= 31 && valor == valor.floor()) {
      return _diaNaCompetencia(valor.toInt(), null, competencia);
    }
    if (valor < 1) return null;
    return dataDeSerial(valor, sistema1904: sistemaData1904);
  }

  final texto = (valor is String ? valor : celula.texto).trim();
  if (texto.isEmpty) return null;

  final iso = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})').firstMatch(texto);
  if (iso != null) {
    return _dataValida(
        int.parse(iso.group(1)!), int.parse(iso.group(2)!), int.parse(iso.group(3)!));
  }

  final brasileira = RegExp(r'^(\d{1,2})[/.\-](\d{1,2})(?:[/.\-](\d{2,4}))?').firstMatch(texto);
  if (brasileira != null) {
    final dia = int.parse(brasileira.group(1)!);
    final mes = int.parse(brasileira.group(2)!);
    final anoTexto = brasileira.group(3);
    if (anoTexto == null) return _diaNaCompetencia(dia, mes, competencia);
    var ano = int.parse(anoTexto);
    if (anoTexto.length == 2) ano += 2000;
    return _dataValida(ano, mes, dia);
  }

  final soDia = RegExp(r'^(\d{1,2})$').firstMatch(texto);
  if (soDia != null) return _diaNaCompetencia(int.parse(soDia.group(1)!), null, competencia);
  return null;
}

DateTime? _dataValida(int ano, int mes, int dia) {
  if (mes < 1 || mes > 12 || dia < 1 || dia > 31) return null;
  final data = dataCivil(ano, mes, dia);
  return data.month == mes ? data : null;
}

DateTime? _diaNaCompetencia(int dia, int? mes, Competencia competencia) {
  for (final data in competencia.dias()) {
    if (data.day == dia && (mes == null || data.month == mes)) return data;
  }
  return null;
}

/// Acumula o plano aplicando os formatos do modelo. Escrever em campo não mapeado não faz
/// nada: é o que torna opcionais todos os campos além da data.
class _Escrita {
  final ModeloPlanilha modelo;
  final PlanoDeEscrita plano;

  _Escrita(this.modelo, this.plano);

  void coluna(int linha, CampoColuna campo, ValorCelula valor) {
    final indice = modelo.colunas[campo];
    if (indice != null) em(linha, indice, valor);
  }

  void em(int linha, int coluna, ValorCelula valor) {
    plano.celulas[ReferenciaCelula(linha, coluna)] = valor;
  }

  ValorCelula data(DateTime data) => switch (modelo.formatoData) {
        FormatoData.ddMmAaaa => TextoCelula(formatarDataCurta(data)),
        FormatoData.ddMm => TextoCelula(formatarDiaMes(data)),
        FormatoData.dd => TextoCelula('${data.day}'),
        FormatoData.aaaaMmDd => TextoCelula(data.iso),
        FormatoData.dataExcel => DataCelula(data),
      };

  ValorCelula hora(Duration hora) => switch (modelo.formatoHora) {
        FormatoHora.hhMm => TextoCelula(formatarHora(hora)),
        FormatoHora.hhMmSs => TextoCelula('${formatarHora(hora)}:00'),
        FormatoHora.decimal => TextoCelula(formatarHorasDecimais(hora)),
        FormatoHora.horaExcel => HoraCelula(hora),
      };

  ValorCelula duracao(Duration duracao, {bool comSinal = false}) {
    final sinal = comSinal && duracao > Duration.zero ? '+' : '';
    return switch (modelo.formatoHora) {
      FormatoHora.hhMm => TextoCelula('$sinal${formatarDuracaoRelogio(duracao)}'),
      FormatoHora.hhMmSs =>
        TextoCelula('$sinal${formatarDuracaoRelogio(duracao, comSegundos: true)}'),
      FormatoHora.decimal => TextoCelula('$sinal${formatarHorasDecimais(duracao)}'),
      FormatoHora.horaExcel => HoraCelula(duracao),
    };
  }
}
