import 'package:pasti_track/core/database/db_remote.dart';
import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';

class MedicamentRemoteDataSource {
  final DBRemote dbremote = DBRemote();

  MedicamentRemoteDataSource();

  Future<List<Medicament>> getMedications() async {
    final querySnapshot = await dbremote.getmedicines();
    return querySnapshot.docs.map((doc) {
      var m = doc.data() as Map<String, dynamic>;
      m['medicine_id'] = doc.id;
      return Medicament.fromJson(m);
    }).toList();
  }

  Future<void> addMedicament(Medicament medicament) async {
    await dbremote.addMedicament(
        medicament.medicineId, medicament.toJsonWithoutId());
  }

  Future<void> deleteMedicament(String id) async {
    await dbremote.deleteMedicament(id);
  }

  Future<void> updateMedicament(Medicament medicament) async {
    await dbremote.updateMedicament(
        medicament.medicineId, medicament.toJsonWithoutId());
  }
}
