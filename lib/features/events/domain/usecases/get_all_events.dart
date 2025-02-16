import 'package:pasti_track/features/events/data/repositories/event_repository_impl.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';
import 'package:pasti_track/features/events/domain/entities/event_status.dart';

class GetAllEvents {
  final EventRepositoryImpl repository;

  GetAllEvents(this.repository);

  Future<List<EventEntity>> call() async {
    await repository.syncData();
    List<EventEntity> events = await repository.getAll();

    DateTime now = DateTime.now();
    for (var event in events) {
      DateTime dateSchedule = event.dateScheduled;

      if (dateSchedule.isBefore(now) && event.status != EventStatus.completed) {
        event.status = EventStatus.passed;
        await repository.update(event);
      }
    }

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
