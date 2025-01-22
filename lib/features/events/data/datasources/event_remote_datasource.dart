import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pasti_track/core/database/db_remote.dart';
import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';

class EventRemoteDataSource {
  final DBRemote dbremote = DBRemote();

  EventRemoteDataSource();

  Future<List<EventEntity>> getAll() async {
    final querySnapshot = await dbremote.getEvents();
    return querySnapshot.docs.map((doc) {
      var m = doc.data() as Map<String, dynamic>;
      m['event_id'] = doc.id;
      return EventEntity.fromJson(m);
    }).toList();
  }

  Future<void> add(EventEntity event) async {
    await dbremote.addEvent(event.eventId, event.toJsonWithoutId());
  }

  Future<void> deleteEvent(String id) async {
    await dbremote.deleteEvent(id);
  }

  Future<void> deleteByRoutineId(String id) async {
    await dbremote.deleteEventsByRoutineId(id);
  }

  Future<void> update(EventEntity event) async {
    await dbremote.updateEvent(event.eventId, event.toJsonWithoutId());
  }

  Future<void> updateStatus(String id, String dateDone) async {
    await dbremote.updateEventStatus(id, dateDone);
  }

  Future<List<EventEntity>> getPendings(DateTime currentDate) async {
    final events = await dbremote.getPendingEvents(currentDate);
    return events.docs.map((doc) {
      return EventEntity.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}
