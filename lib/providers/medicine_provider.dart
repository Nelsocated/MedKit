import 'package:flutter/foundation.dart';

import '../models/medicine.dart';
import '../services/storage_service.dart';

class MedicineProvider extends ChangeNotifier {
  final StorageService storage;

  List<Medicine> medicines = [];
  bool isLoading = true;
  String? errorMessage;

  MedicineProvider(this.storage);

  Future<void> loadMedicines() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      medicines = await storage.getMedicines();
    } catch (error) {
      errorMessage = 'Could not load your medicines.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMedicine(Medicine medicine) async {
    await storage.insertMedicine(medicine);
    await loadMedicines();
  }

  Future<void> updateMedicine(Medicine medicine) async {
    await storage.updateMedicine(medicine);
    await loadMedicines();
  }

  Future<void> deleteMedicine(int id) async {
    await storage.deleteMedicine(id);
    await loadMedicines();
  }
}
