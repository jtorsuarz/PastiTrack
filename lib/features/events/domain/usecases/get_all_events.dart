import 'package:pasti_track/features/events/domain/entities/event_entity.dart';
import 'package:pasti_track/features/events/domain/repositories/event_repository.dart';

class GetAllEvents {
  final EventRepository repository;

  GetAllEvents(this.repository);

  Future<List<EventEntity>> call() async {
    return await repository.getAll();
  }
}
