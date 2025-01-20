import 'package:pasti_track/features/routines/data/repositories/routine_repository_impl.dart';
import 'package:pasti_track/features/routines/domain/entities/routine.dart';

class GetAllRoutines {
  final RoutineRepositoryImpl repository;

  GetAllRoutines(this.repository);

  Future<List<Routine>> call() async {
    await repository.syncData();
    return await repository.getRoutines();
  }
}
