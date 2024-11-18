import 'package:pasti_track/core/database/db_local.dart';
import 'package:pasti_track/features/routines/domain/entities/routine.dart';

class RoutineLocalDataSource {
  final DBLocal database = DBLocal();

  RoutineLocalDataSource();

  Future<List<Routine>> getRoutines() async {
    final result = await database.getRoutines();
    return result.map((map_) {
      return Routine.fromMap(map_);
    }).toList();
  }

  Future<int> addRoutine(Routine routine) async {
    return await database.insertRoutine(routine.toMap());
  }

  Future<int> deleteRoutine(String id) async {
    return await database.deleteRoutine(id);
  }

  Future<int> updateRoutine(Routine Routine) async {
    return await database.updateRoutine(
        Routine.routineId, Routine.toJsonWithoutId());
  }
}
