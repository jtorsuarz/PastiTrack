import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pasti_track/core/config.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/widgets/custom_sizes_box.dart';

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
              CustomSizedBoxes.get20(),
              const Text(
                AppString.signInCompleteSuccess,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              CustomSizedBoxes.get20(),
              ElevatedButton(
                onPressed: () {
                  context.go(AppUrls.homePath);
                },
                child: const Text(AppString.enjoyTheApp),
              ),
              CustomSizedBoxes.get20(),
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
