import 'package:flutter/material.dart';

import 'models/medicine.dart';

Color statusColor(MedicineStatus status) {
  if (status == MedicineStatus.expired) {
    return const Color(0xFFC62828);
  }
  if (status == MedicineStatus.expiringSoon) {
    return const Color(0xFFEF6C00);
  }
  if (status == MedicineStatus.lowStock) {
    return const Color(0xFFF9A825);
  }
  return const Color(0xFF2E7D32);
}

Color statusTextColor(MedicineStatus status) {
  if (status == MedicineStatus.expiringSoon ||
      status == MedicineStatus.lowStock) {
    return const Color(0xFF3E2700);
  }
  return Colors.white;
}

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
