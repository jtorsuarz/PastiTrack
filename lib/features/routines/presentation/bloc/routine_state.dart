part of 'routine_bloc.dart';

abstract class RoutineState {}

class RoutineLoadingState extends RoutineState {}

class RoutineLoadedState extends RoutineState {
  final List<Routine> routines;

  RoutineLoadedState({required this.routines});
}

class RoutineMedicamentsLoadedState extends RoutineState {
  final List<Medicament> medicines;

  RoutineMedicamentsLoadedState({required this.medicines});
}

class RoutineSuccessState extends RoutineState {
  final String message;
  RoutineSuccessState(this.message);
}

class RoutineAddEditErrorState extends RoutineState {
  final String error;
  RoutineAddEditErrorState(this.error);
}

class RoutineErrorState extends RoutineState {
  final String error;
  RoutineErrorState(this.error);
}

class RoutineErrorAlertState extends RoutineState {
  final String error;
  RoutineErrorAlertState(this.error);
}

class RoutineSuccessAlertState extends RoutineState {
  final String message;
  RoutineSuccessAlertState(this.message);
}
