import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:pasti_track/core/services/notification_service.dart';
import 'package:pasti_track/features/events/domain/repositories/event_repository.dart';

class MarkEventAsDone {
  final EventRepository repository;

  MarkEventAsDone(this.repository);

  Future<void> call(String eventId) async {
    AppLogger.p("MarkEventAsDone", eventId);
    await repository.updateStatusEvent(eventId);
    try {
      await NotificationService().cancelNotification(eventId.hashCode);
    } on Exception catch (_) {
      AppLogger.p(
        "NotificationService",
        "Error canceling notification for eventId: $eventId",
      );
    }
  }
}
