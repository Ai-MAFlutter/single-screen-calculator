import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const Color background = Color(0xFF111318);
  static const Color surface = Color(0xFF20232B);
  static const Color numberButton = Color(0xFF292D36);
  static const Color operatorButton = Color(0xFF343B4A);
  static const Color accent = Color(0xFFB9E769);
  static const Color textPrimary = Color(0xFFF5F6FA);
  static const Color textSecondary = Color(0xFF9BA3B4);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        surface: surface,
        onPrimary: background,
        onSurface: textPrimary,
      ),
      fontFamily: 'Roboto',
    );
  }
}
