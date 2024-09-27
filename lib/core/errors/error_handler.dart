import 'package:firebase_auth/firebase_auth.dart';

class ErrorHandler {
  static String handleError(Object error) {
    // Aquí puedes personalizar el manejo de errores
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No hay un usuario con ese correo electrónico.';
        case 'wrong-password':
          return 'La contraseña es incorrecta.';
        // Agrega más casos según sea necesario
        default:
          return 'Ocurrió un error inesperado. Intenta de nuevo.';
      }
    }
    return 'Ocurrió un error inesperado.';
  }
}
