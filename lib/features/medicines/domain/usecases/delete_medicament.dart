import 'package:pasti_track/features/medicines/domain/repositories/medicament_repository.dart';

class DeleteMedicamento {
  final MedicamentRepository repository;

  DeleteMedicamento(this.repository);

  Future<int> call(String id) async {
    return await repository.deleteMedicament(id);
  }
}
