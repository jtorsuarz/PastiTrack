import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/services/WorkManager_service.dart';
import 'package:pasti_track/core/services/notification_service.dart';
import 'package:pasti_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pasti_track/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:pasti_track/features/events/presentation/bloc/events_bloc.dart';
import 'package:pasti_track/features/home/presentation/home_screen.dart';
import 'package:go_router/go_router.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go(AppUrls.homePath);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          //if (state is AuthUnauthenticated) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text(AppString.unauthenticated)),
          // );
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return state is AuthAuthenticated
              ? _AuthenticatedHome()
              : SignInScreen();
        },
      ),
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
