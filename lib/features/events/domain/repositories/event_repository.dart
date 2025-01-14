import 'package:pasti_track/features/events/domain/entities/event_entity.dart';

abstract class EventRepository {
  Future<List<EventEntity>> getAll();
  Future<void> add(EventEntity event);
  Future<int> update(EventEntity event);
  Future<void> delete(String eventId);
  Future<void> deleteByRoutine(String routineId);
}
