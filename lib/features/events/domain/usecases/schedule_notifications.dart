import 'package:pasti_track/core/notifications/notification_service.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';

class ScheduleNotifications {
  final NotificationService notificationService;

  ScheduleNotifications(this.notificationService);

  Future<void> call(List<EventEntity> events) async {
    for (final event in events) {
      String medicationName = await event.medicationName();
      // get hour time from dateSchedule
      String hourProgrammed = event.dateScheduled.toString().split(' ')[1];

      // schedule notification for 5 minutes before the event
      DateTime dateTimeBeforeEvent =
          event.dateScheduled.subtract(const Duration(minutes: 5));
      await notificationService.scheduleNotification(
        id: event.eventId.hashCode,
        title: '��Quedan 5 minutos para tomar tu medicamento!',
        body:
            'Recuerda tomar tu medicamento: $medicationName programado para las ${hourProgrammed[0]}:${hourProgrammed[1]}. Tu salud es lo primero.',
        dateTime: dateTimeBeforeEvent,
        objectId: "", // recordar esto.
      );
    }
  }
}
