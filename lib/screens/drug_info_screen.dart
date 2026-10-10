import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/drug_info_provider.dart';
import '../widgets/drug_info_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_view.dart';

class DrugInfoScreen extends StatefulWidget {
  final String? initialQuery;
  final bool showAppBar;

  const DrugInfoScreen({super.key, this.initialQuery, this.showAppBar = false});

  @override
  State<DrugInfoScreen> createState() => _DrugInfoScreenState();
}

class _DrugInfoScreenState extends State<DrugInfoScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initialQuery = widget.initialQuery;
    if (initialQuery != null) {
      _searchController.text = initialQuery;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<DrugInfoProvider>().search(initialQuery);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    context.read<DrugInfoProvider>().search(_searchController.text);
  }

  Widget _buildSearchRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              hintText: 'Medicine name, e.g. ibuprofen',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _search();
            },
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          icon: const Icon(Icons.search),
          tooltip: 'Search',
          onPressed: _search,
        ),
      ],
    );
  }

  Widget _buildResults(DrugInfoProvider provider) {
    if (provider.state == SearchState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.state == SearchState.empty) {
      return const EmptyState(
        icon: Icons.search_off,
        title: 'No results',
        message:
            'Try the generic US name, e.g. acetaminophen instead of paracetamol.',
      );
    }

    if (provider.state == SearchState.error) {
      return ErrorView(
        message: provider.errorMessage,
        onRetry: () {
          provider.search(provider.lastQuery);
        },
      );
    }

    if (provider.state == SearchState.success) {
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
        itemCount: provider.results.length,
        itemBuilder: (context, index) {
          return DrugInfoCard(info: provider.results[index]);
        },
      );
    }

    return const EmptyState(
      icon: Icons.medication_liquid,
      title: 'Search for a medicine',
      message: "Find what it's for, how to take it and its warnings.",
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DrugInfoProvider>();

    final body = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _buildSearchRow(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'For information only. Ask a pharmacist or doctor before taking any medicine.',
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ),
            Expanded(child: _buildResults(provider)),
          ],
        ),
      ),
    );

    if (widget.showAppBar) {
      return Scaffold(
        appBar: AppBar(title: const Text('Drug Info')),
        body: body,
      );
    }
    return body;
  }
}
