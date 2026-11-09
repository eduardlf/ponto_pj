import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/resultado.dart';
import '../../domain/entidades/configuracao_email.dart';
import '../../domain/entidades/perfil_usuario.dart';
import '../comum/componentes.dart';
import '../comum/interacao.dart';

final perfilAtualProvider = FutureProvider.autoDispose<PerfilUsuario?>((ref) {
  ref.watch(versaoDadosProvider);
  return ref.watch(perfilRepositorioProvider).buscar();
});

/// Salva o perfil e avisa as telas que dependem dele.
Future<Resultado<void>> salvarPerfil(WidgetRef ref, PerfilUsuario perfil) async {
  final resultado = await ref.read(perfilRepositorioProvider).salvar(perfil);
  if (resultado.ehSucesso) ref.read(versaoDadosProvider.notifier).state++;
  return resultado;
}

/// TL-02: nome, matrícula, cargo, empresa e e-mail (RF-01).
class PerfilTela extends ConsumerWidget {
  const PerfilTela({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = ref.watch(perfilAtualProvider);
    return TelaAssincrona(
      titulo: 'Seus dados',
      valor: perfil,
      onTentarDeNovo: () => ref.invalidate(perfilAtualProvider),
      construtor: (p) => FormularioPerfil(
        inicial: p,
        rotuloSalvar: 'Salvar',
        envolverEmTela: true,
        aoSalvar: (novo) async {
          final resultado = await salvarPerfil(ref, novo);
          if (!context.mounted) return false;
          resultado.quando(
            sucesso: (_) => mostrarMensagem(context, 'Dados salvos.'),
            erro: (falha) => mostrarFalha(context, falha),
          );
          return resultado.ehSucesso;
        },
      ),
    );
  }
}

/// Formulário do perfil, usado nas configurações e no onboarding.
class FormularioPerfil extends StatefulWidget {
  final PerfilUsuario? inicial;
  final String rotuloSalvar;

  /// Devolve verdadeiro quando salvou.
  final Future<bool> Function(PerfilUsuario perfil) aoSalvar;
  final Widget? acaoSecundaria;

  /// Nas configurações o formulário tem barra própria e protege a saída.
  final bool envolverEmTela;

  const FormularioPerfil({
    super.key,
    required this.inicial,
    required this.rotuloSalvar,
    required this.aoSalvar,
    this.acaoSecundaria,
    this.envolverEmTela = false,
  });

  @override
  State<FormularioPerfil> createState() => _FormularioPerfilState();
}

class _FormularioPerfilState extends State<FormularioPerfil> {
  final _formulario = GlobalKey<FormState>();
  late final _nome = TextEditingController(text: widget.inicial?.nome);
  late final _matricula = TextEditingController(text: widget.inicial?.matricula);
  late final _cargo = TextEditingController(text: widget.inicial?.cargo);
  late final _empresa = TextEditingController(text: widget.inicial?.empresa);
  late final _email = TextEditingController(text: widget.inicial?.email);
  var _alterado = false;
  var _salvando = false;

  @override
  void dispose() {
    for (final c in [_nome, _matricula, _cargo, _empresa, _email]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formulario.currentState!.validate()) return;
    setState(() => _salvando = true);
    final salvou = await widget.aoSalvar(PerfilUsuario(
      nome: _nome.text.trim(),
      matricula: _matricula.text,
      cargo: _cargo.text,
      empresa: _empresa.text,
      email: _email.text.trim(),
    ));
    if (!mounted) return;
    setState(() {
      _salvando = false;
      if (salvou) _alterado = false;
    });
  }

  Widget _campo(TextEditingController controle, String rotulo,
      {String? dica, TextInputType? teclado, String? Function(String?)? validar,
      TextCapitalization capitalizacao = TextCapitalization.none}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controle,
        keyboardType: teclado,
        textCapitalization: capitalizacao,
        validator: validar,
        onChanged: (_) {
          if (!_alterado) setState(() => _alterado = true);
        },
        decoration: InputDecoration(labelText: rotulo, helperText: dica),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formulario = Form(
      key: _formulario,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Esses dados vão nas células da planilha e no e-mail ao RH.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          _campo(_nome, 'Nome completo',
              capitalizacao: TextCapitalization.words,
              validar: (v) => v == null || v.trim().isEmpty ? 'Informe seu nome.' : null),
          _campo(_matricula, 'Matrícula ou código', dica: 'Opcional'),
          _campo(_cargo, 'Cargo', dica: 'Opcional', capitalizacao: TextCapitalization.sentences),
          _campo(_empresa, 'Empresa', dica: 'Opcional', capitalizacao: TextCapitalization.words),
          _campo(_email, 'Seu e-mail',
              dica: 'Opcional',
              teclado: TextInputType.emailAddress,
              validar: (v) => v == null || v.trim().isEmpty || ConfiguracaoEmail.enderecoValido(v.trim())
                  ? null
                  : 'Esse e-mail não parece válido.'),
          FilledButton(
            onPressed: _salvando ? null : _salvar,
            child: Text(_salvando ? 'Salvando…' : widget.rotuloSalvar),
          ),
          if (widget.acaoSecundaria != null) ...[
            const SizedBox(height: 8),
            widget.acaoSecundaria!,
          ],
        ],
      ),
    );

    if (!widget.envolverEmTela) return formulario;
    return ProtecaoSaida(
      alterado: _alterado,
      child: Scaffold(appBar: AppBar(title: const Text('Seus dados')), body: formulario),
    );
  }
}
