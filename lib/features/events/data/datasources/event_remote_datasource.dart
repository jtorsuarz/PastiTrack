import 'package:pasti_track/core/database/db_remote.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';

class EventRemoteDataSource {
  final DBRemote dbremote = DBRemote();

  EventRemoteDataSource();

  Future<List<EventEntity>> getEvents() async {
    final querySnapshot = await dbremote.getEvents();
    return querySnapshot.docs.map((doc) {
      var m = doc.data() as Map<String, dynamic>;
      m['event_id'] = doc.id;
      return EventEntity.fromJson(m);
    }).toList();
  }

  Future<void> addEvent(EventEntity event) async {
    await dbremote.addEvent(event.eventId, event.toJsonWithoutId());
  }

  Future<void> deleteEvent(String id) async {
    await dbremote.deleteEvent(id);
  }

  Future<void> deleteEventsByRoutineId(String id) async {
    await dbremote.deleteEventsByRoutineId(id);
  }

  Future<void> updateEvent(EventEntity event) async {
    await dbremote.updateEvent(event.medicineId, event.toJsonWithoutId());
  }
}
