import 'package:flutter/material.dart';
import 'package:pasti_track/core/config.dart';

// ignore: must_be_immutable
class SelectDaysBottomSheetWidget extends StatelessWidget {
  List<DateTime> selectedDays;
  void Function()? onPressed;
  SelectDaysBottomSheetWidget(
      {super.key, required this.selectedDays, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppString.selectDays,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Selector de Día Individual
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null && !selectedDays.contains(picked)) {
                    setState(() {
                      selectedDays.add(picked);
                      selectedDays.sort(); // Ordena las fechas
                    });
                  }
                },
                child: const Text(AppString.selectDayIndividual),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  // Selector de Rango de Fechas
                  DateTimeRange? range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    initialDateRange: selectedDays.isNotEmpty
                        ? DateTimeRange(
                            start: selectedDays.first,
                            end: selectedDays.last,
                          )
                        : null,
                  );
                  if (range != null) {
                    List<DateTime> rangeDays = [];
                    for (int i = 0;
                        i <= range.end.difference(range.start).inDays;
                        i++) {
                      rangeDays.add(range.start.add(Duration(days: i)));
                    }
                    setState(() {
                      selectedDays.addAll(rangeDays);
                      selectedDays =
                          selectedDays.toSet().toList(); // Evita duplicados
                      selectedDays.sort(); // Ordena las fechas
                    });
                  }
                },
                child: const Text(AppString.selectRangeDate),
              ),
              const Divider(height: 24),
              Text(
                AppString.daysSelected,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              if (selectedDays.isEmpty) const Text(AppString.noSelectDays),
              if (selectedDays.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: selectedDays.length,
                    itemBuilder: (context, index) {
                      final day = selectedDays[index];
                      return ListTile(
                        title: Text('${day.day}/${day.month}/${day.year}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              selectedDays.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Cancelar y cerrar
                    },
                    child: const Text(AppString.cancel),
                  ),
                  ElevatedButton(
                    onPressed: onPressed,
                    child: const Text(AppString.save),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
