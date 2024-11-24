part of 'routine_bloc.dart';

abstract class RoutineEvent {}

class LoadRoutinesEvent extends RoutineEvent {}

class LoadRoutinesMedicamentsEvent extends RoutineEvent {}

class AddRoutineEvent extends RoutineEvent {
  final Routine routine;
  final bool isGeneralTime;
  AddRoutineEvent(this.routine, this.isGeneralTime);
}

class UpdateRoutineEvent extends RoutineEvent {
  final Routine routine;
  UpdateRoutineEvent(this.routine);
}

class DeleteRoutineEvent extends RoutineEvent {
  final String id;
  DeleteRoutineEvent(this.id);
}
