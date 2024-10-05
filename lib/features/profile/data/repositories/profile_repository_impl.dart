import 'package:firebase_auth/firebase_auth.dart';
import 'package:pasti_track/features/profile/data/models/user_model.dart';
import 'package:pasti_track/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseAuth _auth;

  ProfileRepositoryImpl({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<ProfileModel?> loadProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return ProfileModel.fromFirebase(user);
    }
    return null;
  }

  @override
  Future<void> updateProfile(String name) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updateProfile(displayName: name, photoURL: user.photoURL);
    }
  }

  @override
  Future<void> changePassword(String newPassword) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    }
  }

  @override
  Future<void> updateProfileImage(String imagePath) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updateProfile(
          photoURL: imagePath, displayName: user.displayName);
    }
  }
}
