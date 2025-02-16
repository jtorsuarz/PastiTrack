import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:pasti_track/features/routines/domain/entities/routine.dart';
import 'package:pasti_track/features/routines/domain/entities/routine_frequency.dart';
import 'package:pasti_track/features/routines/presentation/bloc/routine_bloc.dart';
import 'package:pasti_track/features/routines/presentation/widget/reusable_widgets.dart';
import 'package:pasti_track/features/routines/presentation/widget/select_days_bottom_sheet_widget.dart';
import 'package:pasti_track/widgets/custom_sizes_box.dart';

class AddEditRoutineScreen extends StatefulWidget {
  final Routine? routine;
  const AddEditRoutineScreen({super.key, this.routine});

  @override
  State<AddEditRoutineScreen> createState() => _AddEditRoutineScreenState();
}

class _AddEditRoutineScreenState extends State<AddEditRoutineScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedMedication;
  String? _selectedFrequency;
  TimeOfDay? _generalTime;
  String? selectedDayOfWeek;
  List<DateTime> _customDays = [];
  Map<DateTime, TimeOfDay> _customTimes = {};
  bool _useGeneralTime = true;
  late Routine? _routine;

  @override
  void initState() {
    _routine = widget.routine;
    AppLogger.p("AddEditMedication", "routine: ${_routine?.routineId}");
    super.initState();
    if (_routine != null) {
      setState(() {
        selectedMedication = _routine?.medicineId;
        _selectedFrequency = _routine?.frequency;
        _generalTime = _routine?.getTimeOfDay;
        selectedDayOfWeek = _routine?.dayOfWeek;
        _customDays = _routine?.getCustomDays ?? [];
        _customTimes = _routine?.getCustomTimes ?? {};

        if (_customTimes.isNotEmpty) {
          _useGeneralTime = false;
        }
      });
    }
    context.read<RoutineBloc>().add(LoadRoutinesMedicamentsEvent());
  }

  void _resetState() {
    _generalTime = null;
    selectedDayOfWeek = null;
    _customDays.clear();
    _customTimes.clear();
    _useGeneralTime = true;
  }

  Future<void> _selectDays() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        List<DateTime> selectedDays = List.from(_customDays);
        return SelectDaysBottomSheetWidget(
          onPressed: () {
            setState(() {
              _customDays = selectedDays;
            });
            Navigator.pop(context);
          },
          selectedDays: selectedDays,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _routine == null ? AppString.routineCreate : AppString.rutineEdit),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<RoutineBloc>().add(LoadRoutinesEvent());
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<RoutineBloc, RoutineState>(
          listener: (context, state) {
            if (state is RoutineErrorAlertState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
            if (state is RoutineSuccessAlertState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
              context.read<RoutineBloc>().add(LoadRoutinesEvent());
              Navigator.pop(context);
            }
            if (state is RoutineAddEditErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
              context.read<RoutineBloc>().add(LoadRoutinesEvent());
            }
          },
          builder: (context, state) {
            if (state is RoutineMedicamentsLoadedState) {
              return Form(
                key: _formKey,
                child: ListView(
                  children: [
                    buildMedicationDropdown(
                      context: context,
                      medications: state.medicines,
                      selectedMedication: selectedMedication,
                      onChanged: (value) {
                        setState(() {
                          selectedMedication = value;
                        });
                      },
                    ),
                    CustomSizedBoxes.get15(),
                    buildFrecuencyDropdown(
                      context: context,
                      frecuencies: RoutineFrequency.allValues,
                      selectedFrequency: _selectedFrequency,
                      onChanged: (value) {
                        setState(() {
                          _resetState();
                          _selectedFrequency = value;
                        });
                      },
                    ),
                    CustomSizedBoxes.get15(),
                    if (_selectedFrequency == AppString.daily) ...[
                      buildElevatedButtonSelectHour(
                        context: context,
                        onPressed: () async {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: _generalTime ?? TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              _generalTime = pickedTime;
                            });
                          }
                        },
                        generalTime: _generalTime,
                      ),
                    ],
                    if (_selectedFrequency == AppString.weekly) ...[
                      buildDayOfWeekDropdown(
                        selectedDayOfWeek: selectedDayOfWeek,
                        onChanged: (value) {
                          setState(() {
                            selectedDayOfWeek = value;
                          });
                        },
                      ),
                      CustomSizedBoxes.get15(),
                      buildElevatedButtonSelectHour(
                        context: context,
                        generalTime: _generalTime,
                        onPressed: () async {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: _generalTime ?? TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              _generalTime = pickedTime;
                            });
                          }
                        },
                      ),
                      CustomSizedBoxes.get15(),
                    ],
                    if (_selectedFrequency == AppString.customized) ...[
                      ElevatedButton(
                        onPressed: _selectDays,
                        child: const Text(AppString.selectDays),
                      ),
                      CustomSizedBoxes.get15(),
                      SwitchListTile(
                        title: const Text(AppString.useHourGeneral),
                        value: _useGeneralTime,
                        onChanged: (value) {
                          setState(() {
                            _useGeneralTime = value;
                            if (_useGeneralTime) {
                              _customTimes.clear();
                            }
                          });
                        },
                      ),
                      CustomSizedBoxes.get15(),
                      if (_useGeneralTime)
                        buildElevatedButtonSelectHourGeneral(
                          context: context,
                          generalTime: _generalTime,
                          onPressed: () async {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: _generalTime ?? TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              setState(() {
                                _generalTime = pickedTime;
                              });
                            }
                          },
                        ),
                      if (!_useGeneralTime)
                        buildCustomDaysList(context, _customDays, _customTimes,
                            (day, pickedTime) {
                          setState(() {
                            _customTimes[day] = pickedTime;
                          });
                        }),
                    ],
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            List<String> customDays = _customDays
                                .map(
                                  (date) => date.toIso8601String(),
                                )
                                .toList();

                            Map<String, String> customTimes = _customTimes.map(
                                (date, time) => MapEntry(date.toIso8601String(),
                                    "${time.hour}:${time.minute}"));

                            String generalTime = _generalTime == null
                                ? ""
                                : "${_generalTime!.hour}:${_generalTime!.minute}";

                            if (_routine != null) {
                              final routine = _routine!.copyWith(
                                medicineId: selectedMedication!,
                                frequency: _selectedFrequency!,
                                dosageTime: generalTime,
                                dayOfWeek: selectedDayOfWeek,
                                customDays: customDays,
                                customTimes: customTimes,
                                dateUpdated: DateTime.now().toString(),
                              );
                              context
                                  .read<RoutineBloc>()
                                  .add(UpdateRoutineEvent(routine));
                            } else {
                              final routine = Routine(
                                routineId: DateTime.now().toString(),
                                medicineId: selectedMedication!,
                                frequency: _selectedFrequency!,
                                dosageTime: generalTime,
                                dayOfWeek: selectedDayOfWeek,
                                customDays: customDays,
                                customTimes: customTimes,
                                dateUpdated: DateTime.now().toString(),
                              );
                              context.read<RoutineBloc>().add(
                                  AddRoutineEvent(routine, _useGeneralTime));
                            }
                          }
                        },
                        child: const Text(AppString.save),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is RoutineErrorState) {
              return Center(
                child: Text(state.error),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
