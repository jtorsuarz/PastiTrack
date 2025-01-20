import 'package:pasti_track/features/routines/data/repositories/routine_repository_impl.dart';

class DeleteRoutine {
  final RoutineRepositoryImpl repository;

  DeleteRoutine(this.repository);

  Future<int> call(String id) async {
    return await repository.deleteRoutine(id);
  }
}
