/// Destinatários e textos do e-mail de fechamento, todos com variáveis (docs/11).
class ConfiguracaoEmail {
  static const assuntoPadrao = 'Ponto - {nome} - {competencia}';
  static const nomeArquivoPadrao = 'Ponto_{nome}_{mes}-{ano}.xlsx';
  static const corpoPadrao = 'Olá,\n'
      '\n'
      'Segue em anexo o registro de ponto de {competencia}.\n'
      '\n'
      'Total trabalhado: {total_mes}\n'
      'Saldo do período: {saldo_mes}\n'
      '\n'
      'Atenciosamente,\n'
      '{nome}';

  final int? id;
  final List<String> destinatarios;
  final List<String> copia;
  final String assuntoModelo;
  final String corpoModelo;
  final String templateNomeArquivo;

  ConfiguracaoEmail({
    this.id,
    List<String> destinatarios = const [],
    List<String> copia = const [],
    this.assuntoModelo = assuntoPadrao,
    this.corpoModelo = corpoPadrao,
    this.templateNomeArquivo = nomeArquivoPadrao,
  })  : destinatarios = List.unmodifiable(destinatarios),
        copia = List.unmodifiable(copia);

  bool get temDestinatario => destinatarios.isNotEmpty;

  /// Endereços separados por ponto e vírgula, vírgula ou espaço.
  static List<String> separarEnderecos(String texto) => texto
      .split(RegExp(r'[;,\s]+'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  static bool enderecoValido(String endereco) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(endereco);

  ConfiguracaoEmail copiaCom({
    int? id,
    List<String>? destinatarios,
    List<String>? copia,
    String? assuntoModelo,
    String? corpoModelo,
    String? templateNomeArquivo,
  }) {
    return ConfiguracaoEmail(
      id: id ?? this.id,
      destinatarios: destinatarios ?? this.destinatarios,
      copia: copia ?? this.copia,
      assuntoModelo: assuntoModelo ?? this.assuntoModelo,
      corpoModelo: corpoModelo ?? this.corpoModelo,
      templateNomeArquivo: templateNomeArquivo ?? this.templateNomeArquivo,
    );
  }
}
