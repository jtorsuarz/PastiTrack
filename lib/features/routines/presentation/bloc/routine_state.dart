part of 'routine_bloc.dart';

abstract class RoutineState {}

class RoutineLoadingState extends RoutineState {}

class RoutineLoadedState extends RoutineState {
  final List<Routine> routines;

  RoutineLoadedState({required this.routines});
}

class RoutineSuccessState extends RoutineState {
  final String message;
  RoutineSuccessState(this.message);
}

class RoutineErrorState extends RoutineState {
  final String error;
  RoutineErrorState(this.error);
}
