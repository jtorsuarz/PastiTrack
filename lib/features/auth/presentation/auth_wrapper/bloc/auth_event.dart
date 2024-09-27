part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {
  final String email;
  final String password;

  AuthLoggedIn(this.email, this.password);
}

class AuthLoggedOut extends AuthEvent {}
