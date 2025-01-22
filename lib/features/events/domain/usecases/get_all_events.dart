import 'package:pasti_track/features/events/domain/entities/event_entity.dart';
import 'package:pasti_track/features/events/domain/entities/event_status.dart';
import 'package:pasti_track/features/events/domain/repositories/event_repository.dart';

class GetAllEvents {
  final EventRepository repository;

  GetAllEvents(this.repository);

  Future<List<EventEntity>> call() async {
    List<EventEntity> events = await repository.getAll();

    // Actualizamos el estado de los eventos que ya pasaron
    DateTime now = DateTime.now();
    for (var event in events) {
      if (event.dateScheduled.isBefore(now) &&
          event.status != EventStatus.completed) {
        event.status = EventStatus.passed;
        await repository.update(event);
      }
    }

    // Ordenamos los eventos:
    events.sort((a, b) {
      if (a.status == EventStatus.completed) return 1;
      if (b.status == EventStatus.completed) return -1;
      if (a.status == EventStatus.passed) return 1;
      if (b.status == EventStatus.passed) return -1;

      return a.dateScheduled.compareTo(b.dateScheduled);
    });

    return events;
  }
}
