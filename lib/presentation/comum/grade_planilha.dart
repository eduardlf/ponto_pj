import 'package:flutter/material.dart';

import '../../app/tema.dart';
import '../../domain/entidades/conteudo_planilha.dart';
import '../../domain/entidades/referencia_celula.dart';

enum ModoSelecao { nenhum, linha, celula }

/// A planilha real do usuário, rolável nas duas direções (docs/04, seção 4.5). Mostrar o
/// arquivo de verdade, e não um desenho abstrato, é o princípio 4 do produto.
class GradePlanilha extends StatefulWidget {
  final AbaPlanilha aba;
  final ModoSelecao modo;

  /// Linhas destacadas e o rótulo de cada uma, ex.: cabeçalho, dados.
  final Map<int, String> linhasMarcadas;
  final Set<ReferenciaCelula> celulasMarcadas;

  /// Valores que o app escreveria, exibidos por cima do conteúdo original (TL-20).
  final Map<ReferenciaCelula, String> valoresSobrepostos;
  final ValueChanged<int>? aoTocarLinha;
  final ValueChanged<ReferenciaCelula>? aoTocarCelula;
  final double altura;

  /// Linha que a grade mostra ao abrir.
  final int? linhaInicial;

  const GradePlanilha({
    super.key,
    required this.aba,
    this.modo = ModoSelecao.nenhum,
    this.linhasMarcadas = const {},
    this.celulasMarcadas = const {},
    this.valoresSobrepostos = const {},
    this.aoTocarLinha,
    this.aoTocarCelula,
    this.altura = 360,
    this.linhaInicial,
  });

  @override
  State<GradePlanilha> createState() => _GradePlanilhaState();
}

class _GradePlanilhaState extends State<GradePlanilha> {
  static const _larguraNumero = 44.0;
  static const _larguraCelula = 96.0;
  static const _alturaLinha = 48.0;

  late final _horizontal = ScrollController();
  late final _vertical = ScrollController(
    initialScrollOffset: ((widget.linhaInicial ?? 1) - 2).clamp(0, 100000) * _alturaLinha,
  );

  @override
  void dispose() {
    _horizontal.dispose();
    _vertical.dispose();
    super.dispose();
  }

  int get _linhas {
    final sobrepostas = widget.valoresSobrepostos.keys.fold(0, (m, r) => r.linha > m ? r.linha : m);
    final conteudo = [widget.aba.ultimaLinhaComConteudo, sobrepostas, ...widget.linhasMarcadas.keys]
        .fold(0, (m, v) => v > m ? v : m);
    return (conteudo + 3).clamp(1, 400);
  }

  int get _colunas {
    final sobrepostas =
        widget.valoresSobrepostos.keys.fold(-1, (m, r) => r.coluna > m ? r.coluna : m);
    final conteudo = [widget.aba.ultimaColunaComConteudo, sobrepostas, widget.aba.totalColunas - 1]
        .fold(-1, (m, v) => v > m ? v : m);
    return (conteudo + 2).clamp(1, 40);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colunas = _colunas;
    final largura = _larguraNumero + colunas * _larguraCelula;

    return Container(
      height: widget.altura,
      decoration: BoxDecoration(
        border: Border.all(color: tema.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Scrollbar(
        controller: _horizontal,
        child: SingleChildScrollView(
          controller: _horizontal,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: largura,
            child: Column(
              children: [
                _cabecalhoColunas(context, colunas),
                Expanded(
                  child: Scrollbar(
                    controller: _vertical,
                    child: ListView.builder(
                      controller: _vertical,
                      itemExtent: _alturaLinha,
                      itemCount: _linhas,
                      itemBuilder: (context, i) => _linha(context, i + 1, colunas),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cabecalhoColunas(BuildContext context, int colunas) {
    final tema = Theme.of(context);
    return ExcludeSemantics(
      child: Container(
        height: 32,
        color: tema.colorScheme.surfaceContainerHighest,
        child: Row(
          children: [
            const SizedBox(width: _larguraNumero),
            for (var c = 0; c < colunas; c++)
              SizedBox(
                width: _larguraCelula,
                child: Center(
                  child: Text(ReferenciaCelula.letraDaColuna(c), style: tema.textTheme.labelMedium),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _linha(BuildContext context, int linha, int colunas) {
    final tema = Theme.of(context);
    final rotulo = widget.linhasMarcadas[linha];
    final marcada = rotulo != null;
    final corMarcada = tema.colorScheme.primaryContainer;

    final conteudo = Row(
      children: [
        Container(
          width: _larguraNumero,
          alignment: Alignment.center,
          color: marcada ? tema.colorScheme.primary : tema.colorScheme.surfaceContainerHighest,
          child: Text('$linha',
              style: tema.textTheme.labelMedium?.copyWith(
                  color: marcada ? tema.colorScheme.onPrimary : null,
                  fontFeatures: algarismosTabulares)),
        ),
        for (var c = 0; c < colunas; c++) _celula(context, ReferenciaCelula(linha, c), marcada),
      ],
    );

    if (widget.modo != ModoSelecao.linha) {
      return Container(color: marcada ? corMarcada.withOpacity(0.4) : null, child: conteudo);
    }
    final textos = [for (var c = 0; c < colunas; c++) widget.aba.texto(linha, c)]
        .where((t) => t.trim().isNotEmpty)
        .take(4)
        .join(', ');
    return Semantics(
      button: true,
      selected: marcada,
      label: 'Linha $linha${rotulo == null ? '' : ', $rotulo'}${textos.isEmpty ? ', vazia' : ': $textos'}',
      excludeSemantics: true,
      child: InkWell(
        onTap: widget.aoTocarLinha == null ? null : () => widget.aoTocarLinha!(linha),
        child: Container(color: marcada ? corMarcada.withOpacity(0.6) : null, child: conteudo),
      ),
    );
  }

  Widget _celula(BuildContext context, ReferenciaCelula ref, bool linhaMarcada) {
    final tema = Theme.of(context);
    final original = widget.aba.celula(ref.linha, ref.coluna);
    final sobreposto = widget.valoresSobrepostos[ref];
    final marcada = widget.celulasMarcadas.contains(ref);
    final texto = sobreposto ?? original?.texto ?? '';
    final destaque = sobreposto != null;

    final celula = Container(
      width: _larguraCelula,
      height: _alturaLinha,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: marcada
            ? tema.colorScheme.primary
            : destaque
                ? CoresPonto.de(context).credito.withOpacity(0.18)
                : null,
        border: Border(
          right: BorderSide(color: tema.colorScheme.outlineVariant),
          bottom: BorderSide(color: tema.colorScheme.outlineVariant),
        ),
      ),
      child: Text(
        texto,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: tema.textTheme.bodySmall?.copyWith(
          color: marcada ? tema.colorScheme.onPrimary : null,
          fontWeight: destaque || linhaMarcada ? FontWeight.w600 : null,
          fontStyle: original?.temFormula == true && !destaque ? FontStyle.italic : null,
        ),
      ),
    );

    if (widget.modo != ModoSelecao.celula) return celula;
    return Semantics(
      button: true,
      selected: marcada,
      label: 'coluna ${ref.letra}, linha ${ref.linha}, '
          '${texto.isEmpty ? 'vazia' : 'valor $texto'}'
          '${original?.temFormula == true ? ', com fórmula' : ''}',
      excludeSemantics: true,
      child: InkWell(
        onTap: widget.aoTocarCelula == null ? null : () => widget.aoTocarCelula!(ref),
        child: celula,
      ),
    );
  }
}
