import 'package:pasti_track/features/events/data/repositories/event_repository_impl.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';

class AddEvent {
  final EventRepositoryImpl repository;

  AddEvent(this.repository);

  Future<void> call(EventEntity event) async {
    return await repository.add(event);
  }
}
