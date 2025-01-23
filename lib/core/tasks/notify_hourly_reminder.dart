import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:pasti_track/core/services/notification_service.dart';
import 'package:pasti_track/features/events/data/datasources/event_local_datasource.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';

class NotifyHourlyReminderTask {
  static Future<void> execute() async {
    AppLogger.p("Task: NotifyHourlyReminderTask", "");
    final localDataSource = EventLocalDataSource();
    final DateTime oneHourAgo =
        DateTime.now().subtract(const Duration(hours: 1));

    final List<EventEntity> pendingEvents =
        await localDataSource.getPendingEvents(oneHourAgo);

    if (pendingEvents.isNotEmpty) {
      final int pendingCount = pendingEvents.length;
      await NotificationService().showNotification(
        id: 0.hashCode,
        title: AppString.eventPending,
        body: AppString.youHaveXPendingEventsToRegister(pendingCount),
      );
    } else {
      await NotificationService().showNotification(
        id: 0.hashCode,
        title: AppString.registerRoutines,
        body: AppString.rememberToRecordYourRoutinesToStayInControl,
      );
    }
  }
}
