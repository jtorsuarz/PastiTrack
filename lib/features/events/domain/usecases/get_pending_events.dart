import 'package:pasti_track/features/events/domain/entities/event_entity.dart';
import 'package:pasti_track/features/events/domain/repositories/event_repository.dart';

class GetPendingEvents {
  final EventRepository repository;

  GetPendingEvents(this.repository);

  Future<List<EventEntity>> call(DateTime currentDate) async {
    return await repository.getPendingEvents(currentDate);
  }
}
