import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/features/routines/domain/entities/routine.dart';
import 'package:pasti_track/features/routines/presentation/bloc/routine_bloc.dart';
import 'package:pasti_track/widgets/custom_paddings.dart';

class RoutineCard extends StatelessWidget {
  final Routine routine;

  const RoutineCard({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: CustomPaddings.getAll15(),
      child: ListTile(
        title: Text(routine.routineId),
        subtitle: Text(
          AppString.frecuencyAndHourFormat(
              routine.frequency, routine.dosageTime),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () => context.push(
                      AppUrls.addEditRoutinesPath,
                      extra: routine,
                    ),
                icon: const Icon(Icons.edit)),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(AppString.routineDeleted),
                      content: const Text(AppString.routineDeleteConfirmation),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(AppString.cancel),
                        ),
                        TextButton(
                          onPressed: () {
                            BlocProvider.of<RoutineBloc>(context)
                                .add(DeleteRoutineEvent(routine.routineId));
                            Navigator.of(context).pop();
                          },
                          child: const Text(AppString.delete),
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
