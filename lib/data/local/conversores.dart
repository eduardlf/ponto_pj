import 'package:drift/drift.dart';

import '../../core/extensoes/data_extensoes.dart';

/// Datas civis são persistidas como texto ISO `AAAA-MM-DD` (docs/06, seção 6.1).
class ConversorData extends TypeConverter<DateTime, String> {
  const ConversorData();

  @override
  DateTime fromSql(String fromDb) {
    final data = lerDataIso(fromDb);
    if (data == null) throw FormatException('Data inválida no banco: $fromDb');
    return data;
  }

  @override
  String toSql(DateTime value) => value.iso;
}

/// Horas do dia e durações são persistidas como minutos (docs/06, seção 6.1).
class ConversorMinutos extends TypeConverter<Duration, int> {
  const ConversorMinutos();

  @override
  Duration fromSql(int fromDb) => Duration(minutes: fromDb);

  @override
  int toSql(Duration value) => value.inMinutes;
}

/// Enumerações são persistidas com o nome da constante em caixa alta: `porData` é gravado
/// como `POR_DATA`, legível ao inspecionar o banco (docs/06, seção 6.1).
class ConversorEnum<T extends Enum> extends TypeConverter<T, String> {
  final List<T> valores;

  const ConversorEnum(this.valores);

  @override
  T fromSql(String fromDb) => valores.firstWhere(
        (v) => codigoEnum(v) == fromDb,
        orElse: () => throw FormatException('Valor desconhecido no banco: $fromDb'),
      );

  @override
  String toSql(T value) => codigoEnum(value);
}

/// `porData` → `POR_DATA`; `entrada1` → `ENTRADA_1`.
String codigoEnum(Enum valor) => valor.name
    .replaceAllMapped(RegExp(r'(?<=[a-z0-9])([A-Z])|(?<=[a-zA-Z])(\d+)'), (m) => '_${m[0]}')
    .toUpperCase();
