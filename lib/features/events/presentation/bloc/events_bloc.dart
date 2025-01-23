import 'package:bloc/bloc.dart';
import 'package:pasti_track/core/errors/failures.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';
import 'package:pasti_track/features/events/domain/usecases/get_all_events.dart';
import 'package:pasti_track/features/events/domain/usecases/mark_event_as_done.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final MarkEventAsDone markEventAsDone;
  final GetAllEvents getAllEvents;

  EventsBloc(this.markEventAsDone, this.getAllEvents)
      : super(EventsLoadingState()) {
    on<LoadingEventsEvent>(_onLoadingEventsEvent);
    on<EventChangeStatusEvent>(_onEventChangeStatusEvent);
  }
  void _onLoadingEventsEvent(
      LoadingEventsEvent event, Emitter<EventsState> emit) async {
    try {
      emit(EventsLoadingState());
      final events = await getAllEvents.call();
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
      await markEventAsDone.call(eventId);
      emit(EventsDataState(await getAllEvents.call()));
    } on Failure catch (error) {
      emit(EventsErrorState(error.toString()));
    }
  }
}
