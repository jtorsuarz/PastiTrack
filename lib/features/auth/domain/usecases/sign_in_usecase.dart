import 'package:pasti_track/core/constants/app_string.dart';
import 'package:pasti_track/core/errors/exceptions.dart';
import 'package:pasti_track/core/errors/failures.dart';
import 'package:pasti_track/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<void> call(String email, String password) async {
    // Verificar que los parámetros no estén vacíos
    if (email.isEmpty || password.isEmpty) {
      throw Failure(AppString.errorEmailPasswordCannotBeEmpty);
    }

    try {
      await repository.signIn(email, password);
    } on ServerException {
      throw Failure(AppString.errorCommunicationServer);
    } catch (e) {
      throw Failure(e.toString()); // Captura cualquier otra excepción
    }
  }
}
