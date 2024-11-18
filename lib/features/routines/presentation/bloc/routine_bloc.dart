import 'package:bloc/bloc.dart';
import 'package:pasti_track/features/routines/data/repositories/routine_repository_impl.dart';
import 'package:pasti_track/features/routines/domain/entities/routine.dart';

part 'routine_event.dart';
part 'routine_state.dart';

class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  final RoutineRepositoryImpl repository;

  RoutineBloc(this.repository) : super(RoutineLoadingState()) {
    on<LoadRoutinesEvent>(_onLoadRoutinesEvent);
    on<AddRoutineEvent>(_onAddRoutine);
    on<UpdateRoutineEvent>(_onUpdateRoutine);
    on<DeleteRoutineEvent>(_onDeleteRoutine);
  }

  void _onAddRoutine(AddRoutineEvent event, Emitter<RoutineState> emit) async {
    emit(RoutineLoadingState());
    try {
      // Validar los datos antes de agregar la rutina
      if (event.routine.dosageTime.isEmpty) {
        emit(RoutineErrorState(
            'Debe proporcionar al menos un horario para la rutina.'));
        return;
      }

      // Aquí se agregarían los datos a la base de datos (SQLite/Firestore)
      // Por ejemplo: await repository.addRoutine(event.routine);

      emit(RoutineSuccessState('Rutina agregada con éxito'));
    } catch (e) {
      emit(RoutineErrorState('Error al agregar la rutina: $e'));
    }
  }

  void _onUpdateRoutine(
      UpdateRoutineEvent event, Emitter<RoutineState> emit) async {
    emit(RoutineLoadingState());
    try {
      // Aquí se actualizarían los datos en la base de datos (SQLite/Firestore)
      // Por ejemplo: await repository.updateRoutine(event.routine);

      emit(RoutineSuccessState('Rutina actualizada con éxito'));
    } catch (e) {
      emit(RoutineErrorState('Error al actualizar la rutina: $e'));
    }
  }

  void _onDeleteRoutine(
      DeleteRoutineEvent event, Emitter<RoutineState> emit) async {
    emit(RoutineLoadingState());
    try {
      // Aquí se eliminarían los datos en la base de datos (SQLite/Firestore)
      // Por ejemplo: await repository.deleteRoutine(event.routineId);

      emit(RoutineSuccessState('Rutina eliminada con éxito'));
    } catch (e) {
      emit(RoutineErrorState('Error al eliminar la rutina: $e'));
    }
  }

  void _onLoadRoutinesEvent(
      LoadRoutinesEvent event, Emitter<RoutineState> emit) async {
    emit(RoutineLoadingState());
    try {
      final routines = await repository.getRoutines();
      emit(RoutineLoadedState(routines: routines));
    } catch (e) {
      emit(RoutineErrorState(e.toString()));
    }
  }
}
