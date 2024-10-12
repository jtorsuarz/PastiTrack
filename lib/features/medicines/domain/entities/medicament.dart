class Medicament {
  final String medicineId;
  final String name;
  final String dose;
  final String? description;

  Medicament({
    required this.medicineId,
    required this.name,
    required this.dose,
    this.description,
  });
}
