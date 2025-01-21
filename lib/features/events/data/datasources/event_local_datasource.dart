import 'package:pasti_track/core/database/db_local.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';

class EventLocalDataSource {
  final DBLocal database = DBLocal();

  EventLocalDataSource();

  Future<List<EventEntity>> getEvents() async {
    final result = await database.getAllEvents();
    return result.map((json) {
      return EventEntity.fromJson(json);
    }).toList();
  }

  Future<int> addEvent(EventEntity event) async {
    return await database.insertEvent(event.toJson());
  }

  Future<int> deleteEvent(String id) async {
    return await database.deleteEvent(id);
  }

  Future<void> deleteEventsByRoutineId(String routineId) async {
    await database.deleteEventsByRoutineId(routineId);
  }

  Future<int> updateStatusEvent(String eventId, String dateDone) async {
    return await database.updateEventStatusAndDates(
        eventId: eventId, dateDone: dateDone);
  }

  Future<int> updateEvent(EventEntity event) async {
    return Future.value(1);
  }

  Future<List<EventEntity>> getPendingEvents(DateTime currentDate) async {
    final result = await database.getPendingEvents(currentDate);
    return result.map((json) {
      return EventEntity.fromJson(json);
    }).toList();
  }

  Future<List<EventEntity>> getEventsByRoutine(String routineId) async {
    final result = await database.getEventsByRoutine(routineId);
    return result.map((json) {
      return EventEntity.fromJson(json);
    }).toList();
  }
}
