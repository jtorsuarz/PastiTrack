import 'package:pasti_track/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileImageUseCase {
  final ProfileRepository repository;

  UpdateProfileImageUseCase(this.repository);

  Future<void> call(String imageUrl) async {
    await repository.updateProfileImage(imageUrl);
  }
}
