import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';
import 'package:pasti_track/features/medicines/domain/repositories/medicament_repository.dart';

class GetMedications {
  final MedicamentRepository repository;

  GetMedications(this.repository);

  Future<List<Medicament>> call() async {
    return await repository.getMedications();
  }
}
