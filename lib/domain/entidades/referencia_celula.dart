/// Endereço de uma célula: [linha] em base 1, como o usuário vê, e [coluna] em base 0, como
/// `mapeamento_coluna.indice_coluna` (docs/06). Converte de e para o formato A1.
class ReferenciaCelula implements Comparable<ReferenciaCelula> {
  /// Limites do formato `.xlsx`: XFD1048576.
  static const maxColunas = 16384;
  static const maxLinhas = 1048576;

  final int linha;
  final int coluna;

  const ReferenciaCelula(this.linha, this.coluna)
      : assert(linha >= 1),
        assert(coluna >= 0);

  /// Lê `C3`, `aa10` ou `$B$2`. Devolve nulo quando o texto não é uma referência válida.
  static ReferenciaCelula? deA1(String texto) {
    final partes = RegExp(r'^\$?([A-Za-z]{1,3})\$?(\d{1,7})$').firstMatch(texto.trim());
    if (partes == null) return null;
    final coluna = indiceDaColuna(partes.group(1)!);
    final linha = int.parse(partes.group(2)!);
    if (coluna == null || linha < 1 || linha > maxLinhas) return null;
    return ReferenciaCelula(linha, coluna);
  }

  /// `A` → 0, `Z` → 25, `AA` → 26, `AB` → 27.
  static int? indiceDaColuna(String letras) {
    if (!RegExp(r'^[A-Za-z]{1,3}$').hasMatch(letras)) return null;
    var indice = 0;
    for (final unidade in letras.toUpperCase().codeUnits) {
      indice = indice * 26 + (unidade - 64);
    }
    indice -= 1;
    return indice < maxColunas ? indice : null;
  }

  /// 0 → `A`, 25 → `Z`, 26 → `AA`, 27 → `AB`.
  static String letraDaColuna(int indice) {
    assert(indice >= 0 && indice < maxColunas);
    var resto = indice + 1;
    final letras = StringBuffer();
    final pilha = <int>[];
    while (resto > 0) {
      final digito = (resto - 1) % 26;
      pilha.add(65 + digito);
      resto = (resto - 1) ~/ 26;
    }
    for (final unidade in pilha.reversed) {
      letras.writeCharCode(unidade);
    }
    return letras.toString();
  }

  String get letra => letraDaColuna(coluna);

  String get a1 => '$letra$linha';

  @override
  int compareTo(ReferenciaCelula other) =>
      linha != other.linha ? linha.compareTo(other.linha) : coluna.compareTo(other.coluna);

  @override
  bool operator ==(Object other) =>
      other is ReferenciaCelula && other.linha == linha && other.coluna == coluna;

  @override
  int get hashCode => Object.hash(linha, coluna);

  @override
  String toString() => a1;
}
