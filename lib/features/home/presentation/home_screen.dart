import 'package:flutter/material.dart';
import 'package:pasti_track/core/constants/app_string.dart';
import 'package:pasti_track/features/auth/presentation/auth_wrapper/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pantalla de Inicio"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLoggedOut());
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          children: [
            Text(AppString.welcomePastiTrack),
          ],
        ),
      ),
    );
  }
}
