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

  List<Medicine> _medicinesWithStatus(MedicineStatus status, DateTime today) {
    final List<Medicine> result = [];
    for (final medicine in medicines) {
      if (medicine.status(today) == status) {
        result.add(medicine);
      }
    }
    return result;
  }

  List<Medicine> expiredMedicines(DateTime today) {
    return _medicinesWithStatus(MedicineStatus.expired, today);
  }

  List<Medicine> expiringSoonMedicines(DateTime today) {
    return _medicinesWithStatus(MedicineStatus.expiringSoon, today);
  }

  List<Medicine> lowStockMedicines(DateTime today) {
    return _medicinesWithStatus(MedicineStatus.lowStock, today);
  }

  List<String> familyMembers() {
    final List<String> members = [];
    for (final medicine in medicines) {
      if (!members.contains(medicine.forWhom)) {
        members.add(medicine.forWhom);
      }
    }
    members.sort();
    return members;
  }

  Medicine? findById(int id) {
    for (final medicine in medicines) {
      if (medicine.id == id) {
        return medicine;
      }
    }
    return null;
  }

  List<Medicine> filterMedicines(
    String query,
    MedicineStatus? status,
    String? member,
  ) {
    final today = DateTime.now();
    final lowerQuery = query.trim().toLowerCase();
    final List<Medicine> result = [];
    for (final medicine in medicines) {
      if (!medicine.name.toLowerCase().contains(lowerQuery)) {
        continue;
      }
      if (status != null && medicine.status(today) != status) {
        continue;
      }
      if (member != null && medicine.forWhom != member) {
        continue;
      }
      result.add(medicine);
    }
    return result;
  }
}
