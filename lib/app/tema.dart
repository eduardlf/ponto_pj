import 'package:flutter/material.dart';

/// Cores de significado do design system (docs/04, seção 4.5). Cor nunca é o único
/// portador de significado: saldo tem sinal, pendência tem ícone.
@immutable
class CoresPonto extends ThemeExtension<CoresPonto> {
  final Color credito;
  final Color debito;
  final Color atencao;
  final Color neutro;

  const CoresPonto({
    required this.credito,
    required this.debito,
    required this.atencao,
    required this.neutro,
  });

  static const claro = CoresPonto(
    credito: Color(0xFF1B7A3E),
    debito: Color(0xFFC0392B),
    atencao: Color(0xFFB26A00),
    neutro: Color(0xFF6B7480),
  );

  static const escuro = CoresPonto(
    credito: Color(0xFF5FD08A),
    debito: Color(0xFFF2857A),
    atencao: Color(0xFFF0B25E),
    neutro: Color(0xFF8C97A5),
  );

  static CoresPonto de(BuildContext context) => Theme.of(context).extension<CoresPonto>()!;

  /// Verde para crédito, vermelho para débito, cor do texto para zero.
  Color doSaldo(BuildContext context, Duration saldo) {
    if (saldo > Duration.zero) return credito;
    if (saldo < Duration.zero) return debito;
    return Theme.of(context).colorScheme.onSurface;
  }

  @override
  CoresPonto copyWith({Color? credito, Color? debito, Color? atencao, Color? neutro}) =>
      CoresPonto(
        credito: credito ?? this.credito,
        debito: debito ?? this.debito,
        atencao: atencao ?? this.atencao,
        neutro: neutro ?? this.neutro,
      );

  @override
  CoresPonto lerp(CoresPonto? other, double t) {
    if (other == null) return this;
    return CoresPonto(
      credito: Color.lerp(credito, other.credito, t)!,
      debito: Color.lerp(debito, other.debito, t)!,
      atencao: Color.lerp(atencao, other.atencao, t)!,
      neutro: Color.lerp(neutro, other.neutro, t)!,
    );
  }
}

/// Algarismos tabulares: horários e durações não "dançam" ao atualizar o relógio.
const algarismosTabulares = [FontFeature.tabularFigures()];

ThemeData temaClaro() => _tema(Brightness.light);

ThemeData temaEscuro() => _tema(Brightness.dark);

ThemeData _tema(Brightness brilho) {
  final claro = brilho == Brightness.light;
  final esquema = ColorScheme(
    brightness: brilho,
    primary: claro ? const Color(0xFF1565C0) : const Color(0xFF5B9BF3),
    onPrimary: claro ? Colors.white : const Color(0xFF0B1B2B),
    primaryContainer: claro ? const Color(0xFFDCE8F8) : const Color(0xFF1C3A5E),
    onPrimaryContainer: claro ? const Color(0xFF0B2A4F) : const Color(0xFFDCE8F8),
    secondary: claro ? const Color(0xFF1565C0) : const Color(0xFF5B9BF3),
    onSecondary: claro ? Colors.white : const Color(0xFF0B1B2B),
    secondaryContainer: claro ? const Color(0xFFDCE8F8) : const Color(0xFF1C3A5E),
    onSecondaryContainer: claro ? const Color(0xFF0B2A4F) : const Color(0xFFDCE8F8),
    error: claro ? const Color(0xFFC0392B) : const Color(0xFFF2857A),
    onError: claro ? Colors.white : const Color(0xFF2B0B08),
    surface: claro ? Colors.white : const Color(0xFF1A2027),
    onSurface: claro ? const Color(0xFF101418) : const Color(0xFFE6EAF0),
    surfaceContainerLowest: claro ? Colors.white : const Color(0xFF151A20),
    surfaceContainerLow: claro ? const Color(0xFFF8F9FB) : const Color(0xFF1A2027),
    surfaceContainer: claro ? Colors.white : const Color(0xFF1A2027),
    surfaceContainerHigh: claro ? const Color(0xFFF1F3F6) : const Color(0xFF20262E),
    surfaceContainerHighest: claro ? const Color(0xFFECEFF3) : const Color(0xFF232A33),
    onSurfaceVariant: claro ? const Color(0xFF5A6472) : const Color(0xFF9AA5B4),
    outline: claro ? const Color(0xFF8A939E) : const Color(0xFF5C6773),
    outlineVariant: claro ? const Color(0xFFDDE2E9) : const Color(0xFF2C333C),
  );
  final fundo = claro ? const Color(0xFFF5F7FA) : const Color(0xFF0F1418);
  final base = ThemeData(useMaterial3: true, colorScheme: esquema, brightness: brilho);

  return base.copyWith(
    scaffoldBackgroundColor: fundo,
    extensions: [claro ? CoresPonto.claro : CoresPonto.escuro],
    appBarTheme: AppBarTheme(
      backgroundColor: esquema.primary,
      foregroundColor: esquema.onPrimary,
      centerTitle: false,
      titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontSize: 20, fontWeight: FontWeight.w600, color: esquema.onPrimary),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: esquema.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: esquema.outlineVariant),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: esquema.surfaceContainerHighest,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: esquema.surface,
      indicatorColor: esquema.primaryContainer,
    ),
    dividerTheme: DividerThemeData(color: esquema.outlineVariant, space: 1),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
