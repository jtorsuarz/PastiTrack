import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/features/routines/domain/entities/routine.dart';
import 'package:pasti_track/features/routines/presentation/bloc/routine_bloc.dart';

class AddEditRoutineScreen extends StatefulWidget {
  final Routine? routine;
  const AddEditRoutineScreen({super.key, this.routine});

  @override
  State<AddEditRoutineScreen> createState() => _AddEditRoutineScreenState();
}

class _AddEditRoutineScreenState extends State<AddEditRoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedMedication;
  String? _selectedFrequency;
  TimeOfDay? _generalTime; // Hora general
  String? _selectedDayOfWeek; // Para Semanal
  List<DateTime> _customDays = []; // Días para Personalizada
  Map<DateTime, TimeOfDay> _customTimes = {}; // Horarios personalizados por día
  bool _useGeneralTime = true; // Usar hora general o no (Personalizada)

  void _resetState() {
    _generalTime = null;
    _selectedDayOfWeek = null;
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

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Seleccionar Días',
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
                    child: const Text('Seleccionar Día Individual'),
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
                    child: const Text('Seleccionar Rango de Fechas'),
                  ),
                  const Divider(height: 24),
                  Text(
                    'Días Seleccionados:',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  if (selectedDays.isEmpty)
                    const Text('No se han seleccionado días.'),
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
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _customDays = selectedDays;
                          });
                          Navigator.pop(context); // Guardar y cerrar
                        },
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Rutina'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Selección de Medicamento
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Medicamento'),
                items: ['Medicamento A', 'Medicamento B', 'Medicamento C']
                    .map((med) => DropdownMenuItem(
                          value: med,
                          child: Text(med),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMedication = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleccione un medicamento' : null,
              ),
              const SizedBox(height: 16.0),

              // Selección de Frecuencia
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Frecuencia'),
                items: ['Diaria', 'Semanal', 'Personalizada']
                    .map((freq) => DropdownMenuItem(
                          value: freq,
                          child: Text(freq),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _resetState();
                    _selectedFrequency = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleccione una frecuencia' : null,
              ),
              const SizedBox(height: 16.0),

              // Lógica para Diaria
              if (_selectedFrequency == 'Diaria') ...[
                ElevatedButton(
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
                  child: Text(_generalTime == null
                      ? 'Seleccionar Hora'
                      : 'Hora: ${_generalTime!.format(context)}'),
                ),
              ],

              // Lógica para Semanal
              if (_selectedFrequency == 'Semanal') ...[
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Día de la Semana'),
                  items: ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes']
                      .map((day) => DropdownMenuItem(
                            value: day,
                            child: Text(day),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDayOfWeek = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Seleccione un día de la semana' : null,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
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
                  child: Text(_generalTime == null
                      ? 'Seleccionar Hora'
                      : 'Hora: ${_generalTime!.format(context)}'),
                ),
              ],

              // Lógica para Personalizada
              if (_selectedFrequency == 'Personalizada') ...[
                ElevatedButton(
                  onPressed: _selectDays,
                  child: const Text('Seleccionar Días'),
                ),
                const SizedBox(height: 16.0),
                SwitchListTile(
                  title: const Text('Usar Hora General'),
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
                if (_useGeneralTime)
                  ElevatedButton(
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
                    child: Text(_generalTime == null
                        ? 'Seleccionar Hora General'
                        : 'Hora: ${_generalTime!.format(context)}'),
                  ),
                if (!_useGeneralTime)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _customDays.length,
                    itemBuilder: (context, index) {
                      final day = _customDays[index];
                      return Row(
                        children: [
                          Text(
                              '${day.day}/${day.month}/${day.year}: ${_customTimes[day]?.format(context) ?? 'No Seleccionada'}'),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.access_time),
                            onPressed: () async {
                              final pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  _customTimes[day] = pickedTime;
                                });
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
              ],

              // Botón de Guardar
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rutina guardada')),
                      );
                    }
                  },
                  child: const Text('Guardar Rutina'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  REFACTORIZAR Y ASEGURAR EL GUARDADO DE LA RUTINA.