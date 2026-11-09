/// Contratos dos serviços de infraestrutura (docs/09, seção 9.1: "contratos de repositório e
/// de serviço" ficam no domínio). As implementações vivem em `data/`.
library;

import 'dart:typed_data';

import '../../core/resultado.dart';
import '../entidades/conteudo_planilha.dart';
import '../entidades/plano_de_escrita.dart';

/// Lê a estrutura e o conteúdo de um `.xlsx`, para o wizard e para a estratégia por data.
abstract interface class LeitorPlanilha {
  /// [nomeArquivo] permite reconhecer um `.xls` antigo pela extensão.
  Future<Resultado<EstruturaPlanilha>> ler(Uint8List bytes, {String? nomeArquivo});
}

/// O arquivo produzido pelo escritor e o que ele precisou avisar.
class ArquivoEscrito {
  final Uint8List bytes;

  /// Ex.: fórmula substituída por um valor do app.
  final List<String> avisos;

  ArquivoEscrito(this.bytes, {List<String> avisos = const []})
      : avisos = List.unmodifiable(avisos);
}

/// O único componente do sistema que conhece o formato `.xlsx` por dentro (docs/10, 10.5).
abstract interface class EscritorXlsx {
  /// Aplica o plano sobre os bytes do modelo e devolve um NOVO arquivo, preservando tudo
  /// que não foi explicitamente alterado (RN-22).
  Future<Resultado<ArquivoEscrito>> aplicar(Uint8List modeloBase, PlanoDeEscrita plano);
}

/// Cópia do modelo para a área privada do app.
class ArquivoImportado {
  final String caminho;
  final String hash;
  final Uint8List bytes;

  const ArquivoImportado({required this.caminho, required this.hash, required this.bytes});
}

class ArquivoGravado {
  final String caminho;
  final int tamanhoBytes;

  const ArquivoGravado({required this.caminho, required this.tamanhoBytes});
}

/// Arquivos privados do app (docs/09, seção 9.9).
abstract interface class ArmazenamentoArquivos {
  /// Copia o arquivo escolhido pelo usuário — que nunca é alterado nem movido — e calcula
  /// o SHA-256 da cópia.
  Future<Resultado<ArquivoImportado>> importarModelo(Uint8List bytes, String nomeOriginal);

  Future<Resultado<Uint8List>> lerBytes(String caminho);

  /// Grava sem deixar arquivo parcial para trás em caso de falha (RNF-06).
  Future<Resultado<ArquivoGravado>> gravarGerado(String nomeArquivo, Uint8List bytes);

  Future<bool> existe(String caminho);

  Future<Resultado<void>> excluir(String caminho);

  String calcularHash(Uint8List bytes);
}

/// Abre o cliente de e-mail. Sucesso significa que ele ABRIU — nunca que o e-mail foi
/// enviado, o que o app não tem como saber (RN-23).
abstract interface class ServicoEmail {
  Future<Resultado<void>> abrirComposicao({
    required List<String> destinatarios,
    required List<String> copia,
    required String assunto,
    required String corpo,
    required String caminhoAnexo,
  });
}

/// Compartilhamento genérico e abertura do arquivo em outro app (RF-37).
abstract interface class ServicoArquivosExternos {
  Future<Resultado<void>> compartilhar(String caminho, {String? assunto, String? texto});

  Future<Resultado<void>> abrir(String caminho);
}

/// Escolha de arquivo no seletor do sistema.
abstract interface class SeletorArquivos {
  /// Nulo quando o usuário desiste.
  Future<Resultado<ArquivoSelecionado?>> escolherPlanilha();
}

class ArquivoSelecionado {
  final String nome;
  final Uint8List bytes;

  const ArquivoSelecionado({required this.nome, required this.bytes});
}
