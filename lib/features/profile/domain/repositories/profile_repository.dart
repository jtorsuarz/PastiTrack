import 'package:pasti_track/features/profile/data/models/user_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel?> loadProfile();
  Future<void> updateProfile(String name);
  Future<void> changePassword(String newPassword);
  Future<void> updateProfileImage(String imagePath);
}
