import 'package:pasti_track/core/database/db_local.dart';
import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';

class MedicamentLocalDataSource {
  final DBLocal database = DBLocal();

  MedicamentLocalDataSource();

  Future<List<Medicament>> getMedications() async {
    final result = await database.getmedicines();
    return result
        .map((json) => Medicament(
              medicineId: json['medicine_id'] as String,
              name: json['name'] as String,
              dose: json['dose'] as String,
              description: json['description'] as String,
            ))
        .toList();
  }

  Future<int> addMedicament(Medicament medicament) async {
    return await database.insertMedicament({
      'medicine_id': medicament.medicineId,
      'name': medicament.name,
      'dose': medicament.dose,
      'description': medicament.description,
    });
  }

  Future<int> deleteMedicament(String id) async {
    return await database.deleteMedicament(id);
  }

  Future<int> updateMedicament(Medicament medicament) async {
    return await database.updateMedicament({
      'name': medicament.name,
      'dose': medicament.dose,
      'description': medicament.description,
    }, medicament.medicineId);
  }
}
