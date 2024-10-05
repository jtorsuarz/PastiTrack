import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/core/errors/error_screen.dart';
import 'package:pasti_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pasti_track/features/auth/presentation/pages/sign_in_screen.dart';
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
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AuthAuthenticated) {
          return const HomeScreen();
        } else {
          return SignInScreen();
        }
      },
    );
  }
}
