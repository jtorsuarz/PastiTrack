import 'package:pasti_track/features/profile/data/models/user_model.dart';
import 'package:pasti_track/features/profile/domain/repositories/profile_repository.dart';

class LoadProfileUseCase {
  final ProfileRepository repository;

  LoadProfileUseCase(this.repository);

  Future<ProfileModel?> call() async {
    return await repository.loadProfile();
  }
}
