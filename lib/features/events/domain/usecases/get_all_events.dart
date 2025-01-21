import 'package:pasti_track/features/events/domain/entities/event_entity.dart';
import 'package:pasti_track/features/events/domain/repositories/event_repository.dart';

class GetAllEvents {
  final EventRepository repository;

  GetAllEvents(this.repository);

  Future<List<EventEntity>> call() async {
    List<EventEntity> events = await repository.getAll();
    // order by date and update status in passed and register if tome is not
    // expired yet
    events.sort((a, b) => b.dateScheduled.compareTo(a.dateScheduled));

    return events;
  }
}
