/// Hierarquia de falhas esperadas (docs/09, seção 9.5).
///
/// Toda falha nasce com a mensagem em português que o usuário vai ler. A interface exibe
/// [mensagem] e nunca monta texto de erro por conta própria.
sealed class Falha {
  final String mensagem;
  final Object? causa;

  const Falha(this.mensagem, {this.causa});

  @override
  String toString() => mensagem;
}

/// Arquivo não encontrado, sem permissão, sem espaço.
final class FalhaArquivo extends Falha {
  const FalhaArquivo(super.mensagem, {super.causa});
}

/// `.xls` antigo, planilha protegida, corrompida ou vazia.
final class FalhaFormatoPlanilha extends Falha {
  const FalhaFormatoPlanilha(super.mensagem, {super.causa});
}

/// Mapeamento incapaz de produzir a planilha: RN-18, RN-21.
final class FalhaMapeamento extends Falha {
  const FalhaMapeamento(super.mensagem, {super.causa});
}

/// Erro ao montar o novo `.xlsx`.
final class FalhaEscritaPlanilha extends Falha {
  const FalhaEscritaPlanilha(super.mensagem, {super.causa});
}

/// Erro de leitura ou gravação no banco local.
final class FalhaBanco extends Falha {
  const FalhaBanco(super.mensagem, {super.causa});
}

/// Sem cliente de e-mail, sem aplicativo para abrir o arquivo, permissão negada.
final class FalhaSistemaOperacional extends Falha {
  const FalhaSistemaOperacional(super.mensagem, {super.causa});
}

/// Entrada recusada por regra de negócio: RN-03, RN-04.
final class FalhaValidacao extends Falha {
  const FalhaValidacao(super.mensagem, {super.causa});
}
