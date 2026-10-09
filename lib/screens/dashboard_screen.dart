import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/medicine.dart';
import '../providers/medicine_provider.dart';
import '../theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Widget _buildTile(
    BuildContext context,
    String key,
    String label,
    int count,
    MedicineStatus status,
  ) {
    final color = statusColor(status);
    return Expanded(
      child: Card(
        key: Key(key),
        color: color.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Text('$count', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MedicineProvider>();

    Widget body;
    if (provider.isLoading && provider.medicines.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    } else if (provider.errorMessage != null) {
      body = ErrorView(
        message: provider.errorMessage!,
        onRetry: provider.loadMedicines,
      );
    } else if (provider.medicines.isEmpty) {
      body = const EmptyState(
        icon: Icons.medication_outlined,
        title: 'No medicines yet',
        message: 'Tap + to add your first medicine',
      );
    } else {
      final today = DateTime.now();
      final expired = provider.expiredMedicines(today);
      final expiringSoon = provider.expiringSoonMedicines(today);
      final lowStock = provider.lowStockMedicines(today);

      body = ListView(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 88),
        children: [
          Row(
            children: [
              _buildTile(
                context,
                'expired-tile',
                'Expired',
                expired.length,
                MedicineStatus.expired,
              ),
              _buildTile(
                context,
                'expiring-tile',
                'Expiring soon',
                expiringSoon.length,
                MedicineStatus.expiringSoon,
              ),
              _buildTile(
                context,
                'low-stock-tile',
                'Running low',
                lowStock.length,
                MedicineStatus.lowStock,
              ),
            ],
          ),
        ],
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: body,
      ),
    );
  }
}
