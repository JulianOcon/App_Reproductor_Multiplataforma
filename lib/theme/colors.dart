import 'package:flutter/material.dart';

class AppColors {
  // Paleta base
  static const Color primaryColor   = Color(0xFF00E676);
  static const Color secondaryColor = Color(0xFF1DE9B6);

  // Fondo
  static const Color background     = Color(0xFF121212);

  // Texto
  static const Color textColor      = Colors.white;

  /* ---------- NUEVOS ---------- */
  /// Color de las etiquetas (labelText) en los `TextField`
  static const Color labelColor = Colors.white70;

  /// Relleno oscuro de los campos de texto
  static const Color fieldFill  = Color(0xFF1E1E1E);

  /// Rojo profundo estilo Persona 5
  static const Color deepRed = Color(0xFFB00020);

  /// Fondo oscuro para contrastar con el arte
  static const Color darkBackground = Color(0xFF1C1C1E);

  /* --- alias por compatibilidad --- */
  static const Color accentColor      = secondaryColor;
  static const Color backgroundColor  = background;
}
