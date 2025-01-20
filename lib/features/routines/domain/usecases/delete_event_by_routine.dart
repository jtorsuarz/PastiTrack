import 'package:pasti_track/features/events/data/repositories/event_repository_impl.dart';

class DeleteEventByRoutine {
  final EventRepositoryImpl repository;

  DeleteEventByRoutine(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteByRoutine(id);
  }
}
