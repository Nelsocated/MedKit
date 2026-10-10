import 'package:flutter/foundation.dart';

import '../models/drug_info.dart';
import '../services/drug_info_service.dart';

enum SearchState { idle, loading, success, empty, error }

class DrugInfoProvider extends ChangeNotifier {
  final DrugInfoService service;

  SearchState state = SearchState.idle;
  List<DrugInfo> results = [];
  String errorMessage = '';
  String lastQuery = '';

  DrugInfoProvider(this.service);

  Future<void> search(String name) async {
    final query = name.trim();
    if (query.isEmpty) {
      return;
    }

    lastQuery = query;
    state = SearchState.loading;
    notifyListeners();

    try {
      final found = await service.search(query);
      results = found;
      if (found.isEmpty) {
        state = SearchState.empty;
      } else {
        state = SearchState.success;
      }
    } catch (error) {
      results = [];
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      state = SearchState.error;
    }
    notifyListeners();
  }
}
