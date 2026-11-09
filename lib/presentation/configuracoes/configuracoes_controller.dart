import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../domain/entidades/configuracao_email.dart';
import '../../domain/entidades/configuracao_jornada.dart';
import '../../domain/entidades/modelo_planilha.dart';
import '../../domain/entidades/perfil_usuario.dart';

/// Etapa de configuração adiada no onboarding ou ainda não feita (A1).
class PendenciaConfiguracao {
  final String titulo;
  final String explicacao;
  final String rota;

  const PendenciaConfiguracao(this.titulo, this.explicacao, this.rota);
}

class ResumoConfiguracoes {
  final PerfilUsuario? perfil;
  final ConfiguracaoJornada jornada;
  final ModeloPlanilha? modelo;
  final ConfiguracaoEmail email;

  const ResumoConfiguracoes({
    required this.perfil,
    required this.jornada,
    required this.modelo,
    required this.email,
  });

  /// Cartões de pendência do topo de TL-12, um por etapa que ainda falta.
  List<PendenciaConfiguracao> get pendencias => [
        if (perfil == null)
          const PendenciaConfiguracao('Seus dados',
              'Seu nome vai na planilha e no e-mail.', '/perfil'),
        if (modelo == null)
          const PendenciaConfiguracao('Sua planilha',
              'Ensine o app a preencher a planilha da empresa.', '/planilha/wizard'),
        if (!email.temDestinatario)
          const PendenciaConfiguracao('Seu e-mail',
              'Diga para quem a planilha vai no fim do mês.', '/email'),
      ];
}

final resumoConfiguracoesProvider = FutureProvider.autoDispose<ResumoConfiguracoes>((ref) async {
  ref.watch(versaoDadosProvider);
  return ResumoConfiguracoes(
    perfil: await ref.watch(perfilRepositorioProvider).buscar(),
    jornada: await ref.watch(jornadaRepositorioProvider).buscarAtiva(),
    modelo: await ref.watch(modeloPlanilhaRepositorioProvider).buscarAtivo(),
    email: await ref.watch(configuracaoEmailRepositorioProvider).buscar(),
  );
});
