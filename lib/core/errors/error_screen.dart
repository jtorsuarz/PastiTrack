import 'package:flutter/material.dart';
import 'package:pasti_track/core/config.dart';

class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppString.error)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppString.errorOcurred(error)),
            ElevatedButton(
              onPressed: () {
                // Opcional: Volver a intentar la autenticación
              },
              child: const Text(AppString.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
