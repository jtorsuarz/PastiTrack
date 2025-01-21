import 'package:pasti_track/core/database/db_local.dart';
import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';

class MedicamentLocalDataSource {
  final DBLocal database = DBLocal();

  MedicamentLocalDataSource();

  Future<List<Medicament>> getMedications() async {
    final result = await database.getmedicines();
    return result.map((json) {
      return Medicament.fromJson(json);
    }).toList();
  }

  Future<Medicament> getMedicationById(String id) async {
    final json = await database.getMedicamentById(id);
    return Medicament.fromJson(json!);
  }

  Future<int> addMedicament(Medicament medicament) async {
    return await database.insertMedicament(medicament.toJson());
  }

  Future<int> deleteMedicament(String id) async {
    return await database.deleteMedicament(id);
  }

  Future<int> updateMedicament(Medicament medicament) async {
    return await database.updateMedicament(
        medicament.medicineId, medicament.toJsonWithoutId());
  }
}
