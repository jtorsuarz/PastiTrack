part of 'password_recovery_bloc.dart';

abstract class PasswordRecoveryEvent {}

class PasswordRecoveryRequested extends PasswordRecoveryEvent {
  final String email;

  PasswordRecoveryRequested(this.email);
}
