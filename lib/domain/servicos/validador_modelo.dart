import 'package:collection/collection.dart';

import '../entidades/conteudo_planilha.dart';
import '../entidades/modelo_planilha.dart';
import '../entidades/referencia_celula.dart';
import '../enums/enums.dart';
import '../enums/rotulos.dart';

/// Resultado de uma validação do wizard: [erros] bloqueiam o avanço; [alertas] apenas
/// informam (docs/10, seção 10.6).
class ResultadoValidacao {
  final List<String> erros;
  final List<String> alertas;

  ResultadoValidacao({List<String> erros = const [], List<String> alertas = const []})
      : erros = List.unmodifiable(erros),
        alertas = List.unmodifiable(alertas);

  bool get valido => erros.isEmpty;

  ResultadoValidacao somar(ResultadoValidacao outro) => ResultadoValidacao(
        erros: [...erros, ...outro.erros],
        alertas: [...alertas, ...outro.alertas],
      );
}

/// Validações do modelo de planilha, passo a passo e completas.
class ValidadorModelo {
  const ValidadorModelo();

  /// Passo 2: aba e linhas.
  ResultadoValidacao validarLinhas({
    required int? linhaCabecalho,
    required int primeiraLinhaDados,
    required int? ultimaLinhaDados,
    AbaPlanilha? aba,
  }) {
    final erros = <String>[];
    if (primeiraLinhaDados < 1) {
      erros.add('Escolha a primeira linha de dados.');
    }
    if (linhaCabecalho != null && primeiraLinhaDados <= linhaCabecalho) {
      erros.add('A primeira linha de dados precisa vir depois da linha de cabeçalho.');
    }
    if (ultimaLinhaDados != null && ultimaLinhaDados < primeiraLinhaDados) {
      erros.add('A última linha de dados precisa vir depois da primeira.');
    }
    if (aba != null && linhaCabecalho != null) {
      final temTexto = List.generate(aba.totalColunas, (c) => aba.texto(linhaCabecalho, c))
          .any((t) => t.trim().isNotEmpty);
      if (!temTexto) erros.add('A linha de cabeçalho escolhida está vazia.');
    }
    return ResultadoValidacao(erros: erros);
  }

  /// Passo 3: colunas. A data é obrigatória (RN-18); coluna repetida só alerta.
  ResultadoValidacao validarColunas(
    Map<CampoColuna, int> colunas, {
    AbaPlanilha? aba,
    int? primeiraLinhaDados,
    int? ultimaLinhaDados,
  }) {
    final erros = <String>[];
    final alertas = <String>[];

    if (!colunas.containsKey(CampoColuna.data)) {
      erros.add('Escolha a coluna da data para continuar. Sem ela o app não sabe onde '
          'escrever cada dia.');
    }

    final porColuna = groupBy(colunas.entries, (MapEntry<CampoColuna, int> e) => e.value);
    for (final grupo in porColuna.values.where((g) => g.length > 1)) {
      final campos = grupo.map((e) => e.key).toSet();
      if (campos.length == 2 &&
          campos.contains(CampoColuna.observacao) &&
          campos.contains(CampoColuna.status)) {
        alertas.add('Observação e Status vão para a mesma coluna. O status tem prioridade.');
      } else {
        final nomes = campos.map((c) => c.rotulo).toList();
        final ultimo = nomes.removeLast();
        alertas.add('${nomes.join(', ')} e $ultimo vão para a mesma coluna. Só o último '
            'valor escrito fica na planilha.');
      }
    }

    if (aba != null && primeiraLinhaDados != null) {
      final fim = ultimaLinhaDados ?? aba.totalLinhas;
      for (final coluna in colunas.values.toSet()) {
        final temFormula = [
          for (var linha = primeiraLinhaDados; linha <= fim; linha++) aba.celula(linha, coluna)
        ].any((c) => c?.temFormula ?? false);
        if (temFormula) {
          alertas.add('A coluna ${ReferenciaCelula.letraDaColuna(coluna)} tem fórmulas na '
              'área de dados. Escrever nela vai apagá-las.');
        }
      }
    }

    return ResultadoValidacao(erros: erros, alertas: alertas);
  }

  /// Passo 4: células fixas.
  ResultadoValidacao validarCelulasFixas(List<CelulaFixa> celulas, {AbaPlanilha? aba}) {
    final erros = <String>[];
    final alertas = <String>[];
    for (final celula in celulas) {
      final referencia = ReferenciaCelula.deA1(celula.referencia);
      if (referencia == null) {
        erros.add('"${celula.referencia}" não é uma célula. Use o formato B3.');
        continue;
      }
      if (aba == null) continue;
      if (!aba.contem(referencia)) {
        erros.add('A célula ${referencia.a1} não existe nesta aba.');
      } else if (aba.celula(referencia.linha, referencia.coluna)?.temFormula ?? false) {
        alertas.add('A célula ${referencia.a1} tem uma fórmula. Escrever nela vai apagá-la.');
      }
    }
    return ResultadoValidacao(erros: erros, alertas: alertas);
  }

  /// Validação completa, antes de salvar e antes de gerar.
  ResultadoValidacao validar(ModeloPlanilha modelo, {AbaPlanilha? aba}) {
    return validarLinhas(
      linhaCabecalho: modelo.linhaCabecalho,
      primeiraLinhaDados: modelo.primeiraLinhaDados,
      ultimaLinhaDados: modelo.ultimaLinhaDados,
      aba: aba,
    )
        .somar(validarColunas(
          modelo.colunas,
          aba: aba,
          primeiraLinhaDados: modelo.primeiraLinhaDados,
          ultimaLinhaDados: modelo.ultimaLinhaDados,
        ))
        .somar(validarCelulasFixas(modelo.celulasFixas, aba: aba));
  }
}
