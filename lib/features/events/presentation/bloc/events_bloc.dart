import 'package:bloc/bloc.dart';
import 'package:pasti_track/core/errors/failures.dart';
import 'package:pasti_track/features/events/data/repositories/event_repository_impl.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventRepositoryImpl eventsRepository;

  EventsBloc(this.eventsRepository) : super(EventsLoadingState()) {
    on<LoadingEventsEvent>(_onLoadingEventsEvent);
    on<EventChangeStatusEvent>(_onEventChangeStatusEvent);
  }
  void _onLoadingEventsEvent(
      LoadingEventsEvent event, Emitter<EventsState> emit) async {
    try {
      emit(EventsLoadingState());
      final events = await eventsRepository.getAll();
      emit(EventsDataState(events));
    } on Failure catch (error) {
      emit(EventsErrorState(error.toString()));
    }
  }

  void _onEventChangeStatusEvent(
      EventChangeStatusEvent event, Emitter<EventsState> emit) async {
    String eventId = event.eventId;

    try {
      emit(EventsLoadingState());
      await eventsRepository.updateStatusEvent(eventId);
      emit(EventsDataState(await eventsRepository.getAll()));
    } on Failure catch (error) {
      emit(EventsErrorState(error.toString()));
    }
  }
}
