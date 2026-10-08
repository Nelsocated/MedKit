import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/medicine.dart';
import '../routes.dart';
import 'status_badge.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;

  const MedicineCard({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    String whoLine = medicine.forWhom;
    if (medicine.dosage.isNotEmpty) {
      whoLine = '${medicine.dosage} · ${medicine.forWhom}';
    }
    final expiry = DateFormat('MMM d, yyyy').format(medicine.expiryDate);

    return Card(
      child: ListTile(
        title: Text(
          medicine.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(whoLine),
            Text('Expires $expiry · Qty ${medicine.quantity}'),
          ],
        ),
        isThreeLine: true,
        trailing: StatusBadge(status: medicine.status(DateTime.now())),
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.medicineDetail,
            arguments: medicine.id,
          );
        },
      ),
    );
  }
}
