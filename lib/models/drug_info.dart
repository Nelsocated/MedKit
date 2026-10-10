String _firstText(Map<String, dynamic> map, String key) {
  final value = map[key];
  if (value is List && value.isNotEmpty) {
    return value[0].toString();
  }
  return '';
}

class DrugInfo {
  final String brandName;
  final String genericName;
  final String manufacturer;
  final String purpose;
  final String dosage;
  final String warnings;

  DrugInfo({
    required this.brandName,
    required this.genericName,
    required this.manufacturer,
    required this.purpose,
    required this.dosage,
    required this.warnings,
  });

  factory DrugInfo.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> openfda = {};
    if (json['openfda'] is Map<String, dynamic>) {
      openfda = json['openfda'];
    }

    String purpose = _firstText(json, 'purpose');
    if (purpose == '') {
      purpose = _firstText(json, 'indications_and_usage');
    }

    return DrugInfo(
      brandName: _firstText(openfda, 'brand_name'),
      genericName: _firstText(openfda, 'generic_name'),
      manufacturer: _firstText(openfda, 'manufacturer_name'),
      purpose: purpose,
      dosage: _firstText(json, 'dosage_and_administration'),
      warnings: _firstText(json, 'warnings'),
    );
  }
}
