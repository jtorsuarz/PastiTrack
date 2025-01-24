import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pasti_track/features/events/data/repositories/event_repository_impl.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';
import 'package:pasti_track/features/events/domain/entities/event_status.dart';
import 'package:pasti_track/features/events/domain/usecases/get_pending_events.dart';

import 'get_all_events_test.mocks.dart';

@GenerateMocks([EventRepositoryImpl])
void main() {
  late GetPendingEvents useCase;
  late MockEventRepositoryImpl mockEventRepository;

  setUp(() {
    mockEventRepository = MockEventRepositoryImpl();
    useCase = GetPendingEvents(mockEventRepository);
  });

  group('GetPendingEvents', () {
    test('GetPendingEvents.call()', () async {
      final currentDate = DateTime.now();
      final eventList = [
        EventEntity(
          eventId: '1',
          routineId: '2',
          medicineId: '3',
          dateScheduled: DateTime.now(),
          status: EventStatus.pending,
          dateDone: null,
          dateUpdated: DateTime.now(),
          registrationScheduledNotification: 1,
        ),
        EventEntity(
          eventId: '2',
          routineId: '2',
          medicineId: '3',
          dateScheduled: DateTime.now(),
          status: EventStatus.pending,
          dateDone: null,
          dateUpdated: DateTime.now(),
          registrationScheduledNotification: 1,
        ),
      ];

      when(mockEventRepository.getPendingEvents(currentDate))
          .thenAnswer((_) async => eventList);

      final result = await useCase(currentDate);

      expect(result, eventList);
      verify(mockEventRepository.getPendingEvents(currentDate)).called(1);
    });

    test('GetPendingEvents empty', () async {
      final currentDate = DateTime.now();
      final eventList = <EventEntity>[];

      when(mockEventRepository.getPendingEvents(currentDate))
          .thenAnswer((_) async => eventList);

      final result = await useCase(currentDate);

      expect(result, eventList);
      verify(mockEventRepository.getPendingEvents(currentDate)).called(1);
    });
  });
}
