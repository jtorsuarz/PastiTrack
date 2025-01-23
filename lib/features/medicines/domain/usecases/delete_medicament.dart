import 'package:pasti_track/features/medicines/data/repositories/medicament_repository_impl.dart';

class DeleteMedicament {
  final MedicamentRepositoryImpl repository;

  DeleteMedicament(this.repository);

  Future<int> call(String id) async {
    return await repository.deleteMedicament(id);
  }
}
