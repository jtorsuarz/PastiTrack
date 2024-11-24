import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/features/medicines/data/datasources/medicament_local_datasource.dart';
import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';
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

  // Variables de estado
  String? selectedMedication;
  String? _selectedFrequency;
  TimeOfDay? _generalTime;
  String? selectedDayOfWeek;
  List<DateTime> _customDays = [];
  Map<DateTime, TimeOfDay> customTimes = {};
  bool _useGeneralTime = true;

  void _resetState() {
    _generalTime = null;
    selectedDayOfWeek = null;
    _customDays.clear();
    customTimes.clear();
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
            Navigator.pop(context); // Guardar y cerrar
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
        title: const Text(AppString.createRoutine),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Selección de Medicamento
              buildMedicationDropdown(
                context: context,
                medications: [
                  Medicament(
                      dateUpdated: "", dose: "", medicineId: "1", name: "asd")
                ],
                selectedMedication: selectedMedication,
                onChanged: (value) {
                  setState(() {
                    selectedMedication = value;
                  });
                },
              ),
              CustomSizedBoxes.get15(),

              // Selección de Frecuencia
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

              // Lógica para Diaria
              if (_selectedFrequency == AppString.daily) ...[
                buildElevatedButtonSelectHour(
                  context: context,
                  onPressed: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
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

              // Lógica para Semanal
              if (_selectedFrequency == AppString.weekly) ...[
                buildDayOfWeekDropdown(onChanged: (value) {
                  setState(() {
                    selectedDayOfWeek = value;
                  });
                }),
                CustomSizedBoxes.get15(),
                buildElevatedButtonSelectHour(
                  context: context,
                  generalTime: _generalTime,
                  onPressed: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
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

              // Lógica para Personalizada
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
                        customTimes.clear();
                      }
                    });
                  },
                ),
                CustomSizedBoxes.get15(),
                if (_useGeneralTime)
                  buildElevatedButtonSelectHourGeneral(
                    context: context,
                    onPressed: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _generalTime = pickedTime;
                        });
                      }
                    },
                  ),
                if (!_useGeneralTime)
                  buildCustomDaysList(context, _customDays, customTimes,
                      (day, pickedTime) {
                    setState(() {
                      customTimes[day] = pickedTime;
                    });
                  }),
              ],

              // Botón de Guardar
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(AppString.routineSaved)),
                      );
                    }
                  },
                  child: const Text(AppString.save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
