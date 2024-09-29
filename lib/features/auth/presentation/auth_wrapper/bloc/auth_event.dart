part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {
  final String email;
  final String password;

  AuthLoggedIn({required this.email, required this.password});
}

class AuthLoggedOut extends AuthEvent {}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;

  AuthSignUpRequested({required this.email, required this.password});
}

class AuthPasswordRecoveryRequested extends AuthEvent {
  final String email;

  AuthPasswordRecoveryRequested({required this.email});
}
