import 'package:pasti_track/features/events/domain/repositories/event_repository.dart';

class MarkEventAsDone {
  final EventRepository repository;

  MarkEventAsDone(this.repository);

  Future<void> call(String eventId) async {
    await repository.updateStatusEvent(eventId);
  }
}
