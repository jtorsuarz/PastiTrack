part of 'password_recovery_bloc.dart';

abstract class PasswordRecoveryState {}

class PasswordRecoveryInitial extends PasswordRecoveryState {}

class PasswordRecoveryLoading extends PasswordRecoveryState {}

class PasswordRecoverySuccess extends PasswordRecoveryState {}

class PasswordRecoveryFailure extends PasswordRecoveryState {
  final String message;

  PasswordRecoveryFailure(this.message);
}
