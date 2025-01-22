import 'package:connectivity_plus/connectivity_plus.dart';
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
  final Connectivity _connectivity = Connectivity();

  MedicamentRepositoryImpl(
    this.localDB,
    this.remoteDB,
  );

  Future<void> initialize() async {
    if (await isConnected()) {
      await syncData();
    }
  }

  Future<bool> isConnected() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult.first != ConnectivityResult.none;
  }

  @override
  Future<List<Medicament>> getMedications() async {
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
      final result = await localDB.addMedicament(medicament);
      if (await isConnected()) await remoteDB.addMedicament(medicament);
      AppLogger.p("Medicament", "addMedicament ");
      return result;
    } catch (e) {
      AppLogger.p("Catch Medicament", "addMedicament ${e.toString()}");
      throw Failure(AppString.errorWhenCreate(AppString.medicament));
    }
  }

  @override
  Future<int> updateMedicament(Medicament medicament) async {
    try {
      final result = await localDB.updateMedicament(medicament);
      if (await isConnected()) await remoteDB.updateMedicament(medicament);
      AppLogger.p("Medicament", "updateMedicament $result");
      return result;
    } catch (e) {
      AppLogger.p("Catch Medicament", "updateMedicament ${e.toString()}");
      throw Failure(AppString.errorWhenUpdate(AppString.medicament));
    }
  }

  @override
  Future<int> deleteMedicament(String id) async {
    try {
      if (await isConnected()) {
        final result = await localDB.deleteMedicament(id);
        await remoteDB.deleteMedicament(id);
        AppLogger.p("Medicament", "deleteMedicament $result");
        return result;
      } else {
        throw Failure(AppString.errorWhenDelete(
            AppString.canNotBeActionCheckYourConnectivityTryAgain));
      }
    } on Failure catch (e) {
      AppLogger.p("Catch Medicament Failure", "deleteMedicament ${e.message}");
      throw Failure(e.message);
    } catch (e) {
      AppLogger.p("Catch Medicament", "deleteMedicament ${e.toString()}");
      throw Failure(AppString.errorWhenDelete(AppString.medicament));
    }
  }

  Future<void> syncData() async {
    if (await isConnected()) {
      List<Medicament> localMeds = await getMedications();
      List<Medicament> remoteMeds = await remoteDB.getMedications();

      Map<String, Medicament> remoteMedMap = {
        for (var med in remoteMeds) med.medicineId: med
      };

      for (var localMed in localMeds) {
        if (remoteMedMap.containsKey(localMed.medicineId)) {
          Medicament remoteMed = remoteMedMap[localMed.medicineId]!;

          DateTime localDate = DateTime.parse(localMed.dateUpdated);
          DateTime remoteDate = DateTime.parse(remoteMed.dateUpdated);

          if (localDate.isAfter(remoteDate)) {
            await remoteDB.updateMedicament(localMed);
          } else if (remoteDate.isAfter(localDate)) {
            await localDB.updateMedicament(remoteMed);
          }
          remoteMedMap.remove(localMed.medicineId);
        } else {
          await remoteDB.addMedicament(localMed);
        }
      }

      for (var med in remoteMedMap.values) {
        await localDB.addMedicament(med);
      }
    }
  }
}
