import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pasti_track/features/events/data/repositories/event_repository_impl.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';
import 'package:pasti_track/features/events/domain/entities/event_status.dart';
import 'package:pasti_track/features/events/domain/usecases/get_all_events.dart';

import 'get_all_events_test.mocks.dart';

@GenerateMocks([EventRepositoryImpl])
void main() {
  late GetAllEvents useCase;
  late MockEventRepositoryImpl mockRepository;

  setUp(() {
    mockRepository = MockEventRepositoryImpl();
    useCase = GetAllEvents(mockRepository);
  });

  group('GetAllEvents', () {
    test('GetAllEvents', () async {
      final event1 = EventEntity(
        eventId: '1',
        routineId: '2',
        medicineId: '3',
        dateScheduled: DateTime.now().subtract(const Duration(days: 1)),
        status: EventStatus.passed,
        dateDone: null,
        dateUpdated: DateTime.now(),
        registrationScheduledNotification: 1,
      );

      final event2 = EventEntity(
        eventId: '2',
        routineId: '3',
        medicineId: '4',
        dateScheduled: DateTime.now().add(const Duration(days: 1)),
        status: EventStatus.pending,
        dateDone: null,
        dateUpdated: DateTime.now(),
        registrationScheduledNotification: 1,
      );

      final event3 = EventEntity(
        eventId: '3',
        routineId: '4',
        medicineId: '5',
        dateScheduled: DateTime.now().subtract(const Duration(days: 2)),
        status: EventStatus.completed,
        dateDone: DateTime.now().subtract(const Duration(days: 1)),
        dateUpdated: DateTime.now(),
        registrationScheduledNotification: 1,
      );

      when(mockRepository.syncData()).thenAnswer((_) async => Future.value());
      when(mockRepository.getAll())
          .thenAnswer((_) async => [event1, event2, event3]);
      when(mockRepository.update(event1)).thenAnswer((_) async => 1);

      final result = await useCase.call();

      verify(mockRepository.syncData()).called(1);
      verify(mockRepository.getAll()).called(1);
      verify(mockRepository.update(event1)).called(1);

      expect(result, isA<List<EventEntity>>());
      expect(result.length, 3);
      expect(result[0].status, EventStatus.pending);
      expect(result[1].status, EventStatus.passed);
      expect(result[2].status, EventStatus.completed);

      expect(result[0].eventId, '2');
      expect(result[1].eventId, '1');
      expect(result[2].eventId, '3');
    });

    test('GetAllEvents empty', () async {
      // Mock de la respuesta del repositorio
      when(mockRepository.syncData()).thenAnswer((_) async {});
      when(mockRepository.getAll()).thenAnswer((_) async => []);

      // Ejecutar el método
      final result = await useCase.call();

      // Verificar el resultado
      expect(result, isA<List<EventEntity>>());
      expect(result.isEmpty, true);
    });
  });
}
