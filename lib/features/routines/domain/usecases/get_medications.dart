import 'package:pasti_track/features/medicines/data/repositories/medicament_repository_impl.dart';
import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';

class GetAllMedications {
  final MedicamentRepositoryImpl repository;

  GetAllMedications(this.repository);

  Future<List<Medicament>> call() async {
    await repository.syncData();
    return await repository.getMedications();
  }
}
