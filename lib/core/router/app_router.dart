import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/core/constants/app_string.dart';
import 'package:pasti_track/core/constants/app_urls.dart';
import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:pasti_track/features/auth/presentation/auth_wrapper/auth_wrapper.dart';
import 'package:pasti_track/features/auth/presentation/sign_in/sign_in_screen.dart';
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
        path: AppUrls.signInPath,
        builder: (BuildContext context, GoRouterState state) {
          return SignInScreen();
        },
      ),
      GoRoute(
        path: AppUrls.homePath,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
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
      final isLoggingIn = state.matchedLocation == AppUrls.signInPath;

      if (!isLoggedIn) return AppUrls.signInPath;
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
