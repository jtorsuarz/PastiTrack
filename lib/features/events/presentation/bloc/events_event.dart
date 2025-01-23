part of 'events_bloc.dart';

abstract class EventsEvent {}

class LoadingEventsEvent extends EventsEvent {}

class EventChangeStatusEvent extends EventsEvent {
  String eventId;
  EventChangeStatusEvent(this.eventId);
}
