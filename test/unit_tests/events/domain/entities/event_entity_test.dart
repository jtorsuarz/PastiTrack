import 'package:flutter_test/flutter_test.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';
import 'package:pasti_track/features/events/domain/entities/event_status.dart';

void main() {
  test('convert JSON => Entity', () {
    final json = {
      'event_id': '1',
      'routine_id': '2',
      'medicine_id': '3',
      'date_scheduled': '2025-01-01T00:00:00.000Z',
      'status': 'pending',
      'date_done': null,
      'date_updated': '2025-01-01T00:00:00.000Z',
      'registration_scheduled_notification': 1,
    };

    final event = EventEntity.fromJson(json);

    expect(event.eventId, '1');
    expect(event.routineId, '2');
    expect(event.medicineId, '3');
  });

  test('convert Entity => JSON', () {
    final event = EventEntity(
      eventId: '1',
      routineId: '2',
      medicineId: '3',
      dateScheduled: DateTime.parse('2025-01-01T00:00:00.000Z'),
      status: EventStatus.pending,
      dateDone: null,
      dateUpdated: DateTime.parse('2025-01-01T00:00:00.000Z'),
      registrationScheduledNotification: 1,
    );

    final json = event.toJson();

    expect(json['event_id'], '1');
    expect(json['routine_id'], '2');
    expect(json['medicine_id'], '3');
  });
}
