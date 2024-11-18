part of 'routine_bloc.dart';

abstract class RoutineEvent {}

class LoadRoutinesEvent extends RoutineEvent {}

class AddRoutineEvent extends RoutineEvent {
  final Routine routine;
  AddRoutineEvent(this.routine);
}

class UpdateRoutineEvent extends RoutineEvent {
  final Routine routine;
  UpdateRoutineEvent(this.routine);
}

class DeleteRoutineEvent extends RoutineEvent {
  final String id;
  DeleteRoutineEvent(this.id);
}
