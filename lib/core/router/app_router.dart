import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:pasti_track/features/auth/presentation/pages/auth_wrapper.dart';
import 'package:pasti_track/features/auth/presentation/pages/password_recovery_screen.dart';
import 'package:pasti_track/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:pasti_track/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:pasti_track/features/auth/presentation/pages/sign_up_success_screen.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';
import 'package:pasti_track/features/events/presentation/pages/event_detail_screen.dart';
import 'package:pasti_track/features/home/presentation/home_screen.dart';
import 'package:pasti_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';
import 'package:pasti_track/features/medicines/presentation/pages/add_medication_screen.dart';
import 'package:pasti_track/features/medicines/presentation/pages/medication_screen.dart';
import 'package:pasti_track/features/profile/presentation/pages/profile_screen.dart';
import 'package:pasti_track/features/routines/domain/entities/routine.dart';
import 'package:pasti_track/features/routines/presentation/bloc/routine_bloc.dart';
import 'package:pasti_track/features/routines/presentation/pages/create_routine_screen.dart';
import 'package:pasti_track/features/routines/presentation/pages/routines.dart';
import 'package:pasti_track/features/settings/presentation/pages/settings_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppUrls.initial,
    routes: <RouteBase>[
      GoRoute(
        path: AppUrls.initial,
        builder: (BuildContext context, GoRouterState state) =>
            const AuthWrapper(),
      ),
      GoRoute(
        path: AppUrls.homePath,
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
      ),
      GoRoute(
        path: AppUrls.signInPath,
        builder: (BuildContext context, GoRouterState state) =>
            const AuthWrapper(),
      ),
      GoRoute(
        path: AppUrls.signUpPath,
        builder: (BuildContext context, GoRouterState state) => SignUpScreen(),
      ),
      GoRoute(
        path: AppUrls.signUpSuccessPath,
        builder: (BuildContext context, GoRouterState state) =>
            const SignUpSuccessScreen(),
      ),
      GoRoute(
        path: AppUrls.forgotPasswordPath,
        builder: (BuildContext context, GoRouterState state) =>
            const PasswordRecoveryScreen(),
      ),
      GoRoute(
        path: AppUrls.settingsPath,
        builder: (BuildContext context, GoRouterState state) =>
            SettingsScreen(),
      ),
      GoRoute(
        path: AppUrls.editProfilePath,
        builder: (BuildContext context, GoRouterState state) =>
            const ProfileScreen(),
      ),
      GoRoute(
        path: AppUrls.homePath,
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
      ),
      GoRoute(
        path: AppUrls.medicinesPath,
        builder: (BuildContext context, GoRouterState state) =>
            MedicationScreen(),
      ),
      GoRoute(
          path: AppUrls.addEditMedicinesPath,
          builder: (BuildContext context, GoRouterState state) {
            final medicament = state.extra as Medicament?;
            return AddEditMedicamentScreen(medicament: medicament);
          }),
      GoRoute(
        path: AppUrls.routinesPath,
        builder: (BuildContext context, GoRouterState state) {
          return Routines();
        },
      ),
      GoRoute(
          path: AppUrls.addEditRoutinesPath,
          builder: (BuildContext context, GoRouterState state) {
            final routine = state.extra as Routine?;
            return BlocProvider.value(
              value: context.read<RoutineBloc>(),
              child: AddEditRoutineScreen(routine: routine),
            );
          }),
      GoRoute(
        path: AppUrls.eventRegisterTakePath,
        builder: (BuildContext context, GoRouterState state) {
          final event = state.extra as EventEntity?;
          return EventDetailScreen(event: event);
        },
      ),
    ],
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      AppLogger.p("GoRouter", authState.toString());
      AppLogger.p("GoRouter", state.matchedLocation);

      /// States in which you are loading or unauthenticated (including startup)
      final isLoading = authState is AuthLoading || authState is AuthInitial;

      /// Checks if it is loading, initialising or not authenticated.
      if (isLoading) {
        /// If the status is loading or unauthenticated, avoid redirects.
        return null;
      }

      /// Check if the user is authenticated
      final isLoggedIn = authState is AuthAuthenticated;

      /// If you are not authenticated, redirects to login
      if (!isLoggedIn) {
        return state.matchedLocation;
      }

      /// If you are authenticated but are on the login screen, redirects you to the home page.
      final isLoggingIn = state.matchedLocation == AppUrls.signInPath;
      if (isLoggedIn && isLoggingIn) {
        return AppUrls.homePath;
      }

      /// Maintains normal navigation if everything is OK
      return null;
    },
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Text(AppString.errorWithFormat(state.error)),
        ),
      );
    },
  );
}
