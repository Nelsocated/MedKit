import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/medicine_provider.dart';
import '../routes.dart';
import '../widgets/empty_state.dart';
import '../widgets/status_badge.dart';

class MedicineDetailScreen extends StatelessWidget {
  final int medicineId;

  const MedicineDetailScreen({super.key, required this.medicineId});

  Widget _buildRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: TextStyle(color: Colors.grey[700])),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete this medicine?'),
          content: const Text('This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !context.mounted) {
      return;
    }

    final provider = context.read<MedicineProvider>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    navigator.pop();
    try {
      await provider.deleteMedicine(medicineId);
      messenger.showSnackBar(const SnackBar(content: Text('Medicine deleted')));
    } catch (error) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not delete the medicine.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final medicine = context.watch<MedicineProvider>().findById(medicineId);

    if (medicine == null) {
      final route = ModalRoute.of(context);
      if (route != null && !route.isCurrent) {
        return const Scaffold();
      }
      return Scaffold(
        appBar: AppBar(title: const Text('Medicine')),
        body: const EmptyState(
          icon: Icons.delete_outline,
          title: 'This medicine was removed',
          message: 'Go back to see your other medicines.',
        ),
      );
    }

    String dosage = medicine.dosage;
    if (dosage.isEmpty) {
      dosage = 'Not set';
    }
    String notes = medicine.notes;
    if (notes.isEmpty) {
      notes = 'No notes';
    }
    final expiry = DateFormat('MMM d, yyyy').format(medicine.expiryDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(medicine.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routes.medicineForm,
                arguments: medicine,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: () {
              _confirmDelete(context);
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: StatusBadge(status: medicine.status(DateTime.now())),
              ),
              const SizedBox(height: 8),
              _buildRow(context, 'Dosage', dosage),
              _buildRow(context, 'Quantity', '${medicine.quantity}'),
              _buildRow(
                context,
                'Low stock alert at',
                '${medicine.lowStockAt}',
              ),
              _buildRow(context, 'Expires', expiry),
              _buildRow(context, 'For whom', medicine.forWhom),
              _buildRow(context, 'Notes', notes),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.search),
                label: const Text('Look up drug info'),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.drugInfo,
                    arguments: medicine.name,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
