import 'package:flutter/material.dart';
import 'colors.dart';

/// Tema global de la app.
/// Llama [AppTheme.lightTheme] en `MaterialApp.theme`.
class AppTheme {
  AppTheme._(); // Evita instancias accidentales

  /// Tema claro PRINCIPAL (estamos usando `useMaterial3`).
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,

    // Paleta base
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      primary:    AppColors.primaryColor,
      secondary:  AppColors.secondaryColor,
      background: AppColors.background,
      brightness: Brightness.dark, // Mantiene look oscuro
    ),

    scaffoldBackgroundColor: AppColors.background,

    // Tipografía
    textTheme: const TextTheme(
      bodyLarge:  TextStyle(color: AppColors.textColor, fontSize: 16),
      bodyMedium: TextStyle(color: AppColors.textColor, fontSize: 14),
    ),

    // Botones elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),

    // Campos de texto
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      labelStyle: const TextStyle(color: Colors.white70),
    ),
  );

  /* Opcional: un darkTheme distinto si quisieras alternar */
  static ThemeData get darkTheme => lightTheme.copyWith(
    brightness: Brightness.dark,
  );
}
