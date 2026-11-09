import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/falhas.dart';
import '../../core/resultado.dart';
import '../../domain/contratos/contratos.dart';

/// Abre o cliente de e-mail do aparelho já preenchido, com o anexo (docs/11, seção 11.3).
/// O app nunca envia nada pela rede: quem envia é o cliente, com a conta da pessoa.
class ServicoEmailAndroid implements ServicoEmail {
  const ServicoEmailAndroid();

  static const mensagemSemCliente = 'Não encontrei um app de e-mail neste aparelho. '
      'Você pode compartilhar o arquivo por outro caminho.';

  @override
  Future<Resultado<void>> abrirComposicao({
    required List<String> destinatarios,
    required List<String> copia,
    required String assunto,
    required String corpo,
    required String caminhoAnexo,
  }) async {
    try {
      await FlutterEmailSender.send(Email(
        recipients: destinatarios,
        cc: copia,
        subject: assunto,
        body: corpo,
        attachmentPaths: [caminhoAnexo],
        isHTML: false,
      ));
      return const Sucesso(null); // conseguiu ABRIR, não "enviou"
    } on PlatformException catch (erro) {
      if (erro.code == 'not_available') {
        return Erro(FalhaSistemaOperacional(mensagemSemCliente, causa: erro));
      }
      return Erro(FalhaSistemaOperacional('Não consegui abrir o e-mail.', causa: erro));
    } on MissingPluginException catch (erro) {
      return Erro(FalhaSistemaOperacional(mensagemSemCliente, causa: erro));
    }
  }
}

/// Compartilhar por qualquer app (RF-37) e abrir a planilha gerada para conferir.
class ServicoArquivosExternosAndroid implements ServicoArquivosExternos {
  static const _canal = MethodChannel('ponto_pj/arquivos');
  static const _tipoXlsx = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

  const ServicoArquivosExternosAndroid();

  @override
  Future<Resultado<void>> compartilhar(String caminho, {String? assunto, String? texto}) async {
    try {
      await Share.shareXFiles([XFile(caminho, mimeType: _tipoXlsx)],
          subject: assunto, text: texto);
      return const Sucesso(null);
    } on PlatformException catch (erro) {
      return Erro(FalhaSistemaOperacional('Não consegui compartilhar o arquivo.', causa: erro));
    } on MissingPluginException catch (erro) {
      return Erro(FalhaSistemaOperacional('Não consegui compartilhar o arquivo.', causa: erro));
    }
  }

  @override
  Future<Resultado<void>> abrir(String caminho) async {
    try {
      await _canal.invokeMethod<bool>('abrir', {'caminho': caminho, 'tipo': _tipoXlsx});
      return const Sucesso(null);
    } on PlatformException catch (erro) {
      if (erro.code == 'sem_app') {
        return Erro(FalhaSistemaOperacional(
            'Nenhum app deste aparelho abre planilhas. Instale um leitor de Excel ou '
            'compartilhe o arquivo.',
            causa: erro));
      }
      return Erro(FalhaSistemaOperacional('Não consegui abrir a planilha.', causa: erro));
    } on MissingPluginException catch (erro) {
      return Erro(FalhaSistemaOperacional('Não consegui abrir a planilha.', causa: erro));
    }
  }
}

/// Seletor de arquivos do sistema. O arquivo escolhido nunca é alterado nem movido: o app
/// lê os bytes e trabalha sobre uma cópia própria (RN-22).
class SeletorArquivosSistema implements SeletorArquivos {
  const SeletorArquivosSistema();

  @override
  Future<Resultado<ArquivoSelecionado?>> escolherPlanilha() async {
    try {
      // FileType.any: o filtro por extensão falha em alguns aparelhos Android; a extensão é
      // conferida depois, com mensagem própria para o .xls.
      final resultado = await FilePicker.platform.pickFiles(type: FileType.any, withData: true);
      final arquivo = resultado?.files.singleOrNull;
      if (arquivo == null) return const Sucesso(null);
      final bytes = arquivo.bytes;
      if (bytes == null) {
        return const Erro(FalhaArquivo('Não consegui ler o arquivo escolhido. Tente de novo.'));
      }
      return Sucesso(ArquivoSelecionado(nome: arquivo.name, bytes: bytes));
    } on PlatformException catch (erro) {
      return Erro(FalhaSistemaOperacional(
          'Não consegui abrir o seletor de arquivos. Verifique as permissões do app.',
          causa: erro));
    }
  }
}
