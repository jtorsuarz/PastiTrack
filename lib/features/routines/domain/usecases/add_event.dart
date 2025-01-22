import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/notifications/notification_service.dart';
import 'package:pasti_track/features/events/data/repositories/event_repository_impl.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';

class AddEvent {
  final EventRepositoryImpl repository;

  AddEvent(this.repository);

  Future<void> call(EventEntity event) async {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
    try {
      if (event.dateScheduled.isAfter(startOfWeek) &&
          event.dateScheduled.isBefore(endOfWeek)) {
        String medicamentName = await event.medicationName();
        await NotificationService().scheduleNotification(
          id: event.eventId.hashCode,
          title: AppString.scheduleNotificationTitle(medicamentName),
          body: AppString.scheduleNotificationBody(event.dateScheduled),
          dateTime: event.dateScheduled,
          objectEntity: event,
        );
      }
      event.registrationScheduledNotification = 1;
    } on Exception catch (_) {
      event.registrationScheduledNotification = 0;
    }

    return await repository.add(event);
  }
}
