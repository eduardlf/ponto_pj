import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/extensoes/data_extensoes.dart';
import '../../domain/entidades/competencia.dart';
import '../../domain/entidades/configuracao_email.dart';
import '../../domain/servicos/resolvedor_variaveis.dart';
import '../comum/componentes.dart';
import '../comum/interacao.dart';

class EmailEdicao {
  final ConfiguracaoEmail configuracao;
  final ContextoVariaveis contexto;

  const EmailEdicao(this.configuracao, this.contexto);
}

/// Configuração atual e o contexto real (perfil e mês corrente) para a pré-visualização.
final emailEdicaoProvider = FutureProvider.autoDispose<EmailEdicao>((ref) async {
  final configuracao = await ref.watch(configuracaoEmailRepositorioProvider).buscar();
  final perfil = await ref.watch(perfilRepositorioProvider).buscar();
  final modelo = await ref.watch(modeloPlanilhaRepositorioProvider).buscarAtivo();
  final agora = ref.watch(relogioProvider).agora();
  final competencia =
      Competencia.contendo(agora.apenasData, diaInicio: modelo?.diaInicioCompetencia ?? 1);
  final periodo = await ref
      .watch(consultaPeriodoProvider)
      .consultar(competencia.primeiroDia(), competencia.ultimoDia());
  return EmailEdicao(
    configuracao,
    ContextoVariaveis(
        perfil: perfil, competencia: competencia, resumo: periodo.resumo, dataGeracao: agora),
  );
});

/// TL-22: destinatários, assunto, corpo e nome do arquivo, com variáveis (RF-38, RF-39).
class EmailTela extends ConsumerWidget {
  const EmailTela({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edicao = ref.watch(emailEdicaoProvider);
    return TelaAssincrona(
      titulo: 'E-mail',
      valor: edicao,
      onTentarDeNovo: () => ref.invalidate(emailEdicaoProvider),
      construtor: (e) => FormularioEmail(
        edicao: e,
        aoSalvar: (configuracao) async {
          final resultado =
              await ref.read(configuracaoEmailRepositorioProvider).salvar(configuracao);
          if (!context.mounted) return false;
          resultado.quando(
            sucesso: (_) {
              ref.read(versaoDadosProvider.notifier).state++;
              mostrarMensagem(context, 'E-mail salvo.');
            },
            erro: (falha) => mostrarFalha(context, falha),
          );
          return resultado.ehSucesso;
        },
      ),
    );
  }
}

class FormularioEmail extends ConsumerStatefulWidget {
  final EmailEdicao edicao;
  final Future<bool> Function(ConfiguracaoEmail) aoSalvar;

  const FormularioEmail({super.key, required this.edicao, required this.aoSalvar});

  @override
  ConsumerState<FormularioEmail> createState() => _FormularioEmailState();
}

class _FormularioEmailState extends ConsumerState<FormularioEmail> {
  final _formulario = GlobalKey<FormState>();
  late final _para =
      TextEditingController(text: widget.edicao.configuracao.destinatarios.join('; '));
  late final _copia = TextEditingController(text: widget.edicao.configuracao.copia.join('; '));
  late final _assunto = TextEditingController(text: widget.edicao.configuracao.assuntoModelo);
  late final _corpo = TextEditingController(text: widget.edicao.configuracao.corpoModelo);
  late final _arquivo =
      TextEditingController(text: widget.edicao.configuracao.templateNomeArquivo);
  var _alterado = false;

  @override
  void dispose() {
    for (final c in [_para, _copia, _assunto, _corpo, _arquivo]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _validarEnderecos(String? texto, {required bool obrigatorio}) {
    final enderecos = ConfiguracaoEmail.separarEnderecos(texto ?? '');
    if (enderecos.isEmpty) return obrigatorio ? 'Informe ao menos um destinatário.' : null;
    final invalido = enderecos.where((e) => !ConfiguracaoEmail.enderecoValido(e)).firstOrNull;
    return invalido == null ? null : '"$invalido" não parece um e-mail válido.';
  }

  ConfiguracaoEmail get _configuracao => widget.edicao.configuracao.copiaCom(
        destinatarios: ConfiguracaoEmail.separarEnderecos(_para.text),
        copia: ConfiguracaoEmail.separarEnderecos(_copia.text),
        assuntoModelo: _assunto.text,
        corpoModelo: _corpo.text,
        templateNomeArquivo: _arquivo.text,
      );

  @override
  Widget build(BuildContext context) {
    final resolvedor = ref.watch(resolvedorVariaveisProvider);
    final tema = Theme.of(context);
    final contexto = widget.edicao.contexto;

    Widget campo(TextEditingController controle, String rotulo,
        {String? dica, int linhas = 1, String? Function(String?)? validar, TextInputType? teclado}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          controller: controle,
          minLines: linhas,
          maxLines: linhas == 1 ? 1 : null,
          keyboardType: teclado,
          validator: validar,
          onChanged: (_) => setState(() => _alterado = true),
          decoration: InputDecoration(labelText: rotulo, helperText: dica, alignLabelWithHint: true),
        ),
      );
    }

    return ProtecaoSaida(
      alterado: _alterado,
      child: Scaffold(
        appBar: AppBar(title: const Text('E-mail')),
        body: Form(
          key: _formulario,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              campo(_para, 'Para',
                  dica: 'Separe vários e-mails com ponto e vírgula',
                  teclado: TextInputType.emailAddress,
                  validar: (v) => _validarEnderecos(v, obrigatorio: true)),
              campo(_copia, 'Cópia',
                  dica: 'Opcional',
                  teclado: TextInputType.emailAddress,
                  validar: (v) => _validarEnderecos(v, obrigatorio: false)),
              campo(_assunto, 'Assunto',
                  validar: (v) => v == null || v.trim().isEmpty ? 'Informe o assunto.' : null),
              campo(_corpo, 'Mensagem', linhas: 6),
              campo(_arquivo, 'Nome do arquivo',
                  validar: (v) => v == null || v.trim().isEmpty ? 'Informe o nome do arquivo.' : null),
              Text('Você pode usar: ${ResolvedorVariaveis.variaveis.map((v) => '{$v}').join('  ')}',
                  style: tema.textTheme.bodySmall),
              const TituloSecao('Assim vai ficar'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Assunto: ${resolvedor.resolver(_assunto.text, contexto)}',
                          style: tema.textTheme.titleSmall),
                      const SizedBox(height: 8),
                      Text(resolvedor.resolver(_corpo.text, contexto)),
                      const SizedBox(height: 8),
                      Row(children: [
                        const Icon(Icons.attach_file, size: 18),
                        const SizedBox(width: 4),
                        Expanded(child: Text(resolvedor.resolverNomeArquivo(_arquivo.text, contexto))),
                      ]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  if (!_formulario.currentState!.validate()) return;
                  final salvou = await widget.aoSalvar(_configuracao);
                  if (salvou && mounted) setState(() => _alterado = false);
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
