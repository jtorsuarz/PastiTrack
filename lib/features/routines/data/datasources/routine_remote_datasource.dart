import 'package:pasti_track/core/database/db_remote.dart';
import 'package:pasti_track/features/routines/domain/entities/routine.dart';

class RoutineRemoteDataSource {
  final DBRemote dbremote = DBRemote();

  RoutineRemoteDataSource();

  Future<List<Routine>> getRoutines() async {
    final querySnapshot = await dbremote.getRoutines();
    return querySnapshot.docs.map((doc) {
      var m = doc.data() as Map<String, dynamic>;
      m['routine_id'] = doc.id;
      return Routine.fromMap(m);
    }).toList();
  }

  Future<void> addRoutine(Routine routine) async {
    await dbremote.addRoutine(routine.routineId, routine.toJsonWithoutId());
  }

  Future<void> deleteRoutine(String id) async {
    await dbremote.deleteRoutine(id);
  }

  Future<void> updateRoutine(Routine routine) async {
    await dbremote.updateRoutine(routine.routineId, routine.toJsonWithoutId());
  }
}
