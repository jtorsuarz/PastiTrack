import 'package:firebase_auth/firebase_auth.dart';
import 'package:pasti_track/core/constants/app_string.dart';
import 'package:pasti_track/core/errors/failures.dart';
import 'package:pasti_track/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:pasti_track/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await remoteDataSource.signIn(email, password);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthExceptionToFailure(e);
    }
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  Future<User?> getCurrentUser() async {
    return remoteDataSource.getCurrentUser();
  }

  @override
  Future<void> register(String email, String password) async {
    try {
      await remoteDataSource.register(email, password);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthExceptionToFailure(e);
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await remoteDataSource.resetPassword(email);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthExceptionToFailure(e);
    }
  }

  Failure _mapFirebaseAuthExceptionToFailure(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Failure(AppString.errorUserNotFound);
      case 'wrong-password':
        return Failure(AppString.errorInvalidPassword);
      case 'email-already-in-use':
        return Failure(AppString.errorEmailExists);
      case 'invalid-email':
        return Failure(AppString.errorInvalidEmail);
      default:
        return Failure(AppString.errorAuthentication);
    }
  }
}
