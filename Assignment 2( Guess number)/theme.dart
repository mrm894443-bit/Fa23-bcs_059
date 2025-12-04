import 'package:flutter/material.dart';

class AppTheme {
  // Core colors
  static const Color primary = Color(0xFF0A0E27);
  static const Color accent = Color(0xFF00D9FF);
  static const Color neonGreen = Color(0xFF00FF88);
  static const Color warmOrange = Color(0xFFFF6B00);
  static const Color dangerRed = Color(0xFFFF1744);

  // Background palettes used by AnimatedGradientBackground
  static final List<List<Color>> palettes = [
    [Color(0xFF0A0E27), Color(0xFF1A1F3A), Color(0xFF00D9FF)],
    [Color(0xFF0F1535), Color(0xFF1E2D4A), Color(0xFF00FF88)],
    [Color(0xFF0D1228), Color(0xFF1C2840), Color(0xFF00D9FF)],
  ];

  static ThemeData themeData() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(primary: primary, secondary: accent),
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        displayLarge: const TextStyle(
          fontSize: 52,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        bodyLarge: const TextStyle(fontSize: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonGreen,
          foregroundColor: primary,
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        hintStyle: TextStyle(color: accent.withOpacity(0.6)),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accent.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neonGreen),
        ),
      ),
      cardTheme: base.cardTheme.copyWith(color: const Color(0xFF0F1535)),
    );
  }
}
