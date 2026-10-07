import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const medicalBlue = Color(0xFF1565C0);
  final colorScheme = ColorScheme.fromSeed(
    seedColor: medicalBlue,
    primary: medicalBlue,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
