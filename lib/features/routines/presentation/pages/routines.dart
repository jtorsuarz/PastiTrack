import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/features/routines/presentation/bloc/routine_bloc.dart';
import 'package:pasti_track/features/routines/presentation/widget/routine_card.dart';

class Routines extends StatelessWidget {
  bool showAppBar;
  Routines({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: const Text('Listado de Rutinas'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    context.push(AppUrls.addEditRoutinesPath);
                  },
                ),
              ],
            )
          : null,
      body: BlocBuilder<RoutineBloc, RoutineState>(
        builder: (context, state) {
          if (state is RoutineLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RoutineLoadedState) {
            if (state.routines.isEmpty) {
              return Center(child: Text('No hay rutinas creadas.'));
            }
            return ListView.builder(
              itemCount: state.routines.length,
              itemBuilder: (context, index) {
                final routine = state.routines[index];
                return RoutineCard(routine: routine);
              },
            );
          } else if (state is RoutineErrorState) {
            return Center(
                child: Text('Error al cargar las rutinas: ${state.error}'));
          } else {
            return Center(child: Text('Estado desconocido.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppUrls.addEditRoutinesPath);
        },
        heroTag: AppString.addRoutine,
        child: const Icon(Icons.add),
      ),
    );
  }
}
