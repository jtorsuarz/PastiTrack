import 'package:pasti_track/features/medicines/data/repositories/medicament_repository_impl.dart';
import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';

class GetAllMedicaments {
  final MedicamentRepositoryImpl repository;

  GetAllMedicaments(this.repository);

  Future<List<Medicament>> call() async {
    await repository.syncData();
    return await repository.getMedications();
  }
}
