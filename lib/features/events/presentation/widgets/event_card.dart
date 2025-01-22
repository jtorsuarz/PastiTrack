import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';
import 'package:pasti_track/features/events/domain/entities/event_status.dart';
import 'package:pasti_track/features/events/presentation/bloc/events_bloc.dart';
import 'package:pasti_track/widgets/custom_sizes_box.dart';

class EventCard extends StatefulWidget {
  final EventEntity event;
  final String medicationName;

  const EventCard({
    super.key,
    required this.event,
    required this.medicationName,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late EventEntity eventEntity;
  late bool isAvailable;
  late bool isPassed;
  late bool isTaken;
  late String buttonText;
  @override
  void initState() {
    super.initState();
    eventEntity = widget.event;
    isPassed = eventEntity.status == EventStatus.passed ? true : false;
    isTaken = eventEntity.status == EventStatus.completed ? true : false;
    // is available
    isAvailable = isPassed || isTaken;

    buttonText = AppString.registerTake;

    if (isTaken) {
      buttonText = AppString.take;
    }
    if (isPassed) {
      buttonText = AppString.passed;
    }

    AppLogger.p("EventEntity", eventEntity.eventId);
    AppLogger.p("EventEntity", isPassed);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomSizedBoxes.get10(),
                    Wrap(
                      children: [
                        const Text(
                          "${AppString.medicament}: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.medicationName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                    Wrap(
                      children: [
                        const Text(
                          AppString.statusWithTwoPoint,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          eventEntity.status.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: getStatusColor(eventEntity.status.name),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        Text(
                          AppString.registerTake,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${eventEntity.dateDone?.toLocal() ?? eventEntity.status.name}",
                          style: TextStyle(
                            fontSize: 14,
                            color: getStatusColor(eventEntity.status.name),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Wrap(
                      children: [
                        Text(
                          AppString.dateScheduled,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          eventEntity.formatDateTime(eventEntity.dateScheduled),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
            CustomSizedBoxes.get15(),
            Column(
              children: [
                ElevatedButton(
                  onPressed: isAvailable
                      ? null
                      : () {
                          context
                              .read<EventsBloc>()
                              .add(EventChangeStatusEvent(eventEntity.eventId));
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAvailable ? Colors.grey : Colors.teal,
                  ),
                  child: Text(buttonText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
