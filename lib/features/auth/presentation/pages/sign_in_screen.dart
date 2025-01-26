import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pasti_track/widgets/custom_sizes_box.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController =
      TextEditingController(text: 'j.torsuarz@gmail.com');
  final TextEditingController passwordController =
      TextEditingController(text: 'Test123');

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.signIn),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: AppString.email),
              keyboardType: TextInputType.emailAddress,
            ),
            CustomSizedBoxes.get20(),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: AppString.password),
              obscureText: true,
            ),
            CustomSizedBoxes.get20(),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                BlocProvider.of<AuthBloc>(context)
                    .add(AuthLoggedIn(email: email, password: password));
              },
              child: const Text(AppString.signIn),
            ),
            CustomSizedBoxes.get20(),
            ElevatedButton(
              onPressed: () {
                context.push(AppUrls.signUpPath);
              },
              child: const Text(AppString.signUp),
            ),
            CustomSizedBoxes.get20(),
            ElevatedButton(
              onPressed: () {
                context.push(AppUrls.forgotPasswordPath);
              },
              child: const Text(AppString.forgotPassword),
            ),
          ],
        ),
      ),
    );
  }
}
