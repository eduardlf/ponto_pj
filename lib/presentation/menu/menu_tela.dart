import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// TL-11: tudo o que não é o dia a dia.
class MenuTela extends StatelessWidget {
  const MenuTela({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.view_week_outlined),
            title: const Text('Semana'),
            subtitle: const Text('Os sete dias com totais e saldo'),
            onTap: () => context.go('/menu/semana'),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text('Mês'),
            subtitle: const Text('Calendário com o resumo de cada dia'),
            onTap: () => context.go('/menu/mes'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.outgoing_mail),
            title: const Text('Fechamento do mês'),
            subtitle: const Text('Gerar a planilha e enviar ao RH'),
            onTap: () => context.push('/fechamento'),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Histórico de envios'),
            subtitle: const Text('Planilhas geradas e enviadas'),
            onTap: () => context.go('/menu/historico'),
          ),
        ],
      ),
    );
  }
}
