/// Dados que alimentam as células fixas da planilha e as variáveis do e-mail (RF-01).
class PerfilUsuario {
  final String nome;
  final String? matricula;
  final String? cargo;
  final String? empresa;
  final String? email;

  const PerfilUsuario({
    required this.nome,
    this.matricula,
    this.cargo,
    this.empresa,
    this.email,
  });

  PerfilUsuario copiaCom({
    String? nome,
    String? matricula,
    String? cargo,
    String? empresa,
    String? email,
  }) {
    return PerfilUsuario(
      nome: nome ?? this.nome,
      matricula: matricula ?? this.matricula,
      cargo: cargo ?? this.cargo,
      empresa: empresa ?? this.empresa,
      email: email ?? this.email,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PerfilUsuario &&
      other.nome == nome &&
      other.matricula == matricula &&
      other.cargo == cargo &&
      other.empresa == empresa &&
      other.email == email;

  @override
  int get hashCode => Object.hash(nome, matricula, cargo, empresa, email);
}
