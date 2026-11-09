import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:ponto_pj/data/local/banco_local.dart';
import 'package:sqlite3/open.dart';

var _configurado = false;

/// Banco em memória para os testes de repositório (docs/14, seção 14.1).
///
/// No Windows o `flutter test` roda fora do app, sem a biblioteca do SQLite que o plugin
/// empacota; usa-se a `sqlite3.dll` do PATH ou a `winsqlite3.dll` que vem com o sistema.
BancoLocal abrirBancoDeTeste() {
  if (!_configurado) {
    if (Platform.isWindows) {
      open.overrideFor(OperatingSystem.windows, () {
        try {
          return DynamicLibrary.open('sqlite3.dll');
        } on ArgumentError {
          return DynamicLibrary.open('winsqlite3.dll');
        }
      });
    }
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    _configurado = true;
  }
  return BancoLocal(NativeDatabase.memory());
}
