import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color _seed = Color(0xFF2E7D6B);

  static const Color income = Color(0xFF2E9E5B);
  static const Color expense = Color(0xFFD64545);

  static final ThemeData  light = _build(Brightness.light);
  static final ThemeData  dark = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,

      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerHighest,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      textTheme: _textTheme(scheme),
    );
  }
  static TextTheme _textTheme(ColorScheme scheme) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
    ).textTheme;

    final themed = GoogleFonts.poppinsTextTheme(base).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );

    return themed.copyWith(
      headlineMedium: themed.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: themed.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      titleSmall: themed.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      bodyMedium: themed.bodyMedium?.copyWith(fontSize: 15),
    );
  }
}
