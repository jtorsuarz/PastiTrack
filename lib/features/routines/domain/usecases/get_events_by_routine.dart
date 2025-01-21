import 'package:pasti_track/features/events/data/repositories/event_repository_impl.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';

class GetEventsByRoutine {
  final EventRepositoryImpl repository;

  GetEventsByRoutine(this.repository);

  Future<List<EventEntity>> call(String id) async {
    return await repository.getAllByRoutine(id);
  }
}
