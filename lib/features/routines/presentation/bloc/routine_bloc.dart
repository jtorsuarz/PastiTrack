import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/errors/failures.dart';
import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';
import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';
import 'package:pasti_track/features/routines/domain/entities/routine.dart';
import 'package:pasti_track/features/routines/domain/entities/routine_days.dart';
import 'package:pasti_track/features/routines/domain/entities/routine_frequency.dart';
import 'package:pasti_track/features/routines/domain/usecases/add_event.dart';
import 'package:pasti_track/features/routines/domain/usecases/add_routine.dart';
import 'package:pasti_track/features/routines/domain/usecases/delete_event_by_routine.dart';
import 'package:pasti_track/features/routines/domain/usecases/delete_routine.dart';
import 'package:pasti_track/features/routines/domain/usecases/get_all_routines.dart';
import 'package:pasti_track/features/routines/domain/usecases/get_medications.dart';
import 'package:pasti_track/features/routines/domain/usecases/update_routine.dart';

part 'routine_event.dart';
part 'routine_state.dart';

class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  final GetAllRoutines getAllRoutines;
  final GetAllMedications getAllMedications;
  final AddRoutine addRoutine;
  final UpdateRoutine updateRoutine;
  final DeleteRoutine deleteRoutine;
  final DeleteEventByRoutine deleteEventByRoutine;
  final AddEvent addEvent;

  RoutineBloc(
    this.getAllRoutines,
    this.getAllMedications,
    this.addRoutine,
    this.updateRoutine,
    this.deleteRoutine,
    this.deleteEventByRoutine,
    this.addEvent,
  ) : super(RoutineLoadingState()) {
    on<LoadRoutinesMedicamentsEvent>(_onLoadRoutinesMedicamentsEvent);
    on<LoadRoutinesEvent>(_onLoadRoutinesEvent);
    on<AddRoutineEvent>(_onAddRoutine);
    on<CreateRoutineEventsEvent>(_onCreateRoutineEventsEvent);
    on<UpdateRoutineEvent>(_onUpdateRoutine);
    on<DeleteRoutineEvent>(_onDeleteRoutine);
  }

  void _onLoadRoutinesEvent(
      LoadRoutinesEvent event, Emitter<RoutineState> emit) async {
    try {
      final routines = await getAllRoutines.call();
      emit(RoutineLoadedState(routines: routines));
    } on Failure catch (e) {
      emit(RoutineErrorState(e.message));
    }
  }

  void _onLoadRoutinesMedicamentsEvent(
      LoadRoutinesMedicamentsEvent event, Emitter<RoutineState> emit) async {
    try {
      final medicaments = await getAllMedications.call();
      emit(RoutineMedicamentsLoadedState(medicines: medicaments));
    } on Failure catch (e) {
      emit(RoutineErrorState(e.message));
    }
  }

  void _onAddRoutine(AddRoutineEvent event, Emitter<RoutineState> emit) async {
    try {
      if (event.routine.frequency == RoutineFrequency.custom.description) {
        if (event.routine.customDays!.isEmpty) {
          emit(
            RoutineErrorAlertState(AppString.routineYouMustProvideRangeOfDays),
          );
          final medicaments = await getAllMedications.call();
          emit(RoutineMedicamentsLoadedState(medicines: medicaments));
          return;
        }
        if (event.isGeneralTime) {
          if (event.routine.dosageTime.isEmpty) {
            emit(
              RoutineErrorAlertState(
                  AppString.routineMustProvideLeastOnSchedule),
            );
            final medicaments = await getAllMedications.call();
            emit(RoutineMedicamentsLoadedState(medicines: medicaments));
            return;
          }
        } else {
          if (event.routine.customTimes!.isEmpty) {
            emit(
              RoutineErrorAlertState(
                  AppString.routineMustProvideLeastOnSchedule),
            );
            final medicaments = await getAllMedications.call();
            emit(RoutineMedicamentsLoadedState(medicines: medicaments));
            return;
          }
        }
      } else {
        if (event.routine.dosageTime.isEmpty) {
          emit(
            RoutineErrorAlertState(AppString.routineMustProvideLeastOnSchedule),
          );
          final medicaments = await getAllMedications.call();
          emit(RoutineMedicamentsLoadedState(medicines: medicaments));
          return;
        }
      }

      await addRoutine.call(event.routine);
      emit(RoutineSuccessAlertState(AppString.routineSuccessfullyAdded));
      add(CreateRoutineEventsEvent(event.routine));
    } on Failure catch (e) {
      emit(RoutineErrorState(AppString.errorWhenCreate(e.message)));
    }
  }

  void _onCreateRoutineEventsEvent(
      CreateRoutineEventsEvent event, Emitter<RoutineState> emit) async {
    try {
      final routine = event.routine;
      final String frecuency = routine.frequency;
      List<DateTime> daysOfYear = [];
      List<Future<void>> futures = [];

      final timeParts = routine.getTimeOfDay;
      final int hourNow = timeParts == null ? 0 : timeParts.hour;
      final int minuteNow = timeParts == null ? 0 : timeParts.minute;

      // diaria genera registro dependiendo del dia actual hasta el fin de año
      if (frecuency == RoutineFrequency.daily.description) {
        AppLogger.p("Crear Evento", "FRECUENCY $frecuency");
        daysOfYear =
            getRemainingDatesCurrentYear(hour: hourNow, minute: minuteNow);
      }

      // generamos registros cada 7 dias.
      if (frecuency == RoutineFrequency.weekly.description) {
        AppLogger.p("Crear Evento", "FRECUENCY $frecuency");
        daysOfYear = getRemainingDatesCurrentYearByDay(
            day: RoutineDays.numericValue(routine.dayOfWeek),
            hour: hourNow,
            minute: minuteNow);
      }

      // personalizada, se crean las fechas indicadas, pero previamente se tiene que evaluar el tipo de hora que se usa.
      if (frecuency == RoutineFrequency.custom.description) {
        AppLogger.p("Crear Evento", "FRECUENCY $frecuency");
        AppLogger.p("CustomDays", routine.customDays);
        if (routine.getCustomTimes.isNotEmpty) {
          daysOfYear = mergeDateTimeAndTimeOfDay(routine.getCustomTimes);
        } else {
          daysOfYear = routine.customDays!
              .map((date) => DateTime.parse(date!)
                  .copyWith(hour: hourNow, minute: minuteNow))
              .toList();
        }
      }

      for (DateTime date in daysOfYear) {
        DateTime dateScheduled = date;
        AppLogger.p("CustomDaysWithTime", dateScheduled);

        futures.add(addEvent.call(EventEntity(
          eventId: DateTime.now().toIso8601String(),
          routineId: routine.routineId,
          medicineId: routine.medicineId,
          dateScheduled: dateScheduled,
          dateUpdated: DateTime.now(),
          dateDone: null,
          status: false,
        )));
      }

      await Future.wait(futures);

      add(LoadRoutinesEvent());
    } on Failure catch (e) {
      emit(RoutineErrorAlertState(e.message));
    }
  }

  void _onUpdateRoutine(
      UpdateRoutineEvent event, Emitter<RoutineState> emit) async {
    emit(RoutineLoadingState());
    try {
      await updateRoutine.call(event.routine);
      emit(RoutineSuccessAlertState(AppString.routineSuccessfullyUpdated));
      add(LoadRoutinesEvent());
    } on Failure catch (e) {
      emit(RoutineErrorState(e.message));
    }
  }

  void _onDeleteRoutine(
      DeleteRoutineEvent event, Emitter<RoutineState> emit) async {
    emit(RoutineLoadingState());
    try {
      await deleteRoutine.call(event.id);
      await deleteEventByRoutine.call(event.id);
      add(LoadRoutinesEvent());
      emit(RoutineSuccessAlertState(AppString.routineSuccessfullyRemoved));
    } on RoutineErrorAlertState catch (e) {
      emit(RoutineErrorAlertState(e.error));
      add(LoadRoutinesEvent());
    } on Failure catch (e) {
      emit(RoutineErrorState(e.message));
    }
  }

  List<DateTime> getRemainingDatesCurrentYear(
      {required int hour, required int minute}) {
    List<DateTime> days = [];

    DateTime start = DateTime.now().copyWith(hour: hour, minute: minute);
    DateTime end = DateTime(start.year + 1, 1, 1);

    for (DateTime day = start;
        day.isBefore(end);
        day = day.add(const Duration(days: 1))) {
      days.add(day);
    }

    return days;
  }

  List<DateTime> getRemainingDatesCurrentYearByDay(
      {required int day, required int hour, required int minute}) {
    List<DateTime> days = [];
    DateTime currentDate = DateTime.now().copyWith(hour: hour, minute: minute);
    int yearNow = currentDate.year;

    int currentWeekday = currentDate.weekday;
    int daysToAdd = (day - currentWeekday + 7) % 7;
    DateTime nextWeekday = currentDate.add(Duration(days: daysToAdd));
    DateTime nextDay =
        DateTime(nextWeekday.year, nextWeekday.month, nextWeekday.day);

    DateTime end = DateTime(yearNow + 1, 1, 1);

    for (DateTime date = nextDay;
        date.isBefore(end);
        date = date.add(const Duration(days: 7))) {
      days.add(date);
    }

    return days;
  }

  List<DateTime> mergeDateTimeAndTimeOfDay(
      Map<DateTime, TimeOfDay> dateTimeMap) {
    return dateTimeMap.entries.map((entry) {
      DateTime date = entry.key;
      TimeOfDay time = entry.value;

      // Fusionar DateTime con TimeOfDay
      return DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    }).toList();
  }
}
