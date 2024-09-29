import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/core/constants/app_string.dart';
import 'package:pasti_track/core/constants/app_urls.dart';
import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:pasti_track/features/auth/presentation/auth_wrapper/auth_wrapper.dart';
import 'package:pasti_track/features/auth/presentation/password_recovery/password_recovery_screen.dart';
import 'package:pasti_track/features/auth/presentation/sign_in/sign_in_screen.dart';
import 'package:pasti_track/features/auth/presentation/sign_up/sign_up_screen.dart';
import 'package:pasti_track/features/auth/presentation/sign_up/sign_up_success_screen.dart';
import 'package:pasti_track/features/home/presentation/home_screen.dart';
import 'package:pasti_track/features/auth/presentation/auth_wrapper/bloc/auth_bloc.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppUrls.initial,
    routes: <RouteBase>[
      GoRoute(
        path: AppUrls.initial,
        builder: (BuildContext context, GoRouterState state) {
          return const AuthWrapper();
        },
      ),
      GoRoute(
        path: AppUrls.homePath,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: AppUrls.signInPath,
        builder: (BuildContext context, GoRouterState state) {
          return SignInScreen();
        },
      ),
      GoRoute(
        path: AppUrls.signUpPath,
        builder: (BuildContext context, GoRouterState state) {
          return SignUpScreen();
        },
      ),
      GoRoute(
        path: AppUrls.signUpSuccessPath,
        builder: (BuildContext context, GoRouterState state) {
          return const SignUpSuccessScreen();
        },
      ),
      GoRoute(
        path: AppUrls.forgotPasswordPath,
        builder: (BuildContext context, GoRouterState state) {
          return const PasswordRecoveryScreen();
        },
      ),
      GoRoute(
        path: AppUrls.settingsPath,
        builder: (BuildContext context, GoRouterState state) {
          return const Center(
              child: Text(
            AppUrls.settingsPath,
            style: TextStyle(color: Colors.amber),
          ));
        },
      ),
      GoRoute(
        path: AppUrls.editProfilePath,
        builder: (BuildContext context, GoRouterState state) {
          return const Center(
              child: Text(
            AppUrls.editProfilePath,
            style: TextStyle(color: Colors.amber),
          ));
        },
      ),
      GoRoute(
        path: AppUrls.homePath,
        builder: (BuildContext context, GoRouterState state) {
          return const Center(
              child: Text(
            AppUrls.homePath,
            style: TextStyle(color: Colors.amber),
          ));
        },
      ),
      GoRoute(
        path: AppUrls.medicinesPath,
        builder: (BuildContext context, GoRouterState state) {
          return const Center(
              child: Text(
            AppUrls.medicinesPath,
            style: TextStyle(color: Colors.amber),
          ));
        },
      ),
      GoRoute(
        path: AppUrls.routinesPath,
        builder: (BuildContext context, GoRouterState state) {
          return const Center(
              child: Text(
            AppUrls.routinesPath,
            style: TextStyle(color: Colors.amber),
          ));
        },
      ),
      GoRoute(
        path: AppUrls.historyPath,
        builder: (BuildContext context, GoRouterState state) {
          return const Center(
              child: Text(
            AppUrls.historyPath,
            style: TextStyle(color: Colors.amber),
          ));
        },
      ),
    ],
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final isLoading = authState is AuthLoading ||
          authState is AuthInitial ||
          authState is AuthUnauthenticated;
      AppLogger.p("GoRouter", authState.toString());
      if (isLoading) return null;

      final isLoggedIn = authState is AuthAuthenticated;
      if (!isLoggedIn) return AppUrls.signInPath;

      final isLoggingIn = state.matchedLocation == AppUrls.signInPath;
      if (isLoggedIn && isLoggingIn) return AppUrls.homePath;
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
