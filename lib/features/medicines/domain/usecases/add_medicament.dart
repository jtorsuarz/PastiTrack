import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';
import 'package:pasti_track/features/medicines/domain/repositories/medicament_repository.dart';

class AddMedicament {
  final MedicamentRepository repository;

  AddMedicament(this.repository);

  Future<int> call(Medicament medicament) async {
    return await repository.addMedicament(medicament);
  }
}
