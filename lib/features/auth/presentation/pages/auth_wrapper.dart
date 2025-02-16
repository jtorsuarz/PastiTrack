import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/core/errors/error_screen.dart';
import 'package:pasti_track/core/services/WorkManager_service.dart';
import 'package:pasti_track/core/services/notification_service.dart';
import 'package:pasti_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pasti_track/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:pasti_track/features/events/presentation/bloc/events_bloc.dart';
import 'package:pasti_track/features/home/presentation/home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthError) {
          return ErrorScreen(error: state.message);
        }
        if (state is AuthLoading || state is AuthInitial) {
          return Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is AuthAuthenticated) {
          return _AuthenticatedHome();
        } else {
          return SignInScreen();
        }
      },
    );
  }
}

class _AuthenticatedHome extends StatefulWidget {
  @override
  State<_AuthenticatedHome> createState() => _AuthenticatedHomeState();
}

class _AuthenticatedHomeState extends State<_AuthenticatedHome> {
  @override
  void initState() {
    _initializeNotifications();
    super.initState();
  }

  Future<void> _initializeNotifications() async {
    final eventsBloc = context.read<EventsBloc>();
    await NotificationService().initializeEventNotifications(
      context,
      eventsBloc.markEventAsDone,
      eventsBloc,
      LoadingEventsEvent(),
    );

    WorkManagerService().registerTasks();
  }

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
