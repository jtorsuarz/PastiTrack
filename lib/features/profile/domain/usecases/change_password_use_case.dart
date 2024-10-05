import 'package:pasti_track/features/profile/domain/repositories/profile_repository.dart';

class ChangePasswordUseCase {
  final ProfileRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<void> call(String newPassword) async {
    await repository.changePassword(newPassword);
  }
}
