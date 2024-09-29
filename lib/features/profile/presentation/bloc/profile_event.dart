abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String name;

  UpdateProfileEvent({required this.name});
}

class ChangePasswordEvent extends ProfileEvent {
  final String newPassword;

  ChangePasswordEvent({required this.newPassword});
}

class UpdateProfileImageEvent extends ProfileEvent {
  final String imagePath;

  UpdateProfileImageEvent({required this.imagePath});
}
