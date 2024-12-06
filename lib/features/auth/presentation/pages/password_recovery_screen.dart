import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pasti_track/widgets/custom_sizes_box.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.recoveryPassword),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordRecoverySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(AppString.recoveryPasswordEmailSend)),
            );
            Timer(
              const Duration(seconds: 5),
              () => context.go(AppUrls.signInPath),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: AppString.email),
              ),
              CustomSizedBoxes.get20(),
              ElevatedButton(
                onPressed: () {
                  final email = emailController.text.trim();
                  if (email.isNotEmpty) {
                    context
                        .read<AuthBloc>()
                        .add(AuthPasswordRecoveryRequested(email: email));
                  }
                },
                child: const Text(AppString.recoveryPassword),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
