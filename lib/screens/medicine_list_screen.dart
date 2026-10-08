import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/medicine_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_view.dart';
import '../widgets/medicine_card.dart';

class MedicineListScreen extends StatefulWidget {
  const MedicineListScreen({super.key});

  @override
  State<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _query = '';
    });
  }

  Widget _buildSearchField() {
    Widget? clearButton;
    if (_query.isNotEmpty) {
      clearButton = IconButton(
        icon: const Icon(Icons.clear),
        tooltip: 'Clear search',
        onPressed: _clearSearch,
      );
    }

    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search medicines',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: clearButton,
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {
          _query = value;
        });
      },
    );
  }

  Widget _buildList(MedicineProvider provider) {
    if (provider.isLoading && provider.medicines.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return ErrorView(
        message: provider.errorMessage!,
        onRetry: provider.loadMedicines,
      );
    }

    if (provider.medicines.isEmpty) {
      return const EmptyState(
        icon: Icons.medication_outlined,
        title: 'No medicines yet',
        message: 'Tap + to add your first medicine',
      );
    }

    final medicines = provider.filterMedicines(_query, null, null);
    if (medicines.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off,
        title: 'No medicines match your search',
        message: 'Try a different name or filter.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 88),
      itemCount: medicines.length,
      itemBuilder: (context, index) {
        return MedicineCard(medicine: medicines[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MedicineProvider>();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildSearchField(),
            ),
            Expanded(child: _buildList(provider)),
          ],
        ),
      ),
    );
  }
}
