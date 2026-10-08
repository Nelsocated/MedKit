import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/medicine.dart';
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
  MedicineStatus? _status;
  String? _member;

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

  Widget _buildStatusChip(String label, MedicineStatus? status) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: _status == status,
        onSelected: (selected) {
          setState(() {
            _status = status;
          });
        },
      ),
    );
  }

  Widget _buildFilters(List<String> members, String? member) {
    final List<Widget> chips = [_buildStatusChip('All', null)];
    final statuses = [
      MedicineStatus.expired,
      MedicineStatus.expiringSoon,
      MedicineStatus.lowStock,
    ];
    for (final status in statuses) {
      chips.add(_buildStatusChip(statusLabel(status), status));
    }

    final List<DropdownMenuItem<String?>> memberItems = [
      const DropdownMenuItem(value: null, child: Text('Everyone')),
    ];
    for (final name in members) {
      memberItems.add(DropdownMenuItem(value: name, child: Text(name)));
    }

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: chips),
          ),
        ),
        const SizedBox(width: 8),
        DropdownButton<String?>(
          value: member,
          items: memberItems,
          onChanged: (value) {
            setState(() {
              _member = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildList(MedicineProvider provider, String? member) {
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

    final medicines = provider.filterMedicines(_query, _status, member);
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
    final members = provider.familyMembers();
    String? member = _member;
    if (member != null && !members.contains(member)) {
      member = null;
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildSearchField(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: _buildFilters(members, member),
            ),
            Expanded(child: _buildList(provider, member)),
          ],
        ),
      ),
    );
  }
}
