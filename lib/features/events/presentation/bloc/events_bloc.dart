import 'package:bloc/bloc.dart';
import 'package:pasti_track/features/events/data/repositories/event_repository_impl.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventRepositoryImpl eventsRepository;

  EventsBloc(this.eventsRepository) : super(EventsLoadingState()) {
    on<LoadingEventsEvent>(_onLoadingEventsEvent);
  }

  void _onLoadingEventsEvent(
      EventsEvent event, Emitter<EventsState> emit) async {
    emit(EventsLoadingState());
    try {
      final events = await eventsRepository.getAll();
      emit(EventsDataState(events));
    } on Exception catch (error) {
      emit(EventsErrorState(error.toString()));
    }
  }
}
