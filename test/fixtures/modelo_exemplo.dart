import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

/// Planilha de teste da seção 14.3 de docs/14, montada a partir do XML para que cada
/// detalhe fique à vista. Contém, de propósito, tudo o que pode dar errado:
///
/// - título mesclado nas linhas 1 e 2 (`A1:H2`);
/// - nome em `B3` e matrícula em `F3`, com rótulos em `A3` e `E3`;
/// - cabeçalho na linha 5 com acento (`SAÍDA 1`) e dados nas linhas 6 a 36;
/// - bordas, fundo alternado e formato de hora nas colunas de horário;
/// - uma fórmula compartilhada `(D-C)+(F-E)` em `H6:H36`;
/// - `=SUM(H6:H36)` em `H38`;
/// - nenhuma linha 4, para exercitar a inserção de linha;
/// - uma segunda aba com conteúdo, que precisa sair intacta;
/// - `calcChain.xml`, que precisa ser removido.
abstract final class ModeloExemplo {
  static const aba = 'Maio';
  static const primeiraLinha = 6;
  static const ultimaLinha = 36;

  /// Índices de estilo em `cellXfs`.
  static const estiloData = 3;
  static const estiloHora = 4;
  static const estiloHoraAlternada = 5;
  static const estiloTotal = 6;
  static const estiloTexto = 7;

  static const _ns = 'http://schemas.openxmlformats.org/spreadsheetml/2006/main';
  static const _nsRel = 'http://schemas.openxmlformats.org/officeDocument/2006/relationships';
  static const _nsPacote = 'http://schemas.openxmlformats.org/package/2006/relationships';
  static const _cabecalho = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n';

  static const textos = [
    'CONTROLE DE PONTO', 'Nome:', 'Matrícula:', 'DATA', 'DIA', 'ENTRADA 1', 'SAÍDA 1', //
    'ENTRADA 2', 'SAÍDA 2', 'OBS.', 'TOTAL', 'TOTAL DO MÊS', 'Assinatura:',
    'Preencha só as colunas de horário.',
  ];

  static Map<String, String> partes() => {
        '[Content_Types].xml': _tiposConteudo,
        '_rels/.rels': _relsRaiz,
        'docProps/app.xml': _app,
        'docProps/core.xml': _core,
        'xl/workbook.xml': _pastaTrabalho,
        'xl/_rels/workbook.xml.rels': _relsPastaTrabalho,
        'xl/styles.xml': _estilos,
        'xl/sharedStrings.xml': _textosCompartilhados(),
        'xl/worksheets/sheet1.xml': _aba1(),
        'xl/worksheets/sheet2.xml': _aba2,
        'xl/calcChain.xml': _cadeiaCalculo,
      };

  static Uint8List bytes({Map<String, String?> substituir = const {}}) {
    final arquivo = Archive();
    final conteudo = {...partes(), ...substituir};
    for (final MapEntry(key: nome, value: xml) in conteudo.entries) {
      if (xml == null) continue;
      final dados = utf8.encode(xml);
      arquivo.addFile(ArchiveFile(nome, dados.length, dados));
    }
    return Uint8List.fromList(ZipEncoder().encode(arquivo)!);
  }

  static const _tiposConteudo = '$_cabecalho'
      '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
      '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
      '<Default Extension="xml" ContentType="application/xml"/>'
      '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
      '<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
      '<Override PartName="/xl/worksheets/sheet2.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
      '<Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>'
      '<Override PartName="/xl/sharedStrings.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml"/>'
      '<Override PartName="/xl/calcChain.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.calcChain+xml"/>'
      '<Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>'
      '<Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>'
      '</Types>';

  static const _relsRaiz = '$_cabecalho<Relationships xmlns="$_nsPacote">'
      '<Relationship Id="rId1" Type="$_nsRel/officeDocument" Target="xl/workbook.xml"/>'
      '<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>'
      '<Relationship Id="rId3" Type="$_nsRel/extended-properties" Target="docProps/app.xml"/>'
      '</Relationships>';

  static const _app = '$_cabecalho<Properties '
      'xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties">'
      '<Application>Microsoft Excel</Application></Properties>';

  static const _core = '$_cabecalho<cp:coreProperties '
      'xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" '
      'xmlns:dc="http://purl.org/dc/elements/1.1/"><dc:title>Ponto</dc:title>'
      '</cp:coreProperties>';

  static const _pastaTrabalho = '$_cabecalho<workbook xmlns="$_ns" xmlns:r="$_nsRel">'
      '<workbookPr/>'
      '<bookViews><workbookView xWindow="0" yWindow="0" windowWidth="16384" windowHeight="8192"/></bookViews>'
      '<sheets><sheet name="Maio" sheetId="1" r:id="rId1"/>'
      '<sheet name="Instruções" sheetId="2" r:id="rId2"/></sheets>'
      '<calcPr calcId="191029"/>'
      '</workbook>';

  static const _relsPastaTrabalho = '$_cabecalho<Relationships xmlns="$_nsPacote">'
      '<Relationship Id="rId1" Type="$_nsRel/worksheet" Target="worksheets/sheet1.xml"/>'
      '<Relationship Id="rId2" Type="$_nsRel/worksheet" Target="worksheets/sheet2.xml"/>'
      '<Relationship Id="rId3" Type="$_nsRel/styles" Target="styles.xml"/>'
      '<Relationship Id="rId4" Type="$_nsRel/sharedStrings" Target="sharedStrings.xml"/>'
      '<Relationship Id="rId5" Type="$_nsRel/calcChain" Target="calcChain.xml"/>'
      '</Relationships>';

  static const _estilos = '$_cabecalho<styleSheet xmlns="$_ns">'
      '<numFmts count="3"><numFmt numFmtId="164" formatCode="hh:mm"/>'
      '<numFmt numFmtId="165" formatCode="dd/mm/yyyy"/><numFmt numFmtId="166" formatCode="[h]:mm"/></numFmts>'
      '<fonts count="2"><font><sz val="11"/><name val="Calibri"/></font>'
      '<font><b/><sz val="11"/><name val="Calibri"/></font></fonts>'
      '<fills count="3"><fill><patternFill patternType="none"/></fill>'
      '<fill><patternFill patternType="gray125"/></fill>'
      '<fill><patternFill patternType="solid"><fgColor rgb="FFDDEBF7"/><bgColor indexed="64"/></patternFill></fill></fills>'
      '<borders count="2"><border><left/><right/><top/><bottom/><diagonal/></border>'
      '<border><left style="thin"><color auto="1"/></left><right style="thin"><color auto="1"/></right>'
      '<top style="thin"><color auto="1"/></top><bottom style="thin"><color auto="1"/></bottom><diagonal/></border></borders>'
      '<cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>'
      '<cellXfs count="8">'
      '<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/>'
      '<xf numFmtId="0" fontId="1" fillId="0" borderId="0" xfId="0" applyFont="1"/>'
      '<xf numFmtId="0" fontId="1" fillId="2" borderId="1" xfId="0" applyFont="1" applyFill="1" applyBorder="1"/>'
      '<xf numFmtId="165" fontId="0" fillId="0" borderId="1" xfId="0" applyNumberFormat="1" applyBorder="1"/>'
      '<xf numFmtId="164" fontId="0" fillId="0" borderId="1" xfId="0" applyNumberFormat="1" applyBorder="1"/>'
      '<xf numFmtId="164" fontId="0" fillId="2" borderId="1" xfId="0" applyNumberFormat="1" applyFill="1" applyBorder="1"/>'
      '<xf numFmtId="166" fontId="1" fillId="0" borderId="1" xfId="0" applyNumberFormat="1" applyFont="1" applyBorder="1"/>'
      '<xf numFmtId="0" fontId="0" fillId="0" borderId="1" xfId="0" applyBorder="1"/>'
      '</cellXfs>'
      '<cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles>'
      '</styleSheet>';

  static String _textosCompartilhados() => '$_cabecalho<sst xmlns="$_ns" '
      'count="${textos.length}" uniqueCount="${textos.length}">'
      '${textos.map((t) => '<si><t>$t</t></si>').join()}</sst>';

  static String _texto(String ref, int indice, {int? estilo}) =>
      '<c r="$ref"${estilo == null ? '' : ' s="$estilo"'} t="s"><v>$indice</v></c>';

  static String _aba1() {
    final linhas = StringBuffer()
      ..write('<row r="1" spans="1:8">${_texto('A1', 0, estilo: 1)}</row>')
      ..write('<row r="2" spans="1:8"><c r="A2" s="1"/></row>')
      ..write('<row r="3" spans="1:8">${_texto('A3', 1)}<c r="B3" s="$estiloTexto"/>'
          '${_texto('E3', 2)}<c r="F3" s="$estiloTexto"/></row>')
      ..write('<row r="5" spans="1:8">');
    const colunas = 'ABCDEFGH';
    const cabecalhos = [3, 4, 5, 6, 7, 8, 9, 10];
    for (var i = 0; i < 8; i++) {
      linhas.write(_texto('${colunas[i]}5', cabecalhos[i], estilo: 2));
    }
    linhas.write('</row>');

    for (var linha = primeiraLinha; linha <= ultimaLinha; linha++) {
      final hora = linha.isEven ? estiloHora : estiloHoraAlternada;
      final formula = linha == primeiraLinha
          ? '<f t="shared" ref="H$primeiraLinha:H$ultimaLinha" si="0">(D$linha-C$linha)+(F$linha-E$linha)</f>'
          : '<f t="shared" si="0"/>';
      linhas.write('<row r="$linha" spans="1:8">'
          '<c r="A$linha" s="$estiloData"/><c r="B$linha" s="$estiloTexto"/>'
          '<c r="C$linha" s="$hora"/><c r="D$linha" s="$hora"/>'
          '<c r="E$linha" s="$hora"/><c r="F$linha" s="$hora"/>'
          '<c r="G$linha" s="$estiloTexto"/>'
          '<c r="H$linha" s="$estiloTotal">$formula<v>0</v></c></row>');
    }
    linhas
      ..write('<row r="38">${_texto('G38', 11)}'
          '<c r="H38" s="$estiloTotal"><f>SUM(H6:H36)</f><v>0</v></c></row>')
      ..write('<row r="39">${_texto('A39', 12)}</row>');

    return '$_cabecalho<worksheet xmlns="$_ns" xmlns:r="$_nsRel">'
        '<dimension ref="A1:H39"/>'
        '<sheetViews><sheetView tabSelected="1" workbookViewId="0"/></sheetViews>'
        '<sheetFormatPr defaultRowHeight="15"/>'
        '<cols><col min="1" max="1" width="12" customWidth="1"/></cols>'
        '<sheetData>$linhas</sheetData>'
        '<mergeCells count="1"><mergeCell ref="A1:H2"/></mergeCells>'
        '<pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/>'
        '</worksheet>';
  }

  static const _aba2 = '$_cabecalho<worksheet xmlns="$_ns" xmlns:r="$_nsRel">'
      '<dimension ref="A1"/><sheetData><row r="1"><c r="A1" t="s"><v>13</v></c></row>'
      '</sheetData></worksheet>';

  static const _cadeiaCalculo = '$_cabecalho<calcChain xmlns="$_ns">'
      '<c r="H6" i="1"/><c r="H38" i="1"/></calcChain>';
}
