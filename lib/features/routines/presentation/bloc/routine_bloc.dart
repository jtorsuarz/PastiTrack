import 'package:bloc/bloc.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/errors/failures.dart';
import 'package:pasti_track/features/medicines/data/repositories/medicament_repository_impl.dart';
import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';
import 'package:pasti_track/features/routines/data/repositories/routine_repository_impl.dart';
import 'package:pasti_track/features/routines/domain/entities/routine.dart';
import 'package:pasti_track/features/routines/domain/entities/routine_frequency.dart';

part 'routine_event.dart';
part 'routine_state.dart';

class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  final RoutineRepositoryImpl repository;
  final MedicamentRepositoryImpl repositoryMedicaments;

  RoutineBloc(this.repository, this.repositoryMedicaments)
      : super(RoutineLoadingState()) {
    on<LoadRoutinesMedicamentsEvent>(_onLoadRoutinesMedicamentsEvent);
    on<LoadRoutinesEvent>(_onLoadRoutinesEvent);
    on<AddRoutineEvent>(_onAddRoutine);
    on<UpdateRoutineEvent>(_onUpdateRoutine);
    on<DeleteRoutineEvent>(_onDeleteRoutine);
  }

  void _onAddRoutine(AddRoutineEvent event, Emitter<RoutineState> emit) async {
    try {
      // Validar los datos antes de agregar la rutina
      if (event.routine.frequency == RoutineFrequency.custom.description) {
        if (event.routine.customDays!.isEmpty) {
          emit(
            RoutineErrorAlertState(AppString.youMustProvideRangeOfDaysRoutine),
          );
          final medicaments = await repositoryMedicaments.getMedications();
          emit(RoutineMedicamentsLoadedState(medicines: medicaments));
          return;
        }
        if (event.isGeneralTime) {
          if (event.routine.dosageTime.isEmpty) {
            emit(
              RoutineErrorAlertState(
                  AppString.mustProvideLeastOnScheduleRoutine),
            );
            final medicaments = await repositoryMedicaments.getMedications();
            emit(RoutineMedicamentsLoadedState(medicines: medicaments));
            return;
          }
        } else {
          if (event.routine.customTimes!.isEmpty) {
            emit(
              RoutineErrorAlertState(
                  AppString.mustProvideLeastOnScheduleRoutine),
            );
            final medicaments = await repositoryMedicaments.getMedications();
            emit(RoutineMedicamentsLoadedState(medicines: medicaments));
            return;
          }
        }
      } else {
        if (event.routine.dosageTime.isEmpty) {
          emit(
            RoutineErrorAlertState(AppString.mustProvideLeastOnScheduleRoutine),
          );
          final medicaments = await repositoryMedicaments.getMedications();
          emit(RoutineMedicamentsLoadedState(medicines: medicaments));
          return;
        }
      }

      await repository.addRoutine(event.routine);
      await repository.syncData();
      emit(RoutineAddEditSuccessState(AppString.routineSuccessfullyAdded));
    } on Failure catch (e) {
      emit(RoutineErrorState(AppString.errorWhenCreate(e.message)));
    }
  }

  void _onUpdateRoutine(
      UpdateRoutineEvent event, Emitter<RoutineState> emit) async {
    emit(RoutineLoadingState());
    try {
      // Aquí se actualizarían los datos en la base de datos (SQLite/Firestore)
      // Por ejemplo: await repository.updateRoutine(event.routine);

      emit(RoutineAddEditErrorState(AppString.routineSuccessfullyUpdated));
    } on Failure catch (e) {
      emit(RoutineErrorState(AppString.errorWhenUpdate(e.message)));
    }
  }

  void _onDeleteRoutine(
      DeleteRoutineEvent event, Emitter<RoutineState> emit) async {
    emit(RoutineLoadingState());
    try {
      // Aquí se eliminarían los datos en la base de datos (SQLite/Firestore)
      // Por ejemplo: await repository.deleteRoutine(event.routineId);

      emit(RoutineSuccessState(AppString.routineSuccessfullyRemoved));
    } on Failure catch (e) {
      emit(RoutineErrorState(AppString.errorWhenDelete(e.message)));
    }
  }

  void _onLoadRoutinesEvent(
      LoadRoutinesEvent event, Emitter<RoutineState> emit) async {
    emit(RoutineLoadingState());
    try {
      final routines = await repository.getRoutines();
      emit(RoutineLoadedState(routines: routines));
    } on Failure catch (e) {
      emit(RoutineErrorState(AppString.errorWhenLoad(e.message)));
    }
  }

  void _onLoadRoutinesMedicamentsEvent(
      LoadRoutinesMedicamentsEvent event, Emitter<RoutineState> emit) async {
    try {
      final medicaments = await repositoryMedicaments.getMedications();
      emit(RoutineMedicamentsLoadedState(medicines: medicaments));
    } on Failure catch (e) {
      emit(RoutineErrorState(AppString.errorWhenLoad(e.message)));
    }
  }
}
