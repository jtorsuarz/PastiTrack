import 'package:pasti_track/features/profile/data/models/user_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;

  ProfileLoaded({required this.profile});
}

class ProfileUpdated extends ProfileState {}

class ProfilePasswordChanged extends ProfileState {
  final ProfileModel profile;

  ProfilePasswordChanged({required this.profile});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}

class ProfileImageUpdated extends ProfileState {}
