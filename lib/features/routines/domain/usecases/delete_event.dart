import 'package:pasti_track/core/services/notification_service.dart';
import 'package:pasti_track/features/events/data/repositories/event_repository_impl.dart';

class DeleteEvent {
  final EventRepositoryImpl repository;

  DeleteEvent(this.repository);

  Future<void> call(String eventId) async {
    await NotificationService().cancelNotification(eventId.hashCode);
    await repository.delete(eventId);
  }
}
