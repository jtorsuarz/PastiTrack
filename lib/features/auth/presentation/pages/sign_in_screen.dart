import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/features/auth/presentation/bloc/auth_bloc.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController =
      TextEditingController(text: 'j.torsuarz@gmail.com');
  final TextEditingController passwordController =
      TextEditingController(text: 'Test123');

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppString.signIn)),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading || state is AuthInitial) {
            const Center(child: CircularProgressIndicator());
          } else if (state is AuthAuthenticated) {
            context.go(AppUrls.homePath);
          } else if (state is AuthUnauthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(AppString.unauthenticated)),
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
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: passwordController,
                decoration:
                    const InputDecoration(labelText: AppString.password),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: () {
                  final email = emailController.text;
                  final password = passwordController.text;
                  BlocProvider.of<AuthBloc>(context)
                      .add(AuthLoggedIn(email: email, password: password));
                },
                child: const Text(AppString.signIn),
              ),
              ElevatedButton(
                onPressed: () {
                  context.go(AppUrls.signUpPath);
                },
                child: const Text(AppString.signUp),
              ),
              ElevatedButton(
                onPressed: () {
                  context.go(AppUrls.forgotPasswordPath);
                },
                child: const Text(AppString.forgotPassword),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
