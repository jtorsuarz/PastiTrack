import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:pasti_track/core/providers/app_blocs_provider.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';
import 'package:pasti_track/features/events/presentation/bloc/events_bloc.dart';
import 'package:pasti_track/widgets/custom_sizes_box.dart';

class EventCard extends StatefulWidget {
  final EventEntity event;

  const EventCard({
    super.key,
    required this.event,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late EventEntity eventEntity;
  late bool isTaken;
  late String eventStatus;

  @override
  void initState() {
    super.initState();
    eventEntity = widget.event;
    isTaken = eventEntity.dateDone == null ? false : true;
    eventStatus = isTaken ? AppString.take : AppString.pending.toUpperCase();
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
                    Text(
                      eventEntity.eventId,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomSizedBoxes.get10(),
                    Wrap(
                      children: [
                        const Text(
                          "${AppString.medicament} :",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          eventEntity.medicineId,
                          style: TextStyle(
                            fontSize: 14,
                            color: isTaken ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
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
                          eventStatus,
                          style: TextStyle(
                            fontSize: 14,
                            color: isTaken ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                          "${eventEntity.dateScheduled}",
                          style: TextStyle(
                            fontSize: 14,
                            color: isTaken ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        )
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
                          "${eventEntity.dateDone?.toLocal()}",
                          style: TextStyle(
                            fontSize: 14,
                            color: isTaken ? Colors.green : Colors.red,
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
                  onPressed: isTaken
                      ? null
                      : () {
                          context
                              .read<EventsBloc>()
                              .add(EventChangeStatusEvent(eventEntity.eventId));
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isTaken ? Colors.grey : Colors.teal,
                  ),
                  child: Text(isTaken ? "Tomado" : "Marcar como Tomado"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
