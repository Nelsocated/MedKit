import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/medicine.dart';

class StorageService {
  Future<List<Medicine>> _readList() async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString('medicines');
    final List<Medicine> medicines = [];
    if (text == null) {
      return medicines;
    }
    final List<dynamic> maps = jsonDecode(text);
    for (final map in maps) {
      medicines.add(Medicine.fromJson(map));
    }
    return medicines;
  }

  Future<void> _saveList(List<Medicine> medicines) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> maps = [];
    for (final medicine in medicines) {
      maps.add(medicine.toJson());
    }
    await prefs.setString('medicines', jsonEncode(maps));
  }

  Future<List<Medicine>> getMedicines() async {
    final medicines = await _readList();
    medicines.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
    return medicines;
  }
}
