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

  Future<int> updateEvent(EventEntity event) async {
    return await database.updateEventStatusAndDates(
      eventId: event.eventId,
      status: event.status!,
      dateDone: event.dateDone.toString(),
    );
  }
}
