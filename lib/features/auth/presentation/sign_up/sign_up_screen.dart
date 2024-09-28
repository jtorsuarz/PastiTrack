import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/core/constants/app_string.dart';
import 'package:pasti_track/core/constants/app_urls.dart';
import 'package:pasti_track/features/auth/presentation/sign_up/bloc/sign_up_bloc.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppString.signUp)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              context.go(AppUrls.signUpSuccessPath);
            } else if (state is SignUpFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            if (state is SignUpLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: AppString.email),
                ),
                TextField(
                  controller: passwordController,
                  decoration:
                      const InputDecoration(labelText: AppString.password),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final email = emailController.text;
                    final password = passwordController.text;
                    BlocProvider.of<SignUpBloc>(context).add(
                      SignUpSubmitted(email, password),
                    );
                  },
                  child: const Text(AppString.signUp),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
