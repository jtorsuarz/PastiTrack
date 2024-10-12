import 'package:pasti_track/core/database/db_remote.dart';
import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';

class MedicamentRemoteDataSource {
  final DBRemote dbremote = DBRemote();

  MedicamentRemoteDataSource();

  Future<void> addMedicament(Medicament medicament) async {
    await dbremote.addMedicament(medicament.medicineId, {
      'name': medicament.name,
      'dose': medicament.dose,
      'description': medicament.description,
    });
  }

  Future<void> deleteMedicament(String id) async {
    await dbremote.deleteMedicament(id);
  }

  Future<void> updateMedicament(Medicament medicament) async {
    await dbremote.updateMedicament(medicament.medicineId, {
      'name': medicament.name,
      'dose': medicament.dose,
      'description': medicament.description,
    });
  }
}
