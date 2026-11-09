import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

import '../../core/falhas.dart';
import '../../core/relogio.dart';
import '../../core/resultado.dart';
import '../../domain/contratos/contratos.dart';

/// Arquivos privados do app (docs/09, seção 9.9):
/// `<suporte>/modelos/` guarda as cópias dos modelos e `<suporte>/geradas/` as planilhas
/// geradas — a pasta que o `FileProvider` expõe para abrir o arquivo em outro app.
class ArmazenamentoArquivosLocal implements ArmazenamentoArquivos {
  final Future<Directory> Function() _pastaBase;
  final Relogio _relogio;

  ArmazenamentoArquivosLocal(
      {required Future<Directory> Function() pastaBase, required Relogio relogio})
      : _pastaBase = pastaBase,
        _relogio = relogio;

  @override
  Future<Resultado<ArquivoImportado>> importarModelo(Uint8List bytes, String nomeOriginal) async {
    try {
      final pasta = Directory(p.join((await _pastaBase()).path, 'modelos'));
      await pasta.create(recursive: true);
      final marca = _relogio.agora().millisecondsSinceEpoch;
      final destino = File(p.join(pasta.path, '${marca}_${_nomeSeguro(nomeOriginal)}'));
      await destino.writeAsBytes(bytes, flush: true);
      return Sucesso(ArquivoImportado(
        caminho: destino.path,
        hash: calcularHash(bytes),
        bytes: bytes,
      ));
    } on FileSystemException catch (erro) {
      return Erro(FalhaArquivo(
          'Não consegui copiar a planilha para o app. Verifique o espaço disponível no aparelho.',
          causa: erro));
    }
  }

  @override
  Future<Resultado<Uint8List>> lerBytes(String caminho) async {
    try {
      final arquivo = File(caminho);
      if (!await arquivo.exists()) {
        return const Erro(FalhaArquivo(
            'A planilha modelo não está mais no aparelho. Importe o arquivo de novo.'));
      }
      return Sucesso(await arquivo.readAsBytes());
    } on FileSystemException catch (erro) {
      return Erro(FalhaArquivo('Não consegui abrir o arquivo.', causa: erro));
    }
  }

  /// Grava em uma pasta própria por geração, para que regerar uma competência não apague o
  /// arquivo de um envio anterior (RN-24). Escreve primeiro em `.parcial` e só renomeia no
  /// fim: uma falha no meio não deixa arquivo pela metade (RNF-06).
  @override
  Future<Resultado<ArquivoGravado>> gravarGerado(String nomeArquivo, Uint8List bytes) async {
    Directory? pasta;
    try {
      final marca = _relogio.agora().millisecondsSinceEpoch;
      pasta = Directory(p.join((await _pastaBase()).path, 'geradas', '$marca'));
      await pasta.create(recursive: true);
      final parcial = File(p.join(pasta.path, '${_nomeSeguro(nomeArquivo)}.parcial'));
      await parcial.writeAsBytes(bytes, flush: true);
      final final_ = await parcial.rename(p.join(pasta.path, _nomeSeguro(nomeArquivo)));
      return Sucesso(ArquivoGravado(caminho: final_.path, tamanhoBytes: bytes.length));
    } on FileSystemException catch (erro) {
      try {
        if (pasta != null && await pasta.exists()) await pasta.delete(recursive: true);
      } on FileSystemException {
        // Nada a fazer: a falha original é a que importa para a pessoa.
      }
      return Erro(FalhaArquivo(
          'Não consegui salvar a planilha. Verifique o espaço disponível no aparelho.',
          causa: erro));
    }
  }

  @override
  Future<bool> existe(String caminho) => File(caminho).exists();

  @override
  Future<Resultado<void>> excluir(String caminho) async {
    try {
      final arquivo = File(caminho);
      if (await arquivo.exists()) await arquivo.delete();
      return const Sucesso(null);
    } on FileSystemException catch (erro) {
      return Erro(FalhaArquivo('Não consegui excluir o arquivo.', causa: erro));
    }
  }

  @override
  String calcularHash(Uint8List bytes) => sha256.convert(bytes).toString();

  static String _nomeSeguro(String nome) {
    final limpo = nome.replaceAll(RegExp(r'[/\\:*?"<>|]'), '-').trim();
    return limpo.isEmpty ? 'planilha.xlsx' : limpo;
  }
}
