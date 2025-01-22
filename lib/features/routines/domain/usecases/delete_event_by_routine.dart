import 'package:pasti_track/core/notifications/notification_service.dart';
import 'package:pasti_track/features/events/data/repositories/event_repository_impl.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';

class DeleteEventByRoutine {
  final EventRepositoryImpl repository;

  DeleteEventByRoutine(this.repository);

  Future<void> call(String id) async {
    final events = await repository.getAllByRoutine(id);
    for (EventEntity event in events) {
      await NotificationService().cancelNotification(event.eventId.hashCode);
    }
    return await repository.deleteByRoutine(id);
  }
}
