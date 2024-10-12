import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';

abstract class MedicamentRepository {
  Future<List<Medicament>> getMedications();
  Future<int> addMedicament(Medicament medicament);
  Future<int> updateMedicament(Medicament medicament);
  Future<int> deleteMedicament(String id);
}
