// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banco_local.dart';

// ignore_for_file: type=lint
class $PerfisUsuarioTable extends PerfisUsuario
    with TableInfo<$PerfisUsuarioTable, PerfilUsuarioLinha> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PerfisUsuarioTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _matriculaMeta =
      const VerificationMeta('matricula');
  @override
  late final GeneratedColumn<String> matricula = GeneratedColumn<String>(
      'matricula', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cargoMeta = const VerificationMeta('cargo');
  @override
  late final GeneratedColumn<String> cargo = GeneratedColumn<String>(
      'cargo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _empresaMeta =
      const VerificationMeta('empresa');
  @override
  late final GeneratedColumn<String> empresa = GeneratedColumn<String>(
      'empresa', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _criadoEmMeta =
      const VerificationMeta('criadoEm');
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
      'criado_em', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _atualizadoEmMeta =
      const VerificationMeta('atualizadoEm');
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
      'atualizado_em', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, nome, matricula, cargo, empresa, email, criadoEm, atualizadoEm];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'perfil_usuario';
  @override
  VerificationContext validateIntegrity(Insertable<PerfilUsuarioLinha> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('matricula')) {
      context.handle(_matriculaMeta,
          matricula.isAcceptableOrUnknown(data['matricula']!, _matriculaMeta));
    }
    if (data.containsKey('cargo')) {
      context.handle(
          _cargoMeta, cargo.isAcceptableOrUnknown(data['cargo']!, _cargoMeta));
    }
    if (data.containsKey('empresa')) {
      context.handle(_empresaMeta,
          empresa.isAcceptableOrUnknown(data['empresa']!, _empresaMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('criado_em')) {
      context.handle(_criadoEmMeta,
          criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta));
    }
    if (data.containsKey('atualizado_em')) {
      context.handle(
          _atualizadoEmMeta,
          atualizadoEm.isAcceptableOrUnknown(
              data['atualizado_em']!, _atualizadoEmMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PerfilUsuarioLinha map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PerfilUsuarioLinha(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      matricula: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}matricula']),
      cargo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cargo']),
      empresa: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}empresa']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      criadoEm: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}criado_em'])!,
      atualizadoEm: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}atualizado_em'])!,
    );
  }

  @override
  $PerfisUsuarioTable createAlias(String alias) {
    return $PerfisUsuarioTable(attachedDatabase, alias);
  }
}

class PerfilUsuarioLinha extends DataClass
    implements Insertable<PerfilUsuarioLinha> {
  final int id;
  final String nome;
  final String? matricula;
  final String? cargo;
  final String? empresa;
  final String? email;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  const PerfilUsuarioLinha(
      {required this.id,
      required this.nome,
      this.matricula,
      this.cargo,
      this.empresa,
      this.email,
      required this.criadoEm,
      required this.atualizadoEm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || matricula != null) {
      map['matricula'] = Variable<String>(matricula);
    }
    if (!nullToAbsent || cargo != null) {
      map['cargo'] = Variable<String>(cargo);
    }
    if (!nullToAbsent || empresa != null) {
      map['empresa'] = Variable<String>(empresa);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['criado_em'] = Variable<DateTime>(criadoEm);
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    return map;
  }

  PerfisUsuarioCompanion toCompanion(bool nullToAbsent) {
    return PerfisUsuarioCompanion(
      id: Value(id),
      nome: Value(nome),
      matricula: matricula == null && nullToAbsent
          ? const Value.absent()
          : Value(matricula),
      cargo:
          cargo == null && nullToAbsent ? const Value.absent() : Value(cargo),
      empresa: empresa == null && nullToAbsent
          ? const Value.absent()
          : Value(empresa),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      criadoEm: Value(criadoEm),
      atualizadoEm: Value(atualizadoEm),
    );
  }

  factory PerfilUsuarioLinha.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PerfilUsuarioLinha(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      matricula: serializer.fromJson<String?>(json['matricula']),
      cargo: serializer.fromJson<String?>(json['cargo']),
      empresa: serializer.fromJson<String?>(json['empresa']),
      email: serializer.fromJson<String?>(json['email']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'matricula': serializer.toJson<String?>(matricula),
      'cargo': serializer.toJson<String?>(cargo),
      'empresa': serializer.toJson<String?>(empresa),
      'email': serializer.toJson<String?>(email),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
    };
  }

  PerfilUsuarioLinha copyWith(
          {int? id,
          String? nome,
          Value<String?> matricula = const Value.absent(),
          Value<String?> cargo = const Value.absent(),
          Value<String?> empresa = const Value.absent(),
          Value<String?> email = const Value.absent(),
          DateTime? criadoEm,
          DateTime? atualizadoEm}) =>
      PerfilUsuarioLinha(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        matricula: matricula.present ? matricula.value : this.matricula,
        cargo: cargo.present ? cargo.value : this.cargo,
        empresa: empresa.present ? empresa.value : this.empresa,
        email: email.present ? email.value : this.email,
        criadoEm: criadoEm ?? this.criadoEm,
        atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      );
  PerfilUsuarioLinha copyWithCompanion(PerfisUsuarioCompanion data) {
    return PerfilUsuarioLinha(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      matricula: data.matricula.present ? data.matricula.value : this.matricula,
      cargo: data.cargo.present ? data.cargo.value : this.cargo,
      empresa: data.empresa.present ? data.empresa.value : this.empresa,
      email: data.email.present ? data.email.value : this.email,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PerfilUsuarioLinha(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('matricula: $matricula, ')
          ..write('cargo: $cargo, ')
          ..write('empresa: $empresa, ')
          ..write('email: $email, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, nome, matricula, cargo, empresa, email, criadoEm, atualizadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PerfilUsuarioLinha &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.matricula == this.matricula &&
          other.cargo == this.cargo &&
          other.empresa == this.empresa &&
          other.email == this.email &&
          other.criadoEm == this.criadoEm &&
          other.atualizadoEm == this.atualizadoEm);
}

class PerfisUsuarioCompanion extends UpdateCompanion<PerfilUsuarioLinha> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String?> matricula;
  final Value<String?> cargo;
  final Value<String?> empresa;
  final Value<String?> email;
  final Value<DateTime> criadoEm;
  final Value<DateTime> atualizadoEm;
  const PerfisUsuarioCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.matricula = const Value.absent(),
    this.cargo = const Value.absent(),
    this.empresa = const Value.absent(),
    this.email = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
  });
  PerfisUsuarioCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    this.matricula = const Value.absent(),
    this.cargo = const Value.absent(),
    this.empresa = const Value.absent(),
    this.email = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
  }) : nome = Value(nome);
  static Insertable<PerfilUsuarioLinha> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? matricula,
    Expression<String>? cargo,
    Expression<String>? empresa,
    Expression<String>? email,
    Expression<DateTime>? criadoEm,
    Expression<DateTime>? atualizadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (matricula != null) 'matricula': matricula,
      if (cargo != null) 'cargo': cargo,
      if (empresa != null) 'empresa': empresa,
      if (email != null) 'email': email,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
    });
  }

  PerfisUsuarioCompanion copyWith(
      {Value<int>? id,
      Value<String>? nome,
      Value<String?>? matricula,
      Value<String?>? cargo,
      Value<String?>? empresa,
      Value<String?>? email,
      Value<DateTime>? criadoEm,
      Value<DateTime>? atualizadoEm}) {
    return PerfisUsuarioCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      matricula: matricula ?? this.matricula,
      cargo: cargo ?? this.cargo,
      empresa: empresa ?? this.empresa,
      email: email ?? this.email,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (matricula.present) {
      map['matricula'] = Variable<String>(matricula.value);
    }
    if (cargo.present) {
      map['cargo'] = Variable<String>(cargo.value);
    }
    if (empresa.present) {
      map['empresa'] = Variable<String>(empresa.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PerfisUsuarioCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('matricula: $matricula, ')
          ..write('cargo: $cargo, ')
          ..write('empresa: $empresa, ')
          ..write('email: $email, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }
}

class $PreferenciasAppTable extends PreferenciasApp
    with TableInfo<$PreferenciasAppTable, PreferenciaAppLinha> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferenciasAppTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _chaveMeta = const VerificationMeta('chave');
  @override
  late final GeneratedColumn<String> chave = GeneratedColumn<String>(
      'chave', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<String> valor = GeneratedColumn<String>(
      'valor', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [chave, valor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preferencia_app';
  @override
  VerificationContext validateIntegrity(
      Insertable<PreferenciaAppLinha> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('chave')) {
      context.handle(
          _chaveMeta, chave.isAcceptableOrUnknown(data['chave']!, _chaveMeta));
    } else if (isInserting) {
      context.missing(_chaveMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
          _valorMeta, valor.isAcceptableOrUnknown(data['valor']!, _valorMeta));
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {chave};
  @override
  PreferenciaAppLinha map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferenciaAppLinha(
      chave: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chave'])!,
      valor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}valor'])!,
    );
  }

  @override
  $PreferenciasAppTable createAlias(String alias) {
    return $PreferenciasAppTable(attachedDatabase, alias);
  }
}

class PreferenciaAppLinha extends DataClass
    implements Insertable<PreferenciaAppLinha> {
  final String chave;
  final String valor;
  const PreferenciaAppLinha({required this.chave, required this.valor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['chave'] = Variable<String>(chave);
    map['valor'] = Variable<String>(valor);
    return map;
  }

  PreferenciasAppCompanion toCompanion(bool nullToAbsent) {
    return PreferenciasAppCompanion(
      chave: Value(chave),
      valor: Value(valor),
    );
  }

  factory PreferenciaAppLinha.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferenciaAppLinha(
      chave: serializer.fromJson<String>(json['chave']),
      valor: serializer.fromJson<String>(json['valor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'chave': serializer.toJson<String>(chave),
      'valor': serializer.toJson<String>(valor),
    };
  }

  PreferenciaAppLinha copyWith({String? chave, String? valor}) =>
      PreferenciaAppLinha(
        chave: chave ?? this.chave,
        valor: valor ?? this.valor,
      );
  PreferenciaAppLinha copyWithCompanion(PreferenciasAppCompanion data) {
    return PreferenciaAppLinha(
      chave: data.chave.present ? data.chave.value : this.chave,
      valor: data.valor.present ? data.valor.value : this.valor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferenciaAppLinha(')
          ..write('chave: $chave, ')
          ..write('valor: $valor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(chave, valor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferenciaAppLinha &&
          other.chave == this.chave &&
          other.valor == this.valor);
}

class PreferenciasAppCompanion extends UpdateCompanion<PreferenciaAppLinha> {
  final Value<String> chave;
  final Value<String> valor;
  final Value<int> rowid;
  const PreferenciasAppCompanion({
    this.chave = const Value.absent(),
    this.valor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PreferenciasAppCompanion.insert({
    required String chave,
    required String valor,
    this.rowid = const Value.absent(),
  })  : chave = Value(chave),
        valor = Value(valor);
  static Insertable<PreferenciaAppLinha> custom({
    Expression<String>? chave,
    Expression<String>? valor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (chave != null) 'chave': chave,
      if (valor != null) 'valor': valor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PreferenciasAppCompanion copyWith(
      {Value<String>? chave, Value<String>? valor, Value<int>? rowid}) {
    return PreferenciasAppCompanion(
      chave: chave ?? this.chave,
      valor: valor ?? this.valor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (chave.present) {
      map['chave'] = Variable<String>(chave.value);
    }
    if (valor.present) {
      map['valor'] = Variable<String>(valor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferenciasAppCompanion(')
          ..write('chave: $chave, ')
          ..write('valor: $valor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConfiguracoesJornadaTable extends ConfiguracoesJornada
    with TableInfo<$ConfiguracoesJornadaTable, ConfiguracaoJornadaLinha> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfiguracoesJornadaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Jornada padrão'));
  static const VerificationMeta _ativaMeta = const VerificationMeta('ativa');
  @override
  late final GeneratedColumn<bool> ativa = GeneratedColumn<bool>(
      'ativa', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("ativa" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _toleranciaMinutosMeta =
      const VerificationMeta('toleranciaMinutos');
  @override
  late final GeneratedColumn<int> toleranciaMinutos = GeneratedColumn<int>(
      'tolerancia_minutos', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _permiteViradaDiaMeta =
      const VerificationMeta('permiteViradaDia');
  @override
  late final GeneratedColumn<bool> permiteViradaDia = GeneratedColumn<bool>(
      'permite_virada_dia', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("permite_virada_dia" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _dataInicioBancoMeta =
      const VerificationMeta('dataInicioBanco');
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, String>
      dataInicioBanco = GeneratedColumn<String>(
              'data_inicio_banco', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<DateTime?>(
              $ConfiguracoesJornadaTable.$converterdataInicioBancon);
  static const VerificationMeta _criadoEmMeta =
      const VerificationMeta('criadoEm');
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
      'criado_em', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nome,
        ativa,
        toleranciaMinutos,
        permiteViradaDia,
        dataInicioBanco,
        criadoEm
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'configuracao_jornada';
  @override
  VerificationContext validateIntegrity(
      Insertable<ConfiguracaoJornadaLinha> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    }
    if (data.containsKey('ativa')) {
      context.handle(
          _ativaMeta, ativa.isAcceptableOrUnknown(data['ativa']!, _ativaMeta));
    }
    if (data.containsKey('tolerancia_minutos')) {
      context.handle(
          _toleranciaMinutosMeta,
          toleranciaMinutos.isAcceptableOrUnknown(
              data['tolerancia_minutos']!, _toleranciaMinutosMeta));
    }
    if (data.containsKey('permite_virada_dia')) {
      context.handle(
          _permiteViradaDiaMeta,
          permiteViradaDia.isAcceptableOrUnknown(
              data['permite_virada_dia']!, _permiteViradaDiaMeta));
    }
    context.handle(_dataInicioBancoMeta, const VerificationResult.success());
    if (data.containsKey('criado_em')) {
      context.handle(_criadoEmMeta,
          criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConfiguracaoJornadaLinha map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfiguracaoJornadaLinha(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      ativa: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}ativa'])!,
      toleranciaMinutos: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}tolerancia_minutos'])!,
      permiteViradaDia: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}permite_virada_dia'])!,
      dataInicioBanco: $ConfiguracoesJornadaTable.$converterdataInicioBancon
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}data_inicio_banco'])),
      criadoEm: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}criado_em'])!,
    );
  }

  @override
  $ConfiguracoesJornadaTable createAlias(String alias) {
    return $ConfiguracoesJornadaTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterdataInicioBanco =
      const ConversorData();
  static TypeConverter<DateTime?, String?> $converterdataInicioBancon =
      NullAwareTypeConverter.wrap($converterdataInicioBanco);
}

class ConfiguracaoJornadaLinha extends DataClass
    implements Insertable<ConfiguracaoJornadaLinha> {
  final int id;
  final String nome;
  final bool ativa;
  final int toleranciaMinutos;
  final bool permiteViradaDia;
  final DateTime? dataInicioBanco;
  final DateTime criadoEm;
  const ConfiguracaoJornadaLinha(
      {required this.id,
      required this.nome,
      required this.ativa,
      required this.toleranciaMinutos,
      required this.permiteViradaDia,
      this.dataInicioBanco,
      required this.criadoEm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['ativa'] = Variable<bool>(ativa);
    map['tolerancia_minutos'] = Variable<int>(toleranciaMinutos);
    map['permite_virada_dia'] = Variable<bool>(permiteViradaDia);
    if (!nullToAbsent || dataInicioBanco != null) {
      map['data_inicio_banco'] = Variable<String>($ConfiguracoesJornadaTable
          .$converterdataInicioBancon
          .toSql(dataInicioBanco));
    }
    map['criado_em'] = Variable<DateTime>(criadoEm);
    return map;
  }

  ConfiguracoesJornadaCompanion toCompanion(bool nullToAbsent) {
    return ConfiguracoesJornadaCompanion(
      id: Value(id),
      nome: Value(nome),
      ativa: Value(ativa),
      toleranciaMinutos: Value(toleranciaMinutos),
      permiteViradaDia: Value(permiteViradaDia),
      dataInicioBanco: dataInicioBanco == null && nullToAbsent
          ? const Value.absent()
          : Value(dataInicioBanco),
      criadoEm: Value(criadoEm),
    );
  }

  factory ConfiguracaoJornadaLinha.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfiguracaoJornadaLinha(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      ativa: serializer.fromJson<bool>(json['ativa']),
      toleranciaMinutos: serializer.fromJson<int>(json['toleranciaMinutos']),
      permiteViradaDia: serializer.fromJson<bool>(json['permiteViradaDia']),
      dataInicioBanco: serializer.fromJson<DateTime?>(json['dataInicioBanco']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'ativa': serializer.toJson<bool>(ativa),
      'toleranciaMinutos': serializer.toJson<int>(toleranciaMinutos),
      'permiteViradaDia': serializer.toJson<bool>(permiteViradaDia),
      'dataInicioBanco': serializer.toJson<DateTime?>(dataInicioBanco),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
    };
  }

  ConfiguracaoJornadaLinha copyWith(
          {int? id,
          String? nome,
          bool? ativa,
          int? toleranciaMinutos,
          bool? permiteViradaDia,
          Value<DateTime?> dataInicioBanco = const Value.absent(),
          DateTime? criadoEm}) =>
      ConfiguracaoJornadaLinha(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        ativa: ativa ?? this.ativa,
        toleranciaMinutos: toleranciaMinutos ?? this.toleranciaMinutos,
        permiteViradaDia: permiteViradaDia ?? this.permiteViradaDia,
        dataInicioBanco: dataInicioBanco.present
            ? dataInicioBanco.value
            : this.dataInicioBanco,
        criadoEm: criadoEm ?? this.criadoEm,
      );
  ConfiguracaoJornadaLinha copyWithCompanion(
      ConfiguracoesJornadaCompanion data) {
    return ConfiguracaoJornadaLinha(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      ativa: data.ativa.present ? data.ativa.value : this.ativa,
      toleranciaMinutos: data.toleranciaMinutos.present
          ? data.toleranciaMinutos.value
          : this.toleranciaMinutos,
      permiteViradaDia: data.permiteViradaDia.present
          ? data.permiteViradaDia.value
          : this.permiteViradaDia,
      dataInicioBanco: data.dataInicioBanco.present
          ? data.dataInicioBanco.value
          : this.dataInicioBanco,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracaoJornadaLinha(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('ativa: $ativa, ')
          ..write('toleranciaMinutos: $toleranciaMinutos, ')
          ..write('permiteViradaDia: $permiteViradaDia, ')
          ..write('dataInicioBanco: $dataInicioBanco, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, ativa, toleranciaMinutos,
      permiteViradaDia, dataInicioBanco, criadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfiguracaoJornadaLinha &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.ativa == this.ativa &&
          other.toleranciaMinutos == this.toleranciaMinutos &&
          other.permiteViradaDia == this.permiteViradaDia &&
          other.dataInicioBanco == this.dataInicioBanco &&
          other.criadoEm == this.criadoEm);
}

class ConfiguracoesJornadaCompanion
    extends UpdateCompanion<ConfiguracaoJornadaLinha> {
  final Value<int> id;
  final Value<String> nome;
  final Value<bool> ativa;
  final Value<int> toleranciaMinutos;
  final Value<bool> permiteViradaDia;
  final Value<DateTime?> dataInicioBanco;
  final Value<DateTime> criadoEm;
  const ConfiguracoesJornadaCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.ativa = const Value.absent(),
    this.toleranciaMinutos = const Value.absent(),
    this.permiteViradaDia = const Value.absent(),
    this.dataInicioBanco = const Value.absent(),
    this.criadoEm = const Value.absent(),
  });
  ConfiguracoesJornadaCompanion.insert({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.ativa = const Value.absent(),
    this.toleranciaMinutos = const Value.absent(),
    this.permiteViradaDia = const Value.absent(),
    this.dataInicioBanco = const Value.absent(),
    this.criadoEm = const Value.absent(),
  });
  static Insertable<ConfiguracaoJornadaLinha> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<bool>? ativa,
    Expression<int>? toleranciaMinutos,
    Expression<bool>? permiteViradaDia,
    Expression<String>? dataInicioBanco,
    Expression<DateTime>? criadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (ativa != null) 'ativa': ativa,
      if (toleranciaMinutos != null) 'tolerancia_minutos': toleranciaMinutos,
      if (permiteViradaDia != null) 'permite_virada_dia': permiteViradaDia,
      if (dataInicioBanco != null) 'data_inicio_banco': dataInicioBanco,
      if (criadoEm != null) 'criado_em': criadoEm,
    });
  }

  ConfiguracoesJornadaCompanion copyWith(
      {Value<int>? id,
      Value<String>? nome,
      Value<bool>? ativa,
      Value<int>? toleranciaMinutos,
      Value<bool>? permiteViradaDia,
      Value<DateTime?>? dataInicioBanco,
      Value<DateTime>? criadoEm}) {
    return ConfiguracoesJornadaCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      ativa: ativa ?? this.ativa,
      toleranciaMinutos: toleranciaMinutos ?? this.toleranciaMinutos,
      permiteViradaDia: permiteViradaDia ?? this.permiteViradaDia,
      dataInicioBanco: dataInicioBanco ?? this.dataInicioBanco,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (ativa.present) {
      map['ativa'] = Variable<bool>(ativa.value);
    }
    if (toleranciaMinutos.present) {
      map['tolerancia_minutos'] = Variable<int>(toleranciaMinutos.value);
    }
    if (permiteViradaDia.present) {
      map['permite_virada_dia'] = Variable<bool>(permiteViradaDia.value);
    }
    if (dataInicioBanco.present) {
      map['data_inicio_banco'] = Variable<String>($ConfiguracoesJornadaTable
          .$converterdataInicioBancon
          .toSql(dataInicioBanco.value));
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracoesJornadaCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('ativa: $ativa, ')
          ..write('toleranciaMinutos: $toleranciaMinutos, ')
          ..write('permiteViradaDia: $permiteViradaDia, ')
          ..write('dataInicioBanco: $dataInicioBanco, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }
}

class $JornadasDiaSemanaTable extends JornadasDiaSemana
    with TableInfo<$JornadasDiaSemanaTable, JornadaDiaSemanaLinha> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JornadasDiaSemanaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _configuracaoIdMeta =
      const VerificationMeta('configuracaoId');
  @override
  late final GeneratedColumn<int> configuracaoId = GeneratedColumn<int>(
      'configuracao_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES configuracao_jornada (id) ON DELETE CASCADE'));
  static const VerificationMeta _diaSemanaMeta =
      const VerificationMeta('diaSemana');
  @override
  late final GeneratedColumn<int> diaSemana = GeneratedColumn<int>(
      'dia_semana', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _trabalhaMeta =
      const VerificationMeta('trabalha');
  @override
  late final GeneratedColumn<bool> trabalha = GeneratedColumn<bool>(
      'trabalha', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("trabalha" IN (0, 1))'));
  static const VerificationMeta _cargaMinutosMeta =
      const VerificationMeta('cargaMinutos');
  @override
  late final GeneratedColumn<int> cargaMinutos = GeneratedColumn<int>(
      'carga_minutos', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _cargaManualMeta =
      const VerificationMeta('cargaManual');
  @override
  late final GeneratedColumn<bool> cargaManual = GeneratedColumn<bool>(
      'carga_manual', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("carga_manual" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, configuracaoId, diaSemana, trabalha, cargaMinutos, cargaManual];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'jornada_dia_semana';
  @override
  VerificationContext validateIntegrity(
      Insertable<JornadaDiaSemanaLinha> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('configuracao_id')) {
      context.handle(
          _configuracaoIdMeta,
          configuracaoId.isAcceptableOrUnknown(
              data['configuracao_id']!, _configuracaoIdMeta));
    } else if (isInserting) {
      context.missing(_configuracaoIdMeta);
    }
    if (data.containsKey('dia_semana')) {
      context.handle(_diaSemanaMeta,
          diaSemana.isAcceptableOrUnknown(data['dia_semana']!, _diaSemanaMeta));
    } else if (isInserting) {
      context.missing(_diaSemanaMeta);
    }
    if (data.containsKey('trabalha')) {
      context.handle(_trabalhaMeta,
          trabalha.isAcceptableOrUnknown(data['trabalha']!, _trabalhaMeta));
    } else if (isInserting) {
      context.missing(_trabalhaMeta);
    }
    if (data.containsKey('carga_minutos')) {
      context.handle(
          _cargaMinutosMeta,
          cargaMinutos.isAcceptableOrUnknown(
              data['carga_minutos']!, _cargaMinutosMeta));
    } else if (isInserting) {
      context.missing(_cargaMinutosMeta);
    }
    if (data.containsKey('carga_manual')) {
      context.handle(
          _cargaManualMeta,
          cargaManual.isAcceptableOrUnknown(
              data['carga_manual']!, _cargaManualMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {configuracaoId, diaSemana},
      ];
  @override
  JornadaDiaSemanaLinha map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JornadaDiaSemanaLinha(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      configuracaoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}configuracao_id'])!,
      diaSemana: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dia_semana'])!,
      trabalha: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}trabalha'])!,
      cargaMinutos: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}carga_minutos'])!,
      cargaManual: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}carga_manual'])!,
    );
  }

  @override
  $JornadasDiaSemanaTable createAlias(String alias) {
    return $JornadasDiaSemanaTable(attachedDatabase, alias);
  }
}

class JornadaDiaSemanaLinha extends DataClass
    implements Insertable<JornadaDiaSemanaLinha> {
  final int id;
  final int configuracaoId;
  final int diaSemana;
  final bool trabalha;
  final int cargaMinutos;
  final bool cargaManual;
  const JornadaDiaSemanaLinha(
      {required this.id,
      required this.configuracaoId,
      required this.diaSemana,
      required this.trabalha,
      required this.cargaMinutos,
      required this.cargaManual});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['configuracao_id'] = Variable<int>(configuracaoId);
    map['dia_semana'] = Variable<int>(diaSemana);
    map['trabalha'] = Variable<bool>(trabalha);
    map['carga_minutos'] = Variable<int>(cargaMinutos);
    map['carga_manual'] = Variable<bool>(cargaManual);
    return map;
  }

  JornadasDiaSemanaCompanion toCompanion(bool nullToAbsent) {
    return JornadasDiaSemanaCompanion(
      id: Value(id),
      configuracaoId: Value(configuracaoId),
      diaSemana: Value(diaSemana),
      trabalha: Value(trabalha),
      cargaMinutos: Value(cargaMinutos),
      cargaManual: Value(cargaManual),
    );
  }

  factory JornadaDiaSemanaLinha.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JornadaDiaSemanaLinha(
      id: serializer.fromJson<int>(json['id']),
      configuracaoId: serializer.fromJson<int>(json['configuracaoId']),
      diaSemana: serializer.fromJson<int>(json['diaSemana']),
      trabalha: serializer.fromJson<bool>(json['trabalha']),
      cargaMinutos: serializer.fromJson<int>(json['cargaMinutos']),
      cargaManual: serializer.fromJson<bool>(json['cargaManual']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'configuracaoId': serializer.toJson<int>(configuracaoId),
      'diaSemana': serializer.toJson<int>(diaSemana),
      'trabalha': serializer.toJson<bool>(trabalha),
      'cargaMinutos': serializer.toJson<int>(cargaMinutos),
      'cargaManual': serializer.toJson<bool>(cargaManual),
    };
  }

  JornadaDiaSemanaLinha copyWith(
          {int? id,
          int? configuracaoId,
          int? diaSemana,
          bool? trabalha,
          int? cargaMinutos,
          bool? cargaManual}) =>
      JornadaDiaSemanaLinha(
        id: id ?? this.id,
        configuracaoId: configuracaoId ?? this.configuracaoId,
        diaSemana: diaSemana ?? this.diaSemana,
        trabalha: trabalha ?? this.trabalha,
        cargaMinutos: cargaMinutos ?? this.cargaMinutos,
        cargaManual: cargaManual ?? this.cargaManual,
      );
  JornadaDiaSemanaLinha copyWithCompanion(JornadasDiaSemanaCompanion data) {
    return JornadaDiaSemanaLinha(
      id: data.id.present ? data.id.value : this.id,
      configuracaoId: data.configuracaoId.present
          ? data.configuracaoId.value
          : this.configuracaoId,
      diaSemana: data.diaSemana.present ? data.diaSemana.value : this.diaSemana,
      trabalha: data.trabalha.present ? data.trabalha.value : this.trabalha,
      cargaMinutos: data.cargaMinutos.present
          ? data.cargaMinutos.value
          : this.cargaMinutos,
      cargaManual:
          data.cargaManual.present ? data.cargaManual.value : this.cargaManual,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JornadaDiaSemanaLinha(')
          ..write('id: $id, ')
          ..write('configuracaoId: $configuracaoId, ')
          ..write('diaSemana: $diaSemana, ')
          ..write('trabalha: $trabalha, ')
          ..write('cargaMinutos: $cargaMinutos, ')
          ..write('cargaManual: $cargaManual')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, configuracaoId, diaSemana, trabalha, cargaMinutos, cargaManual);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JornadaDiaSemanaLinha &&
          other.id == this.id &&
          other.configuracaoId == this.configuracaoId &&
          other.diaSemana == this.diaSemana &&
          other.trabalha == this.trabalha &&
          other.cargaMinutos == this.cargaMinutos &&
          other.cargaManual == this.cargaManual);
}

class JornadasDiaSemanaCompanion
    extends UpdateCompanion<JornadaDiaSemanaLinha> {
  final Value<int> id;
  final Value<int> configuracaoId;
  final Value<int> diaSemana;
  final Value<bool> trabalha;
  final Value<int> cargaMinutos;
  final Value<bool> cargaManual;
  const JornadasDiaSemanaCompanion({
    this.id = const Value.absent(),
    this.configuracaoId = const Value.absent(),
    this.diaSemana = const Value.absent(),
    this.trabalha = const Value.absent(),
    this.cargaMinutos = const Value.absent(),
    this.cargaManual = const Value.absent(),
  });
  JornadasDiaSemanaCompanion.insert({
    this.id = const Value.absent(),
    required int configuracaoId,
    required int diaSemana,
    required bool trabalha,
    required int cargaMinutos,
    this.cargaManual = const Value.absent(),
  })  : configuracaoId = Value(configuracaoId),
        diaSemana = Value(diaSemana),
        trabalha = Value(trabalha),
        cargaMinutos = Value(cargaMinutos);
  static Insertable<JornadaDiaSemanaLinha> custom({
    Expression<int>? id,
    Expression<int>? configuracaoId,
    Expression<int>? diaSemana,
    Expression<bool>? trabalha,
    Expression<int>? cargaMinutos,
    Expression<bool>? cargaManual,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (configuracaoId != null) 'configuracao_id': configuracaoId,
      if (diaSemana != null) 'dia_semana': diaSemana,
      if (trabalha != null) 'trabalha': trabalha,
      if (cargaMinutos != null) 'carga_minutos': cargaMinutos,
      if (cargaManual != null) 'carga_manual': cargaManual,
    });
  }

  JornadasDiaSemanaCompanion copyWith(
      {Value<int>? id,
      Value<int>? configuracaoId,
      Value<int>? diaSemana,
      Value<bool>? trabalha,
      Value<int>? cargaMinutos,
      Value<bool>? cargaManual}) {
    return JornadasDiaSemanaCompanion(
      id: id ?? this.id,
      configuracaoId: configuracaoId ?? this.configuracaoId,
      diaSemana: diaSemana ?? this.diaSemana,
      trabalha: trabalha ?? this.trabalha,
      cargaMinutos: cargaMinutos ?? this.cargaMinutos,
      cargaManual: cargaManual ?? this.cargaManual,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (configuracaoId.present) {
      map['configuracao_id'] = Variable<int>(configuracaoId.value);
    }
    if (diaSemana.present) {
      map['dia_semana'] = Variable<int>(diaSemana.value);
    }
    if (trabalha.present) {
      map['trabalha'] = Variable<bool>(trabalha.value);
    }
    if (cargaMinutos.present) {
      map['carga_minutos'] = Variable<int>(cargaMinutos.value);
    }
    if (cargaManual.present) {
      map['carga_manual'] = Variable<bool>(cargaManual.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JornadasDiaSemanaCompanion(')
          ..write('id: $id, ')
          ..write('configuracaoId: $configuracaoId, ')
          ..write('diaSemana: $diaSemana, ')
          ..write('trabalha: $trabalha, ')
          ..write('cargaMinutos: $cargaMinutos, ')
          ..write('cargaManual: $cargaManual')
          ..write(')'))
        .toString();
  }
}

class $TurnosPrevistosTable extends TurnosPrevistos
    with TableInfo<$TurnosPrevistosTable, TurnoPrevistoLinha> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TurnosPrevistosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _jornadaDiaIdMeta =
      const VerificationMeta('jornadaDiaId');
  @override
  late final GeneratedColumn<int> jornadaDiaId = GeneratedColumn<int>(
      'jornada_dia_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES jornada_dia_semana (id) ON DELETE CASCADE'));
  static const VerificationMeta _ordemMeta = const VerificationMeta('ordem');
  @override
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
      'ordem', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _horaEntradaMeta =
      const VerificationMeta('horaEntrada');
  @override
  late final GeneratedColumnWithTypeConverter<Duration, int> horaEntrada =
      GeneratedColumn<int>('hora_entrada', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<Duration>($TurnosPrevistosTable.$converterhoraEntrada);
  static const VerificationMeta _horaSaidaMeta =
      const VerificationMeta('horaSaida');
  @override
  late final GeneratedColumnWithTypeConverter<Duration, int> horaSaida =
      GeneratedColumn<int>('hora_saida', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<Duration>($TurnosPrevistosTable.$converterhoraSaida);
  @override
  List<GeneratedColumn> get $columns =>
      [id, jornadaDiaId, ordem, horaEntrada, horaSaida];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'turno_previsto';
  @override
  VerificationContext validateIntegrity(Insertable<TurnoPrevistoLinha> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('jornada_dia_id')) {
      context.handle(
          _jornadaDiaIdMeta,
          jornadaDiaId.isAcceptableOrUnknown(
              data['jornada_dia_id']!, _jornadaDiaIdMeta));
    } else if (isInserting) {
      context.missing(_jornadaDiaIdMeta);
    }
    if (data.containsKey('ordem')) {
      context.handle(
          _ordemMeta, ordem.isAcceptableOrUnknown(data['ordem']!, _ordemMeta));
    } else if (isInserting) {
      context.missing(_ordemMeta);
    }
    context.handle(_horaEntradaMeta, const VerificationResult.success());
    context.handle(_horaSaidaMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TurnoPrevistoLinha map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TurnoPrevistoLinha(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      jornadaDiaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jornada_dia_id'])!,
      ordem: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ordem'])!,
      horaEntrada: $TurnosPrevistosTable.$converterhoraEntrada.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}hora_entrada'])!),
      horaSaida: $TurnosPrevistosTable.$converterhoraSaida.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}hora_saida'])!),
    );
  }

  @override
  $TurnosPrevistosTable createAlias(String alias) {
    return $TurnosPrevistosTable(attachedDatabase, alias);
  }

  static TypeConverter<Duration, int> $converterhoraEntrada =
      const ConversorMinutos();
  static TypeConverter<Duration, int> $converterhoraSaida =
      const ConversorMinutos();
}

class TurnoPrevistoLinha extends DataClass
    implements Insertable<TurnoPrevistoLinha> {
  final int id;
  final int jornadaDiaId;
  final int ordem;
  final Duration horaEntrada;
  final Duration horaSaida;
  const TurnoPrevistoLinha(
      {required this.id,
      required this.jornadaDiaId,
      required this.ordem,
      required this.horaEntrada,
      required this.horaSaida});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['jornada_dia_id'] = Variable<int>(jornadaDiaId);
    map['ordem'] = Variable<int>(ordem);
    {
      map['hora_entrada'] = Variable<int>(
          $TurnosPrevistosTable.$converterhoraEntrada.toSql(horaEntrada));
    }
    {
      map['hora_saida'] = Variable<int>(
          $TurnosPrevistosTable.$converterhoraSaida.toSql(horaSaida));
    }
    return map;
  }

  TurnosPrevistosCompanion toCompanion(bool nullToAbsent) {
    return TurnosPrevistosCompanion(
      id: Value(id),
      jornadaDiaId: Value(jornadaDiaId),
      ordem: Value(ordem),
      horaEntrada: Value(horaEntrada),
      horaSaida: Value(horaSaida),
    );
  }

  factory TurnoPrevistoLinha.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TurnoPrevistoLinha(
      id: serializer.fromJson<int>(json['id']),
      jornadaDiaId: serializer.fromJson<int>(json['jornadaDiaId']),
      ordem: serializer.fromJson<int>(json['ordem']),
      horaEntrada: serializer.fromJson<Duration>(json['horaEntrada']),
      horaSaida: serializer.fromJson<Duration>(json['horaSaida']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'jornadaDiaId': serializer.toJson<int>(jornadaDiaId),
      'ordem': serializer.toJson<int>(ordem),
      'horaEntrada': serializer.toJson<Duration>(horaEntrada),
      'horaSaida': serializer.toJson<Duration>(horaSaida),
    };
  }

  TurnoPrevistoLinha copyWith(
          {int? id,
          int? jornadaDiaId,
          int? ordem,
          Duration? horaEntrada,
          Duration? horaSaida}) =>
      TurnoPrevistoLinha(
        id: id ?? this.id,
        jornadaDiaId: jornadaDiaId ?? this.jornadaDiaId,
        ordem: ordem ?? this.ordem,
        horaEntrada: horaEntrada ?? this.horaEntrada,
        horaSaida: horaSaida ?? this.horaSaida,
      );
  TurnoPrevistoLinha copyWithCompanion(TurnosPrevistosCompanion data) {
    return TurnoPrevistoLinha(
      id: data.id.present ? data.id.value : this.id,
      jornadaDiaId: data.jornadaDiaId.present
          ? data.jornadaDiaId.value
          : this.jornadaDiaId,
      ordem: data.ordem.present ? data.ordem.value : this.ordem,
      horaEntrada:
          data.horaEntrada.present ? data.horaEntrada.value : this.horaEntrada,
      horaSaida: data.horaSaida.present ? data.horaSaida.value : this.horaSaida,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TurnoPrevistoLinha(')
          ..write('id: $id, ')
          ..write('jornadaDiaId: $jornadaDiaId, ')
          ..write('ordem: $ordem, ')
          ..write('horaEntrada: $horaEntrada, ')
          ..write('horaSaida: $horaSaida')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, jornadaDiaId, ordem, horaEntrada, horaSaida);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TurnoPrevistoLinha &&
          other.id == this.id &&
          other.jornadaDiaId == this.jornadaDiaId &&
          other.ordem == this.ordem &&
          other.horaEntrada == this.horaEntrada &&
          other.horaSaida == this.horaSaida);
}

class TurnosPrevistosCompanion extends UpdateCompanion<TurnoPrevistoLinha> {
  final Value<int> id;
  final Value<int> jornadaDiaId;
  final Value<int> ordem;
  final Value<Duration> horaEntrada;
  final Value<Duration> horaSaida;
  const TurnosPrevistosCompanion({
    this.id = const Value.absent(),
    this.jornadaDiaId = const Value.absent(),
    this.ordem = const Value.absent(),
    this.horaEntrada = const Value.absent(),
    this.horaSaida = const Value.absent(),
  });
  TurnosPrevistosCompanion.insert({
    this.id = const Value.absent(),
    required int jornadaDiaId,
    required int ordem,
    required Duration horaEntrada,
    required Duration horaSaida,
  })  : jornadaDiaId = Value(jornadaDiaId),
        ordem = Value(ordem),
        horaEntrada = Value(horaEntrada),
        horaSaida = Value(horaSaida);
  static Insertable<TurnoPrevistoLinha> custom({
    Expression<int>? id,
    Expression<int>? jornadaDiaId,
    Expression<int>? ordem,
    Expression<int>? horaEntrada,
    Expression<int>? horaSaida,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jornadaDiaId != null) 'jornada_dia_id': jornadaDiaId,
      if (ordem != null) 'ordem': ordem,
      if (horaEntrada != null) 'hora_entrada': horaEntrada,
      if (horaSaida != null) 'hora_saida': horaSaida,
    });
  }

  TurnosPrevistosCompanion copyWith(
      {Value<int>? id,
      Value<int>? jornadaDiaId,
      Value<int>? ordem,
      Value<Duration>? horaEntrada,
      Value<Duration>? horaSaida}) {
    return TurnosPrevistosCompanion(
      id: id ?? this.id,
      jornadaDiaId: jornadaDiaId ?? this.jornadaDiaId,
      ordem: ordem ?? this.ordem,
      horaEntrada: horaEntrada ?? this.horaEntrada,
      horaSaida: horaSaida ?? this.horaSaida,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (jornadaDiaId.present) {
      map['jornada_dia_id'] = Variable<int>(jornadaDiaId.value);
    }
    if (ordem.present) {
      map['ordem'] = Variable<int>(ordem.value);
    }
    if (horaEntrada.present) {
      map['hora_entrada'] = Variable<int>(
          $TurnosPrevistosTable.$converterhoraEntrada.toSql(horaEntrada.value));
    }
    if (horaSaida.present) {
      map['hora_saida'] = Variable<int>(
          $TurnosPrevistosTable.$converterhoraSaida.toSql(horaSaida.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TurnosPrevistosCompanion(')
          ..write('id: $id, ')
          ..write('jornadaDiaId: $jornadaDiaId, ')
          ..write('ordem: $ordem, ')
          ..write('horaEntrada: $horaEntrada, ')
          ..write('horaSaida: $horaSaida')
          ..write(')'))
        .toString();
  }
}

class $DiasTrabalhoTable extends DiasTrabalho
    with TableInfo<$DiasTrabalhoTable, DiaTrabalhoLinha> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiasTrabalhoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> data =
      GeneratedColumn<String>('data', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: true,
              defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'))
          .withConverter<DateTime>($DiasTrabalhoTable.$converterdata);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<StatusDia, String> status =
      GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('NORMAL'))
          .withConverter<StatusDia>($DiasTrabalhoTable.$converterstatus);
  static const VerificationMeta _statusManualMeta =
      const VerificationMeta('statusManual');
  @override
  late final GeneratedColumn<bool> statusManual = GeneratedColumn<bool>(
      'status_manual', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("status_manual" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _observacaoMeta =
      const VerificationMeta('observacao');
  @override
  late final GeneratedColumn<String> observacao = GeneratedColumn<String>(
      'observacao', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cargaPrevistaMinutosMeta =
      const VerificationMeta('cargaPrevistaMinutos');
  @override
  late final GeneratedColumn<int> cargaPrevistaMinutos = GeneratedColumn<int>(
      'carga_prevista_minutos', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _minutosTrabalhadosMeta =
      const VerificationMeta('minutosTrabalhados');
  @override
  late final GeneratedColumn<int> minutosTrabalhados = GeneratedColumn<int>(
      'minutos_trabalhados', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _saldoMinutosMeta =
      const VerificationMeta('saldoMinutos');
  @override
  late final GeneratedColumn<int> saldoMinutos = GeneratedColumn<int>(
      'saldo_minutos', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _inconsistenteMeta =
      const VerificationMeta('inconsistente');
  @override
  late final GeneratedColumn<bool> inconsistente = GeneratedColumn<bool>(
      'inconsistente', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("inconsistente" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _fechadoMeta =
      const VerificationMeta('fechado');
  @override
  late final GeneratedColumn<bool> fechado = GeneratedColumn<bool>(
      'fechado', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("fechado" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _atualizadoEmMeta =
      const VerificationMeta('atualizadoEm');
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
      'atualizado_em', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        data,
        status,
        statusManual,
        observacao,
        cargaPrevistaMinutos,
        minutosTrabalhados,
        saldoMinutos,
        inconsistente,
        fechado,
        atualizadoEm
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dia_trabalho';
  @override
  VerificationContext validateIntegrity(Insertable<DiaTrabalhoLinha> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    context.handle(_dataMeta, const VerificationResult.success());
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('status_manual')) {
      context.handle(
          _statusManualMeta,
          statusManual.isAcceptableOrUnknown(
              data['status_manual']!, _statusManualMeta));
    }
    if (data.containsKey('observacao')) {
      context.handle(
          _observacaoMeta,
          observacao.isAcceptableOrUnknown(
              data['observacao']!, _observacaoMeta));
    }
    if (data.containsKey('carga_prevista_minutos')) {
      context.handle(
          _cargaPrevistaMinutosMeta,
          cargaPrevistaMinutos.isAcceptableOrUnknown(
              data['carga_prevista_minutos']!, _cargaPrevistaMinutosMeta));
    }
    if (data.containsKey('minutos_trabalhados')) {
      context.handle(
          _minutosTrabalhadosMeta,
          minutosTrabalhados.isAcceptableOrUnknown(
              data['minutos_trabalhados']!, _minutosTrabalhadosMeta));
    }
    if (data.containsKey('saldo_minutos')) {
      context.handle(
          _saldoMinutosMeta,
          saldoMinutos.isAcceptableOrUnknown(
              data['saldo_minutos']!, _saldoMinutosMeta));
    }
    if (data.containsKey('inconsistente')) {
      context.handle(
          _inconsistenteMeta,
          inconsistente.isAcceptableOrUnknown(
              data['inconsistente']!, _inconsistenteMeta));
    }
    if (data.containsKey('fechado')) {
      context.handle(_fechadoMeta,
          fechado.isAcceptableOrUnknown(data['fechado']!, _fechadoMeta));
    }
    if (data.containsKey('atualizado_em')) {
      context.handle(
          _atualizadoEmMeta,
          atualizadoEm.isAcceptableOrUnknown(
              data['atualizado_em']!, _atualizadoEmMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiaTrabalhoLinha map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaTrabalhoLinha(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      data: $DiasTrabalhoTable.$converterdata.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!),
      status: $DiasTrabalhoTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      statusManual: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}status_manual'])!,
      observacao: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observacao']),
      cargaPrevistaMinutos: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}carga_prevista_minutos'])!,
      minutosTrabalhados: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}minutos_trabalhados'])!,
      saldoMinutos: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}saldo_minutos'])!,
      inconsistente: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}inconsistente'])!,
      fechado: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}fechado'])!,
      atualizadoEm: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}atualizado_em'])!,
    );
  }

  @override
  $DiasTrabalhoTable createAlias(String alias) {
    return $DiasTrabalhoTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterdata = const ConversorData();
  static TypeConverter<StatusDia, String> $converterstatus =
      const ConversorEnum<StatusDia>(StatusDia.values);
}

class DiaTrabalhoLinha extends DataClass
    implements Insertable<DiaTrabalhoLinha> {
  final int id;
  final DateTime data;
  final StatusDia status;
  final bool statusManual;
  final String? observacao;
  final int cargaPrevistaMinutos;
  final int minutosTrabalhados;
  final int saldoMinutos;
  final bool inconsistente;
  final bool fechado;
  final DateTime atualizadoEm;
  const DiaTrabalhoLinha(
      {required this.id,
      required this.data,
      required this.status,
      required this.statusManual,
      this.observacao,
      required this.cargaPrevistaMinutos,
      required this.minutosTrabalhados,
      required this.saldoMinutos,
      required this.inconsistente,
      required this.fechado,
      required this.atualizadoEm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['data'] =
          Variable<String>($DiasTrabalhoTable.$converterdata.toSql(data));
    }
    {
      map['status'] =
          Variable<String>($DiasTrabalhoTable.$converterstatus.toSql(status));
    }
    map['status_manual'] = Variable<bool>(statusManual);
    if (!nullToAbsent || observacao != null) {
      map['observacao'] = Variable<String>(observacao);
    }
    map['carga_prevista_minutos'] = Variable<int>(cargaPrevistaMinutos);
    map['minutos_trabalhados'] = Variable<int>(minutosTrabalhados);
    map['saldo_minutos'] = Variable<int>(saldoMinutos);
    map['inconsistente'] = Variable<bool>(inconsistente);
    map['fechado'] = Variable<bool>(fechado);
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    return map;
  }

  DiasTrabalhoCompanion toCompanion(bool nullToAbsent) {
    return DiasTrabalhoCompanion(
      id: Value(id),
      data: Value(data),
      status: Value(status),
      statusManual: Value(statusManual),
      observacao: observacao == null && nullToAbsent
          ? const Value.absent()
          : Value(observacao),
      cargaPrevistaMinutos: Value(cargaPrevistaMinutos),
      minutosTrabalhados: Value(minutosTrabalhados),
      saldoMinutos: Value(saldoMinutos),
      inconsistente: Value(inconsistente),
      fechado: Value(fechado),
      atualizadoEm: Value(atualizadoEm),
    );
  }

  factory DiaTrabalhoLinha.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaTrabalhoLinha(
      id: serializer.fromJson<int>(json['id']),
      data: serializer.fromJson<DateTime>(json['data']),
      status: serializer.fromJson<StatusDia>(json['status']),
      statusManual: serializer.fromJson<bool>(json['statusManual']),
      observacao: serializer.fromJson<String?>(json['observacao']),
      cargaPrevistaMinutos:
          serializer.fromJson<int>(json['cargaPrevistaMinutos']),
      minutosTrabalhados: serializer.fromJson<int>(json['minutosTrabalhados']),
      saldoMinutos: serializer.fromJson<int>(json['saldoMinutos']),
      inconsistente: serializer.fromJson<bool>(json['inconsistente']),
      fechado: serializer.fromJson<bool>(json['fechado']),
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'data': serializer.toJson<DateTime>(data),
      'status': serializer.toJson<StatusDia>(status),
      'statusManual': serializer.toJson<bool>(statusManual),
      'observacao': serializer.toJson<String?>(observacao),
      'cargaPrevistaMinutos': serializer.toJson<int>(cargaPrevistaMinutos),
      'minutosTrabalhados': serializer.toJson<int>(minutosTrabalhados),
      'saldoMinutos': serializer.toJson<int>(saldoMinutos),
      'inconsistente': serializer.toJson<bool>(inconsistente),
      'fechado': serializer.toJson<bool>(fechado),
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
    };
  }

  DiaTrabalhoLinha copyWith(
          {int? id,
          DateTime? data,
          StatusDia? status,
          bool? statusManual,
          Value<String?> observacao = const Value.absent(),
          int? cargaPrevistaMinutos,
          int? minutosTrabalhados,
          int? saldoMinutos,
          bool? inconsistente,
          bool? fechado,
          DateTime? atualizadoEm}) =>
      DiaTrabalhoLinha(
        id: id ?? this.id,
        data: data ?? this.data,
        status: status ?? this.status,
        statusManual: statusManual ?? this.statusManual,
        observacao: observacao.present ? observacao.value : this.observacao,
        cargaPrevistaMinutos: cargaPrevistaMinutos ?? this.cargaPrevistaMinutos,
        minutosTrabalhados: minutosTrabalhados ?? this.minutosTrabalhados,
        saldoMinutos: saldoMinutos ?? this.saldoMinutos,
        inconsistente: inconsistente ?? this.inconsistente,
        fechado: fechado ?? this.fechado,
        atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      );
  DiaTrabalhoLinha copyWithCompanion(DiasTrabalhoCompanion data) {
    return DiaTrabalhoLinha(
      id: data.id.present ? data.id.value : this.id,
      data: data.data.present ? data.data.value : this.data,
      status: data.status.present ? data.status.value : this.status,
      statusManual: data.statusManual.present
          ? data.statusManual.value
          : this.statusManual,
      observacao:
          data.observacao.present ? data.observacao.value : this.observacao,
      cargaPrevistaMinutos: data.cargaPrevistaMinutos.present
          ? data.cargaPrevistaMinutos.value
          : this.cargaPrevistaMinutos,
      minutosTrabalhados: data.minutosTrabalhados.present
          ? data.minutosTrabalhados.value
          : this.minutosTrabalhados,
      saldoMinutos: data.saldoMinutos.present
          ? data.saldoMinutos.value
          : this.saldoMinutos,
      inconsistente: data.inconsistente.present
          ? data.inconsistente.value
          : this.inconsistente,
      fechado: data.fechado.present ? data.fechado.value : this.fechado,
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiaTrabalhoLinha(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('status: $status, ')
          ..write('statusManual: $statusManual, ')
          ..write('observacao: $observacao, ')
          ..write('cargaPrevistaMinutos: $cargaPrevistaMinutos, ')
          ..write('minutosTrabalhados: $minutosTrabalhados, ')
          ..write('saldoMinutos: $saldoMinutos, ')
          ..write('inconsistente: $inconsistente, ')
          ..write('fechado: $fechado, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      data,
      status,
      statusManual,
      observacao,
      cargaPrevistaMinutos,
      minutosTrabalhados,
      saldoMinutos,
      inconsistente,
      fechado,
      atualizadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaTrabalhoLinha &&
          other.id == this.id &&
          other.data == this.data &&
          other.status == this.status &&
          other.statusManual == this.statusManual &&
          other.observacao == this.observacao &&
          other.cargaPrevistaMinutos == this.cargaPrevistaMinutos &&
          other.minutosTrabalhados == this.minutosTrabalhados &&
          other.saldoMinutos == this.saldoMinutos &&
          other.inconsistente == this.inconsistente &&
          other.fechado == this.fechado &&
          other.atualizadoEm == this.atualizadoEm);
}

class DiasTrabalhoCompanion extends UpdateCompanion<DiaTrabalhoLinha> {
  final Value<int> id;
  final Value<DateTime> data;
  final Value<StatusDia> status;
  final Value<bool> statusManual;
  final Value<String?> observacao;
  final Value<int> cargaPrevistaMinutos;
  final Value<int> minutosTrabalhados;
  final Value<int> saldoMinutos;
  final Value<bool> inconsistente;
  final Value<bool> fechado;
  final Value<DateTime> atualizadoEm;
  const DiasTrabalhoCompanion({
    this.id = const Value.absent(),
    this.data = const Value.absent(),
    this.status = const Value.absent(),
    this.statusManual = const Value.absent(),
    this.observacao = const Value.absent(),
    this.cargaPrevistaMinutos = const Value.absent(),
    this.minutosTrabalhados = const Value.absent(),
    this.saldoMinutos = const Value.absent(),
    this.inconsistente = const Value.absent(),
    this.fechado = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
  });
  DiasTrabalhoCompanion.insert({
    this.id = const Value.absent(),
    required DateTime data,
    this.status = const Value.absent(),
    this.statusManual = const Value.absent(),
    this.observacao = const Value.absent(),
    this.cargaPrevistaMinutos = const Value.absent(),
    this.minutosTrabalhados = const Value.absent(),
    this.saldoMinutos = const Value.absent(),
    this.inconsistente = const Value.absent(),
    this.fechado = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
  }) : data = Value(data);
  static Insertable<DiaTrabalhoLinha> custom({
    Expression<int>? id,
    Expression<String>? data,
    Expression<String>? status,
    Expression<bool>? statusManual,
    Expression<String>? observacao,
    Expression<int>? cargaPrevistaMinutos,
    Expression<int>? minutosTrabalhados,
    Expression<int>? saldoMinutos,
    Expression<bool>? inconsistente,
    Expression<bool>? fechado,
    Expression<DateTime>? atualizadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (data != null) 'data': data,
      if (status != null) 'status': status,
      if (statusManual != null) 'status_manual': statusManual,
      if (observacao != null) 'observacao': observacao,
      if (cargaPrevistaMinutos != null)
        'carga_prevista_minutos': cargaPrevistaMinutos,
      if (minutosTrabalhados != null) 'minutos_trabalhados': minutosTrabalhados,
      if (saldoMinutos != null) 'saldo_minutos': saldoMinutos,
      if (inconsistente != null) 'inconsistente': inconsistente,
      if (fechado != null) 'fechado': fechado,
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
    });
  }

  DiasTrabalhoCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? data,
      Value<StatusDia>? status,
      Value<bool>? statusManual,
      Value<String?>? observacao,
      Value<int>? cargaPrevistaMinutos,
      Value<int>? minutosTrabalhados,
      Value<int>? saldoMinutos,
      Value<bool>? inconsistente,
      Value<bool>? fechado,
      Value<DateTime>? atualizadoEm}) {
    return DiasTrabalhoCompanion(
      id: id ?? this.id,
      data: data ?? this.data,
      status: status ?? this.status,
      statusManual: statusManual ?? this.statusManual,
      observacao: observacao ?? this.observacao,
      cargaPrevistaMinutos: cargaPrevistaMinutos ?? this.cargaPrevistaMinutos,
      minutosTrabalhados: minutosTrabalhados ?? this.minutosTrabalhados,
      saldoMinutos: saldoMinutos ?? this.saldoMinutos,
      inconsistente: inconsistente ?? this.inconsistente,
      fechado: fechado ?? this.fechado,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (data.present) {
      map['data'] =
          Variable<String>($DiasTrabalhoTable.$converterdata.toSql(data.value));
    }
    if (status.present) {
      map['status'] = Variable<String>(
          $DiasTrabalhoTable.$converterstatus.toSql(status.value));
    }
    if (statusManual.present) {
      map['status_manual'] = Variable<bool>(statusManual.value);
    }
    if (observacao.present) {
      map['observacao'] = Variable<String>(observacao.value);
    }
    if (cargaPrevistaMinutos.present) {
      map['carga_prevista_minutos'] = Variable<int>(cargaPrevistaMinutos.value);
    }
    if (minutosTrabalhados.present) {
      map['minutos_trabalhados'] = Variable<int>(minutosTrabalhados.value);
    }
    if (saldoMinutos.present) {
      map['saldo_minutos'] = Variable<int>(saldoMinutos.value);
    }
    if (inconsistente.present) {
      map['inconsistente'] = Variable<bool>(inconsistente.value);
    }
    if (fechado.present) {
      map['fechado'] = Variable<bool>(fechado.value);
    }
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiasTrabalhoCompanion(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('status: $status, ')
          ..write('statusManual: $statusManual, ')
          ..write('observacao: $observacao, ')
          ..write('cargaPrevistaMinutos: $cargaPrevistaMinutos, ')
          ..write('minutosTrabalhados: $minutosTrabalhados, ')
          ..write('saldoMinutos: $saldoMinutos, ')
          ..write('inconsistente: $inconsistente, ')
          ..write('fechado: $fechado, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }
}

class $MarcacoesTable extends Marcacoes
    with TableInfo<$MarcacoesTable, MarcacaoLinha> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MarcacoesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _diaIdMeta = const VerificationMeta('diaId');
  @override
  late final GeneratedColumn<int> diaId = GeneratedColumn<int>(
      'dia_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES dia_trabalho (id) ON DELETE CASCADE'));
  static const VerificationMeta _ordemMeta = const VerificationMeta('ordem');
  @override
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
      'ordem', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumnWithTypeConverter<TipoMarcacao, String> tipo =
      GeneratedColumn<String>('tipo', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TipoMarcacao>($MarcacoesTable.$convertertipo);
  static const VerificationMeta _horaMeta = const VerificationMeta('hora');
  @override
  late final GeneratedColumnWithTypeConverter<Duration, int> hora =
      GeneratedColumn<int>('hora', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<Duration>($MarcacoesTable.$converterhora);
  static const VerificationMeta _origemMeta = const VerificationMeta('origem');
  @override
  late final GeneratedColumnWithTypeConverter<OrigemMarcacao, String> origem =
      GeneratedColumn<String>('origem', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('MANUAL'))
          .withConverter<OrigemMarcacao>($MarcacoesTable.$converterorigem);
  static const VerificationMeta _editadaMeta =
      const VerificationMeta('editada');
  @override
  late final GeneratedColumn<bool> editada = GeneratedColumn<bool>(
      'editada', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("editada" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _criadoEmMeta =
      const VerificationMeta('criadoEm');
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
      'criado_em', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, diaId, ordem, tipo, hora, origem, editada, criadoEm];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'marcacao';
  @override
  VerificationContext validateIntegrity(Insertable<MarcacaoLinha> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('dia_id')) {
      context.handle(
          _diaIdMeta, diaId.isAcceptableOrUnknown(data['dia_id']!, _diaIdMeta));
    } else if (isInserting) {
      context.missing(_diaIdMeta);
    }
    if (data.containsKey('ordem')) {
      context.handle(
          _ordemMeta, ordem.isAcceptableOrUnknown(data['ordem']!, _ordemMeta));
    } else if (isInserting) {
      context.missing(_ordemMeta);
    }
    context.handle(_tipoMeta, const VerificationResult.success());
    context.handle(_horaMeta, const VerificationResult.success());
    context.handle(_origemMeta, const VerificationResult.success());
    if (data.containsKey('editada')) {
      context.handle(_editadaMeta,
          editada.isAcceptableOrUnknown(data['editada']!, _editadaMeta));
    }
    if (data.containsKey('criado_em')) {
      context.handle(_criadoEmMeta,
          criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {diaId, hora},
      ];
  @override
  MarcacaoLinha map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MarcacaoLinha(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      diaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dia_id'])!,
      ordem: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ordem'])!,
      tipo: $MarcacoesTable.$convertertipo.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo'])!),
      hora: $MarcacoesTable.$converterhora.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hora'])!),
      origem: $MarcacoesTable.$converterorigem.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}origem'])!),
      editada: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}editada'])!,
      criadoEm: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}criado_em'])!,
    );
  }

  @override
  $MarcacoesTable createAlias(String alias) {
    return $MarcacoesTable(attachedDatabase, alias);
  }

  static TypeConverter<TipoMarcacao, String> $convertertipo =
      const ConversorEnum<TipoMarcacao>(TipoMarcacao.values);
  static TypeConverter<Duration, int> $converterhora = const ConversorMinutos();
  static TypeConverter<OrigemMarcacao, String> $converterorigem =
      const ConversorEnum<OrigemMarcacao>(OrigemMarcacao.values);
}

class MarcacaoLinha extends DataClass implements Insertable<MarcacaoLinha> {
  final int id;
  final int diaId;
  final int ordem;
  final TipoMarcacao tipo;
  final Duration hora;
  final OrigemMarcacao origem;
  final bool editada;
  final DateTime criadoEm;
  const MarcacaoLinha(
      {required this.id,
      required this.diaId,
      required this.ordem,
      required this.tipo,
      required this.hora,
      required this.origem,
      required this.editada,
      required this.criadoEm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dia_id'] = Variable<int>(diaId);
    map['ordem'] = Variable<int>(ordem);
    {
      map['tipo'] =
          Variable<String>($MarcacoesTable.$convertertipo.toSql(tipo));
    }
    {
      map['hora'] = Variable<int>($MarcacoesTable.$converterhora.toSql(hora));
    }
    {
      map['origem'] =
          Variable<String>($MarcacoesTable.$converterorigem.toSql(origem));
    }
    map['editada'] = Variable<bool>(editada);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    return map;
  }

  MarcacoesCompanion toCompanion(bool nullToAbsent) {
    return MarcacoesCompanion(
      id: Value(id),
      diaId: Value(diaId),
      ordem: Value(ordem),
      tipo: Value(tipo),
      hora: Value(hora),
      origem: Value(origem),
      editada: Value(editada),
      criadoEm: Value(criadoEm),
    );
  }

  factory MarcacaoLinha.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MarcacaoLinha(
      id: serializer.fromJson<int>(json['id']),
      diaId: serializer.fromJson<int>(json['diaId']),
      ordem: serializer.fromJson<int>(json['ordem']),
      tipo: serializer.fromJson<TipoMarcacao>(json['tipo']),
      hora: serializer.fromJson<Duration>(json['hora']),
      origem: serializer.fromJson<OrigemMarcacao>(json['origem']),
      editada: serializer.fromJson<bool>(json['editada']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'diaId': serializer.toJson<int>(diaId),
      'ordem': serializer.toJson<int>(ordem),
      'tipo': serializer.toJson<TipoMarcacao>(tipo),
      'hora': serializer.toJson<Duration>(hora),
      'origem': serializer.toJson<OrigemMarcacao>(origem),
      'editada': serializer.toJson<bool>(editada),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
    };
  }

  MarcacaoLinha copyWith(
          {int? id,
          int? diaId,
          int? ordem,
          TipoMarcacao? tipo,
          Duration? hora,
          OrigemMarcacao? origem,
          bool? editada,
          DateTime? criadoEm}) =>
      MarcacaoLinha(
        id: id ?? this.id,
        diaId: diaId ?? this.diaId,
        ordem: ordem ?? this.ordem,
        tipo: tipo ?? this.tipo,
        hora: hora ?? this.hora,
        origem: origem ?? this.origem,
        editada: editada ?? this.editada,
        criadoEm: criadoEm ?? this.criadoEm,
      );
  MarcacaoLinha copyWithCompanion(MarcacoesCompanion data) {
    return MarcacaoLinha(
      id: data.id.present ? data.id.value : this.id,
      diaId: data.diaId.present ? data.diaId.value : this.diaId,
      ordem: data.ordem.present ? data.ordem.value : this.ordem,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      hora: data.hora.present ? data.hora.value : this.hora,
      origem: data.origem.present ? data.origem.value : this.origem,
      editada: data.editada.present ? data.editada.value : this.editada,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MarcacaoLinha(')
          ..write('id: $id, ')
          ..write('diaId: $diaId, ')
          ..write('ordem: $ordem, ')
          ..write('tipo: $tipo, ')
          ..write('hora: $hora, ')
          ..write('origem: $origem, ')
          ..write('editada: $editada, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, diaId, ordem, tipo, hora, origem, editada, criadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MarcacaoLinha &&
          other.id == this.id &&
          other.diaId == this.diaId &&
          other.ordem == this.ordem &&
          other.tipo == this.tipo &&
          other.hora == this.hora &&
          other.origem == this.origem &&
          other.editada == this.editada &&
          other.criadoEm == this.criadoEm);
}

class MarcacoesCompanion extends UpdateCompanion<MarcacaoLinha> {
  final Value<int> id;
  final Value<int> diaId;
  final Value<int> ordem;
  final Value<TipoMarcacao> tipo;
  final Value<Duration> hora;
  final Value<OrigemMarcacao> origem;
  final Value<bool> editada;
  final Value<DateTime> criadoEm;
  const MarcacoesCompanion({
    this.id = const Value.absent(),
    this.diaId = const Value.absent(),
    this.ordem = const Value.absent(),
    this.tipo = const Value.absent(),
    this.hora = const Value.absent(),
    this.origem = const Value.absent(),
    this.editada = const Value.absent(),
    this.criadoEm = const Value.absent(),
  });
  MarcacoesCompanion.insert({
    this.id = const Value.absent(),
    required int diaId,
    required int ordem,
    required TipoMarcacao tipo,
    required Duration hora,
    this.origem = const Value.absent(),
    this.editada = const Value.absent(),
    this.criadoEm = const Value.absent(),
  })  : diaId = Value(diaId),
        ordem = Value(ordem),
        tipo = Value(tipo),
        hora = Value(hora);
  static Insertable<MarcacaoLinha> custom({
    Expression<int>? id,
    Expression<int>? diaId,
    Expression<int>? ordem,
    Expression<String>? tipo,
    Expression<int>? hora,
    Expression<String>? origem,
    Expression<bool>? editada,
    Expression<DateTime>? criadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (diaId != null) 'dia_id': diaId,
      if (ordem != null) 'ordem': ordem,
      if (tipo != null) 'tipo': tipo,
      if (hora != null) 'hora': hora,
      if (origem != null) 'origem': origem,
      if (editada != null) 'editada': editada,
      if (criadoEm != null) 'criado_em': criadoEm,
    });
  }

  MarcacoesCompanion copyWith(
      {Value<int>? id,
      Value<int>? diaId,
      Value<int>? ordem,
      Value<TipoMarcacao>? tipo,
      Value<Duration>? hora,
      Value<OrigemMarcacao>? origem,
      Value<bool>? editada,
      Value<DateTime>? criadoEm}) {
    return MarcacoesCompanion(
      id: id ?? this.id,
      diaId: diaId ?? this.diaId,
      ordem: ordem ?? this.ordem,
      tipo: tipo ?? this.tipo,
      hora: hora ?? this.hora,
      origem: origem ?? this.origem,
      editada: editada ?? this.editada,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (diaId.present) {
      map['dia_id'] = Variable<int>(diaId.value);
    }
    if (ordem.present) {
      map['ordem'] = Variable<int>(ordem.value);
    }
    if (tipo.present) {
      map['tipo'] =
          Variable<String>($MarcacoesTable.$convertertipo.toSql(tipo.value));
    }
    if (hora.present) {
      map['hora'] =
          Variable<int>($MarcacoesTable.$converterhora.toSql(hora.value));
    }
    if (origem.present) {
      map['origem'] = Variable<String>(
          $MarcacoesTable.$converterorigem.toSql(origem.value));
    }
    if (editada.present) {
      map['editada'] = Variable<bool>(editada.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MarcacoesCompanion(')
          ..write('id: $id, ')
          ..write('diaId: $diaId, ')
          ..write('ordem: $ordem, ')
          ..write('tipo: $tipo, ')
          ..write('hora: $hora, ')
          ..write('origem: $origem, ')
          ..write('editada: $editada, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }
}

class $FeriadosTable extends Feriados
    with TableInfo<$FeriadosTable, FeriadoLinha> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeriadosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> data =
      GeneratedColumn<String>('data', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<DateTime>($FeriadosTable.$converterdata);
  static const VerificationMeta _descricaoMeta =
      const VerificationMeta('descricao');
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
      'descricao', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recorrenteAnualMeta =
      const VerificationMeta('recorrenteAnual');
  @override
  late final GeneratedColumn<bool> recorrenteAnual = GeneratedColumn<bool>(
      'recorrente_anual', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("recorrente_anual" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _abrangenciaMeta =
      const VerificationMeta('abrangencia');
  @override
  late final GeneratedColumnWithTypeConverter<AbrangenciaFeriado, String>
      abrangencia = GeneratedColumn<String>('abrangencia', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('NACIONAL'))
          .withConverter<AbrangenciaFeriado>(
              $FeriadosTable.$converterabrangencia);
  @override
  List<GeneratedColumn> get $columns =>
      [id, data, descricao, recorrenteAnual, abrangencia];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feriado';
  @override
  VerificationContext validateIntegrity(Insertable<FeriadoLinha> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    context.handle(_dataMeta, const VerificationResult.success());
    if (data.containsKey('descricao')) {
      context.handle(_descricaoMeta,
          descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta));
    } else if (isInserting) {
      context.missing(_descricaoMeta);
    }
    if (data.containsKey('recorrente_anual')) {
      context.handle(
          _recorrenteAnualMeta,
          recorrenteAnual.isAcceptableOrUnknown(
              data['recorrente_anual']!, _recorrenteAnualMeta));
    }
    context.handle(_abrangenciaMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeriadoLinha map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeriadoLinha(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      data: $FeriadosTable.$converterdata.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!),
      descricao: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descricao'])!,
      recorrenteAnual: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}recorrente_anual'])!,
      abrangencia: $FeriadosTable.$converterabrangencia.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}abrangencia'])!),
    );
  }

  @override
  $FeriadosTable createAlias(String alias) {
    return $FeriadosTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterdata = const ConversorData();
  static TypeConverter<AbrangenciaFeriado, String> $converterabrangencia =
      const ConversorEnum<AbrangenciaFeriado>(AbrangenciaFeriado.values);
}

class FeriadoLinha extends DataClass implements Insertable<FeriadoLinha> {
  final int id;
  final DateTime data;
  final String descricao;
  final bool recorrenteAnual;
  final AbrangenciaFeriado abrangencia;
  const FeriadoLinha(
      {required this.id,
      required this.data,
      required this.descricao,
      required this.recorrenteAnual,
      required this.abrangencia});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['data'] = Variable<String>($FeriadosTable.$converterdata.toSql(data));
    }
    map['descricao'] = Variable<String>(descricao);
    map['recorrente_anual'] = Variable<bool>(recorrenteAnual);
    {
      map['abrangencia'] = Variable<String>(
          $FeriadosTable.$converterabrangencia.toSql(abrangencia));
    }
    return map;
  }

  FeriadosCompanion toCompanion(bool nullToAbsent) {
    return FeriadosCompanion(
      id: Value(id),
      data: Value(data),
      descricao: Value(descricao),
      recorrenteAnual: Value(recorrenteAnual),
      abrangencia: Value(abrangencia),
    );
  }

  factory FeriadoLinha.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeriadoLinha(
      id: serializer.fromJson<int>(json['id']),
      data: serializer.fromJson<DateTime>(json['data']),
      descricao: serializer.fromJson<String>(json['descricao']),
      recorrenteAnual: serializer.fromJson<bool>(json['recorrenteAnual']),
      abrangencia: serializer.fromJson<AbrangenciaFeriado>(json['abrangencia']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'data': serializer.toJson<DateTime>(data),
      'descricao': serializer.toJson<String>(descricao),
      'recorrenteAnual': serializer.toJson<bool>(recorrenteAnual),
      'abrangencia': serializer.toJson<AbrangenciaFeriado>(abrangencia),
    };
  }

  FeriadoLinha copyWith(
          {int? id,
          DateTime? data,
          String? descricao,
          bool? recorrenteAnual,
          AbrangenciaFeriado? abrangencia}) =>
      FeriadoLinha(
        id: id ?? this.id,
        data: data ?? this.data,
        descricao: descricao ?? this.descricao,
        recorrenteAnual: recorrenteAnual ?? this.recorrenteAnual,
        abrangencia: abrangencia ?? this.abrangencia,
      );
  FeriadoLinha copyWithCompanion(FeriadosCompanion data) {
    return FeriadoLinha(
      id: data.id.present ? data.id.value : this.id,
      data: data.data.present ? data.data.value : this.data,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      recorrenteAnual: data.recorrenteAnual.present
          ? data.recorrenteAnual.value
          : this.recorrenteAnual,
      abrangencia:
          data.abrangencia.present ? data.abrangencia.value : this.abrangencia,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeriadoLinha(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('descricao: $descricao, ')
          ..write('recorrenteAnual: $recorrenteAnual, ')
          ..write('abrangencia: $abrangencia')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, data, descricao, recorrenteAnual, abrangencia);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeriadoLinha &&
          other.id == this.id &&
          other.data == this.data &&
          other.descricao == this.descricao &&
          other.recorrenteAnual == this.recorrenteAnual &&
          other.abrangencia == this.abrangencia);
}

class FeriadosCompanion extends UpdateCompanion<FeriadoLinha> {
  final Value<int> id;
  final Value<DateTime> data;
  final Value<String> descricao;
  final Value<bool> recorrenteAnual;
  final Value<AbrangenciaFeriado> abrangencia;
  const FeriadosCompanion({
    this.id = const Value.absent(),
    this.data = const Value.absent(),
    this.descricao = const Value.absent(),
    this.recorrenteAnual = const Value.absent(),
    this.abrangencia = const Value.absent(),
  });
  FeriadosCompanion.insert({
    this.id = const Value.absent(),
    required DateTime data,
    required String descricao,
    this.recorrenteAnual = const Value.absent(),
    this.abrangencia = const Value.absent(),
  })  : data = Value(data),
        descricao = Value(descricao);
  static Insertable<FeriadoLinha> custom({
    Expression<int>? id,
    Expression<String>? data,
    Expression<String>? descricao,
    Expression<bool>? recorrenteAnual,
    Expression<String>? abrangencia,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (data != null) 'data': data,
      if (descricao != null) 'descricao': descricao,
      if (recorrenteAnual != null) 'recorrente_anual': recorrenteAnual,
      if (abrangencia != null) 'abrangencia': abrangencia,
    });
  }

  FeriadosCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? data,
      Value<String>? descricao,
      Value<bool>? recorrenteAnual,
      Value<AbrangenciaFeriado>? abrangencia}) {
    return FeriadosCompanion(
      id: id ?? this.id,
      data: data ?? this.data,
      descricao: descricao ?? this.descricao,
      recorrenteAnual: recorrenteAnual ?? this.recorrenteAnual,
      abrangencia: abrangencia ?? this.abrangencia,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (data.present) {
      map['data'] =
          Variable<String>($FeriadosTable.$converterdata.toSql(data.value));
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (recorrenteAnual.present) {
      map['recorrente_anual'] = Variable<bool>(recorrenteAnual.value);
    }
    if (abrangencia.present) {
      map['abrangencia'] = Variable<String>(
          $FeriadosTable.$converterabrangencia.toSql(abrangencia.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeriadosCompanion(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('descricao: $descricao, ')
          ..write('recorrenteAnual: $recorrenteAnual, ')
          ..write('abrangencia: $abrangencia')
          ..write(')'))
        .toString();
  }
}

class $ModelosPlanilhaTable extends ModelosPlanilha
    with TableInfo<$ModelosPlanilhaTable, ModeloPlanilhaLinha> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModelosPlanilhaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _caminhoArquivoBaseMeta =
      const VerificationMeta('caminhoArquivoBase');
  @override
  late final GeneratedColumn<String> caminhoArquivoBase =
      GeneratedColumn<String>('caminho_arquivo_base', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomeArquivoOriginalMeta =
      const VerificationMeta('nomeArquivoOriginal');
  @override
  late final GeneratedColumn<String> nomeArquivoOriginal =
      GeneratedColumn<String>('nome_arquivo_original', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hashArquivoMeta =
      const VerificationMeta('hashArquivo');
  @override
  late final GeneratedColumn<String> hashArquivo = GeneratedColumn<String>(
      'hash_arquivo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomeAbaMeta =
      const VerificationMeta('nomeAba');
  @override
  late final GeneratedColumn<String> nomeAba = GeneratedColumn<String>(
      'nome_aba', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _linhaCabecalhoMeta =
      const VerificationMeta('linhaCabecalho');
  @override
  late final GeneratedColumn<int> linhaCabecalho = GeneratedColumn<int>(
      'linha_cabecalho', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _primeiraLinhaDadosMeta =
      const VerificationMeta('primeiraLinhaDados');
  @override
  late final GeneratedColumn<int> primeiraLinhaDados = GeneratedColumn<int>(
      'primeira_linha_dados', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _ultimaLinhaDadosMeta =
      const VerificationMeta('ultimaLinhaDados');
  @override
  late final GeneratedColumn<int> ultimaLinhaDados = GeneratedColumn<int>(
      'ultima_linha_dados', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _estrategiaLinhaMeta =
      const VerificationMeta('estrategiaLinha');
  @override
  late final GeneratedColumnWithTypeConverter<EstrategiaLinha, String>
      estrategiaLinha = GeneratedColumn<String>(
              'estrategia_linha', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<EstrategiaLinha>(
              $ModelosPlanilhaTable.$converterestrategiaLinha);
  static const VerificationMeta _formatoDataMeta =
      const VerificationMeta('formatoData');
  @override
  late final GeneratedColumnWithTypeConverter<FormatoData, String> formatoData =
      GeneratedColumn<String>('formato_data', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('DD_MM_AAAA'))
          .withConverter<FormatoData>(
              $ModelosPlanilhaTable.$converterformatoData);
  static const VerificationMeta _formatoHoraMeta =
      const VerificationMeta('formatoHora');
  @override
  late final GeneratedColumnWithTypeConverter<FormatoHora, String> formatoHora =
      GeneratedColumn<String>('formato_hora', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('HH_MM'))
          .withConverter<FormatoHora>(
              $ModelosPlanilhaTable.$converterformatoHora);
  static const VerificationMeta _escreverComoTextoMeta =
      const VerificationMeta('escreverComoTexto');
  @override
  late final GeneratedColumn<bool> escreverComoTexto = GeneratedColumn<bool>(
      'escrever_como_texto', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("escrever_como_texto" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _diaInicioCompetenciaMeta =
      const VerificationMeta('diaInicioCompetencia');
  @override
  late final GeneratedColumn<int> diaInicioCompetencia = GeneratedColumn<int>(
      'dia_inicio_competencia', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _ativoMeta = const VerificationMeta('ativo');
  @override
  late final GeneratedColumn<bool> ativo = GeneratedColumn<bool>(
      'ativo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("ativo" IN (0, 1))'));
  static const VerificationMeta _criadoEmMeta =
      const VerificationMeta('criadoEm');
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
      'criado_em', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _atualizadoEmMeta =
      const VerificationMeta('atualizadoEm');
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
      'atualizado_em', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nome,
        caminhoArquivoBase,
        nomeArquivoOriginal,
        hashArquivo,
        nomeAba,
        linhaCabecalho,
        primeiraLinhaDados,
        ultimaLinhaDados,
        estrategiaLinha,
        formatoData,
        formatoHora,
        escreverComoTexto,
        diaInicioCompetencia,
        ativo,
        criadoEm,
        atualizadoEm
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'modelo_planilha';
  @override
  VerificationContext validateIntegrity(
      Insertable<ModeloPlanilhaLinha> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('caminho_arquivo_base')) {
      context.handle(
          _caminhoArquivoBaseMeta,
          caminhoArquivoBase.isAcceptableOrUnknown(
              data['caminho_arquivo_base']!, _caminhoArquivoBaseMeta));
    } else if (isInserting) {
      context.missing(_caminhoArquivoBaseMeta);
    }
    if (data.containsKey('nome_arquivo_original')) {
      context.handle(
          _nomeArquivoOriginalMeta,
          nomeArquivoOriginal.isAcceptableOrUnknown(
              data['nome_arquivo_original']!, _nomeArquivoOriginalMeta));
    } else if (isInserting) {
      context.missing(_nomeArquivoOriginalMeta);
    }
    if (data.containsKey('hash_arquivo')) {
      context.handle(
          _hashArquivoMeta,
          hashArquivo.isAcceptableOrUnknown(
              data['hash_arquivo']!, _hashArquivoMeta));
    } else if (isInserting) {
      context.missing(_hashArquivoMeta);
    }
    if (data.containsKey('nome_aba')) {
      context.handle(_nomeAbaMeta,
          nomeAba.isAcceptableOrUnknown(data['nome_aba']!, _nomeAbaMeta));
    } else if (isInserting) {
      context.missing(_nomeAbaMeta);
    }
    if (data.containsKey('linha_cabecalho')) {
      context.handle(
          _linhaCabecalhoMeta,
          linhaCabecalho.isAcceptableOrUnknown(
              data['linha_cabecalho']!, _linhaCabecalhoMeta));
    }
    if (data.containsKey('primeira_linha_dados')) {
      context.handle(
          _primeiraLinhaDadosMeta,
          primeiraLinhaDados.isAcceptableOrUnknown(
              data['primeira_linha_dados']!, _primeiraLinhaDadosMeta));
    } else if (isInserting) {
      context.missing(_primeiraLinhaDadosMeta);
    }
    if (data.containsKey('ultima_linha_dados')) {
      context.handle(
          _ultimaLinhaDadosMeta,
          ultimaLinhaDados.isAcceptableOrUnknown(
              data['ultima_linha_dados']!, _ultimaLinhaDadosMeta));
    }
    context.handle(_estrategiaLinhaMeta, const VerificationResult.success());
    context.handle(_formatoDataMeta, const VerificationResult.success());
    context.handle(_formatoHoraMeta, const VerificationResult.success());
    if (data.containsKey('escrever_como_texto')) {
      context.handle(
          _escreverComoTextoMeta,
          escreverComoTexto.isAcceptableOrUnknown(
              data['escrever_como_texto']!, _escreverComoTextoMeta));
    }
    if (data.containsKey('dia_inicio_competencia')) {
      context.handle(
          _diaInicioCompetenciaMeta,
          diaInicioCompetencia.isAcceptableOrUnknown(
              data['dia_inicio_competencia']!, _diaInicioCompetenciaMeta));
    }
    if (data.containsKey('ativo')) {
      context.handle(
          _ativoMeta, ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta));
    } else if (isInserting) {
      context.missing(_ativoMeta);
    }
    if (data.containsKey('criado_em')) {
      context.handle(_criadoEmMeta,
          criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta));
    }
    if (data.containsKey('atualizado_em')) {
      context.handle(
          _atualizadoEmMeta,
          atualizadoEm.isAcceptableOrUnknown(
              data['atualizado_em']!, _atualizadoEmMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ModeloPlanilhaLinha map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModeloPlanilhaLinha(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      caminhoArquivoBase: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}caminho_arquivo_base'])!,
      nomeArquivoOriginal: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}nome_arquivo_original'])!,
      hashArquivo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hash_arquivo'])!,
      nomeAba: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome_aba'])!,
      linhaCabecalho: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}linha_cabecalho']),
      primeiraLinhaDados: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}primeira_linha_dados'])!,
      ultimaLinhaDados: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ultima_linha_dados']),
      estrategiaLinha: $ModelosPlanilhaTable.$converterestrategiaLinha.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}estrategia_linha'])!),
      formatoData: $ModelosPlanilhaTable.$converterformatoData.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}formato_data'])!),
      formatoHora: $ModelosPlanilhaTable.$converterformatoHora.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}formato_hora'])!),
      escreverComoTexto: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}escrever_como_texto'])!,
      diaInicioCompetencia: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}dia_inicio_competencia'])!,
      ativo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}ativo'])!,
      criadoEm: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}criado_em'])!,
      atualizadoEm: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}atualizado_em'])!,
    );
  }

  @override
  $ModelosPlanilhaTable createAlias(String alias) {
    return $ModelosPlanilhaTable(attachedDatabase, alias);
  }

  static TypeConverter<EstrategiaLinha, String> $converterestrategiaLinha =
      const ConversorEnum<EstrategiaLinha>(EstrategiaLinha.values);
  static TypeConverter<FormatoData, String> $converterformatoData =
      const ConversorEnum<FormatoData>(FormatoData.values);
  static TypeConverter<FormatoHora, String> $converterformatoHora =
      const ConversorEnum<FormatoHora>(FormatoHora.values);
}

class ModeloPlanilhaLinha extends DataClass
    implements Insertable<ModeloPlanilhaLinha> {
  final int id;
  final String nome;
  final String caminhoArquivoBase;
  final String nomeArquivoOriginal;
  final String hashArquivo;
  final String nomeAba;
  final int? linhaCabecalho;
  final int primeiraLinhaDados;
  final int? ultimaLinhaDados;
  final EstrategiaLinha estrategiaLinha;
  final FormatoData formatoData;
  final FormatoHora formatoHora;
  final bool escreverComoTexto;
  final int diaInicioCompetencia;
  final bool ativo;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  const ModeloPlanilhaLinha(
      {required this.id,
      required this.nome,
      required this.caminhoArquivoBase,
      required this.nomeArquivoOriginal,
      required this.hashArquivo,
      required this.nomeAba,
      this.linhaCabecalho,
      required this.primeiraLinhaDados,
      this.ultimaLinhaDados,
      required this.estrategiaLinha,
      required this.formatoData,
      required this.formatoHora,
      required this.escreverComoTexto,
      required this.diaInicioCompetencia,
      required this.ativo,
      required this.criadoEm,
      required this.atualizadoEm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['caminho_arquivo_base'] = Variable<String>(caminhoArquivoBase);
    map['nome_arquivo_original'] = Variable<String>(nomeArquivoOriginal);
    map['hash_arquivo'] = Variable<String>(hashArquivo);
    map['nome_aba'] = Variable<String>(nomeAba);
    if (!nullToAbsent || linhaCabecalho != null) {
      map['linha_cabecalho'] = Variable<int>(linhaCabecalho);
    }
    map['primeira_linha_dados'] = Variable<int>(primeiraLinhaDados);
    if (!nullToAbsent || ultimaLinhaDados != null) {
      map['ultima_linha_dados'] = Variable<int>(ultimaLinhaDados);
    }
    {
      map['estrategia_linha'] = Variable<String>($ModelosPlanilhaTable
          .$converterestrategiaLinha
          .toSql(estrategiaLinha));
    }
    {
      map['formato_data'] = Variable<String>(
          $ModelosPlanilhaTable.$converterformatoData.toSql(formatoData));
    }
    {
      map['formato_hora'] = Variable<String>(
          $ModelosPlanilhaTable.$converterformatoHora.toSql(formatoHora));
    }
    map['escrever_como_texto'] = Variable<bool>(escreverComoTexto);
    map['dia_inicio_competencia'] = Variable<int>(diaInicioCompetencia);
    map['ativo'] = Variable<bool>(ativo);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    return map;
  }

  ModelosPlanilhaCompanion toCompanion(bool nullToAbsent) {
    return ModelosPlanilhaCompanion(
      id: Value(id),
      nome: Value(nome),
      caminhoArquivoBase: Value(caminhoArquivoBase),
      nomeArquivoOriginal: Value(nomeArquivoOriginal),
      hashArquivo: Value(hashArquivo),
      nomeAba: Value(nomeAba),
      linhaCabecalho: linhaCabecalho == null && nullToAbsent
          ? const Value.absent()
          : Value(linhaCabecalho),
      primeiraLinhaDados: Value(primeiraLinhaDados),
      ultimaLinhaDados: ultimaLinhaDados == null && nullToAbsent
          ? const Value.absent()
          : Value(ultimaLinhaDados),
      estrategiaLinha: Value(estrategiaLinha),
      formatoData: Value(formatoData),
      formatoHora: Value(formatoHora),
      escreverComoTexto: Value(escreverComoTexto),
      diaInicioCompetencia: Value(diaInicioCompetencia),
      ativo: Value(ativo),
      criadoEm: Value(criadoEm),
      atualizadoEm: Value(atualizadoEm),
    );
  }

  factory ModeloPlanilhaLinha.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModeloPlanilhaLinha(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      caminhoArquivoBase:
          serializer.fromJson<String>(json['caminhoArquivoBase']),
      nomeArquivoOriginal:
          serializer.fromJson<String>(json['nomeArquivoOriginal']),
      hashArquivo: serializer.fromJson<String>(json['hashArquivo']),
      nomeAba: serializer.fromJson<String>(json['nomeAba']),
      linhaCabecalho: serializer.fromJson<int?>(json['linhaCabecalho']),
      primeiraLinhaDados: serializer.fromJson<int>(json['primeiraLinhaDados']),
      ultimaLinhaDados: serializer.fromJson<int?>(json['ultimaLinhaDados']),
      estrategiaLinha:
          serializer.fromJson<EstrategiaLinha>(json['estrategiaLinha']),
      formatoData: serializer.fromJson<FormatoData>(json['formatoData']),
      formatoHora: serializer.fromJson<FormatoHora>(json['formatoHora']),
      escreverComoTexto: serializer.fromJson<bool>(json['escreverComoTexto']),
      diaInicioCompetencia:
          serializer.fromJson<int>(json['diaInicioCompetencia']),
      ativo: serializer.fromJson<bool>(json['ativo']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'caminhoArquivoBase': serializer.toJson<String>(caminhoArquivoBase),
      'nomeArquivoOriginal': serializer.toJson<String>(nomeArquivoOriginal),
      'hashArquivo': serializer.toJson<String>(hashArquivo),
      'nomeAba': serializer.toJson<String>(nomeAba),
      'linhaCabecalho': serializer.toJson<int?>(linhaCabecalho),
      'primeiraLinhaDados': serializer.toJson<int>(primeiraLinhaDados),
      'ultimaLinhaDados': serializer.toJson<int?>(ultimaLinhaDados),
      'estrategiaLinha': serializer.toJson<EstrategiaLinha>(estrategiaLinha),
      'formatoData': serializer.toJson<FormatoData>(formatoData),
      'formatoHora': serializer.toJson<FormatoHora>(formatoHora),
      'escreverComoTexto': serializer.toJson<bool>(escreverComoTexto),
      'diaInicioCompetencia': serializer.toJson<int>(diaInicioCompetencia),
      'ativo': serializer.toJson<bool>(ativo),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
    };
  }

  ModeloPlanilhaLinha copyWith(
          {int? id,
          String? nome,
          String? caminhoArquivoBase,
          String? nomeArquivoOriginal,
          String? hashArquivo,
          String? nomeAba,
          Value<int?> linhaCabecalho = const Value.absent(),
          int? primeiraLinhaDados,
          Value<int?> ultimaLinhaDados = const Value.absent(),
          EstrategiaLinha? estrategiaLinha,
          FormatoData? formatoData,
          FormatoHora? formatoHora,
          bool? escreverComoTexto,
          int? diaInicioCompetencia,
          bool? ativo,
          DateTime? criadoEm,
          DateTime? atualizadoEm}) =>
      ModeloPlanilhaLinha(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        caminhoArquivoBase: caminhoArquivoBase ?? this.caminhoArquivoBase,
        nomeArquivoOriginal: nomeArquivoOriginal ?? this.nomeArquivoOriginal,
        hashArquivo: hashArquivo ?? this.hashArquivo,
        nomeAba: nomeAba ?? this.nomeAba,
        linhaCabecalho:
            linhaCabecalho.present ? linhaCabecalho.value : this.linhaCabecalho,
        primeiraLinhaDados: primeiraLinhaDados ?? this.primeiraLinhaDados,
        ultimaLinhaDados: ultimaLinhaDados.present
            ? ultimaLinhaDados.value
            : this.ultimaLinhaDados,
        estrategiaLinha: estrategiaLinha ?? this.estrategiaLinha,
        formatoData: formatoData ?? this.formatoData,
        formatoHora: formatoHora ?? this.formatoHora,
        escreverComoTexto: escreverComoTexto ?? this.escreverComoTexto,
        diaInicioCompetencia: diaInicioCompetencia ?? this.diaInicioCompetencia,
        ativo: ativo ?? this.ativo,
        criadoEm: criadoEm ?? this.criadoEm,
        atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      );
  ModeloPlanilhaLinha copyWithCompanion(ModelosPlanilhaCompanion data) {
    return ModeloPlanilhaLinha(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      caminhoArquivoBase: data.caminhoArquivoBase.present
          ? data.caminhoArquivoBase.value
          : this.caminhoArquivoBase,
      nomeArquivoOriginal: data.nomeArquivoOriginal.present
          ? data.nomeArquivoOriginal.value
          : this.nomeArquivoOriginal,
      hashArquivo:
          data.hashArquivo.present ? data.hashArquivo.value : this.hashArquivo,
      nomeAba: data.nomeAba.present ? data.nomeAba.value : this.nomeAba,
      linhaCabecalho: data.linhaCabecalho.present
          ? data.linhaCabecalho.value
          : this.linhaCabecalho,
      primeiraLinhaDados: data.primeiraLinhaDados.present
          ? data.primeiraLinhaDados.value
          : this.primeiraLinhaDados,
      ultimaLinhaDados: data.ultimaLinhaDados.present
          ? data.ultimaLinhaDados.value
          : this.ultimaLinhaDados,
      estrategiaLinha: data.estrategiaLinha.present
          ? data.estrategiaLinha.value
          : this.estrategiaLinha,
      formatoData:
          data.formatoData.present ? data.formatoData.value : this.formatoData,
      formatoHora:
          data.formatoHora.present ? data.formatoHora.value : this.formatoHora,
      escreverComoTexto: data.escreverComoTexto.present
          ? data.escreverComoTexto.value
          : this.escreverComoTexto,
      diaInicioCompetencia: data.diaInicioCompetencia.present
          ? data.diaInicioCompetencia.value
          : this.diaInicioCompetencia,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModeloPlanilhaLinha(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('caminhoArquivoBase: $caminhoArquivoBase, ')
          ..write('nomeArquivoOriginal: $nomeArquivoOriginal, ')
          ..write('hashArquivo: $hashArquivo, ')
          ..write('nomeAba: $nomeAba, ')
          ..write('linhaCabecalho: $linhaCabecalho, ')
          ..write('primeiraLinhaDados: $primeiraLinhaDados, ')
          ..write('ultimaLinhaDados: $ultimaLinhaDados, ')
          ..write('estrategiaLinha: $estrategiaLinha, ')
          ..write('formatoData: $formatoData, ')
          ..write('formatoHora: $formatoHora, ')
          ..write('escreverComoTexto: $escreverComoTexto, ')
          ..write('diaInicioCompetencia: $diaInicioCompetencia, ')
          ..write('ativo: $ativo, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      nome,
      caminhoArquivoBase,
      nomeArquivoOriginal,
      hashArquivo,
      nomeAba,
      linhaCabecalho,
      primeiraLinhaDados,
      ultimaLinhaDados,
      estrategiaLinha,
      formatoData,
      formatoHora,
      escreverComoTexto,
      diaInicioCompetencia,
      ativo,
      criadoEm,
      atualizadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModeloPlanilhaLinha &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.caminhoArquivoBase == this.caminhoArquivoBase &&
          other.nomeArquivoOriginal == this.nomeArquivoOriginal &&
          other.hashArquivo == this.hashArquivo &&
          other.nomeAba == this.nomeAba &&
          other.linhaCabecalho == this.linhaCabecalho &&
          other.primeiraLinhaDados == this.primeiraLinhaDados &&
          other.ultimaLinhaDados == this.ultimaLinhaDados &&
          other.estrategiaLinha == this.estrategiaLinha &&
          other.formatoData == this.formatoData &&
          other.formatoHora == this.formatoHora &&
          other.escreverComoTexto == this.escreverComoTexto &&
          other.diaInicioCompetencia == this.diaInicioCompetencia &&
          other.ativo == this.ativo &&
          other.criadoEm == this.criadoEm &&
          other.atualizadoEm == this.atualizadoEm);
}

class ModelosPlanilhaCompanion extends UpdateCompanion<ModeloPlanilhaLinha> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String> caminhoArquivoBase;
  final Value<String> nomeArquivoOriginal;
  final Value<String> hashArquivo;
  final Value<String> nomeAba;
  final Value<int?> linhaCabecalho;
  final Value<int> primeiraLinhaDados;
  final Value<int?> ultimaLinhaDados;
  final Value<EstrategiaLinha> estrategiaLinha;
  final Value<FormatoData> formatoData;
  final Value<FormatoHora> formatoHora;
  final Value<bool> escreverComoTexto;
  final Value<int> diaInicioCompetencia;
  final Value<bool> ativo;
  final Value<DateTime> criadoEm;
  final Value<DateTime> atualizadoEm;
  const ModelosPlanilhaCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.caminhoArquivoBase = const Value.absent(),
    this.nomeArquivoOriginal = const Value.absent(),
    this.hashArquivo = const Value.absent(),
    this.nomeAba = const Value.absent(),
    this.linhaCabecalho = const Value.absent(),
    this.primeiraLinhaDados = const Value.absent(),
    this.ultimaLinhaDados = const Value.absent(),
    this.estrategiaLinha = const Value.absent(),
    this.formatoData = const Value.absent(),
    this.formatoHora = const Value.absent(),
    this.escreverComoTexto = const Value.absent(),
    this.diaInicioCompetencia = const Value.absent(),
    this.ativo = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
  });
  ModelosPlanilhaCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required String caminhoArquivoBase,
    required String nomeArquivoOriginal,
    required String hashArquivo,
    required String nomeAba,
    this.linhaCabecalho = const Value.absent(),
    required int primeiraLinhaDados,
    this.ultimaLinhaDados = const Value.absent(),
    required EstrategiaLinha estrategiaLinha,
    this.formatoData = const Value.absent(),
    this.formatoHora = const Value.absent(),
    this.escreverComoTexto = const Value.absent(),
    this.diaInicioCompetencia = const Value.absent(),
    required bool ativo,
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
  })  : nome = Value(nome),
        caminhoArquivoBase = Value(caminhoArquivoBase),
        nomeArquivoOriginal = Value(nomeArquivoOriginal),
        hashArquivo = Value(hashArquivo),
        nomeAba = Value(nomeAba),
        primeiraLinhaDados = Value(primeiraLinhaDados),
        estrategiaLinha = Value(estrategiaLinha),
        ativo = Value(ativo);
  static Insertable<ModeloPlanilhaLinha> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? caminhoArquivoBase,
    Expression<String>? nomeArquivoOriginal,
    Expression<String>? hashArquivo,
    Expression<String>? nomeAba,
    Expression<int>? linhaCabecalho,
    Expression<int>? primeiraLinhaDados,
    Expression<int>? ultimaLinhaDados,
    Expression<String>? estrategiaLinha,
    Expression<String>? formatoData,
    Expression<String>? formatoHora,
    Expression<bool>? escreverComoTexto,
    Expression<int>? diaInicioCompetencia,
    Expression<bool>? ativo,
    Expression<DateTime>? criadoEm,
    Expression<DateTime>? atualizadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (caminhoArquivoBase != null)
        'caminho_arquivo_base': caminhoArquivoBase,
      if (nomeArquivoOriginal != null)
        'nome_arquivo_original': nomeArquivoOriginal,
      if (hashArquivo != null) 'hash_arquivo': hashArquivo,
      if (nomeAba != null) 'nome_aba': nomeAba,
      if (linhaCabecalho != null) 'linha_cabecalho': linhaCabecalho,
      if (primeiraLinhaDados != null)
        'primeira_linha_dados': primeiraLinhaDados,
      if (ultimaLinhaDados != null) 'ultima_linha_dados': ultimaLinhaDados,
      if (estrategiaLinha != null) 'estrategia_linha': estrategiaLinha,
      if (formatoData != null) 'formato_data': formatoData,
      if (formatoHora != null) 'formato_hora': formatoHora,
      if (escreverComoTexto != null) 'escrever_como_texto': escreverComoTexto,
      if (diaInicioCompetencia != null)
        'dia_inicio_competencia': diaInicioCompetencia,
      if (ativo != null) 'ativo': ativo,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
    });
  }

  ModelosPlanilhaCompanion copyWith(
      {Value<int>? id,
      Value<String>? nome,
      Value<String>? caminhoArquivoBase,
      Value<String>? nomeArquivoOriginal,
      Value<String>? hashArquivo,
      Value<String>? nomeAba,
      Value<int?>? linhaCabecalho,
      Value<int>? primeiraLinhaDados,
      Value<int?>? ultimaLinhaDados,
      Value<EstrategiaLinha>? estrategiaLinha,
      Value<FormatoData>? formatoData,
      Value<FormatoHora>? formatoHora,
      Value<bool>? escreverComoTexto,
      Value<int>? diaInicioCompetencia,
      Value<bool>? ativo,
      Value<DateTime>? criadoEm,
      Value<DateTime>? atualizadoEm}) {
    return ModelosPlanilhaCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      caminhoArquivoBase: caminhoArquivoBase ?? this.caminhoArquivoBase,
      nomeArquivoOriginal: nomeArquivoOriginal ?? this.nomeArquivoOriginal,
      hashArquivo: hashArquivo ?? this.hashArquivo,
      nomeAba: nomeAba ?? this.nomeAba,
      linhaCabecalho: linhaCabecalho ?? this.linhaCabecalho,
      primeiraLinhaDados: primeiraLinhaDados ?? this.primeiraLinhaDados,
      ultimaLinhaDados: ultimaLinhaDados ?? this.ultimaLinhaDados,
      estrategiaLinha: estrategiaLinha ?? this.estrategiaLinha,
      formatoData: formatoData ?? this.formatoData,
      formatoHora: formatoHora ?? this.formatoHora,
      escreverComoTexto: escreverComoTexto ?? this.escreverComoTexto,
      diaInicioCompetencia: diaInicioCompetencia ?? this.diaInicioCompetencia,
      ativo: ativo ?? this.ativo,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (caminhoArquivoBase.present) {
      map['caminho_arquivo_base'] = Variable<String>(caminhoArquivoBase.value);
    }
    if (nomeArquivoOriginal.present) {
      map['nome_arquivo_original'] =
          Variable<String>(nomeArquivoOriginal.value);
    }
    if (hashArquivo.present) {
      map['hash_arquivo'] = Variable<String>(hashArquivo.value);
    }
    if (nomeAba.present) {
      map['nome_aba'] = Variable<String>(nomeAba.value);
    }
    if (linhaCabecalho.present) {
      map['linha_cabecalho'] = Variable<int>(linhaCabecalho.value);
    }
    if (primeiraLinhaDados.present) {
      map['primeira_linha_dados'] = Variable<int>(primeiraLinhaDados.value);
    }
    if (ultimaLinhaDados.present) {
      map['ultima_linha_dados'] = Variable<int>(ultimaLinhaDados.value);
    }
    if (estrategiaLinha.present) {
      map['estrategia_linha'] = Variable<String>($ModelosPlanilhaTable
          .$converterestrategiaLinha
          .toSql(estrategiaLinha.value));
    }
    if (formatoData.present) {
      map['formato_data'] = Variable<String>(
          $ModelosPlanilhaTable.$converterformatoData.toSql(formatoData.value));
    }
    if (formatoHora.present) {
      map['formato_hora'] = Variable<String>(
          $ModelosPlanilhaTable.$converterformatoHora.toSql(formatoHora.value));
    }
    if (escreverComoTexto.present) {
      map['escrever_como_texto'] = Variable<bool>(escreverComoTexto.value);
    }
    if (diaInicioCompetencia.present) {
      map['dia_inicio_competencia'] = Variable<int>(diaInicioCompetencia.value);
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModelosPlanilhaCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('caminhoArquivoBase: $caminhoArquivoBase, ')
          ..write('nomeArquivoOriginal: $nomeArquivoOriginal, ')
          ..write('hashArquivo: $hashArquivo, ')
          ..write('nomeAba: $nomeAba, ')
          ..write('linhaCabecalho: $linhaCabecalho, ')
          ..write('primeiraLinhaDados: $primeiraLinhaDados, ')
          ..write('ultimaLinhaDados: $ultimaLinhaDados, ')
          ..write('estrategiaLinha: $estrategiaLinha, ')
          ..write('formatoData: $formatoData, ')
          ..write('formatoHora: $formatoHora, ')
          ..write('escreverComoTexto: $escreverComoTexto, ')
          ..write('diaInicioCompetencia: $diaInicioCompetencia, ')
          ..write('ativo: $ativo, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }
}

class $MapeamentosColunaTable extends MapeamentosColuna
    with TableInfo<$MapeamentosColunaTable, MapeamentoColunaLinha> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MapeamentosColunaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _modeloIdMeta =
      const VerificationMeta('modeloId');
  @override
  late final GeneratedColumn<int> modeloId = GeneratedColumn<int>(
      'modelo_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES modelo_planilha (id) ON DELETE CASCADE'));
  static const VerificationMeta _campoMeta = const VerificationMeta('campo');
  @override
  late final GeneratedColumnWithTypeConverter<CampoColuna, String> campo =
      GeneratedColumn<String>('campo', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<CampoColuna>($MapeamentosColunaTable.$convertercampo);
  static const VerificationMeta _indiceColunaMeta =
      const VerificationMeta('indiceColuna');
  @override
  late final GeneratedColumn<int> indiceColuna = GeneratedColumn<int>(
      'indice_coluna', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _rotuloCabecalhoMeta =
      const VerificationMeta('rotuloCabecalho');
  @override
  late final GeneratedColumn<String> rotuloCabecalho = GeneratedColumn<String>(
      'rotulo_cabecalho', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, modeloId, campo, indiceColuna, rotuloCabecalho];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mapeamento_coluna';
  @override
  VerificationContext validateIntegrity(
      Insertable<MapeamentoColunaLinha> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('modelo_id')) {
      context.handle(_modeloIdMeta,
          modeloId.isAcceptableOrUnknown(data['modelo_id']!, _modeloIdMeta));
    } else if (isInserting) {
      context.missing(_modeloIdMeta);
    }
    context.handle(_campoMeta, const VerificationResult.success());
    if (data.containsKey('indice_coluna')) {
      context.handle(
          _indiceColunaMeta,
          indiceColuna.isAcceptableOrUnknown(
              data['indice_coluna']!, _indiceColunaMeta));
    } else if (isInserting) {
      context.missing(_indiceColunaMeta);
    }
    if (data.containsKey('rotulo_cabecalho')) {
      context.handle(
          _rotuloCabecalhoMeta,
          rotuloCabecalho.isAcceptableOrUnknown(
              data['rotulo_cabecalho']!, _rotuloCabecalhoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {modeloId, campo},
      ];
  @override
  MapeamentoColunaLinha map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MapeamentoColunaLinha(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      modeloId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}modelo_id'])!,
      campo: $MapeamentosColunaTable.$convertercampo.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}campo'])!),
      indiceColuna: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}indice_coluna'])!,
      rotuloCabecalho: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}rotulo_cabecalho']),
    );
  }

  @override
  $MapeamentosColunaTable createAlias(String alias) {
    return $MapeamentosColunaTable(attachedDatabase, alias);
  }

  static TypeConverter<CampoColuna, String> $convertercampo =
      const ConversorEnum<CampoColuna>(CampoColuna.values);
}

class MapeamentoColunaLinha extends DataClass
    implements Insertable<MapeamentoColunaLinha> {
  final int id;
  final int modeloId;
  final CampoColuna campo;
  final int indiceColuna;
  final String? rotuloCabecalho;
  const MapeamentoColunaLinha(
      {required this.id,
      required this.modeloId,
      required this.campo,
      required this.indiceColuna,
      this.rotuloCabecalho});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['modelo_id'] = Variable<int>(modeloId);
    {
      map['campo'] = Variable<String>(
          $MapeamentosColunaTable.$convertercampo.toSql(campo));
    }
    map['indice_coluna'] = Variable<int>(indiceColuna);
    if (!nullToAbsent || rotuloCabecalho != null) {
      map['rotulo_cabecalho'] = Variable<String>(rotuloCabecalho);
    }
    return map;
  }

  MapeamentosColunaCompanion toCompanion(bool nullToAbsent) {
    return MapeamentosColunaCompanion(
      id: Value(id),
      modeloId: Value(modeloId),
      campo: Value(campo),
      indiceColuna: Value(indiceColuna),
      rotuloCabecalho: rotuloCabecalho == null && nullToAbsent
          ? const Value.absent()
          : Value(rotuloCabecalho),
    );
  }

  factory MapeamentoColunaLinha.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MapeamentoColunaLinha(
      id: serializer.fromJson<int>(json['id']),
      modeloId: serializer.fromJson<int>(json['modeloId']),
      campo: serializer.fromJson<CampoColuna>(json['campo']),
      indiceColuna: serializer.fromJson<int>(json['indiceColuna']),
      rotuloCabecalho: serializer.fromJson<String?>(json['rotuloCabecalho']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'modeloId': serializer.toJson<int>(modeloId),
      'campo': serializer.toJson<CampoColuna>(campo),
      'indiceColuna': serializer.toJson<int>(indiceColuna),
      'rotuloCabecalho': serializer.toJson<String?>(rotuloCabecalho),
    };
  }

  MapeamentoColunaLinha copyWith(
          {int? id,
          int? modeloId,
          CampoColuna? campo,
          int? indiceColuna,
          Value<String?> rotuloCabecalho = const Value.absent()}) =>
      MapeamentoColunaLinha(
        id: id ?? this.id,
        modeloId: modeloId ?? this.modeloId,
        campo: campo ?? this.campo,
        indiceColuna: indiceColuna ?? this.indiceColuna,
        rotuloCabecalho: rotuloCabecalho.present
            ? rotuloCabecalho.value
            : this.rotuloCabecalho,
      );
  MapeamentoColunaLinha copyWithCompanion(MapeamentosColunaCompanion data) {
    return MapeamentoColunaLinha(
      id: data.id.present ? data.id.value : this.id,
      modeloId: data.modeloId.present ? data.modeloId.value : this.modeloId,
      campo: data.campo.present ? data.campo.value : this.campo,
      indiceColuna: data.indiceColuna.present
          ? data.indiceColuna.value
          : this.indiceColuna,
      rotuloCabecalho: data.rotuloCabecalho.present
          ? data.rotuloCabecalho.value
          : this.rotuloCabecalho,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MapeamentoColunaLinha(')
          ..write('id: $id, ')
          ..write('modeloId: $modeloId, ')
          ..write('campo: $campo, ')
          ..write('indiceColuna: $indiceColuna, ')
          ..write('rotuloCabecalho: $rotuloCabecalho')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, modeloId, campo, indiceColuna, rotuloCabecalho);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MapeamentoColunaLinha &&
          other.id == this.id &&
          other.modeloId == this.modeloId &&
          other.campo == this.campo &&
          other.indiceColuna == this.indiceColuna &&
          other.rotuloCabecalho == this.rotuloCabecalho);
}

class MapeamentosColunaCompanion
    extends UpdateCompanion<MapeamentoColunaLinha> {
  final Value<int> id;
  final Value<int> modeloId;
  final Value<CampoColuna> campo;
  final Value<int> indiceColuna;
  final Value<String?> rotuloCabecalho;
  const MapeamentosColunaCompanion({
    this.id = const Value.absent(),
    this.modeloId = const Value.absent(),
    this.campo = const Value.absent(),
    this.indiceColuna = const Value.absent(),
    this.rotuloCabecalho = const Value.absent(),
  });
  MapeamentosColunaCompanion.insert({
    this.id = const Value.absent(),
    required int modeloId,
    required CampoColuna campo,
    required int indiceColuna,
    this.rotuloCabecalho = const Value.absent(),
  })  : modeloId = Value(modeloId),
        campo = Value(campo),
        indiceColuna = Value(indiceColuna);
  static Insertable<MapeamentoColunaLinha> custom({
    Expression<int>? id,
    Expression<int>? modeloId,
    Expression<String>? campo,
    Expression<int>? indiceColuna,
    Expression<String>? rotuloCabecalho,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modeloId != null) 'modelo_id': modeloId,
      if (campo != null) 'campo': campo,
      if (indiceColuna != null) 'indice_coluna': indiceColuna,
      if (rotuloCabecalho != null) 'rotulo_cabecalho': rotuloCabecalho,
    });
  }

  MapeamentosColunaCompanion copyWith(
      {Value<int>? id,
      Value<int>? modeloId,
      Value<CampoColuna>? campo,
      Value<int>? indiceColuna,
      Value<String?>? rotuloCabecalho}) {
    return MapeamentosColunaCompanion(
      id: id ?? this.id,
      modeloId: modeloId ?? this.modeloId,
      campo: campo ?? this.campo,
      indiceColuna: indiceColuna ?? this.indiceColuna,
      rotuloCabecalho: rotuloCabecalho ?? this.rotuloCabecalho,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (modeloId.present) {
      map['modelo_id'] = Variable<int>(modeloId.value);
    }
    if (campo.present) {
      map['campo'] = Variable<String>(
          $MapeamentosColunaTable.$convertercampo.toSql(campo.value));
    }
    if (indiceColuna.present) {
      map['indice_coluna'] = Variable<int>(indiceColuna.value);
    }
    if (rotuloCabecalho.present) {
      map['rotulo_cabecalho'] = Variable<String>(rotuloCabecalho.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MapeamentosColunaCompanion(')
          ..write('id: $id, ')
          ..write('modeloId: $modeloId, ')
          ..write('campo: $campo, ')
          ..write('indiceColuna: $indiceColuna, ')
          ..write('rotuloCabecalho: $rotuloCabecalho')
          ..write(')'))
        .toString();
  }
}

class $CelulasFixasTable extends CelulasFixas
    with TableInfo<$CelulasFixasTable, CelulaFixaLinha> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CelulasFixasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _modeloIdMeta =
      const VerificationMeta('modeloId');
  @override
  late final GeneratedColumn<int> modeloId = GeneratedColumn<int>(
      'modelo_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES modelo_planilha (id) ON DELETE CASCADE'));
  static const VerificationMeta _campoMeta = const VerificationMeta('campo');
  @override
  late final GeneratedColumnWithTypeConverter<CampoCelulaFixa, String> campo =
      GeneratedColumn<String>('campo', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<CampoCelulaFixa>($CelulasFixasTable.$convertercampo);
  static const VerificationMeta _referenciaCelulaMeta =
      const VerificationMeta('referenciaCelula');
  @override
  late final GeneratedColumn<String> referenciaCelula = GeneratedColumn<String>(
      'referencia_celula', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valorLivreMeta =
      const VerificationMeta('valorLivre');
  @override
  late final GeneratedColumn<String> valorLivre = GeneratedColumn<String>(
      'valor_livre', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, modeloId, campo, referenciaCelula, valorLivre];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'celula_fixa';
  @override
  VerificationContext validateIntegrity(Insertable<CelulaFixaLinha> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('modelo_id')) {
      context.handle(_modeloIdMeta,
          modeloId.isAcceptableOrUnknown(data['modelo_id']!, _modeloIdMeta));
    } else if (isInserting) {
      context.missing(_modeloIdMeta);
    }
    context.handle(_campoMeta, const VerificationResult.success());
    if (data.containsKey('referencia_celula')) {
      context.handle(
          _referenciaCelulaMeta,
          referenciaCelula.isAcceptableOrUnknown(
              data['referencia_celula']!, _referenciaCelulaMeta));
    } else if (isInserting) {
      context.missing(_referenciaCelulaMeta);
    }
    if (data.containsKey('valor_livre')) {
      context.handle(
          _valorLivreMeta,
          valorLivre.isAcceptableOrUnknown(
              data['valor_livre']!, _valorLivreMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CelulaFixaLinha map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CelulaFixaLinha(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      modeloId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}modelo_id'])!,
      campo: $CelulasFixasTable.$convertercampo.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}campo'])!),
      referenciaCelula: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}referencia_celula'])!,
      valorLivre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}valor_livre']),
    );
  }

  @override
  $CelulasFixasTable createAlias(String alias) {
    return $CelulasFixasTable(attachedDatabase, alias);
  }

  static TypeConverter<CampoCelulaFixa, String> $convertercampo =
      const ConversorEnum<CampoCelulaFixa>(CampoCelulaFixa.values);
}

class CelulaFixaLinha extends DataClass implements Insertable<CelulaFixaLinha> {
  final int id;
  final int modeloId;
  final CampoCelulaFixa campo;
  final String referenciaCelula;
  final String? valorLivre;
  const CelulaFixaLinha(
      {required this.id,
      required this.modeloId,
      required this.campo,
      required this.referenciaCelula,
      this.valorLivre});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['modelo_id'] = Variable<int>(modeloId);
    {
      map['campo'] =
          Variable<String>($CelulasFixasTable.$convertercampo.toSql(campo));
    }
    map['referencia_celula'] = Variable<String>(referenciaCelula);
    if (!nullToAbsent || valorLivre != null) {
      map['valor_livre'] = Variable<String>(valorLivre);
    }
    return map;
  }

  CelulasFixasCompanion toCompanion(bool nullToAbsent) {
    return CelulasFixasCompanion(
      id: Value(id),
      modeloId: Value(modeloId),
      campo: Value(campo),
      referenciaCelula: Value(referenciaCelula),
      valorLivre: valorLivre == null && nullToAbsent
          ? const Value.absent()
          : Value(valorLivre),
    );
  }

  factory CelulaFixaLinha.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CelulaFixaLinha(
      id: serializer.fromJson<int>(json['id']),
      modeloId: serializer.fromJson<int>(json['modeloId']),
      campo: serializer.fromJson<CampoCelulaFixa>(json['campo']),
      referenciaCelula: serializer.fromJson<String>(json['referenciaCelula']),
      valorLivre: serializer.fromJson<String?>(json['valorLivre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'modeloId': serializer.toJson<int>(modeloId),
      'campo': serializer.toJson<CampoCelulaFixa>(campo),
      'referenciaCelula': serializer.toJson<String>(referenciaCelula),
      'valorLivre': serializer.toJson<String?>(valorLivre),
    };
  }

  CelulaFixaLinha copyWith(
          {int? id,
          int? modeloId,
          CampoCelulaFixa? campo,
          String? referenciaCelula,
          Value<String?> valorLivre = const Value.absent()}) =>
      CelulaFixaLinha(
        id: id ?? this.id,
        modeloId: modeloId ?? this.modeloId,
        campo: campo ?? this.campo,
        referenciaCelula: referenciaCelula ?? this.referenciaCelula,
        valorLivre: valorLivre.present ? valorLivre.value : this.valorLivre,
      );
  CelulaFixaLinha copyWithCompanion(CelulasFixasCompanion data) {
    return CelulaFixaLinha(
      id: data.id.present ? data.id.value : this.id,
      modeloId: data.modeloId.present ? data.modeloId.value : this.modeloId,
      campo: data.campo.present ? data.campo.value : this.campo,
      referenciaCelula: data.referenciaCelula.present
          ? data.referenciaCelula.value
          : this.referenciaCelula,
      valorLivre:
          data.valorLivre.present ? data.valorLivre.value : this.valorLivre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CelulaFixaLinha(')
          ..write('id: $id, ')
          ..write('modeloId: $modeloId, ')
          ..write('campo: $campo, ')
          ..write('referenciaCelula: $referenciaCelula, ')
          ..write('valorLivre: $valorLivre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, modeloId, campo, referenciaCelula, valorLivre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CelulaFixaLinha &&
          other.id == this.id &&
          other.modeloId == this.modeloId &&
          other.campo == this.campo &&
          other.referenciaCelula == this.referenciaCelula &&
          other.valorLivre == this.valorLivre);
}

class CelulasFixasCompanion extends UpdateCompanion<CelulaFixaLinha> {
  final Value<int> id;
  final Value<int> modeloId;
  final Value<CampoCelulaFixa> campo;
  final Value<String> referenciaCelula;
  final Value<String?> valorLivre;
  const CelulasFixasCompanion({
    this.id = const Value.absent(),
    this.modeloId = const Value.absent(),
    this.campo = const Value.absent(),
    this.referenciaCelula = const Value.absent(),
    this.valorLivre = const Value.absent(),
  });
  CelulasFixasCompanion.insert({
    this.id = const Value.absent(),
    required int modeloId,
    required CampoCelulaFixa campo,
    required String referenciaCelula,
    this.valorLivre = const Value.absent(),
  })  : modeloId = Value(modeloId),
        campo = Value(campo),
        referenciaCelula = Value(referenciaCelula);
  static Insertable<CelulaFixaLinha> custom({
    Expression<int>? id,
    Expression<int>? modeloId,
    Expression<String>? campo,
    Expression<String>? referenciaCelula,
    Expression<String>? valorLivre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modeloId != null) 'modelo_id': modeloId,
      if (campo != null) 'campo': campo,
      if (referenciaCelula != null) 'referencia_celula': referenciaCelula,
      if (valorLivre != null) 'valor_livre': valorLivre,
    });
  }

  CelulasFixasCompanion copyWith(
      {Value<int>? id,
      Value<int>? modeloId,
      Value<CampoCelulaFixa>? campo,
      Value<String>? referenciaCelula,
      Value<String?>? valorLivre}) {
    return CelulasFixasCompanion(
      id: id ?? this.id,
      modeloId: modeloId ?? this.modeloId,
      campo: campo ?? this.campo,
      referenciaCelula: referenciaCelula ?? this.referenciaCelula,
      valorLivre: valorLivre ?? this.valorLivre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (modeloId.present) {
      map['modelo_id'] = Variable<int>(modeloId.value);
    }
    if (campo.present) {
      map['campo'] = Variable<String>(
          $CelulasFixasTable.$convertercampo.toSql(campo.value));
    }
    if (referenciaCelula.present) {
      map['referencia_celula'] = Variable<String>(referenciaCelula.value);
    }
    if (valorLivre.present) {
      map['valor_livre'] = Variable<String>(valorLivre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CelulasFixasCompanion(')
          ..write('id: $id, ')
          ..write('modeloId: $modeloId, ')
          ..write('campo: $campo, ')
          ..write('referenciaCelula: $referenciaCelula, ')
          ..write('valorLivre: $valorLivre')
          ..write(')'))
        .toString();
  }
}

class $TextosStatusTable extends TextosStatus
    with TableInfo<$TextosStatusTable, TextoStatusLinha> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TextosStatusTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _modeloIdMeta =
      const VerificationMeta('modeloId');
  @override
  late final GeneratedColumn<int> modeloId = GeneratedColumn<int>(
      'modelo_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES modelo_planilha (id) ON DELETE CASCADE'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<StatusDia, String> status =
      GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<StatusDia>($TextosStatusTable.$converterstatus);
  static const VerificationMeta _textoMeta = const VerificationMeta('texto');
  @override
  late final GeneratedColumn<String> texto = GeneratedColumn<String>(
      'texto', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, modeloId, status, texto];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'texto_status';
  @override
  VerificationContext validateIntegrity(Insertable<TextoStatusLinha> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('modelo_id')) {
      context.handle(_modeloIdMeta,
          modeloId.isAcceptableOrUnknown(data['modelo_id']!, _modeloIdMeta));
    } else if (isInserting) {
      context.missing(_modeloIdMeta);
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('texto')) {
      context.handle(
          _textoMeta, texto.isAcceptableOrUnknown(data['texto']!, _textoMeta));
    } else if (isInserting) {
      context.missing(_textoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {modeloId, status},
      ];
  @override
  TextoStatusLinha map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TextoStatusLinha(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      modeloId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}modelo_id'])!,
      status: $TextosStatusTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      texto: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}texto'])!,
    );
  }

  @override
  $TextosStatusTable createAlias(String alias) {
    return $TextosStatusTable(attachedDatabase, alias);
  }

  static TypeConverter<StatusDia, String> $converterstatus =
      const ConversorEnum<StatusDia>(StatusDia.values);
}

class TextoStatusLinha extends DataClass
    implements Insertable<TextoStatusLinha> {
  final int id;
  final int modeloId;
  final StatusDia status;
  final String texto;
  const TextoStatusLinha(
      {required this.id,
      required this.modeloId,
      required this.status,
      required this.texto});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['modelo_id'] = Variable<int>(modeloId);
    {
      map['status'] =
          Variable<String>($TextosStatusTable.$converterstatus.toSql(status));
    }
    map['texto'] = Variable<String>(texto);
    return map;
  }

  TextosStatusCompanion toCompanion(bool nullToAbsent) {
    return TextosStatusCompanion(
      id: Value(id),
      modeloId: Value(modeloId),
      status: Value(status),
      texto: Value(texto),
    );
  }

  factory TextoStatusLinha.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TextoStatusLinha(
      id: serializer.fromJson<int>(json['id']),
      modeloId: serializer.fromJson<int>(json['modeloId']),
      status: serializer.fromJson<StatusDia>(json['status']),
      texto: serializer.fromJson<String>(json['texto']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'modeloId': serializer.toJson<int>(modeloId),
      'status': serializer.toJson<StatusDia>(status),
      'texto': serializer.toJson<String>(texto),
    };
  }

  TextoStatusLinha copyWith(
          {int? id, int? modeloId, StatusDia? status, String? texto}) =>
      TextoStatusLinha(
        id: id ?? this.id,
        modeloId: modeloId ?? this.modeloId,
        status: status ?? this.status,
        texto: texto ?? this.texto,
      );
  TextoStatusLinha copyWithCompanion(TextosStatusCompanion data) {
    return TextoStatusLinha(
      id: data.id.present ? data.id.value : this.id,
      modeloId: data.modeloId.present ? data.modeloId.value : this.modeloId,
      status: data.status.present ? data.status.value : this.status,
      texto: data.texto.present ? data.texto.value : this.texto,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TextoStatusLinha(')
          ..write('id: $id, ')
          ..write('modeloId: $modeloId, ')
          ..write('status: $status, ')
          ..write('texto: $texto')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, modeloId, status, texto);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TextoStatusLinha &&
          other.id == this.id &&
          other.modeloId == this.modeloId &&
          other.status == this.status &&
          other.texto == this.texto);
}

class TextosStatusCompanion extends UpdateCompanion<TextoStatusLinha> {
  final Value<int> id;
  final Value<int> modeloId;
  final Value<StatusDia> status;
  final Value<String> texto;
  const TextosStatusCompanion({
    this.id = const Value.absent(),
    this.modeloId = const Value.absent(),
    this.status = const Value.absent(),
    this.texto = const Value.absent(),
  });
  TextosStatusCompanion.insert({
    this.id = const Value.absent(),
    required int modeloId,
    required StatusDia status,
    required String texto,
  })  : modeloId = Value(modeloId),
        status = Value(status),
        texto = Value(texto);
  static Insertable<TextoStatusLinha> custom({
    Expression<int>? id,
    Expression<int>? modeloId,
    Expression<String>? status,
    Expression<String>? texto,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modeloId != null) 'modelo_id': modeloId,
      if (status != null) 'status': status,
      if (texto != null) 'texto': texto,
    });
  }

  TextosStatusCompanion copyWith(
      {Value<int>? id,
      Value<int>? modeloId,
      Value<StatusDia>? status,
      Value<String>? texto}) {
    return TextosStatusCompanion(
      id: id ?? this.id,
      modeloId: modeloId ?? this.modeloId,
      status: status ?? this.status,
      texto: texto ?? this.texto,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (modeloId.present) {
      map['modelo_id'] = Variable<int>(modeloId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
          $TextosStatusTable.$converterstatus.toSql(status.value));
    }
    if (texto.present) {
      map['texto'] = Variable<String>(texto.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TextosStatusCompanion(')
          ..write('id: $id, ')
          ..write('modeloId: $modeloId, ')
          ..write('status: $status, ')
          ..write('texto: $texto')
          ..write(')'))
        .toString();
  }
}

class $ConfiguracoesEmailTable extends ConfiguracoesEmail
    with TableInfo<$ConfiguracoesEmailTable, ConfiguracaoEmailLinha> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfiguracoesEmailTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _destinatariosMeta =
      const VerificationMeta('destinatarios');
  @override
  late final GeneratedColumn<String> destinatarios = GeneratedColumn<String>(
      'destinatarios', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _copiaMeta = const VerificationMeta('copia');
  @override
  late final GeneratedColumn<String> copia = GeneratedColumn<String>(
      'copia', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _assuntoModeloMeta =
      const VerificationMeta('assuntoModelo');
  @override
  late final GeneratedColumn<String> assuntoModelo = GeneratedColumn<String>(
      'assunto_modelo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _corpoModeloMeta =
      const VerificationMeta('corpoModelo');
  @override
  late final GeneratedColumn<String> corpoModelo = GeneratedColumn<String>(
      'corpo_modelo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _templateNomeArquivoMeta =
      const VerificationMeta('templateNomeArquivo');
  @override
  late final GeneratedColumn<String> templateNomeArquivo =
      GeneratedColumn<String>('template_nome_arquivo', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ativoMeta = const VerificationMeta('ativo');
  @override
  late final GeneratedColumn<bool> ativo = GeneratedColumn<bool>(
      'ativo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("ativo" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        destinatarios,
        copia,
        assuntoModelo,
        corpoModelo,
        templateNomeArquivo,
        ativo
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'configuracao_email';
  @override
  VerificationContext validateIntegrity(
      Insertable<ConfiguracaoEmailLinha> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('destinatarios')) {
      context.handle(
          _destinatariosMeta,
          destinatarios.isAcceptableOrUnknown(
              data['destinatarios']!, _destinatariosMeta));
    } else if (isInserting) {
      context.missing(_destinatariosMeta);
    }
    if (data.containsKey('copia')) {
      context.handle(
          _copiaMeta, copia.isAcceptableOrUnknown(data['copia']!, _copiaMeta));
    }
    if (data.containsKey('assunto_modelo')) {
      context.handle(
          _assuntoModeloMeta,
          assuntoModelo.isAcceptableOrUnknown(
              data['assunto_modelo']!, _assuntoModeloMeta));
    } else if (isInserting) {
      context.missing(_assuntoModeloMeta);
    }
    if (data.containsKey('corpo_modelo')) {
      context.handle(
          _corpoModeloMeta,
          corpoModelo.isAcceptableOrUnknown(
              data['corpo_modelo']!, _corpoModeloMeta));
    } else if (isInserting) {
      context.missing(_corpoModeloMeta);
    }
    if (data.containsKey('template_nome_arquivo')) {
      context.handle(
          _templateNomeArquivoMeta,
          templateNomeArquivo.isAcceptableOrUnknown(
              data['template_nome_arquivo']!, _templateNomeArquivoMeta));
    } else if (isInserting) {
      context.missing(_templateNomeArquivoMeta);
    }
    if (data.containsKey('ativo')) {
      context.handle(
          _ativoMeta, ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConfiguracaoEmailLinha map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfiguracaoEmailLinha(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      destinatarios: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}destinatarios'])!,
      copia: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}copia']),
      assuntoModelo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}assunto_modelo'])!,
      corpoModelo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}corpo_modelo'])!,
      templateNomeArquivo: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}template_nome_arquivo'])!,
      ativo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}ativo'])!,
    );
  }

  @override
  $ConfiguracoesEmailTable createAlias(String alias) {
    return $ConfiguracoesEmailTable(attachedDatabase, alias);
  }
}

class ConfiguracaoEmailLinha extends DataClass
    implements Insertable<ConfiguracaoEmailLinha> {
  final int id;

  /// E-mails separados por ponto e vírgula.
  final String destinatarios;
  final String? copia;
  final String assuntoModelo;
  final String corpoModelo;
  final String templateNomeArquivo;
  final bool ativo;
  const ConfiguracaoEmailLinha(
      {required this.id,
      required this.destinatarios,
      this.copia,
      required this.assuntoModelo,
      required this.corpoModelo,
      required this.templateNomeArquivo,
      required this.ativo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['destinatarios'] = Variable<String>(destinatarios);
    if (!nullToAbsent || copia != null) {
      map['copia'] = Variable<String>(copia);
    }
    map['assunto_modelo'] = Variable<String>(assuntoModelo);
    map['corpo_modelo'] = Variable<String>(corpoModelo);
    map['template_nome_arquivo'] = Variable<String>(templateNomeArquivo);
    map['ativo'] = Variable<bool>(ativo);
    return map;
  }

  ConfiguracoesEmailCompanion toCompanion(bool nullToAbsent) {
    return ConfiguracoesEmailCompanion(
      id: Value(id),
      destinatarios: Value(destinatarios),
      copia:
          copia == null && nullToAbsent ? const Value.absent() : Value(copia),
      assuntoModelo: Value(assuntoModelo),
      corpoModelo: Value(corpoModelo),
      templateNomeArquivo: Value(templateNomeArquivo),
      ativo: Value(ativo),
    );
  }

  factory ConfiguracaoEmailLinha.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfiguracaoEmailLinha(
      id: serializer.fromJson<int>(json['id']),
      destinatarios: serializer.fromJson<String>(json['destinatarios']),
      copia: serializer.fromJson<String?>(json['copia']),
      assuntoModelo: serializer.fromJson<String>(json['assuntoModelo']),
      corpoModelo: serializer.fromJson<String>(json['corpoModelo']),
      templateNomeArquivo:
          serializer.fromJson<String>(json['templateNomeArquivo']),
      ativo: serializer.fromJson<bool>(json['ativo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'destinatarios': serializer.toJson<String>(destinatarios),
      'copia': serializer.toJson<String?>(copia),
      'assuntoModelo': serializer.toJson<String>(assuntoModelo),
      'corpoModelo': serializer.toJson<String>(corpoModelo),
      'templateNomeArquivo': serializer.toJson<String>(templateNomeArquivo),
      'ativo': serializer.toJson<bool>(ativo),
    };
  }

  ConfiguracaoEmailLinha copyWith(
          {int? id,
          String? destinatarios,
          Value<String?> copia = const Value.absent(),
          String? assuntoModelo,
          String? corpoModelo,
          String? templateNomeArquivo,
          bool? ativo}) =>
      ConfiguracaoEmailLinha(
        id: id ?? this.id,
        destinatarios: destinatarios ?? this.destinatarios,
        copia: copia.present ? copia.value : this.copia,
        assuntoModelo: assuntoModelo ?? this.assuntoModelo,
        corpoModelo: corpoModelo ?? this.corpoModelo,
        templateNomeArquivo: templateNomeArquivo ?? this.templateNomeArquivo,
        ativo: ativo ?? this.ativo,
      );
  ConfiguracaoEmailLinha copyWithCompanion(ConfiguracoesEmailCompanion data) {
    return ConfiguracaoEmailLinha(
      id: data.id.present ? data.id.value : this.id,
      destinatarios: data.destinatarios.present
          ? data.destinatarios.value
          : this.destinatarios,
      copia: data.copia.present ? data.copia.value : this.copia,
      assuntoModelo: data.assuntoModelo.present
          ? data.assuntoModelo.value
          : this.assuntoModelo,
      corpoModelo:
          data.corpoModelo.present ? data.corpoModelo.value : this.corpoModelo,
      templateNomeArquivo: data.templateNomeArquivo.present
          ? data.templateNomeArquivo.value
          : this.templateNomeArquivo,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracaoEmailLinha(')
          ..write('id: $id, ')
          ..write('destinatarios: $destinatarios, ')
          ..write('copia: $copia, ')
          ..write('assuntoModelo: $assuntoModelo, ')
          ..write('corpoModelo: $corpoModelo, ')
          ..write('templateNomeArquivo: $templateNomeArquivo, ')
          ..write('ativo: $ativo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, destinatarios, copia, assuntoModelo,
      corpoModelo, templateNomeArquivo, ativo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfiguracaoEmailLinha &&
          other.id == this.id &&
          other.destinatarios == this.destinatarios &&
          other.copia == this.copia &&
          other.assuntoModelo == this.assuntoModelo &&
          other.corpoModelo == this.corpoModelo &&
          other.templateNomeArquivo == this.templateNomeArquivo &&
          other.ativo == this.ativo);
}

class ConfiguracoesEmailCompanion
    extends UpdateCompanion<ConfiguracaoEmailLinha> {
  final Value<int> id;
  final Value<String> destinatarios;
  final Value<String?> copia;
  final Value<String> assuntoModelo;
  final Value<String> corpoModelo;
  final Value<String> templateNomeArquivo;
  final Value<bool> ativo;
  const ConfiguracoesEmailCompanion({
    this.id = const Value.absent(),
    this.destinatarios = const Value.absent(),
    this.copia = const Value.absent(),
    this.assuntoModelo = const Value.absent(),
    this.corpoModelo = const Value.absent(),
    this.templateNomeArquivo = const Value.absent(),
    this.ativo = const Value.absent(),
  });
  ConfiguracoesEmailCompanion.insert({
    this.id = const Value.absent(),
    required String destinatarios,
    this.copia = const Value.absent(),
    required String assuntoModelo,
    required String corpoModelo,
    required String templateNomeArquivo,
    this.ativo = const Value.absent(),
  })  : destinatarios = Value(destinatarios),
        assuntoModelo = Value(assuntoModelo),
        corpoModelo = Value(corpoModelo),
        templateNomeArquivo = Value(templateNomeArquivo);
  static Insertable<ConfiguracaoEmailLinha> custom({
    Expression<int>? id,
    Expression<String>? destinatarios,
    Expression<String>? copia,
    Expression<String>? assuntoModelo,
    Expression<String>? corpoModelo,
    Expression<String>? templateNomeArquivo,
    Expression<bool>? ativo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (destinatarios != null) 'destinatarios': destinatarios,
      if (copia != null) 'copia': copia,
      if (assuntoModelo != null) 'assunto_modelo': assuntoModelo,
      if (corpoModelo != null) 'corpo_modelo': corpoModelo,
      if (templateNomeArquivo != null)
        'template_nome_arquivo': templateNomeArquivo,
      if (ativo != null) 'ativo': ativo,
    });
  }

  ConfiguracoesEmailCompanion copyWith(
      {Value<int>? id,
      Value<String>? destinatarios,
      Value<String?>? copia,
      Value<String>? assuntoModelo,
      Value<String>? corpoModelo,
      Value<String>? templateNomeArquivo,
      Value<bool>? ativo}) {
    return ConfiguracoesEmailCompanion(
      id: id ?? this.id,
      destinatarios: destinatarios ?? this.destinatarios,
      copia: copia ?? this.copia,
      assuntoModelo: assuntoModelo ?? this.assuntoModelo,
      corpoModelo: corpoModelo ?? this.corpoModelo,
      templateNomeArquivo: templateNomeArquivo ?? this.templateNomeArquivo,
      ativo: ativo ?? this.ativo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (destinatarios.present) {
      map['destinatarios'] = Variable<String>(destinatarios.value);
    }
    if (copia.present) {
      map['copia'] = Variable<String>(copia.value);
    }
    if (assuntoModelo.present) {
      map['assunto_modelo'] = Variable<String>(assuntoModelo.value);
    }
    if (corpoModelo.present) {
      map['corpo_modelo'] = Variable<String>(corpoModelo.value);
    }
    if (templateNomeArquivo.present) {
      map['template_nome_arquivo'] =
          Variable<String>(templateNomeArquivo.value);
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracoesEmailCompanion(')
          ..write('id: $id, ')
          ..write('destinatarios: $destinatarios, ')
          ..write('copia: $copia, ')
          ..write('assuntoModelo: $assuntoModelo, ')
          ..write('corpoModelo: $corpoModelo, ')
          ..write('templateNomeArquivo: $templateNomeArquivo, ')
          ..write('ativo: $ativo')
          ..write(')'))
        .toString();
  }
}

class $EnviosMensaisTable extends EnviosMensais
    with TableInfo<$EnviosMensaisTable, EnvioMensalLinha> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnviosMensaisTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _modeloIdMeta =
      const VerificationMeta('modeloId');
  @override
  late final GeneratedColumn<int> modeloId = GeneratedColumn<int>(
      'modelo_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES modelo_planilha (id) ON DELETE SET NULL'));
  static const VerificationMeta _competenciaAnoMeta =
      const VerificationMeta('competenciaAno');
  @override
  late final GeneratedColumn<int> competenciaAno = GeneratedColumn<int>(
      'competencia_ano', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _competenciaMesMeta =
      const VerificationMeta('competenciaMes');
  @override
  late final GeneratedColumn<int> competenciaMes = GeneratedColumn<int>(
      'competencia_mes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<StatusEnvio, String> status =
      GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<StatusEnvio>($EnviosMensaisTable.$converterstatus);
  static const VerificationMeta _geradoEmMeta =
      const VerificationMeta('geradoEm');
  @override
  late final GeneratedColumn<DateTime> geradoEm = GeneratedColumn<DateTime>(
      'gerado_em', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _caminhoArquivoMeta =
      const VerificationMeta('caminhoArquivo');
  @override
  late final GeneratedColumn<String> caminhoArquivo = GeneratedColumn<String>(
      'caminho_arquivo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomeArquivoMeta =
      const VerificationMeta('nomeArquivo');
  @override
  late final GeneratedColumn<String> nomeArquivo = GeneratedColumn<String>(
      'nome_arquivo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tamanhoBytesMeta =
      const VerificationMeta('tamanhoBytes');
  @override
  late final GeneratedColumn<int> tamanhoBytes = GeneratedColumn<int>(
      'tamanho_bytes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _enviadoEmMeta =
      const VerificationMeta('enviadoEm');
  @override
  late final GeneratedColumn<DateTime> enviadoEm = GeneratedColumn<DateTime>(
      'enviado_em', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _observacaoMeta =
      const VerificationMeta('observacao');
  @override
  late final GeneratedColumn<String> observacao = GeneratedColumn<String>(
      'observacao', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        modeloId,
        competenciaAno,
        competenciaMes,
        status,
        geradoEm,
        caminhoArquivo,
        nomeArquivo,
        tamanhoBytes,
        enviadoEm,
        observacao
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'envio_mensal';
  @override
  VerificationContext validateIntegrity(Insertable<EnvioMensalLinha> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('modelo_id')) {
      context.handle(_modeloIdMeta,
          modeloId.isAcceptableOrUnknown(data['modelo_id']!, _modeloIdMeta));
    }
    if (data.containsKey('competencia_ano')) {
      context.handle(
          _competenciaAnoMeta,
          competenciaAno.isAcceptableOrUnknown(
              data['competencia_ano']!, _competenciaAnoMeta));
    } else if (isInserting) {
      context.missing(_competenciaAnoMeta);
    }
    if (data.containsKey('competencia_mes')) {
      context.handle(
          _competenciaMesMeta,
          competenciaMes.isAcceptableOrUnknown(
              data['competencia_mes']!, _competenciaMesMeta));
    } else if (isInserting) {
      context.missing(_competenciaMesMeta);
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('gerado_em')) {
      context.handle(_geradoEmMeta,
          geradoEm.isAcceptableOrUnknown(data['gerado_em']!, _geradoEmMeta));
    } else if (isInserting) {
      context.missing(_geradoEmMeta);
    }
    if (data.containsKey('caminho_arquivo')) {
      context.handle(
          _caminhoArquivoMeta,
          caminhoArquivo.isAcceptableOrUnknown(
              data['caminho_arquivo']!, _caminhoArquivoMeta));
    } else if (isInserting) {
      context.missing(_caminhoArquivoMeta);
    }
    if (data.containsKey('nome_arquivo')) {
      context.handle(
          _nomeArquivoMeta,
          nomeArquivo.isAcceptableOrUnknown(
              data['nome_arquivo']!, _nomeArquivoMeta));
    } else if (isInserting) {
      context.missing(_nomeArquivoMeta);
    }
    if (data.containsKey('tamanho_bytes')) {
      context.handle(
          _tamanhoBytesMeta,
          tamanhoBytes.isAcceptableOrUnknown(
              data['tamanho_bytes']!, _tamanhoBytesMeta));
    } else if (isInserting) {
      context.missing(_tamanhoBytesMeta);
    }
    if (data.containsKey('enviado_em')) {
      context.handle(_enviadoEmMeta,
          enviadoEm.isAcceptableOrUnknown(data['enviado_em']!, _enviadoEmMeta));
    }
    if (data.containsKey('observacao')) {
      context.handle(
          _observacaoMeta,
          observacao.isAcceptableOrUnknown(
              data['observacao']!, _observacaoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EnvioMensalLinha map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EnvioMensalLinha(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      modeloId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}modelo_id']),
      competenciaAno: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}competencia_ano'])!,
      competenciaMes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}competencia_mes'])!,
      status: $EnviosMensaisTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      geradoEm: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}gerado_em'])!,
      caminhoArquivo: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}caminho_arquivo'])!,
      nomeArquivo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome_arquivo'])!,
      tamanhoBytes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tamanho_bytes'])!,
      enviadoEm: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}enviado_em']),
      observacao: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observacao']),
    );
  }

  @override
  $EnviosMensaisTable createAlias(String alias) {
    return $EnviosMensaisTable(attachedDatabase, alias);
  }

  static TypeConverter<StatusEnvio, String> $converterstatus =
      const ConversorEnum<StatusEnvio>(StatusEnvio.values);
}

class EnvioMensalLinha extends DataClass
    implements Insertable<EnvioMensalLinha> {
  final int id;
  final int? modeloId;
  final int competenciaAno;
  final int competenciaMes;
  final StatusEnvio status;
  final DateTime geradoEm;
  final String caminhoArquivo;
  final String nomeArquivo;
  final int tamanhoBytes;
  final DateTime? enviadoEm;
  final String? observacao;
  const EnvioMensalLinha(
      {required this.id,
      this.modeloId,
      required this.competenciaAno,
      required this.competenciaMes,
      required this.status,
      required this.geradoEm,
      required this.caminhoArquivo,
      required this.nomeArquivo,
      required this.tamanhoBytes,
      this.enviadoEm,
      this.observacao});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || modeloId != null) {
      map['modelo_id'] = Variable<int>(modeloId);
    }
    map['competencia_ano'] = Variable<int>(competenciaAno);
    map['competencia_mes'] = Variable<int>(competenciaMes);
    {
      map['status'] =
          Variable<String>($EnviosMensaisTable.$converterstatus.toSql(status));
    }
    map['gerado_em'] = Variable<DateTime>(geradoEm);
    map['caminho_arquivo'] = Variable<String>(caminhoArquivo);
    map['nome_arquivo'] = Variable<String>(nomeArquivo);
    map['tamanho_bytes'] = Variable<int>(tamanhoBytes);
    if (!nullToAbsent || enviadoEm != null) {
      map['enviado_em'] = Variable<DateTime>(enviadoEm);
    }
    if (!nullToAbsent || observacao != null) {
      map['observacao'] = Variable<String>(observacao);
    }
    return map;
  }

  EnviosMensaisCompanion toCompanion(bool nullToAbsent) {
    return EnviosMensaisCompanion(
      id: Value(id),
      modeloId: modeloId == null && nullToAbsent
          ? const Value.absent()
          : Value(modeloId),
      competenciaAno: Value(competenciaAno),
      competenciaMes: Value(competenciaMes),
      status: Value(status),
      geradoEm: Value(geradoEm),
      caminhoArquivo: Value(caminhoArquivo),
      nomeArquivo: Value(nomeArquivo),
      tamanhoBytes: Value(tamanhoBytes),
      enviadoEm: enviadoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(enviadoEm),
      observacao: observacao == null && nullToAbsent
          ? const Value.absent()
          : Value(observacao),
    );
  }

  factory EnvioMensalLinha.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EnvioMensalLinha(
      id: serializer.fromJson<int>(json['id']),
      modeloId: serializer.fromJson<int?>(json['modeloId']),
      competenciaAno: serializer.fromJson<int>(json['competenciaAno']),
      competenciaMes: serializer.fromJson<int>(json['competenciaMes']),
      status: serializer.fromJson<StatusEnvio>(json['status']),
      geradoEm: serializer.fromJson<DateTime>(json['geradoEm']),
      caminhoArquivo: serializer.fromJson<String>(json['caminhoArquivo']),
      nomeArquivo: serializer.fromJson<String>(json['nomeArquivo']),
      tamanhoBytes: serializer.fromJson<int>(json['tamanhoBytes']),
      enviadoEm: serializer.fromJson<DateTime?>(json['enviadoEm']),
      observacao: serializer.fromJson<String?>(json['observacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'modeloId': serializer.toJson<int?>(modeloId),
      'competenciaAno': serializer.toJson<int>(competenciaAno),
      'competenciaMes': serializer.toJson<int>(competenciaMes),
      'status': serializer.toJson<StatusEnvio>(status),
      'geradoEm': serializer.toJson<DateTime>(geradoEm),
      'caminhoArquivo': serializer.toJson<String>(caminhoArquivo),
      'nomeArquivo': serializer.toJson<String>(nomeArquivo),
      'tamanhoBytes': serializer.toJson<int>(tamanhoBytes),
      'enviadoEm': serializer.toJson<DateTime?>(enviadoEm),
      'observacao': serializer.toJson<String?>(observacao),
    };
  }

  EnvioMensalLinha copyWith(
          {int? id,
          Value<int?> modeloId = const Value.absent(),
          int? competenciaAno,
          int? competenciaMes,
          StatusEnvio? status,
          DateTime? geradoEm,
          String? caminhoArquivo,
          String? nomeArquivo,
          int? tamanhoBytes,
          Value<DateTime?> enviadoEm = const Value.absent(),
          Value<String?> observacao = const Value.absent()}) =>
      EnvioMensalLinha(
        id: id ?? this.id,
        modeloId: modeloId.present ? modeloId.value : this.modeloId,
        competenciaAno: competenciaAno ?? this.competenciaAno,
        competenciaMes: competenciaMes ?? this.competenciaMes,
        status: status ?? this.status,
        geradoEm: geradoEm ?? this.geradoEm,
        caminhoArquivo: caminhoArquivo ?? this.caminhoArquivo,
        nomeArquivo: nomeArquivo ?? this.nomeArquivo,
        tamanhoBytes: tamanhoBytes ?? this.tamanhoBytes,
        enviadoEm: enviadoEm.present ? enviadoEm.value : this.enviadoEm,
        observacao: observacao.present ? observacao.value : this.observacao,
      );
  EnvioMensalLinha copyWithCompanion(EnviosMensaisCompanion data) {
    return EnvioMensalLinha(
      id: data.id.present ? data.id.value : this.id,
      modeloId: data.modeloId.present ? data.modeloId.value : this.modeloId,
      competenciaAno: data.competenciaAno.present
          ? data.competenciaAno.value
          : this.competenciaAno,
      competenciaMes: data.competenciaMes.present
          ? data.competenciaMes.value
          : this.competenciaMes,
      status: data.status.present ? data.status.value : this.status,
      geradoEm: data.geradoEm.present ? data.geradoEm.value : this.geradoEm,
      caminhoArquivo: data.caminhoArquivo.present
          ? data.caminhoArquivo.value
          : this.caminhoArquivo,
      nomeArquivo:
          data.nomeArquivo.present ? data.nomeArquivo.value : this.nomeArquivo,
      tamanhoBytes: data.tamanhoBytes.present
          ? data.tamanhoBytes.value
          : this.tamanhoBytes,
      enviadoEm: data.enviadoEm.present ? data.enviadoEm.value : this.enviadoEm,
      observacao:
          data.observacao.present ? data.observacao.value : this.observacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EnvioMensalLinha(')
          ..write('id: $id, ')
          ..write('modeloId: $modeloId, ')
          ..write('competenciaAno: $competenciaAno, ')
          ..write('competenciaMes: $competenciaMes, ')
          ..write('status: $status, ')
          ..write('geradoEm: $geradoEm, ')
          ..write('caminhoArquivo: $caminhoArquivo, ')
          ..write('nomeArquivo: $nomeArquivo, ')
          ..write('tamanhoBytes: $tamanhoBytes, ')
          ..write('enviadoEm: $enviadoEm, ')
          ..write('observacao: $observacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      modeloId,
      competenciaAno,
      competenciaMes,
      status,
      geradoEm,
      caminhoArquivo,
      nomeArquivo,
      tamanhoBytes,
      enviadoEm,
      observacao);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnvioMensalLinha &&
          other.id == this.id &&
          other.modeloId == this.modeloId &&
          other.competenciaAno == this.competenciaAno &&
          other.competenciaMes == this.competenciaMes &&
          other.status == this.status &&
          other.geradoEm == this.geradoEm &&
          other.caminhoArquivo == this.caminhoArquivo &&
          other.nomeArquivo == this.nomeArquivo &&
          other.tamanhoBytes == this.tamanhoBytes &&
          other.enviadoEm == this.enviadoEm &&
          other.observacao == this.observacao);
}

class EnviosMensaisCompanion extends UpdateCompanion<EnvioMensalLinha> {
  final Value<int> id;
  final Value<int?> modeloId;
  final Value<int> competenciaAno;
  final Value<int> competenciaMes;
  final Value<StatusEnvio> status;
  final Value<DateTime> geradoEm;
  final Value<String> caminhoArquivo;
  final Value<String> nomeArquivo;
  final Value<int> tamanhoBytes;
  final Value<DateTime?> enviadoEm;
  final Value<String?> observacao;
  const EnviosMensaisCompanion({
    this.id = const Value.absent(),
    this.modeloId = const Value.absent(),
    this.competenciaAno = const Value.absent(),
    this.competenciaMes = const Value.absent(),
    this.status = const Value.absent(),
    this.geradoEm = const Value.absent(),
    this.caminhoArquivo = const Value.absent(),
    this.nomeArquivo = const Value.absent(),
    this.tamanhoBytes = const Value.absent(),
    this.enviadoEm = const Value.absent(),
    this.observacao = const Value.absent(),
  });
  EnviosMensaisCompanion.insert({
    this.id = const Value.absent(),
    this.modeloId = const Value.absent(),
    required int competenciaAno,
    required int competenciaMes,
    required StatusEnvio status,
    required DateTime geradoEm,
    required String caminhoArquivo,
    required String nomeArquivo,
    required int tamanhoBytes,
    this.enviadoEm = const Value.absent(),
    this.observacao = const Value.absent(),
  })  : competenciaAno = Value(competenciaAno),
        competenciaMes = Value(competenciaMes),
        status = Value(status),
        geradoEm = Value(geradoEm),
        caminhoArquivo = Value(caminhoArquivo),
        nomeArquivo = Value(nomeArquivo),
        tamanhoBytes = Value(tamanhoBytes);
  static Insertable<EnvioMensalLinha> custom({
    Expression<int>? id,
    Expression<int>? modeloId,
    Expression<int>? competenciaAno,
    Expression<int>? competenciaMes,
    Expression<String>? status,
    Expression<DateTime>? geradoEm,
    Expression<String>? caminhoArquivo,
    Expression<String>? nomeArquivo,
    Expression<int>? tamanhoBytes,
    Expression<DateTime>? enviadoEm,
    Expression<String>? observacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modeloId != null) 'modelo_id': modeloId,
      if (competenciaAno != null) 'competencia_ano': competenciaAno,
      if (competenciaMes != null) 'competencia_mes': competenciaMes,
      if (status != null) 'status': status,
      if (geradoEm != null) 'gerado_em': geradoEm,
      if (caminhoArquivo != null) 'caminho_arquivo': caminhoArquivo,
      if (nomeArquivo != null) 'nome_arquivo': nomeArquivo,
      if (tamanhoBytes != null) 'tamanho_bytes': tamanhoBytes,
      if (enviadoEm != null) 'enviado_em': enviadoEm,
      if (observacao != null) 'observacao': observacao,
    });
  }

  EnviosMensaisCompanion copyWith(
      {Value<int>? id,
      Value<int?>? modeloId,
      Value<int>? competenciaAno,
      Value<int>? competenciaMes,
      Value<StatusEnvio>? status,
      Value<DateTime>? geradoEm,
      Value<String>? caminhoArquivo,
      Value<String>? nomeArquivo,
      Value<int>? tamanhoBytes,
      Value<DateTime?>? enviadoEm,
      Value<String?>? observacao}) {
    return EnviosMensaisCompanion(
      id: id ?? this.id,
      modeloId: modeloId ?? this.modeloId,
      competenciaAno: competenciaAno ?? this.competenciaAno,
      competenciaMes: competenciaMes ?? this.competenciaMes,
      status: status ?? this.status,
      geradoEm: geradoEm ?? this.geradoEm,
      caminhoArquivo: caminhoArquivo ?? this.caminhoArquivo,
      nomeArquivo: nomeArquivo ?? this.nomeArquivo,
      tamanhoBytes: tamanhoBytes ?? this.tamanhoBytes,
      enviadoEm: enviadoEm ?? this.enviadoEm,
      observacao: observacao ?? this.observacao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (modeloId.present) {
      map['modelo_id'] = Variable<int>(modeloId.value);
    }
    if (competenciaAno.present) {
      map['competencia_ano'] = Variable<int>(competenciaAno.value);
    }
    if (competenciaMes.present) {
      map['competencia_mes'] = Variable<int>(competenciaMes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
          $EnviosMensaisTable.$converterstatus.toSql(status.value));
    }
    if (geradoEm.present) {
      map['gerado_em'] = Variable<DateTime>(geradoEm.value);
    }
    if (caminhoArquivo.present) {
      map['caminho_arquivo'] = Variable<String>(caminhoArquivo.value);
    }
    if (nomeArquivo.present) {
      map['nome_arquivo'] = Variable<String>(nomeArquivo.value);
    }
    if (tamanhoBytes.present) {
      map['tamanho_bytes'] = Variable<int>(tamanhoBytes.value);
    }
    if (enviadoEm.present) {
      map['enviado_em'] = Variable<DateTime>(enviadoEm.value);
    }
    if (observacao.present) {
      map['observacao'] = Variable<String>(observacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnviosMensaisCompanion(')
          ..write('id: $id, ')
          ..write('modeloId: $modeloId, ')
          ..write('competenciaAno: $competenciaAno, ')
          ..write('competenciaMes: $competenciaMes, ')
          ..write('status: $status, ')
          ..write('geradoEm: $geradoEm, ')
          ..write('caminhoArquivo: $caminhoArquivo, ')
          ..write('nomeArquivo: $nomeArquivo, ')
          ..write('tamanhoBytes: $tamanhoBytes, ')
          ..write('enviadoEm: $enviadoEm, ')
          ..write('observacao: $observacao')
          ..write(')'))
        .toString();
  }
}

class $ConfiguracoesNotificacaoTable extends ConfiguracoesNotificacao
    with
        TableInfo<$ConfiguracoesNotificacaoTable,
            ConfiguracaoNotificacaoLinha> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfiguracoesNotificacaoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumnWithTypeConverter<TipoNotificacao, String> tipo =
      GeneratedColumn<String>('tipo', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: true,
              defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'))
          .withConverter<TipoNotificacao>(
              $ConfiguracoesNotificacaoTable.$convertertipo);
  static const VerificationMeta _ativaMeta = const VerificationMeta('ativa');
  @override
  late final GeneratedColumn<bool> ativa = GeneratedColumn<bool>(
      'ativa', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("ativa" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _horaMeta = const VerificationMeta('hora');
  @override
  late final GeneratedColumn<int> hora = GeneratedColumn<int>(
      'hora', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _antecedenciaMinutosMeta =
      const VerificationMeta('antecedenciaMinutos');
  @override
  late final GeneratedColumn<int> antecedenciaMinutos = GeneratedColumn<int>(
      'antecedencia_minutos', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _diaReferenciaMeta =
      const VerificationMeta('diaReferencia');
  @override
  late final GeneratedColumn<int> diaReferencia = GeneratedColumn<int>(
      'dia_referencia', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, tipo, ativa, hora, antecedenciaMinutos, diaReferencia];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'configuracao_notificacao';
  @override
  VerificationContext validateIntegrity(
      Insertable<ConfiguracaoNotificacaoLinha> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    context.handle(_tipoMeta, const VerificationResult.success());
    if (data.containsKey('ativa')) {
      context.handle(
          _ativaMeta, ativa.isAcceptableOrUnknown(data['ativa']!, _ativaMeta));
    }
    if (data.containsKey('hora')) {
      context.handle(
          _horaMeta, hora.isAcceptableOrUnknown(data['hora']!, _horaMeta));
    }
    if (data.containsKey('antecedencia_minutos')) {
      context.handle(
          _antecedenciaMinutosMeta,
          antecedenciaMinutos.isAcceptableOrUnknown(
              data['antecedencia_minutos']!, _antecedenciaMinutosMeta));
    }
    if (data.containsKey('dia_referencia')) {
      context.handle(
          _diaReferenciaMeta,
          diaReferencia.isAcceptableOrUnknown(
              data['dia_referencia']!, _diaReferenciaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConfiguracaoNotificacaoLinha map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfiguracaoNotificacaoLinha(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tipo: $ConfiguracoesNotificacaoTable.$convertertipo.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}tipo'])!),
      ativa: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}ativa'])!,
      hora: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hora']),
      antecedenciaMinutos: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}antecedencia_minutos'])!,
      diaReferencia: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dia_referencia']),
    );
  }

  @override
  $ConfiguracoesNotificacaoTable createAlias(String alias) {
    return $ConfiguracoesNotificacaoTable(attachedDatabase, alias);
  }

  static TypeConverter<TipoNotificacao, String> $convertertipo =
      const ConversorEnum<TipoNotificacao>(TipoNotificacao.values);
}

class ConfiguracaoNotificacaoLinha extends DataClass
    implements Insertable<ConfiguracaoNotificacaoLinha> {
  final int id;
  final TipoNotificacao tipo;
  final bool ativa;
  final int? hora;
  final int antecedenciaMinutos;
  final int? diaReferencia;
  const ConfiguracaoNotificacaoLinha(
      {required this.id,
      required this.tipo,
      required this.ativa,
      this.hora,
      required this.antecedenciaMinutos,
      this.diaReferencia});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['tipo'] = Variable<String>(
          $ConfiguracoesNotificacaoTable.$convertertipo.toSql(tipo));
    }
    map['ativa'] = Variable<bool>(ativa);
    if (!nullToAbsent || hora != null) {
      map['hora'] = Variable<int>(hora);
    }
    map['antecedencia_minutos'] = Variable<int>(antecedenciaMinutos);
    if (!nullToAbsent || diaReferencia != null) {
      map['dia_referencia'] = Variable<int>(diaReferencia);
    }
    return map;
  }

  ConfiguracoesNotificacaoCompanion toCompanion(bool nullToAbsent) {
    return ConfiguracoesNotificacaoCompanion(
      id: Value(id),
      tipo: Value(tipo),
      ativa: Value(ativa),
      hora: hora == null && nullToAbsent ? const Value.absent() : Value(hora),
      antecedenciaMinutos: Value(antecedenciaMinutos),
      diaReferencia: diaReferencia == null && nullToAbsent
          ? const Value.absent()
          : Value(diaReferencia),
    );
  }

  factory ConfiguracaoNotificacaoLinha.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfiguracaoNotificacaoLinha(
      id: serializer.fromJson<int>(json['id']),
      tipo: serializer.fromJson<TipoNotificacao>(json['tipo']),
      ativa: serializer.fromJson<bool>(json['ativa']),
      hora: serializer.fromJson<int?>(json['hora']),
      antecedenciaMinutos:
          serializer.fromJson<int>(json['antecedenciaMinutos']),
      diaReferencia: serializer.fromJson<int?>(json['diaReferencia']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tipo': serializer.toJson<TipoNotificacao>(tipo),
      'ativa': serializer.toJson<bool>(ativa),
      'hora': serializer.toJson<int?>(hora),
      'antecedenciaMinutos': serializer.toJson<int>(antecedenciaMinutos),
      'diaReferencia': serializer.toJson<int?>(diaReferencia),
    };
  }

  ConfiguracaoNotificacaoLinha copyWith(
          {int? id,
          TipoNotificacao? tipo,
          bool? ativa,
          Value<int?> hora = const Value.absent(),
          int? antecedenciaMinutos,
          Value<int?> diaReferencia = const Value.absent()}) =>
      ConfiguracaoNotificacaoLinha(
        id: id ?? this.id,
        tipo: tipo ?? this.tipo,
        ativa: ativa ?? this.ativa,
        hora: hora.present ? hora.value : this.hora,
        antecedenciaMinutos: antecedenciaMinutos ?? this.antecedenciaMinutos,
        diaReferencia:
            diaReferencia.present ? diaReferencia.value : this.diaReferencia,
      );
  ConfiguracaoNotificacaoLinha copyWithCompanion(
      ConfiguracoesNotificacaoCompanion data) {
    return ConfiguracaoNotificacaoLinha(
      id: data.id.present ? data.id.value : this.id,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      ativa: data.ativa.present ? data.ativa.value : this.ativa,
      hora: data.hora.present ? data.hora.value : this.hora,
      antecedenciaMinutos: data.antecedenciaMinutos.present
          ? data.antecedenciaMinutos.value
          : this.antecedenciaMinutos,
      diaReferencia: data.diaReferencia.present
          ? data.diaReferencia.value
          : this.diaReferencia,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracaoNotificacaoLinha(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('ativa: $ativa, ')
          ..write('hora: $hora, ')
          ..write('antecedenciaMinutos: $antecedenciaMinutos, ')
          ..write('diaReferencia: $diaReferencia')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tipo, ativa, hora, antecedenciaMinutos, diaReferencia);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfiguracaoNotificacaoLinha &&
          other.id == this.id &&
          other.tipo == this.tipo &&
          other.ativa == this.ativa &&
          other.hora == this.hora &&
          other.antecedenciaMinutos == this.antecedenciaMinutos &&
          other.diaReferencia == this.diaReferencia);
}

class ConfiguracoesNotificacaoCompanion
    extends UpdateCompanion<ConfiguracaoNotificacaoLinha> {
  final Value<int> id;
  final Value<TipoNotificacao> tipo;
  final Value<bool> ativa;
  final Value<int?> hora;
  final Value<int> antecedenciaMinutos;
  final Value<int?> diaReferencia;
  const ConfiguracoesNotificacaoCompanion({
    this.id = const Value.absent(),
    this.tipo = const Value.absent(),
    this.ativa = const Value.absent(),
    this.hora = const Value.absent(),
    this.antecedenciaMinutos = const Value.absent(),
    this.diaReferencia = const Value.absent(),
  });
  ConfiguracoesNotificacaoCompanion.insert({
    this.id = const Value.absent(),
    required TipoNotificacao tipo,
    this.ativa = const Value.absent(),
    this.hora = const Value.absent(),
    this.antecedenciaMinutos = const Value.absent(),
    this.diaReferencia = const Value.absent(),
  }) : tipo = Value(tipo);
  static Insertable<ConfiguracaoNotificacaoLinha> custom({
    Expression<int>? id,
    Expression<String>? tipo,
    Expression<bool>? ativa,
    Expression<int>? hora,
    Expression<int>? antecedenciaMinutos,
    Expression<int>? diaReferencia,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipo != null) 'tipo': tipo,
      if (ativa != null) 'ativa': ativa,
      if (hora != null) 'hora': hora,
      if (antecedenciaMinutos != null)
        'antecedencia_minutos': antecedenciaMinutos,
      if (diaReferencia != null) 'dia_referencia': diaReferencia,
    });
  }

  ConfiguracoesNotificacaoCompanion copyWith(
      {Value<int>? id,
      Value<TipoNotificacao>? tipo,
      Value<bool>? ativa,
      Value<int?>? hora,
      Value<int>? antecedenciaMinutos,
      Value<int?>? diaReferencia}) {
    return ConfiguracoesNotificacaoCompanion(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      ativa: ativa ?? this.ativa,
      hora: hora ?? this.hora,
      antecedenciaMinutos: antecedenciaMinutos ?? this.antecedenciaMinutos,
      diaReferencia: diaReferencia ?? this.diaReferencia,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(
          $ConfiguracoesNotificacaoTable.$convertertipo.toSql(tipo.value));
    }
    if (ativa.present) {
      map['ativa'] = Variable<bool>(ativa.value);
    }
    if (hora.present) {
      map['hora'] = Variable<int>(hora.value);
    }
    if (antecedenciaMinutos.present) {
      map['antecedencia_minutos'] = Variable<int>(antecedenciaMinutos.value);
    }
    if (diaReferencia.present) {
      map['dia_referencia'] = Variable<int>(diaReferencia.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracoesNotificacaoCompanion(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('ativa: $ativa, ')
          ..write('hora: $hora, ')
          ..write('antecedenciaMinutos: $antecedenciaMinutos, ')
          ..write('diaReferencia: $diaReferencia')
          ..write(')'))
        .toString();
  }
}

abstract class _$BancoLocal extends GeneratedDatabase {
  _$BancoLocal(QueryExecutor e) : super(e);
  $BancoLocalManager get managers => $BancoLocalManager(this);
  late final $PerfisUsuarioTable perfisUsuario = $PerfisUsuarioTable(this);
  late final $PreferenciasAppTable preferenciasApp =
      $PreferenciasAppTable(this);
  late final $ConfiguracoesJornadaTable configuracoesJornada =
      $ConfiguracoesJornadaTable(this);
  late final $JornadasDiaSemanaTable jornadasDiaSemana =
      $JornadasDiaSemanaTable(this);
  late final $TurnosPrevistosTable turnosPrevistos =
      $TurnosPrevistosTable(this);
  late final $DiasTrabalhoTable diasTrabalho = $DiasTrabalhoTable(this);
  late final $MarcacoesTable marcacoes = $MarcacoesTable(this);
  late final $FeriadosTable feriados = $FeriadosTable(this);
  late final $ModelosPlanilhaTable modelosPlanilha =
      $ModelosPlanilhaTable(this);
  late final $MapeamentosColunaTable mapeamentosColuna =
      $MapeamentosColunaTable(this);
  late final $CelulasFixasTable celulasFixas = $CelulasFixasTable(this);
  late final $TextosStatusTable textosStatus = $TextosStatusTable(this);
  late final $ConfiguracoesEmailTable configuracoesEmail =
      $ConfiguracoesEmailTable(this);
  late final $EnviosMensaisTable enviosMensais = $EnviosMensaisTable(this);
  late final $ConfiguracoesNotificacaoTable configuracoesNotificacao =
      $ConfiguracoesNotificacaoTable(this);
  late final Index idxMarcacaoDiaOrdem = Index('idx_marcacao_dia_ordem',
      'CREATE INDEX idx_marcacao_dia_ordem ON marcacao (dia_id, ordem)');
  late final Index idxFeriadoData = Index(
      'idx_feriado_data', 'CREATE INDEX idx_feriado_data ON feriado (data)');
  late final Index idxEnvioCompetencia = Index('idx_envio_competencia',
      'CREATE INDEX idx_envio_competencia ON envio_mensal (competencia_ano, competencia_mes)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        perfisUsuario,
        preferenciasApp,
        configuracoesJornada,
        jornadasDiaSemana,
        turnosPrevistos,
        diasTrabalho,
        marcacoes,
        feriados,
        modelosPlanilha,
        mapeamentosColuna,
        celulasFixas,
        textosStatus,
        configuracoesEmail,
        enviosMensais,
        configuracoesNotificacao,
        idxMarcacaoDiaOrdem,
        idxFeriadoData,
        idxEnvioCompetencia
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('configuracao_jornada',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('jornada_dia_semana', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('jornada_dia_semana',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('turno_previsto', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('dia_trabalho',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('marcacao', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('modelo_planilha',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('mapeamento_coluna', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('modelo_planilha',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('celula_fixa', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('modelo_planilha',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('texto_status', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('modelo_planilha',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('envio_mensal', kind: UpdateKind.update),
            ],
          ),
        ],
      );
}

typedef $$PerfisUsuarioTableCreateCompanionBuilder = PerfisUsuarioCompanion
    Function({
  Value<int> id,
  required String nome,
  Value<String?> matricula,
  Value<String?> cargo,
  Value<String?> empresa,
  Value<String?> email,
  Value<DateTime> criadoEm,
  Value<DateTime> atualizadoEm,
});
typedef $$PerfisUsuarioTableUpdateCompanionBuilder = PerfisUsuarioCompanion
    Function({
  Value<int> id,
  Value<String> nome,
  Value<String?> matricula,
  Value<String?> cargo,
  Value<String?> empresa,
  Value<String?> email,
  Value<DateTime> criadoEm,
  Value<DateTime> atualizadoEm,
});

class $$PerfisUsuarioTableFilterComposer
    extends Composer<_$BancoLocal, $PerfisUsuarioTable> {
  $$PerfisUsuarioTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get matricula => $composableBuilder(
      column: $table.matricula, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cargo => $composableBuilder(
      column: $table.cargo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get empresa => $composableBuilder(
      column: $table.empresa, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
      column: $table.atualizadoEm, builder: (column) => ColumnFilters(column));
}

class $$PerfisUsuarioTableOrderingComposer
    extends Composer<_$BancoLocal, $PerfisUsuarioTable> {
  $$PerfisUsuarioTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get matricula => $composableBuilder(
      column: $table.matricula, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cargo => $composableBuilder(
      column: $table.cargo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get empresa => $composableBuilder(
      column: $table.empresa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
      column: $table.atualizadoEm,
      builder: (column) => ColumnOrderings(column));
}

class $$PerfisUsuarioTableAnnotationComposer
    extends Composer<_$BancoLocal, $PerfisUsuarioTable> {
  $$PerfisUsuarioTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get matricula =>
      $composableBuilder(column: $table.matricula, builder: (column) => column);

  GeneratedColumn<String> get cargo =>
      $composableBuilder(column: $table.cargo, builder: (column) => column);

  GeneratedColumn<String> get empresa =>
      $composableBuilder(column: $table.empresa, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
      column: $table.atualizadoEm, builder: (column) => column);
}

class $$PerfisUsuarioTableTableManager extends RootTableManager<
    _$BancoLocal,
    $PerfisUsuarioTable,
    PerfilUsuarioLinha,
    $$PerfisUsuarioTableFilterComposer,
    $$PerfisUsuarioTableOrderingComposer,
    $$PerfisUsuarioTableAnnotationComposer,
    $$PerfisUsuarioTableCreateCompanionBuilder,
    $$PerfisUsuarioTableUpdateCompanionBuilder,
    (
      PerfilUsuarioLinha,
      BaseReferences<_$BancoLocal, $PerfisUsuarioTable, PerfilUsuarioLinha>
    ),
    PerfilUsuarioLinha,
    PrefetchHooks Function()> {
  $$PerfisUsuarioTableTableManager(_$BancoLocal db, $PerfisUsuarioTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PerfisUsuarioTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PerfisUsuarioTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PerfisUsuarioTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String?> matricula = const Value.absent(),
            Value<String?> cargo = const Value.absent(),
            Value<String?> empresa = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<DateTime> criadoEm = const Value.absent(),
            Value<DateTime> atualizadoEm = const Value.absent(),
          }) =>
              PerfisUsuarioCompanion(
            id: id,
            nome: nome,
            matricula: matricula,
            cargo: cargo,
            empresa: empresa,
            email: email,
            criadoEm: criadoEm,
            atualizadoEm: atualizadoEm,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nome,
            Value<String?> matricula = const Value.absent(),
            Value<String?> cargo = const Value.absent(),
            Value<String?> empresa = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<DateTime> criadoEm = const Value.absent(),
            Value<DateTime> atualizadoEm = const Value.absent(),
          }) =>
              PerfisUsuarioCompanion.insert(
            id: id,
            nome: nome,
            matricula: matricula,
            cargo: cargo,
            empresa: empresa,
            email: email,
            criadoEm: criadoEm,
            atualizadoEm: atualizadoEm,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PerfisUsuarioTableProcessedTableManager = ProcessedTableManager<
    _$BancoLocal,
    $PerfisUsuarioTable,
    PerfilUsuarioLinha,
    $$PerfisUsuarioTableFilterComposer,
    $$PerfisUsuarioTableOrderingComposer,
    $$PerfisUsuarioTableAnnotationComposer,
    $$PerfisUsuarioTableCreateCompanionBuilder,
    $$PerfisUsuarioTableUpdateCompanionBuilder,
    (
      PerfilUsuarioLinha,
      BaseReferences<_$BancoLocal, $PerfisUsuarioTable, PerfilUsuarioLinha>
    ),
    PerfilUsuarioLinha,
    PrefetchHooks Function()>;
typedef $$PreferenciasAppTableCreateCompanionBuilder = PreferenciasAppCompanion
    Function({
  required String chave,
  required String valor,
  Value<int> rowid,
});
typedef $$PreferenciasAppTableUpdateCompanionBuilder = PreferenciasAppCompanion
    Function({
  Value<String> chave,
  Value<String> valor,
  Value<int> rowid,
});

class $$PreferenciasAppTableFilterComposer
    extends Composer<_$BancoLocal, $PreferenciasAppTable> {
  $$PreferenciasAppTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get chave => $composableBuilder(
      column: $table.chave, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get valor => $composableBuilder(
      column: $table.valor, builder: (column) => ColumnFilters(column));
}

class $$PreferenciasAppTableOrderingComposer
    extends Composer<_$BancoLocal, $PreferenciasAppTable> {
  $$PreferenciasAppTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get chave => $composableBuilder(
      column: $table.chave, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get valor => $composableBuilder(
      column: $table.valor, builder: (column) => ColumnOrderings(column));
}

class $$PreferenciasAppTableAnnotationComposer
    extends Composer<_$BancoLocal, $PreferenciasAppTable> {
  $$PreferenciasAppTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get chave =>
      $composableBuilder(column: $table.chave, builder: (column) => column);

  GeneratedColumn<String> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);
}

class $$PreferenciasAppTableTableManager extends RootTableManager<
    _$BancoLocal,
    $PreferenciasAppTable,
    PreferenciaAppLinha,
    $$PreferenciasAppTableFilterComposer,
    $$PreferenciasAppTableOrderingComposer,
    $$PreferenciasAppTableAnnotationComposer,
    $$PreferenciasAppTableCreateCompanionBuilder,
    $$PreferenciasAppTableUpdateCompanionBuilder,
    (
      PreferenciaAppLinha,
      BaseReferences<_$BancoLocal, $PreferenciasAppTable, PreferenciaAppLinha>
    ),
    PreferenciaAppLinha,
    PrefetchHooks Function()> {
  $$PreferenciasAppTableTableManager(
      _$BancoLocal db, $PreferenciasAppTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferenciasAppTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferenciasAppTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferenciasAppTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> chave = const Value.absent(),
            Value<String> valor = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PreferenciasAppCompanion(
            chave: chave,
            valor: valor,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String chave,
            required String valor,
            Value<int> rowid = const Value.absent(),
          }) =>
              PreferenciasAppCompanion.insert(
            chave: chave,
            valor: valor,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PreferenciasAppTableProcessedTableManager = ProcessedTableManager<
    _$BancoLocal,
    $PreferenciasAppTable,
    PreferenciaAppLinha,
    $$PreferenciasAppTableFilterComposer,
    $$PreferenciasAppTableOrderingComposer,
    $$PreferenciasAppTableAnnotationComposer,
    $$PreferenciasAppTableCreateCompanionBuilder,
    $$PreferenciasAppTableUpdateCompanionBuilder,
    (
      PreferenciaAppLinha,
      BaseReferences<_$BancoLocal, $PreferenciasAppTable, PreferenciaAppLinha>
    ),
    PreferenciaAppLinha,
    PrefetchHooks Function()>;
typedef $$ConfiguracoesJornadaTableCreateCompanionBuilder
    = ConfiguracoesJornadaCompanion Function({
  Value<int> id,
  Value<String> nome,
  Value<bool> ativa,
  Value<int> toleranciaMinutos,
  Value<bool> permiteViradaDia,
  Value<DateTime?> dataInicioBanco,
  Value<DateTime> criadoEm,
});
typedef $$ConfiguracoesJornadaTableUpdateCompanionBuilder
    = ConfiguracoesJornadaCompanion Function({
  Value<int> id,
  Value<String> nome,
  Value<bool> ativa,
  Value<int> toleranciaMinutos,
  Value<bool> permiteViradaDia,
  Value<DateTime?> dataInicioBanco,
  Value<DateTime> criadoEm,
});

final class $$ConfiguracoesJornadaTableReferences extends BaseReferences<
    _$BancoLocal, $ConfiguracoesJornadaTable, ConfiguracaoJornadaLinha> {
  $$ConfiguracoesJornadaTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$JornadasDiaSemanaTable,
      List<JornadaDiaSemanaLinha>> _jornadasDiaSemanaRefsTable(
          _$BancoLocal db) =>
      MultiTypedResultKey.fromTable(db.jornadasDiaSemana,
          aliasName: $_aliasNameGenerator(
              db.configuracoesJornada.id, db.jornadasDiaSemana.configuracaoId));

  $$JornadasDiaSemanaTableProcessedTableManager get jornadasDiaSemanaRefs {
    final manager =
        $$JornadasDiaSemanaTableTableManager($_db, $_db.jornadasDiaSemana)
            .filter((f) => f.configuracaoId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_jornadasDiaSemanaRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ConfiguracoesJornadaTableFilterComposer
    extends Composer<_$BancoLocal, $ConfiguracoesJornadaTable> {
  $$ConfiguracoesJornadaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get ativa => $composableBuilder(
      column: $table.ativa, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get toleranciaMinutos => $composableBuilder(
      column: $table.toleranciaMinutos,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get permiteViradaDia => $composableBuilder(
      column: $table.permiteViradaDia,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime?, DateTime, String>
      get dataInicioBanco => $composableBuilder(
          column: $table.dataInicioBanco,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnFilters(column));

  Expression<bool> jornadasDiaSemanaRefs(
      Expression<bool> Function($$JornadasDiaSemanaTableFilterComposer f) f) {
    final $$JornadasDiaSemanaTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.jornadasDiaSemana,
        getReferencedColumn: (t) => t.configuracaoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JornadasDiaSemanaTableFilterComposer(
              $db: $db,
              $table: $db.jornadasDiaSemana,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ConfiguracoesJornadaTableOrderingComposer
    extends Composer<_$BancoLocal, $ConfiguracoesJornadaTable> {
  $$ConfiguracoesJornadaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get ativa => $composableBuilder(
      column: $table.ativa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get toleranciaMinutos => $composableBuilder(
      column: $table.toleranciaMinutos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get permiteViradaDia => $composableBuilder(
      column: $table.permiteViradaDia,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dataInicioBanco => $composableBuilder(
      column: $table.dataInicioBanco,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnOrderings(column));
}

class $$ConfiguracoesJornadaTableAnnotationComposer
    extends Composer<_$BancoLocal, $ConfiguracoesJornadaTable> {
  $$ConfiguracoesJornadaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<bool> get ativa =>
      $composableBuilder(column: $table.ativa, builder: (column) => column);

  GeneratedColumn<int> get toleranciaMinutos => $composableBuilder(
      column: $table.toleranciaMinutos, builder: (column) => column);

  GeneratedColumn<bool> get permiteViradaDia => $composableBuilder(
      column: $table.permiteViradaDia, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, String> get dataInicioBanco =>
      $composableBuilder(
          column: $table.dataInicioBanco, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  Expression<T> jornadasDiaSemanaRefs<T extends Object>(
      Expression<T> Function($$JornadasDiaSemanaTableAnnotationComposer a) f) {
    final $$JornadasDiaSemanaTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.jornadasDiaSemana,
            getReferencedColumn: (t) => t.configuracaoId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$JornadasDiaSemanaTableAnnotationComposer(
                  $db: $db,
                  $table: $db.jornadasDiaSemana,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ConfiguracoesJornadaTableTableManager extends RootTableManager<
    _$BancoLocal,
    $ConfiguracoesJornadaTable,
    ConfiguracaoJornadaLinha,
    $$ConfiguracoesJornadaTableFilterComposer,
    $$ConfiguracoesJornadaTableOrderingComposer,
    $$ConfiguracoesJornadaTableAnnotationComposer,
    $$ConfiguracoesJornadaTableCreateCompanionBuilder,
    $$ConfiguracoesJornadaTableUpdateCompanionBuilder,
    (ConfiguracaoJornadaLinha, $$ConfiguracoesJornadaTableReferences),
    ConfiguracaoJornadaLinha,
    PrefetchHooks Function({bool jornadasDiaSemanaRefs})> {
  $$ConfiguracoesJornadaTableTableManager(
      _$BancoLocal db, $ConfiguracoesJornadaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfiguracoesJornadaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConfiguracoesJornadaTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConfiguracoesJornadaTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<bool> ativa = const Value.absent(),
            Value<int> toleranciaMinutos = const Value.absent(),
            Value<bool> permiteViradaDia = const Value.absent(),
            Value<DateTime?> dataInicioBanco = const Value.absent(),
            Value<DateTime> criadoEm = const Value.absent(),
          }) =>
              ConfiguracoesJornadaCompanion(
            id: id,
            nome: nome,
            ativa: ativa,
            toleranciaMinutos: toleranciaMinutos,
            permiteViradaDia: permiteViradaDia,
            dataInicioBanco: dataInicioBanco,
            criadoEm: criadoEm,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<bool> ativa = const Value.absent(),
            Value<int> toleranciaMinutos = const Value.absent(),
            Value<bool> permiteViradaDia = const Value.absent(),
            Value<DateTime?> dataInicioBanco = const Value.absent(),
            Value<DateTime> criadoEm = const Value.absent(),
          }) =>
              ConfiguracoesJornadaCompanion.insert(
            id: id,
            nome: nome,
            ativa: ativa,
            toleranciaMinutos: toleranciaMinutos,
            permiteViradaDia: permiteViradaDia,
            dataInicioBanco: dataInicioBanco,
            criadoEm: criadoEm,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ConfiguracoesJornadaTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({jornadasDiaSemanaRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (jornadasDiaSemanaRefs) db.jornadasDiaSemana
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (jornadasDiaSemanaRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$ConfiguracoesJornadaTableReferences
                            ._jornadasDiaSemanaRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ConfiguracoesJornadaTableReferences(db, table, p0)
                                .jornadasDiaSemanaRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.configuracaoId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ConfiguracoesJornadaTableProcessedTableManager
    = ProcessedTableManager<
        _$BancoLocal,
        $ConfiguracoesJornadaTable,
        ConfiguracaoJornadaLinha,
        $$ConfiguracoesJornadaTableFilterComposer,
        $$ConfiguracoesJornadaTableOrderingComposer,
        $$ConfiguracoesJornadaTableAnnotationComposer,
        $$ConfiguracoesJornadaTableCreateCompanionBuilder,
        $$ConfiguracoesJornadaTableUpdateCompanionBuilder,
        (ConfiguracaoJornadaLinha, $$ConfiguracoesJornadaTableReferences),
        ConfiguracaoJornadaLinha,
        PrefetchHooks Function({bool jornadasDiaSemanaRefs})>;
typedef $$JornadasDiaSemanaTableCreateCompanionBuilder
    = JornadasDiaSemanaCompanion Function({
  Value<int> id,
  required int configuracaoId,
  required int diaSemana,
  required bool trabalha,
  required int cargaMinutos,
  Value<bool> cargaManual,
});
typedef $$JornadasDiaSemanaTableUpdateCompanionBuilder
    = JornadasDiaSemanaCompanion Function({
  Value<int> id,
  Value<int> configuracaoId,
  Value<int> diaSemana,
  Value<bool> trabalha,
  Value<int> cargaMinutos,
  Value<bool> cargaManual,
});

final class $$JornadasDiaSemanaTableReferences extends BaseReferences<
    _$BancoLocal, $JornadasDiaSemanaTable, JornadaDiaSemanaLinha> {
  $$JornadasDiaSemanaTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ConfiguracoesJornadaTable _configuracaoIdTable(_$BancoLocal db) =>
      db.configuracoesJornada.createAlias($_aliasNameGenerator(
          db.jornadasDiaSemana.configuracaoId, db.configuracoesJornada.id));

  $$ConfiguracoesJornadaTableProcessedTableManager get configuracaoId {
    final manager =
        $$ConfiguracoesJornadaTableTableManager($_db, $_db.configuracoesJornada)
            .filter((f) => f.id($_item.configuracaoId));
    final item = $_typedResult.readTableOrNull(_configuracaoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TurnosPrevistosTable, List<TurnoPrevistoLinha>>
      _turnosPrevistosRefsTable(_$BancoLocal db) =>
          MultiTypedResultKey.fromTable(db.turnosPrevistos,
              aliasName: $_aliasNameGenerator(
                  db.jornadasDiaSemana.id, db.turnosPrevistos.jornadaDiaId));

  $$TurnosPrevistosTableProcessedTableManager get turnosPrevistosRefs {
    final manager =
        $$TurnosPrevistosTableTableManager($_db, $_db.turnosPrevistos)
            .filter((f) => f.jornadaDiaId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_turnosPrevistosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$JornadasDiaSemanaTableFilterComposer
    extends Composer<_$BancoLocal, $JornadasDiaSemanaTable> {
  $$JornadasDiaSemanaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get diaSemana => $composableBuilder(
      column: $table.diaSemana, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get trabalha => $composableBuilder(
      column: $table.trabalha, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cargaMinutos => $composableBuilder(
      column: $table.cargaMinutos, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get cargaManual => $composableBuilder(
      column: $table.cargaManual, builder: (column) => ColumnFilters(column));

  $$ConfiguracoesJornadaTableFilterComposer get configuracaoId {
    final $$ConfiguracoesJornadaTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.configuracaoId,
        referencedTable: $db.configuracoesJornada,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConfiguracoesJornadaTableFilterComposer(
              $db: $db,
              $table: $db.configuracoesJornada,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> turnosPrevistosRefs(
      Expression<bool> Function($$TurnosPrevistosTableFilterComposer f) f) {
    final $$TurnosPrevistosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.turnosPrevistos,
        getReferencedColumn: (t) => t.jornadaDiaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TurnosPrevistosTableFilterComposer(
              $db: $db,
              $table: $db.turnosPrevistos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$JornadasDiaSemanaTableOrderingComposer
    extends Composer<_$BancoLocal, $JornadasDiaSemanaTable> {
  $$JornadasDiaSemanaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get diaSemana => $composableBuilder(
      column: $table.diaSemana, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get trabalha => $composableBuilder(
      column: $table.trabalha, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cargaMinutos => $composableBuilder(
      column: $table.cargaMinutos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get cargaManual => $composableBuilder(
      column: $table.cargaManual, builder: (column) => ColumnOrderings(column));

  $$ConfiguracoesJornadaTableOrderingComposer get configuracaoId {
    final $$ConfiguracoesJornadaTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.configuracaoId,
            referencedTable: $db.configuracoesJornada,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ConfiguracoesJornadaTableOrderingComposer(
                  $db: $db,
                  $table: $db.configuracoesJornada,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$JornadasDiaSemanaTableAnnotationComposer
    extends Composer<_$BancoLocal, $JornadasDiaSemanaTable> {
  $$JornadasDiaSemanaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get diaSemana =>
      $composableBuilder(column: $table.diaSemana, builder: (column) => column);

  GeneratedColumn<bool> get trabalha =>
      $composableBuilder(column: $table.trabalha, builder: (column) => column);

  GeneratedColumn<int> get cargaMinutos => $composableBuilder(
      column: $table.cargaMinutos, builder: (column) => column);

  GeneratedColumn<bool> get cargaManual => $composableBuilder(
      column: $table.cargaManual, builder: (column) => column);

  $$ConfiguracoesJornadaTableAnnotationComposer get configuracaoId {
    final $$ConfiguracoesJornadaTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.configuracaoId,
            referencedTable: $db.configuracoesJornada,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ConfiguracoesJornadaTableAnnotationComposer(
                  $db: $db,
                  $table: $db.configuracoesJornada,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  Expression<T> turnosPrevistosRefs<T extends Object>(
      Expression<T> Function($$TurnosPrevistosTableAnnotationComposer a) f) {
    final $$TurnosPrevistosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.turnosPrevistos,
        getReferencedColumn: (t) => t.jornadaDiaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TurnosPrevistosTableAnnotationComposer(
              $db: $db,
              $table: $db.turnosPrevistos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$JornadasDiaSemanaTableTableManager extends RootTableManager<
    _$BancoLocal,
    $JornadasDiaSemanaTable,
    JornadaDiaSemanaLinha,
    $$JornadasDiaSemanaTableFilterComposer,
    $$JornadasDiaSemanaTableOrderingComposer,
    $$JornadasDiaSemanaTableAnnotationComposer,
    $$JornadasDiaSemanaTableCreateCompanionBuilder,
    $$JornadasDiaSemanaTableUpdateCompanionBuilder,
    (JornadaDiaSemanaLinha, $$JornadasDiaSemanaTableReferences),
    JornadaDiaSemanaLinha,
    PrefetchHooks Function({bool configuracaoId, bool turnosPrevistosRefs})> {
  $$JornadasDiaSemanaTableTableManager(
      _$BancoLocal db, $JornadasDiaSemanaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JornadasDiaSemanaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JornadasDiaSemanaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JornadasDiaSemanaTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> configuracaoId = const Value.absent(),
            Value<int> diaSemana = const Value.absent(),
            Value<bool> trabalha = const Value.absent(),
            Value<int> cargaMinutos = const Value.absent(),
            Value<bool> cargaManual = const Value.absent(),
          }) =>
              JornadasDiaSemanaCompanion(
            id: id,
            configuracaoId: configuracaoId,
            diaSemana: diaSemana,
            trabalha: trabalha,
            cargaMinutos: cargaMinutos,
            cargaManual: cargaManual,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int configuracaoId,
            required int diaSemana,
            required bool trabalha,
            required int cargaMinutos,
            Value<bool> cargaManual = const Value.absent(),
          }) =>
              JornadasDiaSemanaCompanion.insert(
            id: id,
            configuracaoId: configuracaoId,
            diaSemana: diaSemana,
            trabalha: trabalha,
            cargaMinutos: cargaMinutos,
            cargaManual: cargaManual,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$JornadasDiaSemanaTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {configuracaoId = false, turnosPrevistosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (turnosPrevistosRefs) db.turnosPrevistos
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (configuracaoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.configuracaoId,
                    referencedTable: $$JornadasDiaSemanaTableReferences
                        ._configuracaoIdTable(db),
                    referencedColumn: $$JornadasDiaSemanaTableReferences
                        ._configuracaoIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (turnosPrevistosRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$JornadasDiaSemanaTableReferences
                            ._turnosPrevistosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$JornadasDiaSemanaTableReferences(db, table, p0)
                                .turnosPrevistosRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.jornadaDiaId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$JornadasDiaSemanaTableProcessedTableManager = ProcessedTableManager<
    _$BancoLocal,
    $JornadasDiaSemanaTable,
    JornadaDiaSemanaLinha,
    $$JornadasDiaSemanaTableFilterComposer,
    $$JornadasDiaSemanaTableOrderingComposer,
    $$JornadasDiaSemanaTableAnnotationComposer,
    $$JornadasDiaSemanaTableCreateCompanionBuilder,
    $$JornadasDiaSemanaTableUpdateCompanionBuilder,
    (JornadaDiaSemanaLinha, $$JornadasDiaSemanaTableReferences),
    JornadaDiaSemanaLinha,
    PrefetchHooks Function({bool configuracaoId, bool turnosPrevistosRefs})>;
typedef $$TurnosPrevistosTableCreateCompanionBuilder = TurnosPrevistosCompanion
    Function({
  Value<int> id,
  required int jornadaDiaId,
  required int ordem,
  required Duration horaEntrada,
  required Duration horaSaida,
});
typedef $$TurnosPrevistosTableUpdateCompanionBuilder = TurnosPrevistosCompanion
    Function({
  Value<int> id,
  Value<int> jornadaDiaId,
  Value<int> ordem,
  Value<Duration> horaEntrada,
  Value<Duration> horaSaida,
});

final class $$TurnosPrevistosTableReferences extends BaseReferences<
    _$BancoLocal, $TurnosPrevistosTable, TurnoPrevistoLinha> {
  $$TurnosPrevistosTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $JornadasDiaSemanaTable _jornadaDiaIdTable(_$BancoLocal db) =>
      db.jornadasDiaSemana.createAlias($_aliasNameGenerator(
          db.turnosPrevistos.jornadaDiaId, db.jornadasDiaSemana.id));

  $$JornadasDiaSemanaTableProcessedTableManager get jornadaDiaId {
    final manager =
        $$JornadasDiaSemanaTableTableManager($_db, $_db.jornadasDiaSemana)
            .filter((f) => f.id($_item.jornadaDiaId));
    final item = $_typedResult.readTableOrNull(_jornadaDiaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TurnosPrevistosTableFilterComposer
    extends Composer<_$BancoLocal, $TurnosPrevistosTable> {
  $$TurnosPrevistosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ordem => $composableBuilder(
      column: $table.ordem, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Duration, Duration, int> get horaEntrada =>
      $composableBuilder(
          column: $table.horaEntrada,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Duration, Duration, int> get horaSaida =>
      $composableBuilder(
          column: $table.horaSaida,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$JornadasDiaSemanaTableFilterComposer get jornadaDiaId {
    final $$JornadasDiaSemanaTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.jornadaDiaId,
        referencedTable: $db.jornadasDiaSemana,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JornadasDiaSemanaTableFilterComposer(
              $db: $db,
              $table: $db.jornadasDiaSemana,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TurnosPrevistosTableOrderingComposer
    extends Composer<_$BancoLocal, $TurnosPrevistosTable> {
  $$TurnosPrevistosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ordem => $composableBuilder(
      column: $table.ordem, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get horaEntrada => $composableBuilder(
      column: $table.horaEntrada, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get horaSaida => $composableBuilder(
      column: $table.horaSaida, builder: (column) => ColumnOrderings(column));

  $$JornadasDiaSemanaTableOrderingComposer get jornadaDiaId {
    final $$JornadasDiaSemanaTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.jornadaDiaId,
        referencedTable: $db.jornadasDiaSemana,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JornadasDiaSemanaTableOrderingComposer(
              $db: $db,
              $table: $db.jornadasDiaSemana,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TurnosPrevistosTableAnnotationComposer
    extends Composer<_$BancoLocal, $TurnosPrevistosTable> {
  $$TurnosPrevistosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get ordem =>
      $composableBuilder(column: $table.ordem, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Duration, int> get horaEntrada =>
      $composableBuilder(
          column: $table.horaEntrada, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Duration, int> get horaSaida =>
      $composableBuilder(column: $table.horaSaida, builder: (column) => column);

  $$JornadasDiaSemanaTableAnnotationComposer get jornadaDiaId {
    final $$JornadasDiaSemanaTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.jornadaDiaId,
            referencedTable: $db.jornadasDiaSemana,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$JornadasDiaSemanaTableAnnotationComposer(
                  $db: $db,
                  $table: $db.jornadasDiaSemana,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$TurnosPrevistosTableTableManager extends RootTableManager<
    _$BancoLocal,
    $TurnosPrevistosTable,
    TurnoPrevistoLinha,
    $$TurnosPrevistosTableFilterComposer,
    $$TurnosPrevistosTableOrderingComposer,
    $$TurnosPrevistosTableAnnotationComposer,
    $$TurnosPrevistosTableCreateCompanionBuilder,
    $$TurnosPrevistosTableUpdateCompanionBuilder,
    (TurnoPrevistoLinha, $$TurnosPrevistosTableReferences),
    TurnoPrevistoLinha,
    PrefetchHooks Function({bool jornadaDiaId})> {
  $$TurnosPrevistosTableTableManager(
      _$BancoLocal db, $TurnosPrevistosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TurnosPrevistosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TurnosPrevistosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TurnosPrevistosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> jornadaDiaId = const Value.absent(),
            Value<int> ordem = const Value.absent(),
            Value<Duration> horaEntrada = const Value.absent(),
            Value<Duration> horaSaida = const Value.absent(),
          }) =>
              TurnosPrevistosCompanion(
            id: id,
            jornadaDiaId: jornadaDiaId,
            ordem: ordem,
            horaEntrada: horaEntrada,
            horaSaida: horaSaida,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int jornadaDiaId,
            required int ordem,
            required Duration horaEntrada,
            required Duration horaSaida,
          }) =>
              TurnosPrevistosCompanion.insert(
            id: id,
            jornadaDiaId: jornadaDiaId,
            ordem: ordem,
            horaEntrada: horaEntrada,
            horaSaida: horaSaida,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TurnosPrevistosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({jornadaDiaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (jornadaDiaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.jornadaDiaId,
                    referencedTable:
                        $$TurnosPrevistosTableReferences._jornadaDiaIdTable(db),
                    referencedColumn: $$TurnosPrevistosTableReferences
                        ._jornadaDiaIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TurnosPrevistosTableProcessedTableManager = ProcessedTableManager<
    _$BancoLocal,
    $TurnosPrevistosTable,
    TurnoPrevistoLinha,
    $$TurnosPrevistosTableFilterComposer,
    $$TurnosPrevistosTableOrderingComposer,
    $$TurnosPrevistosTableAnnotationComposer,
    $$TurnosPrevistosTableCreateCompanionBuilder,
    $$TurnosPrevistosTableUpdateCompanionBuilder,
    (TurnoPrevistoLinha, $$TurnosPrevistosTableReferences),
    TurnoPrevistoLinha,
    PrefetchHooks Function({bool jornadaDiaId})>;
typedef $$DiasTrabalhoTableCreateCompanionBuilder = DiasTrabalhoCompanion
    Function({
  Value<int> id,
  required DateTime data,
  Value<StatusDia> status,
  Value<bool> statusManual,
  Value<String?> observacao,
  Value<int> cargaPrevistaMinutos,
  Value<int> minutosTrabalhados,
  Value<int> saldoMinutos,
  Value<bool> inconsistente,
  Value<bool> fechado,
  Value<DateTime> atualizadoEm,
});
typedef $$DiasTrabalhoTableUpdateCompanionBuilder = DiasTrabalhoCompanion
    Function({
  Value<int> id,
  Value<DateTime> data,
  Value<StatusDia> status,
  Value<bool> statusManual,
  Value<String?> observacao,
  Value<int> cargaPrevistaMinutos,
  Value<int> minutosTrabalhados,
  Value<int> saldoMinutos,
  Value<bool> inconsistente,
  Value<bool> fechado,
  Value<DateTime> atualizadoEm,
});

final class $$DiasTrabalhoTableReferences
    extends BaseReferences<_$BancoLocal, $DiasTrabalhoTable, DiaTrabalhoLinha> {
  $$DiasTrabalhoTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MarcacoesTable, List<MarcacaoLinha>>
      _marcacoesRefsTable(_$BancoLocal db) =>
          MultiTypedResultKey.fromTable(db.marcacoes,
              aliasName:
                  $_aliasNameGenerator(db.diasTrabalho.id, db.marcacoes.diaId));

  $$MarcacoesTableProcessedTableManager get marcacoesRefs {
    final manager = $$MarcacoesTableTableManager($_db, $_db.marcacoes)
        .filter((f) => f.diaId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_marcacoesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DiasTrabalhoTableFilterComposer
    extends Composer<_$BancoLocal, $DiasTrabalhoTable> {
  $$DiasTrabalhoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get data =>
      $composableBuilder(
          column: $table.data,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<StatusDia, StatusDia, String> get status =>
      $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get statusManual => $composableBuilder(
      column: $table.statusManual, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observacao => $composableBuilder(
      column: $table.observacao, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cargaPrevistaMinutos => $composableBuilder(
      column: $table.cargaPrevistaMinutos,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minutosTrabalhados => $composableBuilder(
      column: $table.minutosTrabalhados,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get saldoMinutos => $composableBuilder(
      column: $table.saldoMinutos, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get inconsistente => $composableBuilder(
      column: $table.inconsistente, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get fechado => $composableBuilder(
      column: $table.fechado, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
      column: $table.atualizadoEm, builder: (column) => ColumnFilters(column));

  Expression<bool> marcacoesRefs(
      Expression<bool> Function($$MarcacoesTableFilterComposer f) f) {
    final $$MarcacoesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.marcacoes,
        getReferencedColumn: (t) => t.diaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MarcacoesTableFilterComposer(
              $db: $db,
              $table: $db.marcacoes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DiasTrabalhoTableOrderingComposer
    extends Composer<_$BancoLocal, $DiasTrabalhoTable> {
  $$DiasTrabalhoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get statusManual => $composableBuilder(
      column: $table.statusManual,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observacao => $composableBuilder(
      column: $table.observacao, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cargaPrevistaMinutos => $composableBuilder(
      column: $table.cargaPrevistaMinutos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minutosTrabalhados => $composableBuilder(
      column: $table.minutosTrabalhados,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get saldoMinutos => $composableBuilder(
      column: $table.saldoMinutos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get inconsistente => $composableBuilder(
      column: $table.inconsistente,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get fechado => $composableBuilder(
      column: $table.fechado, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
      column: $table.atualizadoEm,
      builder: (column) => ColumnOrderings(column));
}

class $$DiasTrabalhoTableAnnotationComposer
    extends Composer<_$BancoLocal, $DiasTrabalhoTable> {
  $$DiasTrabalhoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StatusDia, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get statusManual => $composableBuilder(
      column: $table.statusManual, builder: (column) => column);

  GeneratedColumn<String> get observacao => $composableBuilder(
      column: $table.observacao, builder: (column) => column);

  GeneratedColumn<int> get cargaPrevistaMinutos => $composableBuilder(
      column: $table.cargaPrevistaMinutos, builder: (column) => column);

  GeneratedColumn<int> get minutosTrabalhados => $composableBuilder(
      column: $table.minutosTrabalhados, builder: (column) => column);

  GeneratedColumn<int> get saldoMinutos => $composableBuilder(
      column: $table.saldoMinutos, builder: (column) => column);

  GeneratedColumn<bool> get inconsistente => $composableBuilder(
      column: $table.inconsistente, builder: (column) => column);

  GeneratedColumn<bool> get fechado =>
      $composableBuilder(column: $table.fechado, builder: (column) => column);

  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
      column: $table.atualizadoEm, builder: (column) => column);

  Expression<T> marcacoesRefs<T extends Object>(
      Expression<T> Function($$MarcacoesTableAnnotationComposer a) f) {
    final $$MarcacoesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.marcacoes,
        getReferencedColumn: (t) => t.diaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MarcacoesTableAnnotationComposer(
              $db: $db,
              $table: $db.marcacoes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DiasTrabalhoTableTableManager extends RootTableManager<
    _$BancoLocal,
    $DiasTrabalhoTable,
    DiaTrabalhoLinha,
    $$DiasTrabalhoTableFilterComposer,
    $$DiasTrabalhoTableOrderingComposer,
    $$DiasTrabalhoTableAnnotationComposer,
    $$DiasTrabalhoTableCreateCompanionBuilder,
    $$DiasTrabalhoTableUpdateCompanionBuilder,
    (DiaTrabalhoLinha, $$DiasTrabalhoTableReferences),
    DiaTrabalhoLinha,
    PrefetchHooks Function({bool marcacoesRefs})> {
  $$DiasTrabalhoTableTableManager(_$BancoLocal db, $DiasTrabalhoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiasTrabalhoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiasTrabalhoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiasTrabalhoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> data = const Value.absent(),
            Value<StatusDia> status = const Value.absent(),
            Value<bool> statusManual = const Value.absent(),
            Value<String?> observacao = const Value.absent(),
            Value<int> cargaPrevistaMinutos = const Value.absent(),
            Value<int> minutosTrabalhados = const Value.absent(),
            Value<int> saldoMinutos = const Value.absent(),
            Value<bool> inconsistente = const Value.absent(),
            Value<bool> fechado = const Value.absent(),
            Value<DateTime> atualizadoEm = const Value.absent(),
          }) =>
              DiasTrabalhoCompanion(
            id: id,
            data: data,
            status: status,
            statusManual: statusManual,
            observacao: observacao,
            cargaPrevistaMinutos: cargaPrevistaMinutos,
            minutosTrabalhados: minutosTrabalhados,
            saldoMinutos: saldoMinutos,
            inconsistente: inconsistente,
            fechado: fechado,
            atualizadoEm: atualizadoEm,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime data,
            Value<StatusDia> status = const Value.absent(),
            Value<bool> statusManual = const Value.absent(),
            Value<String?> observacao = const Value.absent(),
            Value<int> cargaPrevistaMinutos = const Value.absent(),
            Value<int> minutosTrabalhados = const Value.absent(),
            Value<int> saldoMinutos = const Value.absent(),
            Value<bool> inconsistente = const Value.absent(),
            Value<bool> fechado = const Value.absent(),
            Value<DateTime> atualizadoEm = const Value.absent(),
          }) =>
              DiasTrabalhoCompanion.insert(
            id: id,
            data: data,
            status: status,
            statusManual: statusManual,
            observacao: observacao,
            cargaPrevistaMinutos: cargaPrevistaMinutos,
            minutosTrabalhados: minutosTrabalhados,
            saldoMinutos: saldoMinutos,
            inconsistente: inconsistente,
            fechado: fechado,
            atualizadoEm: atualizadoEm,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DiasTrabalhoTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({marcacoesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (marcacoesRefs) db.marcacoes],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (marcacoesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$DiasTrabalhoTableReferences
                            ._marcacoesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DiasTrabalhoTableReferences(db, table, p0)
                                .marcacoesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.diaId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DiasTrabalhoTableProcessedTableManager = ProcessedTableManager<
    _$BancoLocal,
    $DiasTrabalhoTable,
    DiaTrabalhoLinha,
    $$DiasTrabalhoTableFilterComposer,
    $$DiasTrabalhoTableOrderingComposer,
    $$DiasTrabalhoTableAnnotationComposer,
    $$DiasTrabalhoTableCreateCompanionBuilder,
    $$DiasTrabalhoTableUpdateCompanionBuilder,
    (DiaTrabalhoLinha, $$DiasTrabalhoTableReferences),
    DiaTrabalhoLinha,
    PrefetchHooks Function({bool marcacoesRefs})>;
typedef $$MarcacoesTableCreateCompanionBuilder = MarcacoesCompanion Function({
  Value<int> id,
  required int diaId,
  required int ordem,
  required TipoMarcacao tipo,
  required Duration hora,
  Value<OrigemMarcacao> origem,
  Value<bool> editada,
  Value<DateTime> criadoEm,
});
typedef $$MarcacoesTableUpdateCompanionBuilder = MarcacoesCompanion Function({
  Value<int> id,
  Value<int> diaId,
  Value<int> ordem,
  Value<TipoMarcacao> tipo,
  Value<Duration> hora,
  Value<OrigemMarcacao> origem,
  Value<bool> editada,
  Value<DateTime> criadoEm,
});

final class $$MarcacoesTableReferences
    extends BaseReferences<_$BancoLocal, $MarcacoesTable, MarcacaoLinha> {
  $$MarcacoesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DiasTrabalhoTable _diaIdTable(_$BancoLocal db) =>
      db.diasTrabalho.createAlias(
          $_aliasNameGenerator(db.marcacoes.diaId, db.diasTrabalho.id));

  $$DiasTrabalhoTableProcessedTableManager get diaId {
    final manager = $$DiasTrabalhoTableTableManager($_db, $_db.diasTrabalho)
        .filter((f) => f.id($_item.diaId));
    final item = $_typedResult.readTableOrNull(_diaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MarcacoesTableFilterComposer
    extends Composer<_$BancoLocal, $MarcacoesTable> {
  $$MarcacoesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ordem => $composableBuilder(
      column: $table.ordem, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TipoMarcacao, TipoMarcacao, String> get tipo =>
      $composableBuilder(
          column: $table.tipo,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Duration, Duration, int> get hora =>
      $composableBuilder(
          column: $table.hora,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<OrigemMarcacao, OrigemMarcacao, String>
      get origem => $composableBuilder(
          column: $table.origem,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get editada => $composableBuilder(
      column: $table.editada, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnFilters(column));

  $$DiasTrabalhoTableFilterComposer get diaId {
    final $$DiasTrabalhoTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.diaId,
        referencedTable: $db.diasTrabalho,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiasTrabalhoTableFilterComposer(
              $db: $db,
              $table: $db.diasTrabalho,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MarcacoesTableOrderingComposer
    extends Composer<_$BancoLocal, $MarcacoesTable> {
  $$MarcacoesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ordem => $composableBuilder(
      column: $table.ordem, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hora => $composableBuilder(
      column: $table.hora, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get origem => $composableBuilder(
      column: $table.origem, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get editada => $composableBuilder(
      column: $table.editada, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnOrderings(column));

  $$DiasTrabalhoTableOrderingComposer get diaId {
    final $$DiasTrabalhoTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.diaId,
        referencedTable: $db.diasTrabalho,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiasTrabalhoTableOrderingComposer(
              $db: $db,
              $table: $db.diasTrabalho,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MarcacoesTableAnnotationComposer
    extends Composer<_$BancoLocal, $MarcacoesTable> {
  $$MarcacoesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get ordem =>
      $composableBuilder(column: $table.ordem, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoMarcacao, String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Duration, int> get hora =>
      $composableBuilder(column: $table.hora, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OrigemMarcacao, String> get origem =>
      $composableBuilder(column: $table.origem, builder: (column) => column);

  GeneratedColumn<bool> get editada =>
      $composableBuilder(column: $table.editada, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  $$DiasTrabalhoTableAnnotationComposer get diaId {
    final $$DiasTrabalhoTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.diaId,
        referencedTable: $db.diasTrabalho,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiasTrabalhoTableAnnotationComposer(
              $db: $db,
              $table: $db.diasTrabalho,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MarcacoesTableTableManager extends RootTableManager<
    _$BancoLocal,
    $MarcacoesTable,
    MarcacaoLinha,
    $$MarcacoesTableFilterComposer,
    $$MarcacoesTableOrderingComposer,
    $$MarcacoesTableAnnotationComposer,
    $$MarcacoesTableCreateCompanionBuilder,
    $$MarcacoesTableUpdateCompanionBuilder,
    (MarcacaoLinha, $$MarcacoesTableReferences),
    MarcacaoLinha,
    PrefetchHooks Function({bool diaId})> {
  $$MarcacoesTableTableManager(_$BancoLocal db, $MarcacoesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MarcacoesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MarcacoesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MarcacoesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> diaId = const Value.absent(),
            Value<int> ordem = const Value.absent(),
            Value<TipoMarcacao> tipo = const Value.absent(),
            Value<Duration> hora = const Value.absent(),
            Value<OrigemMarcacao> origem = const Value.absent(),
            Value<bool> editada = const Value.absent(),
            Value<DateTime> criadoEm = const Value.absent(),
          }) =>
              MarcacoesCompanion(
            id: id,
            diaId: diaId,
            ordem: ordem,
            tipo: tipo,
            hora: hora,
            origem: origem,
            editada: editada,
            criadoEm: criadoEm,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int diaId,
            required int ordem,
            required TipoMarcacao tipo,
            required Duration hora,
            Value<OrigemMarcacao> origem = const Value.absent(),
            Value<bool> editada = const Value.absent(),
            Value<DateTime> criadoEm = const Value.absent(),
          }) =>
              MarcacoesCompanion.insert(
            id: id,
            diaId: diaId,
            ordem: ordem,
            tipo: tipo,
            hora: hora,
            origem: origem,
            editada: editada,
            criadoEm: criadoEm,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MarcacoesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({diaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (diaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.diaId,
                    referencedTable: $$MarcacoesTableReferences._diaIdTable(db),
                    referencedColumn:
                        $$MarcacoesTableReferences._diaIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MarcacoesTableProcessedTableManager = ProcessedTableManager<
    _$BancoLocal,
    $MarcacoesTable,
    MarcacaoLinha,
    $$MarcacoesTableFilterComposer,
    $$MarcacoesTableOrderingComposer,
    $$MarcacoesTableAnnotationComposer,
    $$MarcacoesTableCreateCompanionBuilder,
    $$MarcacoesTableUpdateCompanionBuilder,
    (MarcacaoLinha, $$MarcacoesTableReferences),
    MarcacaoLinha,
    PrefetchHooks Function({bool diaId})>;
typedef $$FeriadosTableCreateCompanionBuilder = FeriadosCompanion Function({
  Value<int> id,
  required DateTime data,
  required String descricao,
  Value<bool> recorrenteAnual,
  Value<AbrangenciaFeriado> abrangencia,
});
typedef $$FeriadosTableUpdateCompanionBuilder = FeriadosCompanion Function({
  Value<int> id,
  Value<DateTime> data,
  Value<String> descricao,
  Value<bool> recorrenteAnual,
  Value<AbrangenciaFeriado> abrangencia,
});

class $$FeriadosTableFilterComposer
    extends Composer<_$BancoLocal, $FeriadosTable> {
  $$FeriadosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get data =>
      $composableBuilder(
          column: $table.data,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get descricao => $composableBuilder(
      column: $table.descricao, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get recorrenteAnual => $composableBuilder(
      column: $table.recorrenteAnual,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AbrangenciaFeriado, AbrangenciaFeriado, String>
      get abrangencia => $composableBuilder(
          column: $table.abrangencia,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$FeriadosTableOrderingComposer
    extends Composer<_$BancoLocal, $FeriadosTable> {
  $$FeriadosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descricao => $composableBuilder(
      column: $table.descricao, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get recorrenteAnual => $composableBuilder(
      column: $table.recorrenteAnual,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get abrangencia => $composableBuilder(
      column: $table.abrangencia, builder: (column) => ColumnOrderings(column));
}

class $$FeriadosTableAnnotationComposer
    extends Composer<_$BancoLocal, $FeriadosTable> {
  $$FeriadosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumn<bool> get recorrenteAnual => $composableBuilder(
      column: $table.recorrenteAnual, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AbrangenciaFeriado, String>
      get abrangencia => $composableBuilder(
          column: $table.abrangencia, builder: (column) => column);
}

class $$FeriadosTableTableManager extends RootTableManager<
    _$BancoLocal,
    $FeriadosTable,
    FeriadoLinha,
    $$FeriadosTableFilterComposer,
    $$FeriadosTableOrderingComposer,
    $$FeriadosTableAnnotationComposer,
    $$FeriadosTableCreateCompanionBuilder,
    $$FeriadosTableUpdateCompanionBuilder,
    (FeriadoLinha, BaseReferences<_$BancoLocal, $FeriadosTable, FeriadoLinha>),
    FeriadoLinha,
    PrefetchHooks Function()> {
  $$FeriadosTableTableManager(_$BancoLocal db, $FeriadosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeriadosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeriadosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeriadosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> data = const Value.absent(),
            Value<String> descricao = const Value.absent(),
            Value<bool> recorrenteAnual = const Value.absent(),
            Value<AbrangenciaFeriado> abrangencia = const Value.absent(),
          }) =>
              FeriadosCompanion(
            id: id,
            data: data,
            descricao: descricao,
            recorrenteAnual: recorrenteAnual,
            abrangencia: abrangencia,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime data,
            required String descricao,
            Value<bool> recorrenteAnual = const Value.absent(),
            Value<AbrangenciaFeriado> abrangencia = const Value.absent(),
          }) =>
              FeriadosCompanion.insert(
            id: id,
            data: data,
            descricao: descricao,
            recorrenteAnual: recorrenteAnual,
            abrangencia: abrangencia,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FeriadosTableProcessedTableManager = ProcessedTableManager<
    _$BancoLocal,
    $FeriadosTable,
    FeriadoLinha,
    $$FeriadosTableFilterComposer,
    $$FeriadosTableOrderingComposer,
    $$FeriadosTableAnnotationComposer,
    $$FeriadosTableCreateCompanionBuilder,
    $$FeriadosTableUpdateCompanionBuilder,
    (FeriadoLinha, BaseReferences<_$BancoLocal, $FeriadosTable, FeriadoLinha>),
    FeriadoLinha,
    PrefetchHooks Function()>;
typedef $$ModelosPlanilhaTableCreateCompanionBuilder = ModelosPlanilhaCompanion
    Function({
  Value<int> id,
  required String nome,
  required String caminhoArquivoBase,
  required String nomeArquivoOriginal,
  required String hashArquivo,
  required String nomeAba,
  Value<int?> linhaCabecalho,
  required int primeiraLinhaDados,
  Value<int?> ultimaLinhaDados,
  required EstrategiaLinha estrategiaLinha,
  Value<FormatoData> formatoData,
  Value<FormatoHora> formatoHora,
  Value<bool> escreverComoTexto,
  Value<int> diaInicioCompetencia,
  required bool ativo,
  Value<DateTime> criadoEm,
  Value<DateTime> atualizadoEm,
});
typedef $$ModelosPlanilhaTableUpdateCompanionBuilder = ModelosPlanilhaCompanion
    Function({
  Value<int> id,
  Value<String> nome,
  Value<String> caminhoArquivoBase,
  Value<String> nomeArquivoOriginal,
  Value<String> hashArquivo,
  Value<String> nomeAba,
  Value<int?> linhaCabecalho,
  Value<int> primeiraLinhaDados,
  Value<int?> ultimaLinhaDados,
  Value<EstrategiaLinha> estrategiaLinha,
  Value<FormatoData> formatoData,
  Value<FormatoHora> formatoHora,
  Value<bool> escreverComoTexto,
  Value<int> diaInicioCompetencia,
  Value<bool> ativo,
  Value<DateTime> criadoEm,
  Value<DateTime> atualizadoEm,
});

final class $$ModelosPlanilhaTableReferences extends BaseReferences<
    _$BancoLocal, $ModelosPlanilhaTable, ModeloPlanilhaLinha> {
  $$ModelosPlanilhaTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MapeamentosColunaTable,
      List<MapeamentoColunaLinha>> _mapeamentosColunaRefsTable(
          _$BancoLocal db) =>
      MultiTypedResultKey.fromTable(db.mapeamentosColuna,
          aliasName: $_aliasNameGenerator(
              db.modelosPlanilha.id, db.mapeamentosColuna.modeloId));

  $$MapeamentosColunaTableProcessedTableManager get mapeamentosColunaRefs {
    final manager =
        $$MapeamentosColunaTableTableManager($_db, $_db.mapeamentosColuna)
            .filter((f) => f.modeloId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_mapeamentosColunaRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CelulasFixasTable, List<CelulaFixaLinha>>
      _celulasFixasRefsTable(_$BancoLocal db) =>
          MultiTypedResultKey.fromTable(db.celulasFixas,
              aliasName: $_aliasNameGenerator(
                  db.modelosPlanilha.id, db.celulasFixas.modeloId));

  $$CelulasFixasTableProcessedTableManager get celulasFixasRefs {
    final manager = $$CelulasFixasTableTableManager($_db, $_db.celulasFixas)
        .filter((f) => f.modeloId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_celulasFixasRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TextosStatusTable, List<TextoStatusLinha>>
      _textosStatusRefsTable(_$BancoLocal db) =>
          MultiTypedResultKey.fromTable(db.textosStatus,
              aliasName: $_aliasNameGenerator(
                  db.modelosPlanilha.id, db.textosStatus.modeloId));

  $$TextosStatusTableProcessedTableManager get textosStatusRefs {
    final manager = $$TextosStatusTableTableManager($_db, $_db.textosStatus)
        .filter((f) => f.modeloId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_textosStatusRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$EnviosMensaisTable, List<EnvioMensalLinha>>
      _enviosMensaisRefsTable(_$BancoLocal db) =>
          MultiTypedResultKey.fromTable(db.enviosMensais,
              aliasName: $_aliasNameGenerator(
                  db.modelosPlanilha.id, db.enviosMensais.modeloId));

  $$EnviosMensaisTableProcessedTableManager get enviosMensaisRefs {
    final manager = $$EnviosMensaisTableTableManager($_db, $_db.enviosMensais)
        .filter((f) => f.modeloId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_enviosMensaisRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ModelosPlanilhaTableFilterComposer
    extends Composer<_$BancoLocal, $ModelosPlanilhaTable> {
  $$ModelosPlanilhaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get caminhoArquivoBase => $composableBuilder(
      column: $table.caminhoArquivoBase,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nomeArquivoOriginal => $composableBuilder(
      column: $table.nomeArquivoOriginal,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hashArquivo => $composableBuilder(
      column: $table.hashArquivo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nomeAba => $composableBuilder(
      column: $table.nomeAba, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get linhaCabecalho => $composableBuilder(
      column: $table.linhaCabecalho,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get primeiraLinhaDados => $composableBuilder(
      column: $table.primeiraLinhaDados,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ultimaLinhaDados => $composableBuilder(
      column: $table.ultimaLinhaDados,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<EstrategiaLinha, EstrategiaLinha, String>
      get estrategiaLinha => $composableBuilder(
          column: $table.estrategiaLinha,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<FormatoData, FormatoData, String>
      get formatoData => $composableBuilder(
          column: $table.formatoData,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<FormatoHora, FormatoHora, String>
      get formatoHora => $composableBuilder(
          column: $table.formatoHora,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get escreverComoTexto => $composableBuilder(
      column: $table.escreverComoTexto,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get diaInicioCompetencia => $composableBuilder(
      column: $table.diaInicioCompetencia,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get ativo => $composableBuilder(
      column: $table.ativo, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
      column: $table.atualizadoEm, builder: (column) => ColumnFilters(column));

  Expression<bool> mapeamentosColunaRefs(
      Expression<bool> Function($$MapeamentosColunaTableFilterComposer f) f) {
    final $$MapeamentosColunaTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mapeamentosColuna,
        getReferencedColumn: (t) => t.modeloId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MapeamentosColunaTableFilterComposer(
              $db: $db,
              $table: $db.mapeamentosColuna,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> celulasFixasRefs(
      Expression<bool> Function($$CelulasFixasTableFilterComposer f) f) {
    final $$CelulasFixasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.celulasFixas,
        getReferencedColumn: (t) => t.modeloId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CelulasFixasTableFilterComposer(
              $db: $db,
              $table: $db.celulasFixas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> textosStatusRefs(
      Expression<bool> Function($$TextosStatusTableFilterComposer f) f) {
    final $$TextosStatusTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.textosStatus,
        getReferencedColumn: (t) => t.modeloId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TextosStatusTableFilterComposer(
              $db: $db,
              $table: $db.textosStatus,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> enviosMensaisRefs(
      Expression<bool> Function($$EnviosMensaisTableFilterComposer f) f) {
    final $$EnviosMensaisTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.enviosMensais,
        getReferencedColumn: (t) => t.modeloId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EnviosMensaisTableFilterComposer(
              $db: $db,
              $table: $db.enviosMensais,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ModelosPlanilhaTableOrderingComposer
    extends Composer<_$BancoLocal, $ModelosPlanilhaTable> {
  $$ModelosPlanilhaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get caminhoArquivoBase => $composableBuilder(
      column: $table.caminhoArquivoBase,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nomeArquivoOriginal => $composableBuilder(
      column: $table.nomeArquivoOriginal,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hashArquivo => $composableBuilder(
      column: $table.hashArquivo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nomeAba => $composableBuilder(
      column: $table.nomeAba, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get linhaCabecalho => $composableBuilder(
      column: $table.linhaCabecalho,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get primeiraLinhaDados => $composableBuilder(
      column: $table.primeiraLinhaDados,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ultimaLinhaDados => $composableBuilder(
      column: $table.ultimaLinhaDados,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get estrategiaLinha => $composableBuilder(
      column: $table.estrategiaLinha,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get formatoData => $composableBuilder(
      column: $table.formatoData, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get formatoHora => $composableBuilder(
      column: $table.formatoHora, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get escreverComoTexto => $composableBuilder(
      column: $table.escreverComoTexto,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get diaInicioCompetencia => $composableBuilder(
      column: $table.diaInicioCompetencia,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get ativo => $composableBuilder(
      column: $table.ativo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
      column: $table.atualizadoEm,
      builder: (column) => ColumnOrderings(column));
}

class $$ModelosPlanilhaTableAnnotationComposer
    extends Composer<_$BancoLocal, $ModelosPlanilhaTable> {
  $$ModelosPlanilhaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get caminhoArquivoBase => $composableBuilder(
      column: $table.caminhoArquivoBase, builder: (column) => column);

  GeneratedColumn<String> get nomeArquivoOriginal => $composableBuilder(
      column: $table.nomeArquivoOriginal, builder: (column) => column);

  GeneratedColumn<String> get hashArquivo => $composableBuilder(
      column: $table.hashArquivo, builder: (column) => column);

  GeneratedColumn<String> get nomeAba =>
      $composableBuilder(column: $table.nomeAba, builder: (column) => column);

  GeneratedColumn<int> get linhaCabecalho => $composableBuilder(
      column: $table.linhaCabecalho, builder: (column) => column);

  GeneratedColumn<int> get primeiraLinhaDados => $composableBuilder(
      column: $table.primeiraLinhaDados, builder: (column) => column);

  GeneratedColumn<int> get ultimaLinhaDados => $composableBuilder(
      column: $table.ultimaLinhaDados, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EstrategiaLinha, String>
      get estrategiaLinha => $composableBuilder(
          column: $table.estrategiaLinha, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FormatoData, String> get formatoData =>
      $composableBuilder(
          column: $table.formatoData, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FormatoHora, String> get formatoHora =>
      $composableBuilder(
          column: $table.formatoHora, builder: (column) => column);

  GeneratedColumn<bool> get escreverComoTexto => $composableBuilder(
      column: $table.escreverComoTexto, builder: (column) => column);

  GeneratedColumn<int> get diaInicioCompetencia => $composableBuilder(
      column: $table.diaInicioCompetencia, builder: (column) => column);

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
      column: $table.atualizadoEm, builder: (column) => column);

  Expression<T> mapeamentosColunaRefs<T extends Object>(
      Expression<T> Function($$MapeamentosColunaTableAnnotationComposer a) f) {
    final $$MapeamentosColunaTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.mapeamentosColuna,
            getReferencedColumn: (t) => t.modeloId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MapeamentosColunaTableAnnotationComposer(
                  $db: $db,
                  $table: $db.mapeamentosColuna,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> celulasFixasRefs<T extends Object>(
      Expression<T> Function($$CelulasFixasTableAnnotationComposer a) f) {
    final $$CelulasFixasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.celulasFixas,
        getReferencedColumn: (t) => t.modeloId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CelulasFixasTableAnnotationComposer(
              $db: $db,
              $table: $db.celulasFixas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> textosStatusRefs<T extends Object>(
      Expression<T> Function($$TextosStatusTableAnnotationComposer a) f) {
    final $$TextosStatusTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.textosStatus,
        getReferencedColumn: (t) => t.modeloId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TextosStatusTableAnnotationComposer(
              $db: $db,
              $table: $db.textosStatus,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> enviosMensaisRefs<T extends Object>(
      Expression<T> Function($$EnviosMensaisTableAnnotationComposer a) f) {
    final $$EnviosMensaisTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.enviosMensais,
        getReferencedColumn: (t) => t.modeloId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EnviosMensaisTableAnnotationComposer(
              $db: $db,
              $table: $db.enviosMensais,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ModelosPlanilhaTableTableManager extends RootTableManager<
    _$BancoLocal,
    $ModelosPlanilhaTable,
    ModeloPlanilhaLinha,
    $$ModelosPlanilhaTableFilterComposer,
    $$ModelosPlanilhaTableOrderingComposer,
    $$ModelosPlanilhaTableAnnotationComposer,
    $$ModelosPlanilhaTableCreateCompanionBuilder,
    $$ModelosPlanilhaTableUpdateCompanionBuilder,
    (ModeloPlanilhaLinha, $$ModelosPlanilhaTableReferences),
    ModeloPlanilhaLinha,
    PrefetchHooks Function(
        {bool mapeamentosColunaRefs,
        bool celulasFixasRefs,
        bool textosStatusRefs,
        bool enviosMensaisRefs})> {
  $$ModelosPlanilhaTableTableManager(
      _$BancoLocal db, $ModelosPlanilhaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModelosPlanilhaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModelosPlanilhaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModelosPlanilhaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String> caminhoArquivoBase = const Value.absent(),
            Value<String> nomeArquivoOriginal = const Value.absent(),
            Value<String> hashArquivo = const Value.absent(),
            Value<String> nomeAba = const Value.absent(),
            Value<int?> linhaCabecalho = const Value.absent(),
            Value<int> primeiraLinhaDados = const Value.absent(),
            Value<int?> ultimaLinhaDados = const Value.absent(),
            Value<EstrategiaLinha> estrategiaLinha = const Value.absent(),
            Value<FormatoData> formatoData = const Value.absent(),
            Value<FormatoHora> formatoHora = const Value.absent(),
            Value<bool> escreverComoTexto = const Value.absent(),
            Value<int> diaInicioCompetencia = const Value.absent(),
            Value<bool> ativo = const Value.absent(),
            Value<DateTime> criadoEm = const Value.absent(),
            Value<DateTime> atualizadoEm = const Value.absent(),
          }) =>
              ModelosPlanilhaCompanion(
            id: id,
            nome: nome,
            caminhoArquivoBase: caminhoArquivoBase,
            nomeArquivoOriginal: nomeArquivoOriginal,
            hashArquivo: hashArquivo,
            nomeAba: nomeAba,
            linhaCabecalho: linhaCabecalho,
            primeiraLinhaDados: primeiraLinhaDados,
            ultimaLinhaDados: ultimaLinhaDados,
            estrategiaLinha: estrategiaLinha,
            formatoData: formatoData,
            formatoHora: formatoHora,
            escreverComoTexto: escreverComoTexto,
            diaInicioCompetencia: diaInicioCompetencia,
            ativo: ativo,
            criadoEm: criadoEm,
            atualizadoEm: atualizadoEm,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nome,
            required String caminhoArquivoBase,
            required String nomeArquivoOriginal,
            required String hashArquivo,
            required String nomeAba,
            Value<int?> linhaCabecalho = const Value.absent(),
            required int primeiraLinhaDados,
            Value<int?> ultimaLinhaDados = const Value.absent(),
            required EstrategiaLinha estrategiaLinha,
            Value<FormatoData> formatoData = const Value.absent(),
            Value<FormatoHora> formatoHora = const Value.absent(),
            Value<bool> escreverComoTexto = const Value.absent(),
            Value<int> diaInicioCompetencia = const Value.absent(),
            required bool ativo,
            Value<DateTime> criadoEm = const Value.absent(),
            Value<DateTime> atualizadoEm = const Value.absent(),
          }) =>
              ModelosPlanilhaCompanion.insert(
            id: id,
            nome: nome,
            caminhoArquivoBase: caminhoArquivoBase,
            nomeArquivoOriginal: nomeArquivoOriginal,
            hashArquivo: hashArquivo,
            nomeAba: nomeAba,
            linhaCabecalho: linhaCabecalho,
            primeiraLinhaDados: primeiraLinhaDados,
            ultimaLinhaDados: ultimaLinhaDados,
            estrategiaLinha: estrategiaLinha,
            formatoData: formatoData,
            formatoHora: formatoHora,
            escreverComoTexto: escreverComoTexto,
            diaInicioCompetencia: diaInicioCompetencia,
            ativo: ativo,
            criadoEm: criadoEm,
            atualizadoEm: atualizadoEm,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ModelosPlanilhaTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {mapeamentosColunaRefs = false,
              celulasFixasRefs = false,
              textosStatusRefs = false,
              enviosMensaisRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (mapeamentosColunaRefs) db.mapeamentosColuna,
                if (celulasFixasRefs) db.celulasFixas,
                if (textosStatusRefs) db.textosStatus,
                if (enviosMensaisRefs) db.enviosMensais
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mapeamentosColunaRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$ModelosPlanilhaTableReferences
                            ._mapeamentosColunaRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ModelosPlanilhaTableReferences(db, table, p0)
                                .mapeamentosColunaRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.modeloId == item.id),
                        typedResults: items),
                  if (celulasFixasRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$ModelosPlanilhaTableReferences
                            ._celulasFixasRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ModelosPlanilhaTableReferences(db, table, p0)
                                .celulasFixasRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.modeloId == item.id),
                        typedResults: items),
                  if (textosStatusRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$ModelosPlanilhaTableReferences
                            ._textosStatusRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ModelosPlanilhaTableReferences(db, table, p0)
                                .textosStatusRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.modeloId == item.id),
                        typedResults: items),
                  if (enviosMensaisRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$ModelosPlanilhaTableReferences
                            ._enviosMensaisRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ModelosPlanilhaTableReferences(db, table, p0)
                                .enviosMensaisRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.modeloId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ModelosPlanilhaTableProcessedTableManager = ProcessedTableManager<
    _$BancoLocal,
    $ModelosPlanilhaTable,
    ModeloPlanilhaLinha,
    $$ModelosPlanilhaTableFilterComposer,
    $$ModelosPlanilhaTableOrderingComposer,
    $$ModelosPlanilhaTableAnnotationComposer,
    $$ModelosPlanilhaTableCreateCompanionBuilder,
    $$ModelosPlanilhaTableUpdateCompanionBuilder,
    (ModeloPlanilhaLinha, $$ModelosPlanilhaTableReferences),
    ModeloPlanilhaLinha,
    PrefetchHooks Function(
        {bool mapeamentosColunaRefs,
        bool celulasFixasRefs,
        bool textosStatusRefs,
        bool enviosMensaisRefs})>;
typedef $$MapeamentosColunaTableCreateCompanionBuilder
    = MapeamentosColunaCompanion Function({
  Value<int> id,
  required int modeloId,
  required CampoColuna campo,
  required int indiceColuna,
  Value<String?> rotuloCabecalho,
});
typedef $$MapeamentosColunaTableUpdateCompanionBuilder
    = MapeamentosColunaCompanion Function({
  Value<int> id,
  Value<int> modeloId,
  Value<CampoColuna> campo,
  Value<int> indiceColuna,
  Value<String?> rotuloCabecalho,
});

final class $$MapeamentosColunaTableReferences extends BaseReferences<
    _$BancoLocal, $MapeamentosColunaTable, MapeamentoColunaLinha> {
  $$MapeamentosColunaTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ModelosPlanilhaTable _modeloIdTable(_$BancoLocal db) =>
      db.modelosPlanilha.createAlias($_aliasNameGenerator(
          db.mapeamentosColuna.modeloId, db.modelosPlanilha.id));

  $$ModelosPlanilhaTableProcessedTableManager get modeloId {
    final manager =
        $$ModelosPlanilhaTableTableManager($_db, $_db.modelosPlanilha)
            .filter((f) => f.id($_item.modeloId));
    final item = $_typedResult.readTableOrNull(_modeloIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MapeamentosColunaTableFilterComposer
    extends Composer<_$BancoLocal, $MapeamentosColunaTable> {
  $$MapeamentosColunaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<CampoColuna, CampoColuna, String> get campo =>
      $composableBuilder(
          column: $table.campo,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get indiceColuna => $composableBuilder(
      column: $table.indiceColuna, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rotuloCabecalho => $composableBuilder(
      column: $table.rotuloCabecalho,
      builder: (column) => ColumnFilters(column));

  $$ModelosPlanilhaTableFilterComposer get modeloId {
    final $$ModelosPlanilhaTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.modeloId,
        referencedTable: $db.modelosPlanilha,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ModelosPlanilhaTableFilterComposer(
              $db: $db,
              $table: $db.modelosPlanilha,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MapeamentosColunaTableOrderingComposer
    extends Composer<_$BancoLocal, $MapeamentosColunaTable> {
  $$MapeamentosColunaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get campo => $composableBuilder(
      column: $table.campo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get indiceColuna => $composableBuilder(
      column: $table.indiceColuna,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rotuloCabecalho => $composableBuilder(
      column: $table.rotuloCabecalho,
      builder: (column) => ColumnOrderings(column));

  $$ModelosPlanilhaTableOrderingComposer get modeloId {
    final $$ModelosPlanilhaTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.modeloId,
        referencedTable: $db.modelosPlanilha,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ModelosPlanilhaTableOrderingComposer(
              $db: $db,
              $table: $db.modelosPlanilha,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MapeamentosColunaTableAnnotationComposer
    extends Composer<_$BancoLocal, $MapeamentosColunaTable> {
  $$MapeamentosColunaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CampoColuna, String> get campo =>
      $composableBuilder(column: $table.campo, builder: (column) => column);

  GeneratedColumn<int> get indiceColuna => $composableBuilder(
      column: $table.indiceColuna, builder: (column) => column);

  GeneratedColumn<String> get rotuloCabecalho => $composableBuilder(
      column: $table.rotuloCabecalho, builder: (column) => column);

  $$ModelosPlanilhaTableAnnotationComposer get modeloId {
    final $$ModelosPlanilhaTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.modeloId,
        referencedTable: $db.modelosPlanilha,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ModelosPlanilhaTableAnnotationComposer(
              $db: $db,
              $table: $db.modelosPlanilha,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MapeamentosColunaTableTableManager extends RootTableManager<
    _$BancoLocal,
    $MapeamentosColunaTable,
    MapeamentoColunaLinha,
    $$MapeamentosColunaTableFilterComposer,
    $$MapeamentosColunaTableOrderingComposer,
    $$MapeamentosColunaTableAnnotationComposer,
    $$MapeamentosColunaTableCreateCompanionBuilder,
    $$MapeamentosColunaTableUpdateCompanionBuilder,
    (MapeamentoColunaLinha, $$MapeamentosColunaTableReferences),
    MapeamentoColunaLinha,
    PrefetchHooks Function({bool modeloId})> {
  $$MapeamentosColunaTableTableManager(
      _$BancoLocal db, $MapeamentosColunaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MapeamentosColunaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MapeamentosColunaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MapeamentosColunaTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> modeloId = const Value.absent(),
            Value<CampoColuna> campo = const Value.absent(),
            Value<int> indiceColuna = const Value.absent(),
            Value<String?> rotuloCabecalho = const Value.absent(),
          }) =>
              MapeamentosColunaCompanion(
            id: id,
            modeloId: modeloId,
            campo: campo,
            indiceColuna: indiceColuna,
            rotuloCabecalho: rotuloCabecalho,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int modeloId,
            required CampoColuna campo,
            required int indiceColuna,
            Value<String?> rotuloCabecalho = const Value.absent(),
          }) =>
              MapeamentosColunaCompanion.insert(
            id: id,
            modeloId: modeloId,
            campo: campo,
            indiceColuna: indiceColuna,
            rotuloCabecalho: rotuloCabecalho,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MapeamentosColunaTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({modeloId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (modeloId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.modeloId,
                    referencedTable:
                        $$MapeamentosColunaTableReferences._modeloIdTable(db),
                    referencedColumn: $$MapeamentosColunaTableReferences
                        ._modeloIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MapeamentosColunaTableProcessedTableManager = ProcessedTableManager<
    _$BancoLocal,
    $MapeamentosColunaTable,
    MapeamentoColunaLinha,
    $$MapeamentosColunaTableFilterComposer,
    $$MapeamentosColunaTableOrderingComposer,
    $$MapeamentosColunaTableAnnotationComposer,
    $$MapeamentosColunaTableCreateCompanionBuilder,
    $$MapeamentosColunaTableUpdateCompanionBuilder,
    (MapeamentoColunaLinha, $$MapeamentosColunaTableReferences),
    MapeamentoColunaLinha,
    PrefetchHooks Function({bool modeloId})>;
typedef $$CelulasFixasTableCreateCompanionBuilder = CelulasFixasCompanion
    Function({
  Value<int> id,
  required int modeloId,
  required CampoCelulaFixa campo,
  required String referenciaCelula,
  Value<String?> valorLivre,
});
typedef $$CelulasFixasTableUpdateCompanionBuilder = CelulasFixasCompanion
    Function({
  Value<int> id,
  Value<int> modeloId,
  Value<CampoCelulaFixa> campo,
  Value<String> referenciaCelula,
  Value<String?> valorLivre,
});

final class $$CelulasFixasTableReferences
    extends BaseReferences<_$BancoLocal, $CelulasFixasTable, CelulaFixaLinha> {
  $$CelulasFixasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ModelosPlanilhaTable _modeloIdTable(_$BancoLocal db) =>
      db.modelosPlanilha.createAlias($_aliasNameGenerator(
          db.celulasFixas.modeloId, db.modelosPlanilha.id));

  $$ModelosPlanilhaTableProcessedTableManager get modeloId {
    final manager =
        $$ModelosPlanilhaTableTableManager($_db, $_db.modelosPlanilha)
            .filter((f) => f.id($_item.modeloId));
    final item = $_typedResult.readTableOrNull(_modeloIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CelulasFixasTableFilterComposer
    extends Composer<_$BancoLocal, $CelulasFixasTable> {
  $$CelulasFixasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<CampoCelulaFixa, CampoCelulaFixa, String>
      get campo => $composableBuilder(
          column: $table.campo,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get referenciaCelula => $composableBuilder(
      column: $table.referenciaCelula,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get valorLivre => $composableBuilder(
      column: $table.valorLivre, builder: (column) => ColumnFilters(column));

  $$ModelosPlanilhaTableFilterComposer get modeloId {
    final $$ModelosPlanilhaTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.modeloId,
        referencedTable: $db.modelosPlanilha,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ModelosPlanilhaTableFilterComposer(
              $db: $db,
              $table: $db.modelosPlanilha,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CelulasFixasTableOrderingComposer
    extends Composer<_$BancoLocal, $CelulasFixasTable> {
  $$CelulasFixasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get campo => $composableBuilder(
      column: $table.campo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenciaCelula => $composableBuilder(
      column: $table.referenciaCelula,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get valorLivre => $composableBuilder(
      column: $table.valorLivre, builder: (column) => ColumnOrderings(column));

  $$ModelosPlanilhaTableOrderingComposer get modeloId {
    final $$ModelosPlanilhaTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.modeloId,
        referencedTable: $db.modelosPlanilha,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ModelosPlanilhaTableOrderingComposer(
              $db: $db,
              $table: $db.modelosPlanilha,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CelulasFixasTableAnnotationComposer
    extends Composer<_$BancoLocal, $CelulasFixasTable> {
  $$CelulasFixasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CampoCelulaFixa, String> get campo =>
      $composableBuilder(column: $table.campo, builder: (column) => column);

  GeneratedColumn<String> get referenciaCelula => $composableBuilder(
      column: $table.referenciaCelula, builder: (column) => column);

  GeneratedColumn<String> get valorLivre => $composableBuilder(
      column: $table.valorLivre, builder: (column) => column);

  $$ModelosPlanilhaTableAnnotationComposer get modeloId {
    final $$ModelosPlanilhaTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.modeloId,
        referencedTable: $db.modelosPlanilha,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ModelosPlanilhaTableAnnotationComposer(
              $db: $db,
              $table: $db.modelosPlanilha,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CelulasFixasTableTableManager extends RootTableManager<
    _$BancoLocal,
    $CelulasFixasTable,
    CelulaFixaLinha,
    $$CelulasFixasTableFilterComposer,
    $$CelulasFixasTableOrderingComposer,
    $$CelulasFixasTableAnnotationComposer,
    $$CelulasFixasTableCreateCompanionBuilder,
    $$CelulasFixasTableUpdateCompanionBuilder,
    (CelulaFixaLinha, $$CelulasFixasTableReferences),
    CelulaFixaLinha,
    PrefetchHooks Function({bool modeloId})> {
  $$CelulasFixasTableTableManager(_$BancoLocal db, $CelulasFixasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CelulasFixasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CelulasFixasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CelulasFixasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> modeloId = const Value.absent(),
            Value<CampoCelulaFixa> campo = const Value.absent(),
            Value<String> referenciaCelula = const Value.absent(),
            Value<String?> valorLivre = const Value.absent(),
          }) =>
              CelulasFixasCompanion(
            id: id,
            modeloId: modeloId,
            campo: campo,
            referenciaCelula: referenciaCelula,
            valorLivre: valorLivre,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int modeloId,
            required CampoCelulaFixa campo,
            required String referenciaCelula,
            Value<String?> valorLivre = const Value.absent(),
          }) =>
              CelulasFixasCompanion.insert(
            id: id,
            modeloId: modeloId,
            campo: campo,
            referenciaCelula: referenciaCelula,
            valorLivre: valorLivre,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CelulasFixasTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({modeloId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (modeloId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.modeloId,
                    referencedTable:
                        $$CelulasFixasTableReferences._modeloIdTable(db),
                    referencedColumn:
                        $$CelulasFixasTableReferences._modeloIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CelulasFixasTableProcessedTableManager = ProcessedTableManager<
    _$BancoLocal,
    $CelulasFixasTable,
    CelulaFixaLinha,
    $$CelulasFixasTableFilterComposer,
    $$CelulasFixasTableOrderingComposer,
    $$CelulasFixasTableAnnotationComposer,
    $$CelulasFixasTableCreateCompanionBuilder,
    $$CelulasFixasTableUpdateCompanionBuilder,
    (CelulaFixaLinha, $$CelulasFixasTableReferences),
    CelulaFixaLinha,
    PrefetchHooks Function({bool modeloId})>;
typedef $$TextosStatusTableCreateCompanionBuilder = TextosStatusCompanion
    Function({
  Value<int> id,
  required int modeloId,
  required StatusDia status,
  required String texto,
});
typedef $$TextosStatusTableUpdateCompanionBuilder = TextosStatusCompanion
    Function({
  Value<int> id,
  Value<int> modeloId,
  Value<StatusDia> status,
  Value<String> texto,
});

final class $$TextosStatusTableReferences
    extends BaseReferences<_$BancoLocal, $TextosStatusTable, TextoStatusLinha> {
  $$TextosStatusTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ModelosPlanilhaTable _modeloIdTable(_$BancoLocal db) =>
      db.modelosPlanilha.createAlias($_aliasNameGenerator(
          db.textosStatus.modeloId, db.modelosPlanilha.id));

  $$ModelosPlanilhaTableProcessedTableManager get modeloId {
    final manager =
        $$ModelosPlanilhaTableTableManager($_db, $_db.modelosPlanilha)
            .filter((f) => f.id($_item.modeloId));
    final item = $_typedResult.readTableOrNull(_modeloIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TextosStatusTableFilterComposer
    extends Composer<_$BancoLocal, $TextosStatusTable> {
  $$TextosStatusTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<StatusDia, StatusDia, String> get status =>
      $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get texto => $composableBuilder(
      column: $table.texto, builder: (column) => ColumnFilters(column));

  $$ModelosPlanilhaTableFilterComposer get modeloId {
    final $$ModelosPlanilhaTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.modeloId,
        referencedTable: $db.modelosPlanilha,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ModelosPlanilhaTableFilterComposer(
              $db: $db,
              $table: $db.modelosPlanilha,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TextosStatusTableOrderingComposer
    extends Composer<_$BancoLocal, $TextosStatusTable> {
  $$TextosStatusTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get texto => $composableBuilder(
      column: $table.texto, builder: (column) => ColumnOrderings(column));

  $$ModelosPlanilhaTableOrderingComposer get modeloId {
    final $$ModelosPlanilhaTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.modeloId,
        referencedTable: $db.modelosPlanilha,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ModelosPlanilhaTableOrderingComposer(
              $db: $db,
              $table: $db.modelosPlanilha,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TextosStatusTableAnnotationComposer
    extends Composer<_$BancoLocal, $TextosStatusTable> {
  $$TextosStatusTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StatusDia, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get texto =>
      $composableBuilder(column: $table.texto, builder: (column) => column);

  $$ModelosPlanilhaTableAnnotationComposer get modeloId {
    final $$ModelosPlanilhaTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.modeloId,
        referencedTable: $db.modelosPlanilha,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ModelosPlanilhaTableAnnotationComposer(
              $db: $db,
              $table: $db.modelosPlanilha,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TextosStatusTableTableManager extends RootTableManager<
    _$BancoLocal,
    $TextosStatusTable,
    TextoStatusLinha,
    $$TextosStatusTableFilterComposer,
    $$TextosStatusTableOrderingComposer,
    $$TextosStatusTableAnnotationComposer,
    $$TextosStatusTableCreateCompanionBuilder,
    $$TextosStatusTableUpdateCompanionBuilder,
    (TextoStatusLinha, $$TextosStatusTableReferences),
    TextoStatusLinha,
    PrefetchHooks Function({bool modeloId})> {
  $$TextosStatusTableTableManager(_$BancoLocal db, $TextosStatusTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TextosStatusTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TextosStatusTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TextosStatusTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> modeloId = const Value.absent(),
            Value<StatusDia> status = const Value.absent(),
            Value<String> texto = const Value.absent(),
          }) =>
              TextosStatusCompanion(
            id: id,
            modeloId: modeloId,
            status: status,
            texto: texto,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int modeloId,
            required StatusDia status,
            required String texto,
          }) =>
              TextosStatusCompanion.insert(
            id: id,
            modeloId: modeloId,
            status: status,
            texto: texto,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TextosStatusTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({modeloId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (modeloId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.modeloId,
                    referencedTable:
                        $$TextosStatusTableReferences._modeloIdTable(db),
                    referencedColumn:
                        $$TextosStatusTableReferences._modeloIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TextosStatusTableProcessedTableManager = ProcessedTableManager<
    _$BancoLocal,
    $TextosStatusTable,
    TextoStatusLinha,
    $$TextosStatusTableFilterComposer,
    $$TextosStatusTableOrderingComposer,
    $$TextosStatusTableAnnotationComposer,
    $$TextosStatusTableCreateCompanionBuilder,
    $$TextosStatusTableUpdateCompanionBuilder,
    (TextoStatusLinha, $$TextosStatusTableReferences),
    TextoStatusLinha,
    PrefetchHooks Function({bool modeloId})>;
typedef $$ConfiguracoesEmailTableCreateCompanionBuilder
    = ConfiguracoesEmailCompanion Function({
  Value<int> id,
  required String destinatarios,
  Value<String?> copia,
  required String assuntoModelo,
  required String corpoModelo,
  required String templateNomeArquivo,
  Value<bool> ativo,
});
typedef $$ConfiguracoesEmailTableUpdateCompanionBuilder
    = ConfiguracoesEmailCompanion Function({
  Value<int> id,
  Value<String> destinatarios,
  Value<String?> copia,
  Value<String> assuntoModelo,
  Value<String> corpoModelo,
  Value<String> templateNomeArquivo,
  Value<bool> ativo,
});

class $$ConfiguracoesEmailTableFilterComposer
    extends Composer<_$BancoLocal, $ConfiguracoesEmailTable> {
  $$ConfiguracoesEmailTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get destinatarios => $composableBuilder(
      column: $table.destinatarios, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get copia => $composableBuilder(
      column: $table.copia, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assuntoModelo => $composableBuilder(
      column: $table.assuntoModelo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get corpoModelo => $composableBuilder(
      column: $table.corpoModelo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get templateNomeArquivo => $composableBuilder(
      column: $table.templateNomeArquivo,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get ativo => $composableBuilder(
      column: $table.ativo, builder: (column) => ColumnFilters(column));
}

class $$ConfiguracoesEmailTableOrderingComposer
    extends Composer<_$BancoLocal, $ConfiguracoesEmailTable> {
  $$ConfiguracoesEmailTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get destinatarios => $composableBuilder(
      column: $table.destinatarios,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get copia => $composableBuilder(
      column: $table.copia, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assuntoModelo => $composableBuilder(
      column: $table.assuntoModelo,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get corpoModelo => $composableBuilder(
      column: $table.corpoModelo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get templateNomeArquivo => $composableBuilder(
      column: $table.templateNomeArquivo,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get ativo => $composableBuilder(
      column: $table.ativo, builder: (column) => ColumnOrderings(column));
}

class $$ConfiguracoesEmailTableAnnotationComposer
    extends Composer<_$BancoLocal, $ConfiguracoesEmailTable> {
  $$ConfiguracoesEmailTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get destinatarios => $composableBuilder(
      column: $table.destinatarios, builder: (column) => column);

  GeneratedColumn<String> get copia =>
      $composableBuilder(column: $table.copia, builder: (column) => column);

  GeneratedColumn<String> get assuntoModelo => $composableBuilder(
      column: $table.assuntoModelo, builder: (column) => column);

  GeneratedColumn<String> get corpoModelo => $composableBuilder(
      column: $table.corpoModelo, builder: (column) => column);

  GeneratedColumn<String> get templateNomeArquivo => $composableBuilder(
      column: $table.templateNomeArquivo, builder: (column) => column);

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);
}

class $$ConfiguracoesEmailTableTableManager extends RootTableManager<
    _$BancoLocal,
    $ConfiguracoesEmailTable,
    ConfiguracaoEmailLinha,
    $$ConfiguracoesEmailTableFilterComposer,
    $$ConfiguracoesEmailTableOrderingComposer,
    $$ConfiguracoesEmailTableAnnotationComposer,
    $$ConfiguracoesEmailTableCreateCompanionBuilder,
    $$ConfiguracoesEmailTableUpdateCompanionBuilder,
    (
      ConfiguracaoEmailLinha,
      BaseReferences<_$BancoLocal, $ConfiguracoesEmailTable,
          ConfiguracaoEmailLinha>
    ),
    ConfiguracaoEmailLinha,
    PrefetchHooks Function()> {
  $$ConfiguracoesEmailTableTableManager(
      _$BancoLocal db, $ConfiguracoesEmailTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfiguracoesEmailTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConfiguracoesEmailTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConfiguracoesEmailTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> destinatarios = const Value.absent(),
            Value<String?> copia = const Value.absent(),
            Value<String> assuntoModelo = const Value.absent(),
            Value<String> corpoModelo = const Value.absent(),
            Value<String> templateNomeArquivo = const Value.absent(),
            Value<bool> ativo = const Value.absent(),
          }) =>
              ConfiguracoesEmailCompanion(
            id: id,
            destinatarios: destinatarios,
            copia: copia,
            assuntoModelo: assuntoModelo,
            corpoModelo: corpoModelo,
            templateNomeArquivo: templateNomeArquivo,
            ativo: ativo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String destinatarios,
            Value<String?> copia = const Value.absent(),
            required String assuntoModelo,
            required String corpoModelo,
            required String templateNomeArquivo,
            Value<bool> ativo = const Value.absent(),
          }) =>
              ConfiguracoesEmailCompanion.insert(
            id: id,
            destinatarios: destinatarios,
            copia: copia,
            assuntoModelo: assuntoModelo,
            corpoModelo: corpoModelo,
            templateNomeArquivo: templateNomeArquivo,
            ativo: ativo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConfiguracoesEmailTableProcessedTableManager = ProcessedTableManager<
    _$BancoLocal,
    $ConfiguracoesEmailTable,
    ConfiguracaoEmailLinha,
    $$ConfiguracoesEmailTableFilterComposer,
    $$ConfiguracoesEmailTableOrderingComposer,
    $$ConfiguracoesEmailTableAnnotationComposer,
    $$ConfiguracoesEmailTableCreateCompanionBuilder,
    $$ConfiguracoesEmailTableUpdateCompanionBuilder,
    (
      ConfiguracaoEmailLinha,
      BaseReferences<_$BancoLocal, $ConfiguracoesEmailTable,
          ConfiguracaoEmailLinha>
    ),
    ConfiguracaoEmailLinha,
    PrefetchHooks Function()>;
typedef $$EnviosMensaisTableCreateCompanionBuilder = EnviosMensaisCompanion
    Function({
  Value<int> id,
  Value<int?> modeloId,
  required int competenciaAno,
  required int competenciaMes,
  required StatusEnvio status,
  required DateTime geradoEm,
  required String caminhoArquivo,
  required String nomeArquivo,
  required int tamanhoBytes,
  Value<DateTime?> enviadoEm,
  Value<String?> observacao,
});
typedef $$EnviosMensaisTableUpdateCompanionBuilder = EnviosMensaisCompanion
    Function({
  Value<int> id,
  Value<int?> modeloId,
  Value<int> competenciaAno,
  Value<int> competenciaMes,
  Value<StatusEnvio> status,
  Value<DateTime> geradoEm,
  Value<String> caminhoArquivo,
  Value<String> nomeArquivo,
  Value<int> tamanhoBytes,
  Value<DateTime?> enviadoEm,
  Value<String?> observacao,
});

final class $$EnviosMensaisTableReferences extends BaseReferences<_$BancoLocal,
    $EnviosMensaisTable, EnvioMensalLinha> {
  $$EnviosMensaisTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ModelosPlanilhaTable _modeloIdTable(_$BancoLocal db) =>
      db.modelosPlanilha.createAlias($_aliasNameGenerator(
          db.enviosMensais.modeloId, db.modelosPlanilha.id));

  $$ModelosPlanilhaTableProcessedTableManager? get modeloId {
    if ($_item.modeloId == null) return null;
    final manager =
        $$ModelosPlanilhaTableTableManager($_db, $_db.modelosPlanilha)
            .filter((f) => f.id($_item.modeloId!));
    final item = $_typedResult.readTableOrNull(_modeloIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EnviosMensaisTableFilterComposer
    extends Composer<_$BancoLocal, $EnviosMensaisTable> {
  $$EnviosMensaisTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get competenciaAno => $composableBuilder(
      column: $table.competenciaAno,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get competenciaMes => $composableBuilder(
      column: $table.competenciaMes,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<StatusEnvio, StatusEnvio, String> get status =>
      $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get geradoEm => $composableBuilder(
      column: $table.geradoEm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get caminhoArquivo => $composableBuilder(
      column: $table.caminhoArquivo,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nomeArquivo => $composableBuilder(
      column: $table.nomeArquivo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tamanhoBytes => $composableBuilder(
      column: $table.tamanhoBytes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get enviadoEm => $composableBuilder(
      column: $table.enviadoEm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observacao => $composableBuilder(
      column: $table.observacao, builder: (column) => ColumnFilters(column));

  $$ModelosPlanilhaTableFilterComposer get modeloId {
    final $$ModelosPlanilhaTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.modeloId,
        referencedTable: $db.modelosPlanilha,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ModelosPlanilhaTableFilterComposer(
              $db: $db,
              $table: $db.modelosPlanilha,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EnviosMensaisTableOrderingComposer
    extends Composer<_$BancoLocal, $EnviosMensaisTable> {
  $$EnviosMensaisTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get competenciaAno => $composableBuilder(
      column: $table.competenciaAno,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get competenciaMes => $composableBuilder(
      column: $table.competenciaMes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get geradoEm => $composableBuilder(
      column: $table.geradoEm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get caminhoArquivo => $composableBuilder(
      column: $table.caminhoArquivo,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nomeArquivo => $composableBuilder(
      column: $table.nomeArquivo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tamanhoBytes => $composableBuilder(
      column: $table.tamanhoBytes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get enviadoEm => $composableBuilder(
      column: $table.enviadoEm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observacao => $composableBuilder(
      column: $table.observacao, builder: (column) => ColumnOrderings(column));

  $$ModelosPlanilhaTableOrderingComposer get modeloId {
    final $$ModelosPlanilhaTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.modeloId,
        referencedTable: $db.modelosPlanilha,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ModelosPlanilhaTableOrderingComposer(
              $db: $db,
              $table: $db.modelosPlanilha,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EnviosMensaisTableAnnotationComposer
    extends Composer<_$BancoLocal, $EnviosMensaisTable> {
  $$EnviosMensaisTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get competenciaAno => $composableBuilder(
      column: $table.competenciaAno, builder: (column) => column);

  GeneratedColumn<int> get competenciaMes => $composableBuilder(
      column: $table.competenciaMes, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StatusEnvio, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get geradoEm =>
      $composableBuilder(column: $table.geradoEm, builder: (column) => column);

  GeneratedColumn<String> get caminhoArquivo => $composableBuilder(
      column: $table.caminhoArquivo, builder: (column) => column);

  GeneratedColumn<String> get nomeArquivo => $composableBuilder(
      column: $table.nomeArquivo, builder: (column) => column);

  GeneratedColumn<int> get tamanhoBytes => $composableBuilder(
      column: $table.tamanhoBytes, builder: (column) => column);

  GeneratedColumn<DateTime> get enviadoEm =>
      $composableBuilder(column: $table.enviadoEm, builder: (column) => column);

  GeneratedColumn<String> get observacao => $composableBuilder(
      column: $table.observacao, builder: (column) => column);

  $$ModelosPlanilhaTableAnnotationComposer get modeloId {
    final $$ModelosPlanilhaTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.modeloId,
        referencedTable: $db.modelosPlanilha,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ModelosPlanilhaTableAnnotationComposer(
              $db: $db,
              $table: $db.modelosPlanilha,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EnviosMensaisTableTableManager extends RootTableManager<
    _$BancoLocal,
    $EnviosMensaisTable,
    EnvioMensalLinha,
    $$EnviosMensaisTableFilterComposer,
    $$EnviosMensaisTableOrderingComposer,
    $$EnviosMensaisTableAnnotationComposer,
    $$EnviosMensaisTableCreateCompanionBuilder,
    $$EnviosMensaisTableUpdateCompanionBuilder,
    (EnvioMensalLinha, $$EnviosMensaisTableReferences),
    EnvioMensalLinha,
    PrefetchHooks Function({bool modeloId})> {
  $$EnviosMensaisTableTableManager(_$BancoLocal db, $EnviosMensaisTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnviosMensaisTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnviosMensaisTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EnviosMensaisTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> modeloId = const Value.absent(),
            Value<int> competenciaAno = const Value.absent(),
            Value<int> competenciaMes = const Value.absent(),
            Value<StatusEnvio> status = const Value.absent(),
            Value<DateTime> geradoEm = const Value.absent(),
            Value<String> caminhoArquivo = const Value.absent(),
            Value<String> nomeArquivo = const Value.absent(),
            Value<int> tamanhoBytes = const Value.absent(),
            Value<DateTime?> enviadoEm = const Value.absent(),
            Value<String?> observacao = const Value.absent(),
          }) =>
              EnviosMensaisCompanion(
            id: id,
            modeloId: modeloId,
            competenciaAno: competenciaAno,
            competenciaMes: competenciaMes,
            status: status,
            geradoEm: geradoEm,
            caminhoArquivo: caminhoArquivo,
            nomeArquivo: nomeArquivo,
            tamanhoBytes: tamanhoBytes,
            enviadoEm: enviadoEm,
            observacao: observacao,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> modeloId = const Value.absent(),
            required int competenciaAno,
            required int competenciaMes,
            required StatusEnvio status,
            required DateTime geradoEm,
            required String caminhoArquivo,
            required String nomeArquivo,
            required int tamanhoBytes,
            Value<DateTime?> enviadoEm = const Value.absent(),
            Value<String?> observacao = const Value.absent(),
          }) =>
              EnviosMensaisCompanion.insert(
            id: id,
            modeloId: modeloId,
            competenciaAno: competenciaAno,
            competenciaMes: competenciaMes,
            status: status,
            geradoEm: geradoEm,
            caminhoArquivo: caminhoArquivo,
            nomeArquivo: nomeArquivo,
            tamanhoBytes: tamanhoBytes,
            enviadoEm: enviadoEm,
            observacao: observacao,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EnviosMensaisTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({modeloId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (modeloId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.modeloId,
                    referencedTable:
                        $$EnviosMensaisTableReferences._modeloIdTable(db),
                    referencedColumn:
                        $$EnviosMensaisTableReferences._modeloIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EnviosMensaisTableProcessedTableManager = ProcessedTableManager<
    _$BancoLocal,
    $EnviosMensaisTable,
    EnvioMensalLinha,
    $$EnviosMensaisTableFilterComposer,
    $$EnviosMensaisTableOrderingComposer,
    $$EnviosMensaisTableAnnotationComposer,
    $$EnviosMensaisTableCreateCompanionBuilder,
    $$EnviosMensaisTableUpdateCompanionBuilder,
    (EnvioMensalLinha, $$EnviosMensaisTableReferences),
    EnvioMensalLinha,
    PrefetchHooks Function({bool modeloId})>;
typedef $$ConfiguracoesNotificacaoTableCreateCompanionBuilder
    = ConfiguracoesNotificacaoCompanion Function({
  Value<int> id,
  required TipoNotificacao tipo,
  Value<bool> ativa,
  Value<int?> hora,
  Value<int> antecedenciaMinutos,
  Value<int?> diaReferencia,
});
typedef $$ConfiguracoesNotificacaoTableUpdateCompanionBuilder
    = ConfiguracoesNotificacaoCompanion Function({
  Value<int> id,
  Value<TipoNotificacao> tipo,
  Value<bool> ativa,
  Value<int?> hora,
  Value<int> antecedenciaMinutos,
  Value<int?> diaReferencia,
});

class $$ConfiguracoesNotificacaoTableFilterComposer
    extends Composer<_$BancoLocal, $ConfiguracoesNotificacaoTable> {
  $$ConfiguracoesNotificacaoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TipoNotificacao, TipoNotificacao, String>
      get tipo => $composableBuilder(
          column: $table.tipo,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get ativa => $composableBuilder(
      column: $table.ativa, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hora => $composableBuilder(
      column: $table.hora, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get antecedenciaMinutos => $composableBuilder(
      column: $table.antecedenciaMinutos,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get diaReferencia => $composableBuilder(
      column: $table.diaReferencia, builder: (column) => ColumnFilters(column));
}

class $$ConfiguracoesNotificacaoTableOrderingComposer
    extends Composer<_$BancoLocal, $ConfiguracoesNotificacaoTable> {
  $$ConfiguracoesNotificacaoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get ativa => $composableBuilder(
      column: $table.ativa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hora => $composableBuilder(
      column: $table.hora, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get antecedenciaMinutos => $composableBuilder(
      column: $table.antecedenciaMinutos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get diaReferencia => $composableBuilder(
      column: $table.diaReferencia,
      builder: (column) => ColumnOrderings(column));
}

class $$ConfiguracoesNotificacaoTableAnnotationComposer
    extends Composer<_$BancoLocal, $ConfiguracoesNotificacaoTable> {
  $$ConfiguracoesNotificacaoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoNotificacao, String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<bool> get ativa =>
      $composableBuilder(column: $table.ativa, builder: (column) => column);

  GeneratedColumn<int> get hora =>
      $composableBuilder(column: $table.hora, builder: (column) => column);

  GeneratedColumn<int> get antecedenciaMinutos => $composableBuilder(
      column: $table.antecedenciaMinutos, builder: (column) => column);

  GeneratedColumn<int> get diaReferencia => $composableBuilder(
      column: $table.diaReferencia, builder: (column) => column);
}

class $$ConfiguracoesNotificacaoTableTableManager extends RootTableManager<
    _$BancoLocal,
    $ConfiguracoesNotificacaoTable,
    ConfiguracaoNotificacaoLinha,
    $$ConfiguracoesNotificacaoTableFilterComposer,
    $$ConfiguracoesNotificacaoTableOrderingComposer,
    $$ConfiguracoesNotificacaoTableAnnotationComposer,
    $$ConfiguracoesNotificacaoTableCreateCompanionBuilder,
    $$ConfiguracoesNotificacaoTableUpdateCompanionBuilder,
    (
      ConfiguracaoNotificacaoLinha,
      BaseReferences<_$BancoLocal, $ConfiguracoesNotificacaoTable,
          ConfiguracaoNotificacaoLinha>
    ),
    ConfiguracaoNotificacaoLinha,
    PrefetchHooks Function()> {
  $$ConfiguracoesNotificacaoTableTableManager(
      _$BancoLocal db, $ConfiguracoesNotificacaoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfiguracoesNotificacaoTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ConfiguracoesNotificacaoTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConfiguracoesNotificacaoTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<TipoNotificacao> tipo = const Value.absent(),
            Value<bool> ativa = const Value.absent(),
            Value<int?> hora = const Value.absent(),
            Value<int> antecedenciaMinutos = const Value.absent(),
            Value<int?> diaReferencia = const Value.absent(),
          }) =>
              ConfiguracoesNotificacaoCompanion(
            id: id,
            tipo: tipo,
            ativa: ativa,
            hora: hora,
            antecedenciaMinutos: antecedenciaMinutos,
            diaReferencia: diaReferencia,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required TipoNotificacao tipo,
            Value<bool> ativa = const Value.absent(),
            Value<int?> hora = const Value.absent(),
            Value<int> antecedenciaMinutos = const Value.absent(),
            Value<int?> diaReferencia = const Value.absent(),
          }) =>
              ConfiguracoesNotificacaoCompanion.insert(
            id: id,
            tipo: tipo,
            ativa: ativa,
            hora: hora,
            antecedenciaMinutos: antecedenciaMinutos,
            diaReferencia: diaReferencia,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConfiguracoesNotificacaoTableProcessedTableManager
    = ProcessedTableManager<
        _$BancoLocal,
        $ConfiguracoesNotificacaoTable,
        ConfiguracaoNotificacaoLinha,
        $$ConfiguracoesNotificacaoTableFilterComposer,
        $$ConfiguracoesNotificacaoTableOrderingComposer,
        $$ConfiguracoesNotificacaoTableAnnotationComposer,
        $$ConfiguracoesNotificacaoTableCreateCompanionBuilder,
        $$ConfiguracoesNotificacaoTableUpdateCompanionBuilder,
        (
          ConfiguracaoNotificacaoLinha,
          BaseReferences<_$BancoLocal, $ConfiguracoesNotificacaoTable,
              ConfiguracaoNotificacaoLinha>
        ),
        ConfiguracaoNotificacaoLinha,
        PrefetchHooks Function()>;

class $BancoLocalManager {
  final _$BancoLocal _db;
  $BancoLocalManager(this._db);
  $$PerfisUsuarioTableTableManager get perfisUsuario =>
      $$PerfisUsuarioTableTableManager(_db, _db.perfisUsuario);
  $$PreferenciasAppTableTableManager get preferenciasApp =>
      $$PreferenciasAppTableTableManager(_db, _db.preferenciasApp);
  $$ConfiguracoesJornadaTableTableManager get configuracoesJornada =>
      $$ConfiguracoesJornadaTableTableManager(_db, _db.configuracoesJornada);
  $$JornadasDiaSemanaTableTableManager get jornadasDiaSemana =>
      $$JornadasDiaSemanaTableTableManager(_db, _db.jornadasDiaSemana);
  $$TurnosPrevistosTableTableManager get turnosPrevistos =>
      $$TurnosPrevistosTableTableManager(_db, _db.turnosPrevistos);
  $$DiasTrabalhoTableTableManager get diasTrabalho =>
      $$DiasTrabalhoTableTableManager(_db, _db.diasTrabalho);
  $$MarcacoesTableTableManager get marcacoes =>
      $$MarcacoesTableTableManager(_db, _db.marcacoes);
  $$FeriadosTableTableManager get feriados =>
      $$FeriadosTableTableManager(_db, _db.feriados);
  $$ModelosPlanilhaTableTableManager get modelosPlanilha =>
      $$ModelosPlanilhaTableTableManager(_db, _db.modelosPlanilha);
  $$MapeamentosColunaTableTableManager get mapeamentosColuna =>
      $$MapeamentosColunaTableTableManager(_db, _db.mapeamentosColuna);
  $$CelulasFixasTableTableManager get celulasFixas =>
      $$CelulasFixasTableTableManager(_db, _db.celulasFixas);
  $$TextosStatusTableTableManager get textosStatus =>
      $$TextosStatusTableTableManager(_db, _db.textosStatus);
  $$ConfiguracoesEmailTableTableManager get configuracoesEmail =>
      $$ConfiguracoesEmailTableTableManager(_db, _db.configuracoesEmail);
  $$EnviosMensaisTableTableManager get enviosMensais =>
      $$EnviosMensaisTableTableManager(_db, _db.enviosMensais);
  $$ConfiguracoesNotificacaoTableTableManager get configuracoesNotificacao =>
      $$ConfiguracoesNotificacaoTableTableManager(
          _db, _db.configuracoesNotificacao);
}
