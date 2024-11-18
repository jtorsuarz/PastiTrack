import 'package:pasti_track/features/routines/domain/entities/routine.dart';

abstract class RoutineRepository {
  Future<List<Routine>> getRoutines();
  Future<void> addRoutine(Routine routine);
  Future<int> updateRoutine(Routine medicament);
  Future<void> deleteRoutine(String routineId);
}
