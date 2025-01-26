import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/services/notification_service.dart';
import 'package:pasti_track/features/events/data/repositories/event_repository_impl.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';

class AddEvent {
  final EventRepositoryImpl repository;

  AddEvent(this.repository);

  Future<void> call(EventEntity event) async {
    final notificationService = NotificationService();
    try {
      String medicamentName = await event.medicationName();
      await notificationService.scheduleNotification(
        id: event.eventId.hashCode,
        title: AppString.scheduleNotificationTitle(medicamentName),
        body: AppString.scheduleNotificationBody(event.dateScheduled),
        dateTime: event.dateScheduled,
        objectEntity: event,
      );
      event.registrationScheduledNotification = 1;
    } on Exception catch (_) {
      event.registrationScheduledNotification = 0;
    }

    return await repository.add(event);
  }
}
