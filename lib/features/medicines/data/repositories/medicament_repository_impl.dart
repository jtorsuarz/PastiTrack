import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/errors/failures.dart';
import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:pasti_track/features/medicines/data/datasources/medicament_local_datasource.dart';
import 'package:pasti_track/features/medicines/data/datasources/medicament_remote_datasource.dart';
import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';
import 'package:pasti_track/features/medicines/domain/repositories/medicament_repository.dart';

class MedicamentRepositoryImpl implements MedicamentRepository {
  final MedicamentLocalDataSource localDB;
  final MedicamentRemoteDataSource remoteDB;

  MedicamentRepositoryImpl(
    this.localDB,
    this.remoteDB,
  );

  @override
  Future<List<Medicament>> getMedications() async {
    AppLogger.p(" Medicament", getMedications);

    try {
      final localMedications = await localDB.getMedications();
      AppLogger.p("Medicament getMedications", localMedications);
      return localMedications;
    } catch (e) {
      AppLogger.p("Catch Medicament", "getMedications ${e.toString()}");
      throw Failure(AppString.errorWhenLoad(AppString.medicaments));
    }
  }

  @override
  Future<int> addMedicament(Medicament medicament) async {
    try {
      final result1 = await localDB.addMedicament(medicament);
      await remoteDB.addMedicament(medicament);
      AppLogger.p("Medicament", "addMedicament ");
      return result1;
    } catch (e) {
      AppLogger.p("Catch Medicament", "addMedicament ${e.toString()}");
      throw Failure(AppString.errorWhenCreate(AppString.medicament));
    }
  }

  @override
  Future<int> deleteMedicament(String id) async {
    try {
      final result = await localDB.deleteMedicament(id);
      await remoteDB.deleteMedicament(id);
      AppLogger.p("Medicament", "deleteMedicament $result");
      return result;
    } catch (e) {
      AppLogger.p("Catch Medicament", "deleteMedicament ${e.toString()}");
      throw Failure(AppString.errorWhenDelete(AppString.medicament));
    }
  }

  @override
  Future<int> updateMedicament(Medicament medicament) async {
    try {
      final result = await localDB.updateMedicament(medicament);
      await remoteDB.updateMedicament(medicament);
      AppLogger.p("Medicament", "updateMedicament $result");
      return result;
    } catch (e) {
      AppLogger.p("Catch Medicament", "updateMedicament ${e.toString()}");
      throw Failure(AppString.errorWhenUpdate(AppString.medicament));
    }
  }
}
