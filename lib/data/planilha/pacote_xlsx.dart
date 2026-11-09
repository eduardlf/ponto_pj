import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:xml/xml.dart';

/// Navegação no pacote OOXML de um `.xlsx`: um zip de XML ligado por arquivos de
/// relacionamento (`_rels`). Usado tanto pela leitura quanto pela escrita.
class PacoteXlsx {
  static const tipoDocumento =
      'http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument';
  static const tipoPlanilha =
      'http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet';
  static const tipoTextos =
      'http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings';
  static const tipoEstilos =
      'http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles';
  static const tipoCadeiaCalculo =
      'http://schemas.openxmlformats.org/officeDocument/2006/relationships/calcChain';
  static const nsRelacoes =
      'http://schemas.openxmlformats.org/officeDocument/2006/relationships';

  final Archive arquivo;

  PacoteXlsx._(this.arquivo);

  /// Lança [FormatException] quando os bytes não são um `.xlsx` legível.
  factory PacoteXlsx.ler(Uint8List bytes) {
    final Archive arquivo;
    try {
      arquivo = ZipDecoder().decodeBytes(bytes);
    } catch (erro) {
      throw FormatException('O arquivo não é um zip válido: $erro');
    }
    final pacote = PacoteXlsx._(arquivo);
    if (pacote.entrada('[Content_Types].xml') == null) {
      throw const FormatException('Falta [Content_Types].xml');
    }
    return pacote;
  }

  /// Zip começa com `PK\x03\x04`.
  static bool pareceZip(Uint8List bytes) =>
      bytes.length > 4 && bytes[0] == 0x50 && bytes[1] == 0x4B && bytes[2] == 0x03 &&
      bytes[3] == 0x04;

  /// Documento composto OLE2: o `.xls` antigo e o `.xlsx` protegido por senha.
  static bool pareceOle2(Uint8List bytes) =>
      bytes.length > 8 && bytes[0] == 0xD0 && bytes[1] == 0xCF && bytes[2] == 0x11 &&
      bytes[3] == 0xE0;

  ArchiveFile? entrada(String caminho) => arquivo.findFile(caminho);

  Uint8List? bytesDe(String caminho) {
    final entrada = this.entrada(caminho);
    if (entrada == null) return null;
    final conteudo = entrada.content;
    return conteudo is Uint8List ? conteudo : Uint8List.fromList(conteudo as List<int>);
  }

  XmlDocument? xmlDe(String caminho) {
    final bytes = bytesDe(caminho);
    if (bytes == null) return null;
    return XmlDocument.parse(utf8.decode(bytes, allowMalformed: true));
  }

  /// Caminho da pasta de trabalho, normalmente `xl/workbook.xml`.
  String get caminhoPastaTrabalho {
    final raiz = relacoesDe('');
    for (final relacao in raiz.values) {
      if (relacao.tipo == tipoDocumento) return relacao.alvo;
    }
    return 'xl/workbook.xml';
  }

  /// Relacionamentos de uma parte, com os alvos já resolvidos para caminhos do zip.
  Map<String, Relacao> relacoesDe(String parte) {
    final pasta = parte.isEmpty ? '' : p.posix.dirname(parte);
    final arquivoRels = parte.isEmpty
        ? '_rels/.rels'
        : p.posix.join(pasta, '_rels', '${p.posix.basename(parte)}.rels');
    final documento = xmlDe(arquivoRels);
    if (documento == null) return const {};
    return {
      for (final rel in documento.findAllElements('Relationship'))
        if (rel.getAttribute('Id') case final id?)
          id: Relacao(
            id: id,
            tipo: rel.getAttribute('Type') ?? '',
            alvo: resolverAlvo(pasta, rel.getAttribute('Target') ?? ''),
            externo: rel.getAttribute('TargetMode') == 'External',
          ),
    };
  }

  static String resolverAlvo(String pastaOrigem, String alvo) {
    if (alvo.startsWith('/')) return p.posix.normalize(alvo.substring(1));
    return p.posix.normalize(p.posix.join(pastaOrigem, alvo));
  }

  /// Abas na ordem da pasta de trabalho: nome e caminho da parte no zip.
  List<({String nome, String caminho})> abas() {
    final caminho = caminhoPastaTrabalho;
    final documento = xmlDe(caminho);
    if (documento == null) throw const FormatException('Pasta de trabalho ausente');
    final relacoes = relacoesDe(caminho);
    return [
      for (final aba in documento.findAllElements('sheet', namespace: '*'))
        if (relacoes[aba.getAttribute('id', namespace: nsRelacoes)] case final relacao?
            when relacao.tipo == tipoPlanilha)
          (nome: aba.getAttribute('name') ?? '', caminho: relacao.alvo),
    ];
  }

  /// Caminho da parte de um tipo ligado à pasta de trabalho (textos, estilos, cálculo).
  String? parteDoTipo(String tipo) {
    for (final relacao in relacoesDe(caminhoPastaTrabalho).values) {
      if (relacao.tipo == tipo) return relacao.alvo;
    }
    return null;
  }

  /// `date1904="1"` em `workbookPr`: datas contadas a partir de 1904.
  bool get sistemaData1904 {
    final documento = xmlDe(caminhoPastaTrabalho);
    final propriedades = documento?.findAllElements('workbookPr', namespace: '*').firstOrNull;
    final valor = propriedades?.getAttribute('date1904');
    return valor == '1' || valor == 'true';
  }
}

class Relacao {
  final String id;
  final String tipo;
  final String alvo;
  final bool externo;

  const Relacao({required this.id, required this.tipo, required this.alvo, this.externo = false});
}
