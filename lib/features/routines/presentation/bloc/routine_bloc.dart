import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'routine_event.dart';
part 'routine_state.dart';

class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  RoutineBloc() : super(RoutineInitial()) {
    on<RoutineEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
