import 'package:pasti_track/features/routines/data/repositories/routine_repository_impl.dart';
import 'package:pasti_track/features/routines/domain/entities/routine.dart';

class UpdateRoutine {
  final RoutineRepositoryImpl repository;

  UpdateRoutine(this.repository);

  Future<int> call(Routine routine) async {
    return await repository.updateRoutine(routine);
  }
}
