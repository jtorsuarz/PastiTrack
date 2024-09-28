import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/core/constants/app_string.dart';
import 'package:pasti_track/core/constants/app_urls.dart';
import 'bloc/password_recovery_bloc.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text(AppString.recoveryPassword)),
      body: BlocListener<PasswordRecoveryBloc, PasswordRecoveryState>(
        listener: (context, state) {
          if (state is PasswordRecoverySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(AppString.recoveryPasswordEmailSend)),
            );
            Timer(
              const Duration(seconds: 5),
              () => context.go(AppUrls.signInPath),
            );
          } else if (state is PasswordRecoveryFailure) {
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final email = emailController.text.trim();
                  if (email.isNotEmpty) {
                    context
                        .read<PasswordRecoveryBloc>()
                        .add(PasswordRecoveryRequested(email));
                  }
                },
                child: const Text(AppString.recoveryPassword),
              ),
              BlocBuilder<PasswordRecoveryBloc, PasswordRecoveryState>(
                builder: (context, state) {
                  if (state is PasswordRecoveryLoading) {
                    return const CircularProgressIndicator();
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
