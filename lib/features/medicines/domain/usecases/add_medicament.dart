import 'package:pasti_track/features/medicines/data/repositories/medicament_repository_impl.dart';
import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';

class AddMedicament {
  final MedicamentRepositoryImpl repository;

  AddMedicament(this.repository);

  Future<int> call(Medicament medicament) async {
    return await repository.addMedicament(medicament);
  }
}
