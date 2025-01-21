import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/features/events/presentation/bloc/events_bloc.dart';
import 'package:pasti_track/features/routines/presentation/bloc/routine_bloc.dart';
import 'package:pasti_track/features/routines/presentation/widget/routine_card.dart';

// ignore: must_be_immutable
class Routines extends StatelessWidget {
  bool showAppBar;
  Routines({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: const Text(AppString.routinesList),
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
      body: BlocConsumer<RoutineBloc, RoutineState>(
        listener: (context, state) {
          if (state is RoutineErrorAlertState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
          if (state is RoutineSuccessAlertState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.read<EventsBloc>().add(LoadingEventsEvent());
          }
        },
        builder: (context, state) {
          if (state is RoutineLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RoutineLoadedState) {
            if (state.routines.isEmpty) {
              return const Center(child: Text(AppString.routinesEmpty));
            }
            return ListView.builder(
              itemCount: state.routines.length,
              itemBuilder: (context, index) {
                final routine = state.routines[index];
                return RoutineCard(routine: routine);
              },
            );
          }
          if (state is RoutineErrorState) {
            return Center(child: Text(state.error));
          } else {
            return const Center(child: Text(AppString.errorUnknown));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppUrls.addEditRoutinesPath);
        },
        heroTag: AppString.routineAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
