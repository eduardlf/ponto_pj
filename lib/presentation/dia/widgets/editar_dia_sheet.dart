import 'package:flutter/material.dart';

import '../../../core/formatadores.dart';
import '../../../core/resultado.dart';
import '../../../domain/entidades/dia_trabalho.dart';
import '../../../domain/enums/enums.dart';
import '../../../domain/enums/rotulos.dart';
import '../../comum/componentes.dart';
import '../../comum/interacao.dart';

/// TL-10: status do dia e observação (RF-13).
Future<void> abrirEditarDia(
  BuildContext context, {
  required DiaTrabalho dia,
  required Future<Resultado<DiaTrabalho>> Function(StatusDia, String?) salvar,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: _EditarDia(dia: dia, salvar: salvar),
    ),
  );
}

class _EditarDia extends StatefulWidget {
  final DiaTrabalho dia;
  final Future<Resultado<DiaTrabalho>> Function(StatusDia, String?) salvar;

  const _EditarDia({required this.dia, required this.salvar});

  @override
  State<_EditarDia> createState() => _EditarDiaState();
}

class _EditarDiaState extends State<_EditarDia> {
  late StatusDia _status = widget.dia.status;
  late final _observacao = TextEditingController(text: widget.dia.observacao ?? '');
  var _salvando = false;

  @override
  void dispose() {
    _observacao.dispose();
    super.dispose();
  }

  String _efeito(StatusDia status) => switch (status) {
        StatusDia.normal || StatusDia.compensacao =>
          'O saldo é o trabalhado menos a carga prevista do dia.',
        StatusDia.falta => 'A carga do dia é descontada do saldo, mesmo com horários registrados.',
        _ => 'A carga do dia é abonada: não conta como débito. Horários registrados viram crédito.',
      };

  Future<void> _salvar() async {
    setState(() => _salvando = true);
    final resultado = await widget.salvar(_status, _observacao.text);
    if (!mounted) return;
    setState(() => _salvando = false);
    resultado.quando(
      sucesso: (_) {
        Navigator.of(context).pop();
        mostrarMensagem(context, 'Dia atualizado.');
      },
      erro: (falha) => mostrarFalha(context, falha),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Como foi ${formatarDataExtensa(widget.dia.data)}?',
                style: tema.textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final status in StatusDia.values)
                  ChoiceChip(
                    avatar: Icon(iconeDoStatus(status), size: 18),
                    label: Text(status.rotulo),
                    selected: _status == status,
                    onSelected: (_) => setState(() => _status = status),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(_efeito(_status),
                style: tema.textTheme.bodySmall
                    ?.copyWith(color: tema.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 16),
            TextField(
              controller: _observacao,
              maxLines: 3,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Observação',
                hintText: 'Ex.: consulta médica pela manhã',
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _salvando ? null : _salvar,
              child: Text(_salvando ? 'Salvando…' : 'Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
