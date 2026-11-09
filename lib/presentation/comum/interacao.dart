import 'package:flutter/material.dart';

import '../../core/falhas.dart';

/// Pede confirmação antes de algo irreversível (docs/04, princípio 3).
Future<bool> confirmar(
  BuildContext context, {
  required String titulo,
  required String mensagem,
  String rotuloConfirmar = 'Confirmar',
  String rotuloCancelar = 'Cancelar',
  bool destrutivo = false,
}) async {
  final resposta = await showDialog<bool>(
    context: context,
    builder: (context) {
      final cores = Theme.of(context).colorScheme;
      return AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(rotuloCancelar),
          ),
          FilledButton(
            style: destrutivo
                ? FilledButton.styleFrom(backgroundColor: cores.error, foregroundColor: cores.onError)
                : null,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(rotuloConfirmar),
          ),
        ],
      );
    },
  );
  return resposta ?? false;
}

/// Aviso breve na base da tela, com ação opcional como "Desfazer".
void mostrarMensagem(
  BuildContext context,
  String texto, {
  String? rotuloAcao,
  VoidCallback? aoAcionar,
  Duration duracao = const Duration(seconds: 4),
}) {
  final mensageiro = ScaffoldMessenger.of(context);
  mensageiro.hideCurrentSnackBar();
  mensageiro.showSnackBar(SnackBar(
    content: Text(texto),
    duration: duracao,
    action: rotuloAcao == null || aoAcionar == null
        ? null
        : SnackBarAction(label: rotuloAcao, onPressed: aoAcionar),
  ));
}

/// A interface exibe `falha.mensagem` e nunca monta texto de erro (docs/09, seção 9.5).
void mostrarFalha(BuildContext context, Falha falha) => mostrarMensagem(context, falha.mensagem);

/// Seletor de horário em 24 h. Devolve minutos desde a meia-noite.
Future<Duration?> escolherHorario(BuildContext context,
    {required Duration inicial, String? titulo}) async {
  final escolhido = await showTimePicker(
    context: context,
    helpText: titulo,
    cancelText: 'Cancelar',
    confirmText: 'Confirmar',
    hourLabelText: 'Hora',
    minuteLabelText: 'Minuto',
    initialEntryMode: TimePickerEntryMode.dial,
    initialTime: TimeOfDay(hour: inicial.inHours % 24, minute: inicial.inMinutes % 60),
    builder: (context, filho) => MediaQuery(
      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
      child: filho!,
    ),
  );
  if (escolhido == null) return null;
  return Duration(hours: escolhido.hour, minutes: escolhido.minute);
}

/// Seletor de data do sistema. Devolve a data civil (meia-noite UTC).
Future<DateTime?> escolherData(BuildContext context,
    {required DateTime inicial, DateTime? primeira, DateTime? ultima, String? titulo}) async {
  final escolhida = await showDatePicker(
    context: context,
    helpText: titulo,
    cancelText: 'Cancelar',
    confirmText: 'Confirmar',
    initialDate: DateTime(inicial.year, inicial.month, inicial.day),
    firstDate: primeira ?? DateTime(2000),
    lastDate: ultima ?? DateTime(2100),
  );
  if (escolhida == null) return null;
  return DateTime.utc(escolhida.year, escolhida.month, escolhida.day);
}

/// Formulário com alterações não salvas pede confirmação antes de sair (princípio 3).
class ProtecaoSaida extends StatelessWidget {
  final bool alterado;
  final Widget child;

  const ProtecaoSaida({super.key, required this.alterado, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !alterado,
      onPopInvokedWithResult: (saiu, _) async {
        if (saiu) return;
        final navegador = Navigator.of(context);
        final descartar = await confirmar(
          context,
          titulo: 'Descartar alterações?',
          mensagem: 'O que você mudou nesta tela ainda não foi salvo.',
          rotuloConfirmar: 'Descartar',
          destrutivo: true,
        );
        if (descartar) navegador.pop();
      },
      child: child,
    );
  }
}
