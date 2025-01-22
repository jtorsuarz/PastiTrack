import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';
import 'package:pasti_track/features/events/presentation/bloc/events_bloc.dart';

class EventDetailScreen extends StatelessWidget {
  final EventEntity event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medicamento: ${event.medicineId}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            Text('Fecha Programada: ${event.dateScheduled.toLocal()}'),
            SizedBox(height: 20),
            Text('Estado: ${event.status.name}'),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Llamar a la función de actualización del evento
                BlocProvider.of<EventsBloc>(context)
                    .add(EventChangeStatusEvent(event.eventId));

                // Esperar que la actualización termine y redirigir a Home
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text('Marcar como Completado'),
            ),
            ElevatedButton(
              onPressed: () {
                // Redirigir a Home directamente
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text('Omitir'),
            ),
          ],
        ),
      ),
    );
  }
}
