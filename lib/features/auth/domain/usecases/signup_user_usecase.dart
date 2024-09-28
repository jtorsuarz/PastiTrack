import 'package:pasti_track/features/auth/domain/repositories/auth_repository.dart';

class SignUpUserUseCase {
  final AuthRepository repository;

  SignUpUserUseCase(this.repository);

  Future<void> call({required String email, required String password}) async {
    return await repository.signUpUser(email: email, password: password);
  }
}
