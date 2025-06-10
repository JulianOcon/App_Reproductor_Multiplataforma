import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        primary: AppColors.primaryColor,
        secondary: AppColors.accentColor,
        background: AppColors.backgroundColor,
      ),
      scaffoldBackgroundColor: AppColors.backgroundColor,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16, color: AppColors.textColor),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.textColor),
      ),
    );
  }
}
