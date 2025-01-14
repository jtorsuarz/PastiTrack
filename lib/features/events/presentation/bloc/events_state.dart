part of 'events_bloc.dart';

abstract class EventsState {}

final class EventsLoadingState extends EventsState {}

class EventsDataState extends EventsState {
  final List<EventEntity> events;
  EventsDataState(this.events);
}

class EventsErrorAlertState extends EventsState {
  final String error;
  EventsErrorAlertState(this.error);
}

class EventsSuccessAlertState extends EventsState {
  final String message;
  EventsSuccessAlertState(this.message);
}

class EventsErrorState extends EventsState {
  final String error;
  EventsErrorState(this.error);
}
