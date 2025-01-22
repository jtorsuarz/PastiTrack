import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pasti_track/core/constants/app_string.dart';
import 'package:pasti_track/core/errors/failures.dart';
import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:pasti_track/features/events/data/datasources/event_local_datasource.dart';
import 'package:pasti_track/features/events/data/datasources/event_remote_datasource.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';
import 'package:pasti_track/features/events/domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventLocalDataSource localDB;
  final EventRemoteDataSource remoteDB;
  final Connectivity _connectivity = Connectivity();

  EventRepositoryImpl(
    this.localDB,
    this.remoteDB,
  );

  Future<bool> isConnected() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult.first != ConnectivityResult.none;
  }

  @override
  Future<List<EventEntity>> getAll() async {
    try {
      final result = await localDB.getEvents();
      if (await isConnected()) await remoteDB.getAll();
      AppLogger.p("Event", "getAll");
      return result;
    } catch (e) {
      AppLogger.p("Catch Event", "getAll ${e.toString()}");
      throw Failure(AppString.errorWhenLoad(AppString.event));
    }
  }

  @override
  Future<void> add(EventEntity event) async {
    try {
      await localDB.addEvent(event);
      if (await isConnected()) await remoteDB.add(event);
      AppLogger.p("Event", "add");
    } catch (e) {
      AppLogger.p("Catch Event", "add ${e.toString()}");
      throw Failure(AppString.errorWhenCreate(AppString.event));
    }
  }

  @override
  Future<void> delete(String eventId) async {
    try {
      await localDB.deleteEvent(eventId);
      if (await isConnected()) await remoteDB.deleteEvent(eventId);
      AppLogger.p("Event", "delete");
    } catch (e) {
      AppLogger.p("Catch Event", "delete ${e.toString()}");
      throw Failure(AppString.errorWhenCreate(AppString.event));
    }
  }

  @override
  Future<void> deleteByRoutine(String routineId) async {
    try {
      await localDB.deleteEventsByRoutineId(routineId);
      if (await isConnected()) {
        await remoteDB.deleteByRoutineId(routineId);
      }
      AppLogger.p("Event", "deleteByRoutine");
    } catch (e) {
      AppLogger.p("Catch Event", "deleteByRoutine ${e.toString()}");
      throw Failure(AppString.errorWhenDelete(AppString.eventsFromRoutine));
    }
  }

  @override
  Future<int> update(EventEntity event) async {
    try {
      final result = await localDB.updateEvent(event);
      if (await isConnected()) await remoteDB.update(event);
      AppLogger.p("Event", "update");
      return result;
    } catch (e) {
      AppLogger.p("Catch Event", "update ${e.toString()}");
      throw Failure(AppString.errorWhenUpdate(AppString.event));
    }
  }

  @override
  Future<int> updateStatusEvent(String eventId) async {
    try {
      String dateDone = DateTime.now().toIso8601String();
      final result = await localDB.updateStatusEvent(eventId, dateDone);
      if (await isConnected()) {
        await remoteDB.updateStatus(eventId, dateDone);
      }
      AppLogger.p("Event", "updateStatusEvent");
      return result;
    } catch (e) {
      AppLogger.p("Catch Event", "updateStatusEvent ${e.toString()}");
      throw Failure(AppString.errorWhenUpdate(AppString.event));
    }
  }

  @override
  Future<List<EventEntity>> getAllByRoutine(String routineId) {
    try {
      return localDB.getEventsByRoutine(routineId);
    } catch (e) {
      AppLogger.p("Catch Event", "getAllByRoutine ${e.toString()}");
      throw Failure(AppString.errorWhenLoad(AppString.event));
    }
  }

  @override
  Future<List<EventEntity>> getPendingEvents(DateTime currentDate) async {
    try {
      await remoteDB.getPendings(currentDate);
      AppLogger.p("Event", "updateStatusEvent");
      return localDB.getPendingEvents(currentDate);
    } catch (e) {
      AppLogger.p("Catch Event", "updateStatusEvent ${e.toString()}");
      throw Failure(AppString.errorWhenLoad(AppString.event));
    }
  }

  Future<void> syncData() async {
    if (await isConnected()) {
      List<EventEntity> localEvents = await getAll();
      List<EventEntity> remoteEvents = await remoteDB.getAll();

      Map<String, EventEntity> remoteEventMap = {
        for (var event in remoteEvents) event.eventId: event
      };

      for (var localEvent in localEvents) {
        if (remoteEventMap.containsKey(localEvent.eventId)) {
          EventEntity remoteEvent = remoteEventMap[localEvent.eventId]!;

          DateTime localDate = localEvent.dateUpdated;
          DateTime remoteDate = remoteEvent.dateUpdated;

          if (localDate.isAfter(remoteDate)) {
            await remoteDB.update(localEvent);
          } else if (remoteDate.isAfter(localDate)) {
            await localDB.updateEvent(remoteEvent);
          }
          remoteEventMap.remove(localEvent.eventId);
        } else {
          await remoteDB.add(localEvent);
        }
      }

      for (var event in remoteEventMap.values) {
        await localDB.addEvent(event);
      }
    }
  }
}
