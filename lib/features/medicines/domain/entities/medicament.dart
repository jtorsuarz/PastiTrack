class Medicament {
  final String medicineId;
  final String name;
  final String dose;
  final String dateUpdated;
  final String? description;

  Medicament({
    required this.medicineId,
    required this.name,
    required this.dose,
    required this.dateUpdated,
    this.description,
  });

  Medicament copyWith({
    String? medicineId,
    String? name,
    String? dose,
    String? description,
    String? dateUpdated,
  }) {
    return Medicament(
      medicineId: medicineId ?? this.medicineId,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicine_id': medicineId,
      'name': name,
      'dose': dose,
      'description': description ?? '',
      'date_updated': dateUpdated,
    };
  }

  Map<String, dynamic> toJsonWithoutId() {
    return {
      'name': name,
      'dose': dose,
      'description': description ?? '',
      'date_updated': dateUpdated,
    };
  }

  factory Medicament.fromJson(Map<String, dynamic> json) {
    return Medicament(
      medicineId: json['medicine_id'] as String,
      name: json['name'],
      dose: json['dose'],
      description: json['description'] ?? '',
      dateUpdated: json['date_updated'] as String,
    );
  }
}
