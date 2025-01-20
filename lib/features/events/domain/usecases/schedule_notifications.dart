import 'package:pasti_track/core/notifications/notification_service.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';

class ScheduleNotifications {
  final NotificationService notificationService;

  ScheduleNotifications(this.notificationService);

  Future<void> call(List<EventEntity> events) async {
    for (final event in events) {
      await notificationService.scheduleNotification(
        id: event.eventId.hashCode,
        title: 'Recuerda tomar tu medicamento',
        body:
            'El medicamento asociado a la rutina ${event.routineId} está programado.',
        scheduledDate: event.dateScheduled,
        scheduledTime: DateTime.now(),
      );
    }
  }
}
