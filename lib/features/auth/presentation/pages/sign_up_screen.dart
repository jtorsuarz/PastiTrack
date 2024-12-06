import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pasti_track/widgets/custom_sizes_box.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.signUp),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSignUpSuccess) {
              context.go(AppUrls.signUpSuccessPath);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: AppString.email),
                ),
                CustomSizedBoxes.get20(),
                TextField(
                  controller: passwordController,
                  decoration:
                      const InputDecoration(labelText: AppString.password),
                  obscureText: true,
                ),
                CustomSizedBoxes.get20(),
                ElevatedButton(
                  onPressed: () {
                    final email = emailController.text;
                    final password = passwordController.text;
                    BlocProvider.of<AuthBloc>(context).add(
                      AuthSignUpRequested(email: email, password: password),
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
