import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/services/WorkManager_service.dart';
import 'package:pasti_track/core/services/notification_service.dart';
import 'package:pasti_track/features/auth/domain/usecases/password_recovery.dart';
import 'package:pasti_track/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:pasti_track/features/auth/domain/usecases/signup_user_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  final SignInUseCase _signInUseCase;
  final SignUpUserUseCase _signUpUserUseCase;
  final PasswordRecoveryUseCase _passwordRecoveryUseCase;
  final Completer<void> _completer = Completer<void>();

  AuthBloc(
    this._firebaseAuth,
    this._signInUseCase,
    this._signUpUserUseCase,
    this._passwordRecoveryUseCase,
  ) : super(AuthInitial()) {
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
        if (!event.email.contains('@')) {
          emit(AuthError(AppString.errorInvalidEmail));
        } else if (event.password.isEmpty) {
          emit(AuthError(AppString.errorInvalidPassword));
        } else {
          await _signInUseCase.call(event.email, event.password);
          emit(AuthAuthenticated(_firebaseAuth.currentUser!));
        }
      } catch (error) {
        emit(AuthError(AppString.errorSignIn));
      }
    });

    on<AuthLoggedOut>((event, emit) async {
      emit(AuthLoading());
      try {
        await _firebaseAuth.signOut();
        await NotificationService().cancelAllNotifications();
        WorkManagerService.cancelAllTasks();
        emit(AuthUnauthenticated());
      } catch (error) {
        emit(AuthError(AppString.errorSignOut));
      }
    });

    on<AuthSignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        if (!event.email.contains('@')) {
          emit(AuthError(AppString.errorInvalidEmail));
        } else if (event.password.isEmpty) {
          emit(AuthError(AppString.errorInvalidPassword));
        } else if (event.password.length < 8) {
          emit(AuthError(AppString.errorPasswordLength));
        } else {
          await _signUpUserUseCase.call(
              email: event.email, password: event.password);
          emit(AuthAuthenticated(_firebaseAuth.currentUser!));
        }
      } catch (error) {
        emit(AuthError(AppString.errorSignUp));
      }
    });

    on<AuthPasswordRecoveryRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _passwordRecoveryUseCase.call(event.email);
        emit(AuthPasswordRecoverySuccess());
      } catch (error) {
        emit(AuthError(AppString.errorPasswordReset));
      }
    });
  }

  Future<void> get initializationCompleted => _completer.future;
}
