import 'package:pasti_track/features/auth/domain/repositories/auth_repository.dart';

class PasswordRecoveryUseCase {
  final AuthRepository repository;

  PasswordRecoveryUseCase(this.repository);

  Future<void> call(String email) async {
    return await repository.resetPassword(email);
  }
}
