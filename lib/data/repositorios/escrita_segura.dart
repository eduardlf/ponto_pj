import '../../core/falhas.dart';
import '../../core/resultado.dart';
import '../local/banco_local.dart';

/// Executa uma escrita em transação e transforma qualquer erro do banco em [FalhaBanco], com
/// a mensagem que a pessoa vai ler. Uma [Falha] devolvida pela própria ação (validação) é
/// repassada como está.
Future<Resultado<T>> escritaSegura<T>(
    BancoLocal banco, Future<Resultado<T>> Function() acao) async {
  try {
    return await banco.transaction(acao);
  } catch (erro) {
    return Erro(FalhaBanco('Não consegui salvar no aparelho. Tente de novo.', causa: erro));
  }
}
