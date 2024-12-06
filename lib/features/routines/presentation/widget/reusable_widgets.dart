import 'package:flutter/material.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';
import 'package:pasti_track/features/routines/domain/entities/routine_days.dart';
import 'package:pasti_track/features/routines/domain/entities/routine_frequency.dart';

/// Dropdown para seleccionar medicamentos
Widget buildMedicationDropdown({
  required BuildContext context,
  required List<Medicament> medications,
  required String? selectedMedication,
  required Function(String?) onChanged,
}) {
  String textHint = medications.isNotEmpty
      ? AppString.selectMedicament
      : AppString.noMedicines;
  return DropdownButtonFormField<String>(
    value: selectedMedication,
    decoration: const InputDecoration(labelText: AppString.medicament),
    disabledHint: Text(textHint),
    items: medications
        .map((med) =>
            DropdownMenuItem(value: med.medicineId, child: Text(med.name)))
        .toList(),
    onChanged: onChanged,
    validator: (value) => value == null ? AppString.selectMedicament : null,
  );
}

/// Dropdown para seleccionar Frecuencia
Widget buildFrecuencyDropdown({
  required BuildContext context,
  required List<RoutineFrequency> frecuencies,
  required String? selectedFrequency,
  required Function(String?) onChanged,
}) {
  return DropdownButtonFormField<String>(
    value: selectedFrequency,
    decoration: const InputDecoration(labelText: AppString.frecuency),
    items: frecuencies
        .map((freq) => DropdownMenuItem(
              value: freq.description,
              child: Text(freq.description),
            ))
        .toList(),
    onChanged: onChanged,
    validator: (value) => value == null ? AppString.selectFrequency : null,
  );
}

Widget buildElevatedButtonSelectHour({
  required BuildContext context,
  required Function()? onPressed,
  TimeOfDay? generalTime,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: Text(
      generalTime == null
          ? AppString.selectHour
          : AppString.hourSelectedWithFormat(
              generalTime.format(context),
            ),
    ),
  );
}

Widget buildElevatedButtonSelectHourGeneral({
  required BuildContext context,
  required Function()? onPressed,
  TimeOfDay? generalTime,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: Text(
      generalTime == null
          ? AppString.selectHourGeneral
          : AppString.hourSelectedWithFormat(
              generalTime.format(context),
            ),
    ),
  );
}

Widget buildDayOfWeekDropdown({
  required String? selectedDayOfWeek,
  required Function(String?)? onChanged,
}) {
  return DropdownButtonFormField<String>(
    value: selectedDayOfWeek,
    decoration: const InputDecoration(labelText: AppString.dayOfWeek),
    items: RoutineDays.allValues
        .map(
          (day) => DropdownMenuItem(
            value: day.description,
            child: Text(day.description),
          ),
        )
        .toList(),
    onChanged: onChanged,
    validator: (value) => value == null ? AppString.selectDayofWeek : null,
  );
}

Widget buildCustomDaysList(
    BuildContext context,
    List<DateTime> customDays,
    Map<DateTime, TimeOfDay> customTimes,
    void Function(DateTime, TimeOfDay) onChanged) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: customDays.length,
    itemBuilder: (context, index) {
      final day = customDays[index];
      return Row(
        children: [
          Text(
            AppString.dateSelectedWithFormat(
                day, customTimes[day]?.format(context)),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.access_time),
            onPressed: () async {
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (pickedTime != null) {
                onChanged(day, pickedTime);
              }
            },
          ),
        ],
      );
    },
  );
}
