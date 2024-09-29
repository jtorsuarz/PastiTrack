import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pasti_track/core/config.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  final Completer<void> _completer = Completer<void>();

  AuthBloc(this._firebaseAuth) : super(AuthInitial()) {
    on<AuthCheckRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = _firebaseAuth.currentUser;

        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (error) {
        emit(AuthError(AppString.errorVerifyStatusAuth));
      }
      _completer.complete();
    });

    on<AuthLoggedIn>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(AuthAuthenticated(userCredential.user!));
      } catch (error) {
        emit(AuthError(AppString.errorSignIn));
      }
    });

    on<AuthLoggedOut>((event, emit) async {
      emit(AuthLoading());
      try {
        await _firebaseAuth.signOut();
        emit(AuthUnauthenticated());
      } catch (error) {
        emit(AuthError(AppString.errorSignOut));
      }
    });
  }

  Future<void> get initializationCompleted => _completer.future;
}
