// lib/presentation/auth/sign_in/sign_in_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/core/constants/app_string.dart';
import 'package:pasti_track/core/constants/app_urls.dart';
import 'bloc/sign_in_bloc.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppString.signIn)),
      body: BlocListener<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignInLoading) {
            const Center(child: CircularProgressIndicator());
          } else if (state is SignInSuccess) {
            context.go(AppUrls.homePath);
          } else if (state is SignInFailure) {
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
                  BlocProvider.of<SignInBloc>(context)
                      .add(SignInButtonPressed(email, password));
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
