import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:pasti_track/core/services/notification_service.dart';
import 'package:pasti_track/features/events/data/datasources/event_local_datasource.dart';
import 'package:pasti_track/features/events/data/datasources/event_remote_datasource.dart';
import 'package:pasti_track/features/events/data/repositories/event_repository_impl.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';

class RegisterDailyNotificationsTask {
  static Future<void> execute() async {
    AppLogger.p("Task: RegisterDailyNotificationsTask", "");
    final repository =
        EventRepositoryImpl(EventLocalDataSource(), EventRemoteDataSource());
    final DateTime oneHourAgo =
        DateTime.now().subtract(const Duration(hours: 1));

    final List<EventEntity> pendingEvents =
        await repository.getPendingEvents(oneHourAgo);

    final List<EventEntity> unregisteredEvents = pendingEvents
        .where((event) => event.registrationScheduledNotification == 0)
        .toList();

    final notificationService = NotificationService();
    for (var event in unregisteredEvents) {
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

      await repository.update(event);
    }
  }
}
