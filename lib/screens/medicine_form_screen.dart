import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/medicine.dart';

class MedicineFormScreen extends StatefulWidget {
  final Medicine? medicine;

  const MedicineFormScreen({super.key, this.medicine});

  @override
  State<MedicineFormScreen> createState() => _MedicineFormScreenState();
}

class _MedicineFormScreenState extends State<MedicineFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _quantityController = TextEditingController();
  final _lowStockController = TextEditingController(text: '5');
  final _expiryController = TextEditingController();
  final _forWhomController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _expiryDate;

  @override
  void initState() {
    super.initState();
    final medicine = widget.medicine;
    if (medicine != null) {
      _nameController.text = medicine.name;
      _dosageController.text = medicine.dosage;
      _quantityController.text = medicine.quantity.toString();
      _lowStockController.text = medicine.lowStockAt.toString();
      _forWhomController.text = medicine.forWhom;
      _notesController.text = medicine.notes;
      _setExpiryDate(medicine.expiryDate);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _quantityController.dispose();
    _lowStockController.dispose();
    _expiryController.dispose();
    _forWhomController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _setExpiryDate(DateTime date) {
    _expiryDate = date;
    _expiryController.text = DateFormat('MMM d, yyyy').format(date);
  }

  Future<void> _pickExpiryDate() async {
    DateTime initialDate = DateTime.now();
    if (_expiryDate != null) {
      initialDate = _expiryDate!;
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _setExpiryDate(picked);
      });
    }
  }

  String? _validateRequired(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  String? _validateWholeNumber(String? value) {
    if (value == null) {
      return 'Enter a whole number (0 or more)';
    }
    final number = int.tryParse(value.trim());
    if (number == null || number < 0) {
      return 'Enter a whole number (0 or more)';
    }
    return null;
  }

  String? _validateExpiryDate(String? value) {
    if (_expiryDate == null) {
      return 'Please pick an expiry date';
    }
    return null;
  }

  void _save() {
    _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Add Medicine';
    if (widget.medicine != null) {
      title = 'Edit Medicine';
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      _validateRequired(value, 'Please enter a name'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _dosageController,
                  decoration: const InputDecoration(
                    labelText: 'Dosage',
                    hintText: 'e.g. 500 mg',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  validator: _validateWholeNumber,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _lowStockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Low stock alert at',
                  ),
                  validator: _validateWholeNumber,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _expiryController,
                  readOnly: true,
                  onTap: _pickExpiryDate,
                  decoration: const InputDecoration(
                    labelText: 'Expiry date',
                    helperText:
                        'If the pack shows only month and year, pick the last day of that month.',
                    helperMaxLines: 2,
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: _validateExpiryDate,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _forWhomController,
                  decoration: const InputDecoration(
                    labelText: 'For whom',
                    hintText: 'e.g. Mom, Everyone',
                  ),
                  validator: (value) =>
                      _validateRequired(value, 'Please enter who it is for'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _save,
                  child: const Text('Save medicine'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
