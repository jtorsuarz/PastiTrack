import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Error")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Ocurrió un error: $error"),
            ElevatedButton(
              onPressed: () {
                // Opcional: Volver a intentar la autenticación
              },
              child: const Text("Reintentar"),
            ),
          ],
        ),
      ),
    );
  }
}
