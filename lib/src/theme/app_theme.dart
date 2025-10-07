import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales basados en la app TypeScript
  static const Color _cyanPrimary = Color(0xFF22D3EE); // cyan-400
  static const Color _cyan500 = Color(0xFF06B6D4); // cyan-500
  
  static const Color _purple500 = Color(0xFFA855F7); // purple-500
  
  static const Color _green500 = Color(0xFF22C55E); // green-500
  static const Color _orange500 = Color(0xFFF97316); // orange-500
  
  // Tema claro
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF8FAFC), // background light
    colorScheme: const ColorScheme.light(
      primary: _cyan500,
      secondary: _purple500,
      surface: Colors.white, // card
      surfaceContainerHighest: Color(0xFFF1F5F9), // muted
      outline: Color(0xFFE2E8F0), // border
      error: Color(0xFFEF4444), // red-500
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: Color(0xFF1E293B)),
      titleTextStyle: TextStyle(
        color: Color(0xFF1E293B),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  // Tema oscuro (principal)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0F172A), // background dark
    colorScheme: const ColorScheme.dark(
      primary: _cyanPrimary,
      secondary: _purple500,
      surface: Color(0xFF1E293B), // card dark
      surfaceContainerHighest: Color(0xFF334155), // muted dark
      outline: Color(0xFF334155), // border dark
      error: Color(0xFFEF4444), // red-500
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E293B),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF334155), width: 1),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E293B),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  // Colores específicos del accent (para bottom nav)
  static const Color accentColor = Color(0xFF0891B2); // cyan-600 dark accent
  static const Color accentColorLight = Color(0xFF06B6D4); // cyan-500

  // Colores para métricas
  static const Color metricCyan = _cyanPrimary;
  static const Color metricPurple = _purple500;
  static const Color metricGreen = _green500;
  static const Color metricOrange = _orange500;

  // Text styles
  static const TextStyle h1 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyXSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle mono = TextStyle(
    fontFamily: 'monospace',
    fontSize: 14,
  );
}
