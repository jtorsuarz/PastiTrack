import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/features/routines/domain/entities/routine.dart';
import 'package:pasti_track/features/routines/presentation/bloc/routine_bloc.dart';
import 'package:pasti_track/widgets/custom_paddings.dart';

class RoutineCard extends StatelessWidget {
  final Routine routine;

  const RoutineCard({required this.routine});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: CustomPaddings.getAll15(),
      child: ListTile(
        title: Text(routine.routineId),
        subtitle: Text(
            'Frecuencia: ${routine.frequency} - Hora: ${routine.dosageTime}'), //
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            // Confirmar la eliminación de la rutina
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Eliminar Rutina'),
                  content:
                      Text('¿Está seguro de que desea eliminar esta rutina?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        BlocProvider.of<RoutineBloc>(context)
                            .add(DeleteRoutineEvent(routine.routineId));
                        Navigator.of(context).pop();
                      },
                      child: Text('Eliminar'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
