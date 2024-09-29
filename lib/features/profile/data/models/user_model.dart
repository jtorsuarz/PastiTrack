import 'package:firebase_auth/firebase_auth.dart';

class ProfileModel {
  final String uid;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? photoUrl;
  final int? createdAt;

  ProfileModel({
    required this.uid,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.photoUrl,
    this.createdAt,
  });

  factory ProfileModel.fromFirebase(User user) {
    return ProfileModel(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      phoneNumber: user.phoneNumber,
      photoUrl: user.photoURL,
      createdAt: user.metadata.creationTime?.year ?? DateTime.now().year,
    );
  }
}
