import 'package:flutter/material.dart';

import '../models/medicine.dart';
import '../theme.dart';

class StatusBadge extends StatelessWidget {
  final MedicineStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor(status),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusLabel(status),
        style: TextStyle(
          color: statusTextColor(status),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
