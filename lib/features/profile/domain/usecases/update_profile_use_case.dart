import 'package:pasti_track/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<void> call(String name) async {
    await repository.updateProfile(name);
  }
}
