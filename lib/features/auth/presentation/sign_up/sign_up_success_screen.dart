import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pasti_track/core/config.dart';
import 'package:go_router/go_router.dart';

class SignUpSuccessScreen extends StatelessWidget {
  final int timeoutDuration;

  const SignUpSuccessScreen({super.key, this.timeoutDuration = 5});

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: timeoutDuration), () {
      context.go(AppUrls.signInPath);
    });

    return Scaffold(
      appBar: AppBar(title: const Text(AppString.signUpSuccess)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                size: 100,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              const Text(
                AppString.signInCompleteSuccess,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.go(AppUrls.signInPath);
                },
                child: const Text(AppString.goToSignIn),
              ),
              const SizedBox(height: 20),
              Text(
                AppString.redirectAutomaticSeconds(timeoutDuration),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
