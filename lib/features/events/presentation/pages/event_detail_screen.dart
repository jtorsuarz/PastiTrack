import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';
import 'package:pasti_track/features/events/presentation/bloc/events_bloc.dart';
import 'package:pasti_track/core/config.dart';
import 'package:go_router/go_router.dart';

class EventDetailScreen extends StatelessWidget {
  final EventEntity? event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.event),
        centerTitle: true,
      ),
      body: BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          if (state is EventsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Verificamos si el evento es nulo
          if (event == null) {
            return Center(
              child: Text('Evento no encontrado',
                  style: Theme.of(context).textTheme.headlineMedium),
            );
          }

          // Usamos FutureBuilder para manejar la llamada asíncrona
          return FutureBuilder<String>(
            future:
                event!.medicationName(), // Llamada asíncrona a medicationName()
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error al cargar el medicamento'),
                );
              } else if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Medicamento: ${snapshot.data}', // Aquí mostramos el medicamento obtenido
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: 20),
                      Text(
                          'Fecha Programada: ${event!.dateScheduled.toLocal()}'),
                      SizedBox(height: 20),
                      Text('Estado: ${event!.status.name}'),
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          // Marcar evento como completado
                          BlocProvider.of<EventsBloc>(context)
                              .add(EventChangeStatusEvent(event!.eventId));

                          // Esperar que la actualización termine y redirigir a Home
                          context.pushReplacement(AppUrls.homePath);
                        },
                        child: Text('Marcar como Completado'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Redirigir a Home directamente
                          context.pushReplacement(AppUrls.homePath);
                        },
                        child: Text('Omitir'),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text('No se encontró el medicamento'),
                );
              }
            },
          );
        },
      ),
    );
  }
}
