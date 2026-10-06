import 'package:intl/intl.dart';

enum MedicineStatus { expired, expiringSoon, lowStock, ok }

DateTime dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

String statusLabel(MedicineStatus status) {
  if (status == MedicineStatus.expired) {
    return 'Expired';
  }
  if (status == MedicineStatus.expiringSoon) {
    return 'Expiring soon';
  }
  if (status == MedicineStatus.lowStock) {
    return 'Low stock';
  }
  return 'OK';
}

class Medicine {
  final int? id;
  final String name;
  final String dosage;
  final int quantity;
  final int lowStockAt;
  final DateTime expiryDate;
  final String forWhom;
  final String notes;

  Medicine({
    this.id,
    required this.name,
    required this.dosage,
    required this.quantity,
    required this.lowStockAt,
    required this.expiryDate,
    required this.forWhom,
    required this.notes,
  });

  bool isExpired(DateTime today) {
    return dateOnly(expiryDate).isBefore(dateOnly(today));
  }

  bool isExpiringSoon(DateTime today) {
    if (isExpired(today)) {
      return false;
    }
    final lastDay = DateTime(today.year, today.month, today.day + 30);
    return !dateOnly(expiryDate).isAfter(lastDay);
  }

  bool get isLowStock {
    return quantity <= lowStockAt;
  }

  MedicineStatus status(DateTime today) {
    if (isExpired(today)) {
      return MedicineStatus.expired;
    }
    if (isExpiringSoon(today)) {
      return MedicineStatus.expiringSoon;
    }
    if (isLowStock) {
      return MedicineStatus.lowStock;
    }
    return MedicineStatus.ok;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'quantity': quantity,
      'low_stock_at': lowStockAt,
      'expiry_date': DateFormat('yyyy-MM-dd').format(expiryDate),
      'for_whom': forWhom,
      'notes': notes,
    };
  }

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      dosage: json['dosage'],
      quantity: json['quantity'],
      lowStockAt: json['low_stock_at'],
      expiryDate: DateFormat('yyyy-MM-dd').parse(json['expiry_date']),
      forWhom: json['for_whom'],
      notes: json['notes'],
    );
  }
}
