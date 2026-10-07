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

  Future<int> insertMedicine(Medicine medicine) async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('next_id') ?? 1;
    final newMedicine = Medicine(
      id: id,
      name: medicine.name,
      dosage: medicine.dosage,
      quantity: medicine.quantity,
      lowStockAt: medicine.lowStockAt,
      expiryDate: medicine.expiryDate,
      forWhom: medicine.forWhom,
      notes: medicine.notes,
    );
    final medicines = await _readList();
    medicines.add(newMedicine);
    await _saveList(medicines);
    await prefs.setInt('next_id', id + 1);
    return id;
  }

  Future<void> updateMedicine(Medicine medicine) async {
    final medicines = await _readList();
    for (int i = 0; i < medicines.length; i++) {
      if (medicines[i].id == medicine.id) {
        medicines[i] = medicine;
      }
    }
    await _saveList(medicines);
  }

  Future<void> deleteMedicine(int id) async {
    final medicines = await _readList();
    final List<Medicine> kept = [];
    for (final medicine in medicines) {
      if (medicine.id != id) {
        kept.add(medicine);
      }
    }
    await _saveList(kept);
  }
}
