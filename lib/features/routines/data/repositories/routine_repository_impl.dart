import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/errors/failures.dart';
import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:pasti_track/features/routines/data/datasources/routine_local_datasource.dart';
import 'package:pasti_track/features/routines/data/datasources/routine_remote_datasource.dart';
import 'package:pasti_track/features/routines/domain/entities/routine.dart';
import 'package:pasti_track/features/routines/domain/repositories/routine_repository.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  final RoutineLocalDataSource localDB;
  final RoutineRemoteDataSource remoteDB;
  final Connectivity _connectivity = Connectivity();

  RoutineRepositoryImpl(
    this.localDB,
    this.remoteDB,
  );

  Future<bool> isConnected() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult.first != ConnectivityResult.none;
  }

  @override
  Future<List<Routine>> getRoutines() async {
    try {
      final localRoutines = await localDB.getRoutines();
      AppLogger.p("Routine getRoutines", localRoutines);
      return localRoutines;
    } catch (e) {
      AppLogger.p("Catch Routine", "getRoutines ${e.toString()}");
      throw Failure(AppString.errorWhenLoad(AppString.routines));
    }
  }

  @override
  Future<int> addRoutine(Routine routines) async {
    try {
      final result = await localDB.addRoutine(routines);
      if (await isConnected()) await remoteDB.addRoutine(routines);
      AppLogger.p("Routine", "addRoutine ");
      return result;
    } catch (e) {
      AppLogger.p("Catch Routine", "addRoutine ${e.toString()}");
      throw Failure(AppString.errorWhenCreate(AppString.routines));
    }
  }

  @override
  Future<int> updateRoutine(Routine routines) async {
    try {
      final result = await localDB.updateRoutine(routines);
      if (await isConnected()) await remoteDB.updateRoutine(routines);
      AppLogger.p("Routine", "updateRoutine $result");
      return result;
    } catch (e) {
      AppLogger.p("Catch Routine", "updateRoutine ${e.toString()}");
      throw Failure(AppString.errorWhenUpdate(AppString.routines));
    }
  }

  @override
  Future<int> deleteRoutine(String id) async {
    try {
      if (await isConnected()) {
        final result = await localDB.deleteRoutine(id);
        await remoteDB.deleteRoutine(id);
        AppLogger.p("Routine", "deleteRoutine $result");
        return result;
      } else {
        throw Failure(AppString.errorWhenDelete(
            AppString.canNotBeActionCheckYourConnectivityTryAgain));
      }
    } on Failure catch (e) {
      AppLogger.p("Catch Routine Failure", "deleteRoutine ${e.message}");
      throw Failure(e.message);
    } catch (e) {
      AppLogger.p("Catch Routine", "deleteRoutine ${e.toString()}");
      throw Failure(AppString.errorWhenDelete(AppString.routines));
    }
  }

  Future<void> syncData() async {
    if (await isConnected()) {
      List<Routine> localRouts = await getRoutines();
      List<Routine> remoteRouts = await remoteDB.getRoutines();

      Map<String, Routine> remoteRouMap = {
        for (var rout in remoteRouts) rout.routineId: rout
      };

      for (var localRout in localRouts) {
        if (remoteRouMap.containsKey(localRout.routineId)) {
          Routine remoteRout = remoteRouMap[localRout.routineId]!;

          DateTime localDate = DateTime.parse(localRout.dateUpdated);
          DateTime remoteDate = DateTime.parse(remoteRout.dateUpdated);

          if (localDate.isAfter(remoteDate)) {
            await remoteDB.updateRoutine(localRout);
          } else if (remoteDate.isAfter(localDate)) {
            await localDB.updateRoutine(remoteRout);
          }
          remoteRouMap.remove(localRout.medicineId);
        } else {
          await remoteDB.addRoutine(localRout);
        }
      }

      for (var med in remoteRouMap.values) {
        await localDB.addRoutine(med);
      }
    }
  }
}
