import 'package:flutter/material.dart';

import '../../../app/tema.dart';
import '../../../core/formatadores.dart';
import '../../../domain/entidades/marcacao.dart';
import '../../../domain/entidades/turno.dart';
import '../../../domain/enums/enums.dart';

/// Marcações do dia como linha do tempo vertical: turnos, intervalos e a previsão de
/// saída esmaecida (RF-12). O leitor de tela ouve "Entrada às 08:00", não "seta 08:00".
class LinhaDoTempoMarcacoes extends StatelessWidget {
  final List<Marcacao> marcacoes;
  final List<Turno> turnos;
  final List<Intervalo> intervalos;

  /// Tempo do turno aberto, quando o dia está em andamento.
  final Duration? turnoEmCurso;
  final Duration? previsaoSaida;
  final bool cargaCumprida;
  final ValueChanged<Marcacao> onTocar;
  final Future<bool> Function(Marcacao) onExcluir;

  const LinhaDoTempoMarcacoes({
    super.key,
    required this.marcacoes,
    required this.turnos,
    required this.intervalos,
    required this.onTocar,
    required this.onExcluir,
    this.turnoEmCurso,
    this.previsaoSaida,
    this.cargaCumprida = false,
  });

  @override
  Widget build(BuildContext context) {
    final itens = <Widget>[];
    for (var i = 0; i < marcacoes.length; i++) {
      itens.add(_ItemMarcacao(
        marcacao: marcacoes[i],
        onTocar: () => onTocar(marcacoes[i]),
        onExcluir: () => onExcluir(marcacoes[i]),
      ));
      final turno = i ~/ 2;
      if (i.isEven && i + 1 < marcacoes.length && turno < turnos.length) {
        final t = turnos[turno];
        itens.add(_Trecho(
          texto: t.valido
              ? 'Turno de ${formatarDuracao(t.duracao)}'
              : 'Turno inválido: a saída vem antes da entrada',
          continuo: true,
          alerta: !t.valido,
        ));
      } else if (i.isOdd && i + 1 < marcacoes.length && turno < intervalos.length) {
        itens.add(_Trecho(
          texto: 'Intervalo de ${formatarDuracao(intervalos[turno].duracao)}',
          continuo: false,
        ));
      } else if (i == marcacoes.length - 1 && turnoEmCurso != null) {
        itens.add(_Trecho(texto: 'Em curso: ${formatarDuracao(turnoEmCurso!)}', continuo: true));
      }
    }
    if (previsaoSaida != null) {
      itens.add(_Previsao(hora: previsaoSaida!, cumprida: cargaCumprida));
    }
    return Semantics(
      container: true,
      label: 'Marcações do dia',
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: itens),
    );
  }
}

class _ItemMarcacao extends StatelessWidget {
  final Marcacao marcacao;
  final VoidCallback onTocar;
  final Future<bool> Function() onExcluir;

  const _ItemMarcacao({required this.marcacao, required this.onTocar, required this.onExcluir});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = CoresPonto.de(context);
    final entrada = marcacao.tipo == TipoMarcacao.entrada;
    final tipo = entrada ? 'Entrada' : 'Saída';
    final hora = formatarHora(marcacao.hora);
    final detalhes = [
      if (marcacao.origem == OrigemMarcacao.manual) 'manual',
      if (marcacao.editada) 'editada',
    ];

    return Dismissible(
      key: ValueKey('marcacao-${marcacao.id}-${marcacao.hora.inMinutes}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => onExcluir(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: cores.debito,
        child: Icon(Icons.delete_outline, color: tema.colorScheme.onError),
      ),
      child: Semantics(
        button: true,
        label: '$tipo às $hora${detalhes.isEmpty ? '' : ', ${detalhes.join(', ')}'}',
        hint: 'Toque para editar ou excluir',
        excludeSemantics: true,
        child: InkWell(
          onTap: onTocar,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(entrada ? Icons.login : Icons.logout,
                      color: entrada ? cores.credito : tema.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 16),
                  Text(hora,
                      style: tema.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600, fontFeatures: algarismosTabulares)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      detalhes.isEmpty ? tipo : '$tipo · ${detalhes.join(' · ')}',
                      style: tema.textTheme.bodyMedium
                          ?.copyWith(color: tema.colorScheme.onSurfaceVariant),
                    ),
                  ),
                  Icon(Icons.more_vert, color: tema.colorScheme.onSurfaceVariant),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Trecho extends StatelessWidget {
  final String texto;
  final bool continuo;
  final bool alerta;

  const _Trecho({required this.texto, required this.continuo, this.alerta = false});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cor = alerta ? CoresPonto.de(context).atencao : tema.colorScheme.outline;
    return Padding(
      padding: const EdgeInsets.only(left: 27),
      child: Row(
        children: [
          SizedBox(
            height: 36,
            child: CustomPaint(painter: _Linha(cor: cor, continua: continuo), size: const Size(2, 36)),
          ),
          const SizedBox(width: 27),
          Expanded(
            child: Text(texto,
                style: tema.textTheme.bodyMedium?.copyWith(
                    color: alerta ? cor : tema.colorScheme.onSurfaceVariant,
                    fontFeatures: algarismosTabulares)),
          ),
        ],
      ),
    );
  }
}

class _Linha extends CustomPainter {
  final Color cor;
  final bool continua;

  const _Linha({required this.cor, required this.continua});

  @override
  void paint(Canvas canvas, Size size) {
    final pincel = Paint()
      ..color = cor
      ..strokeWidth = 2;
    if (continua) {
      canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), pincel);
      return;
    }
    for (var y = 0.0; y < size.height; y += 6) {
      canvas.drawLine(Offset(size.width / 2, y), Offset(size.width / 2, y + 3), pincel);
    }
  }

  @override
  bool shouldRepaint(_Linha antiga) => antiga.cor != cor || antiga.continua != continua;
}

class _Previsao extends StatelessWidget {
  final Duration hora;
  final bool cumprida;

  const _Previsao({required this.hora, required this.cumprida});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cor = CoresPonto.de(context).neutro;
    final rotulo = cumprida ? 'Carga cumprida' : 'Previsão de saída';
    return Semantics(
      label: '$rotulo: ${formatarHora(hora)}',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(cumprida ? Icons.check_circle_outline : Icons.schedule, color: cor),
            const SizedBox(width: 16),
            Text(formatarHora(hora),
                style: tema.textTheme.headlineSmall?.copyWith(
                    color: cor, fontFeatures: algarismosTabulares)),
            const SizedBox(width: 12),
            Expanded(child: Text(rotulo, style: tema.textTheme.bodyMedium?.copyWith(color: cor))),
          ],
        ),
      ),
    );
  }
}
