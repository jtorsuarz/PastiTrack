import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pasti_track/core/database/db_local.dart';
import 'package:pasti_track/features/events/data/datasources/event_local_datasource.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';

import 'event_local_datasource_test.mocks.dart';

@GenerateMocks([DBLocal])
void main() {
  late EventLocalDataSource dataSource;
  late MockDBLocal mockDBLocal;

  setUp(() {
    mockDBLocal = MockDBLocal();
    dataSource = EventLocalDataSource(database: mockDBLocal);
  });

  group('EventLocalDataSource Tests', () {
    test('Initialization of Database Mocks', () {
      expect(dataSource.database, mockDBLocal);
    });

    final event = {
      'event_id': '1',
      'routine_id': '2',
      'medicine_id': '3',
      'date_scheduled': '2025-01-23T10:00:00',
      'status': 'pending',
      'date_done': null,
      'date_updated': '2025-01-23T09:00:00',
      'registration_scheduled_notification': '1',
    };

    test('getAllEvents', () async {
      final eventListJson = [event];

      when(mockDBLocal.getAllEvents()).thenAnswer((_) async => eventListJson);

      final result = await dataSource.getAll();
      expect(result, isA<List<EventEntity>>());
      expect(result.length, 1);
    });
    test('getPendingEvents', () async {
      final currentDate = DateTime.now();
      final eventListJson = [event];

      when(mockDBLocal.getPendingEvents(currentDate))
          .thenAnswer((_) async => eventListJson);

      final result = await dataSource.getPendingEvents(currentDate);

      expect(result, isA<List<EventEntity>>());
      expect(result.length, 1);
    });

    test('getEventById', () async {
      final mockEvent = event;

      when(mockDBLocal.getEventById(mockEvent['event_id']))
          .thenAnswer((_) async => mockEvent);

      final result =
          await dataSource.database.getEventById(mockEvent['event_id']!);

      verify(mockDBLocal.getEventById(mockEvent['event_id'])).called(1);

      expect(result, mockEvent);
    });

    test('addEvent', () async {
      when(dataSource.addEvent(EventEntity.fromJson(event)))
          .thenAnswer((_) async => 1);

      final result = await dataSource.addEvent(EventEntity.fromJson(event));

      verify(dataSource.addEvent(EventEntity.fromJson(event))).called(1);

      expect(result, 1);
    });
    test('getEventsByRoutine', () async {
      const routineId = '2';
      final eventListJson = [event];

      when(mockDBLocal.getEventsByRoutine(routineId))
          .thenAnswer((_) async => eventListJson);

      final result = await dataSource.getEventsByRoutine(routineId);

      expect(result, isA<List<EventEntity>>());
      expect(result.length, 1);
    });

    test('updateEvent', () async {
      final mockEvent = EventEntity.fromJson(event);

      final eventJson = mockEvent.toJson();
      when(mockDBLocal.updateEvent(eventJson)).thenAnswer((_) async => 1);

      final result = await dataSource.updateEvent(mockEvent);

      verify(mockDBLocal.updateEvent(eventJson)).called(1);
      expect(result, 1);
    });

    test('updateEventStatusAndDates', () async {
      const eventId = '1';
      final dateDone = DateTime.now().toIso8601String();

      when(mockDBLocal.updateEventStatusAndDates(
              eventId: eventId, dateDone: dateDone))
          .thenAnswer((_) async => 1);

      final result = await dataSource.updateStatusEvent(eventId, dateDone);

      verify(mockDBLocal.updateEventStatusAndDates(
              eventId: eventId, dateDone: dateDone))
          .called(1);
      expect(result, 1);
    });

    test('deleteEvent', () async {
      when(dataSource.deleteEvent(event['event_id']!))
          .thenAnswer((_) async => 1);

      final result = await dataSource.deleteEvent(event['event_id']!);

      verify(dataSource.deleteEvent(event['event_id']!)).called(1);

      expect(result, 1);
    });

    test('deleteEventsByRoutineId', () async {
      const routineId = '2';

      when(mockDBLocal.deleteEventsByRoutineId(routineId))
          .thenAnswer((_) async => 1);

      await dataSource.deleteEventsByRoutineId(routineId);

      verify(mockDBLocal.deleteEventsByRoutineId(routineId)).called(1);
    });
  });
}
