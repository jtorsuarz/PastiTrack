import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<void> signIn(String email, String password);
  Future<void> signOut();
  Future<User?> getCurrentUser();
  Future<void> signUpUser({required String email, required String password});
  Future<void> resetPassword(String email);
}
