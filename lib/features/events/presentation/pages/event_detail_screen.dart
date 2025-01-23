import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';
import 'package:pasti_track/features/events/presentation/bloc/events_bloc.dart';
import 'package:pasti_track/core/config.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/widgets/custom_sizes_box.dart';

class EventDetailScreen extends StatelessWidget {
  final EventEntity? event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.event),
        centerTitle: true,
      ),
      body: BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          if (state is EventsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (event == null) {
            return Center(
              child: Text(AppString.eventNotFound,
                  style: Theme.of(context).textTheme.headlineMedium),
            );
          }

          return FutureBuilder<String>(
            future: event!.medicationName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(AppString.errorWhenLoad(AppString.medicament)),
                );
              } else if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.textWithTwoPoints(
                            AppString.medicament, snapshot.data),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      CustomSizedBoxes.get20(),
                      Text(
                        AppString.textWithTwoPoints(
                          AppString.dateScheduled,
                          event!.dateScheduled.toLocal(),
                        ),
                      ),
                      CustomSizedBoxes.get20(),
                      Text(
                        AppString.textWithTwoPoints(
                            AppString.status, event!.status.name),
                      ),
                      CustomSizedBoxes.get40(),
                      ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<EventsBloc>(context).add(
                            EventChangeStatusEvent(event!.eventId),
                          );
                          context.pushReplacement(AppUrls.homePath);
                        },
                        child: Text(AppString.registerTake),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.pushReplacement(AppUrls.homePath);
                        },
                        child: Text(AppString.omitter),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text(AppString.medicamentNotFound),
                );
              }
            },
          );
        },
      ),
    );
  }
}
