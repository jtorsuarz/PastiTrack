import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';
import 'package:pasti_track/features/events/presentation/bloc/events_bloc.dart';
import 'package:pasti_track/features/events/presentation/widgets/event_card.dart';

class EventsScreen extends StatelessWidget {
  final bool showAppBar;
  const EventsScreen({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);

    return Scaffold(
      body: BlocConsumer<EventsBloc, EventsState>(
        listener: (context, state) {
          AppLogger.p("EventsScreen", "EventsStates ${state.toString()}");
          themeData = Theme.of(context);
          if (state is EventsErrorAlertState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
          if (state is EventsSuccessAlertState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          AppLogger.p("EventsScreen", "EventsStates ${state.toString()}");
          if (state is EventsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is EventsDataState) {
            List<EventEntity> events = state.events;

            if (events.isEmpty) {
              return const Center(
                child: Text(AppString.noScheduledEventsFound),
              );
            }

            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                EventEntity entity = state.events[index];
                return FutureBuilder<String>(
                  future: entity.medicationName(), // Llama al método asíncrono.
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text(AppString.errorWhenLoad(snapshot.error));
                    } else {
                      String medicationName = snapshot.data ?? AppString.noName;
                      return EventCard(
                        event: entity,
                        medicationName: medicationName,
                        themeData: themeData,
                      );
                    }
                  },
                );
              },
            );
          }

          return Center(
            child: Text(AppString.errorWhenLoad(AppString.events)),
          );
        },
      ),
    );
  }
}
