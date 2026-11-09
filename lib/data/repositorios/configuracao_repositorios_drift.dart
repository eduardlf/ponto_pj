import 'package:drift/drift.dart';

import '../../core/relogio.dart';
import '../../core/resultado.dart';
import '../../domain/entidades/configuracao_email.dart';
import '../../domain/entidades/perfil_usuario.dart';
import '../../domain/repositorios/repositorios.dart';
import '../local/banco_local.dart';
import 'escrita_segura.dart';

/// `perfil_usuario` tem registro único, sempre com id 1 (docs/06, seção 6.4).
class PerfilRepositorioDrift implements PerfilRepositorio {
  static const _id = 1;

  final BancoLocal _banco;
  final Relogio _relogio;

  PerfilRepositorioDrift(this._banco, {required Relogio relogio}) : _relogio = relogio;

  @override
  Future<PerfilUsuario?> buscar() async {
    final linha = await (_banco.select(_banco.perfisUsuario)..where((t) => t.id.equals(_id)))
        .getSingleOrNull();
    if (linha == null) return null;
    return PerfilUsuario(
      nome: linha.nome,
      matricula: linha.matricula,
      cargo: linha.cargo,
      empresa: linha.empresa,
      email: linha.email,
    );
  }

  @override
  Future<Resultado<void>> salvar(PerfilUsuario perfil) {
    String? limpo(String? texto) => texto == null || texto.trim().isEmpty ? null : texto.trim();
    return escritaSegura(_banco, () async {
      await _banco.into(_banco.perfisUsuario).insertOnConflictUpdate(PerfisUsuarioCompanion(
            id: const Value(_id),
            nome: Value(perfil.nome.trim()),
            matricula: Value(limpo(perfil.matricula)),
            cargo: Value(limpo(perfil.cargo)),
            empresa: Value(limpo(perfil.empresa)),
            email: Value(limpo(perfil.email)),
            atualizadoEm: Value(_relogio.agora()),
          ));
      return const Sucesso(null);
    });
  }
}

class ConfiguracaoEmailRepositorioDrift implements ConfiguracaoEmailRepositorio {
  final BancoLocal _banco;

  ConfiguracaoEmailRepositorioDrift(this._banco);

  @override
  Future<ConfiguracaoEmail> buscar() async {
    final linha = await (_banco.select(_banco.configuracoesEmail)
          ..where((t) => t.ativo.equals(true))
          ..limit(1))
        .getSingleOrNull();
    if (linha == null) return ConfiguracaoEmail();
    return ConfiguracaoEmail(
      id: linha.id,
      destinatarios: ConfiguracaoEmail.separarEnderecos(linha.destinatarios),
      copia: ConfiguracaoEmail.separarEnderecos(linha.copia ?? ''),
      assuntoModelo: linha.assuntoModelo,
      corpoModelo: linha.corpoModelo,
      templateNomeArquivo: linha.templateNomeArquivo,
    );
  }

  @override
  Future<Resultado<void>> salvar(ConfiguracaoEmail configuracao) {
    return escritaSegura(_banco, () async {
      final valores = ConfiguracoesEmailCompanion(
        destinatarios: Value(configuracao.destinatarios.join(';')),
        copia: Value(configuracao.copia.isEmpty ? null : configuracao.copia.join(';')),
        assuntoModelo: Value(configuracao.assuntoModelo),
        corpoModelo: Value(configuracao.corpoModelo),
        templateNomeArquivo: Value(configuracao.templateNomeArquivo),
        ativo: const Value(true),
      );
      final atual = await (_banco.select(_banco.configuracoesEmail)
            ..where((t) => t.ativo.equals(true))
            ..limit(1))
          .getSingleOrNull();
      if (atual == null) {
        await _banco.into(_banco.configuracoesEmail).insert(valores);
      } else {
        await (_banco.update(_banco.configuracoesEmail)..where((t) => t.id.equals(atual.id)))
            .write(valores);
      }
      return const Sucesso(null);
    });
  }
}

class PreferenciasRepositorioDrift implements PreferenciasRepositorio {
  final BancoLocal _banco;

  PreferenciasRepositorioDrift(this._banco);

  Future<String?> _ler(String chave) async {
    final linha = await (_banco.select(_banco.preferenciasApp)
          ..where((t) => t.chave.equals(chave)))
        .getSingleOrNull();
    return linha?.valor;
  }

  Future<void> _gravar(String chave, String valor) => _banco
      .into(_banco.preferenciasApp)
      .insertOnConflictUpdate(PreferenciasAppCompanion.insert(chave: chave, valor: valor));

  @override
  Future<bool> onboardingConcluido() async =>
      await _ler(ChavesPreferencia.onboardingConcluido) == 'true';

  @override
  Future<void> marcarOnboardingConcluido() =>
      _gravar(ChavesPreferencia.onboardingConcluido, 'true');

  @override
  Future<String> tema() async => await _ler(ChavesPreferencia.tema) ?? 'sistema';

  @override
  Future<void> definirTema(String tema) => _gravar(ChavesPreferencia.tema, tema);
}
