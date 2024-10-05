import 'package:bloc/bloc.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/features/profile/domain/usecases/change_password_use_case.dart';
import 'package:pasti_track/features/profile/domain/usecases/load_profile_use_case.dart';
import 'package:pasti_track/features/profile/domain/usecases/update_profile_image_use_case.dart';
import 'package:pasti_track/features/profile/domain/usecases/update_profile_use_case.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final LoadProfileUseCase loadProfile;
  final UpdateProfileUseCase updateProfile;
  final ChangePasswordUseCase changePassword;
  final UpdateProfileImageUseCase updateProfileImage;

  ProfileBloc(this.loadProfile, this.updateProfile, this.changePassword,
      this.updateProfileImage)
      : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfileEvent);
    on<UpdateProfileEvent>(_onUpdateProfileEvent);
    on<ChangePasswordEvent>(_onChangePasswordEvent);
    on<UpdateProfileImageEvent>(_onUpdateProfileImageEvent);
  }

  void _onLoadProfileEvent(
      LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final profile = await loadProfile();
      emit(ProfileLoaded(profile: profile!));
    } catch (e) {
      emit(
        ProfileError(message: AppString.errorWhenLoadingProfile(e.toString())),
      );
    }
  }

  void _onUpdateProfileEvent(
      UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await updateProfile(event.name);
      emit(ProfileUpdated());
      add(LoadProfileEvent());
    } catch (e) {
      emit(
        ProfileError(message: AppString.errorWhenUpdateProfile(e.toString())),
      );
    }
  }

  void _onChangePasswordEvent(
      ChangePasswordEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await changePassword(event.newPassword);
      final profile = await loadProfile();
      emit(ProfilePasswordChanged(profile: profile!));
      add(LoadProfileEvent());
    } catch (e) {
      emit(
        ProfileError(message: AppString.errorWhenChangePassword(e.toString())),
      );
    }
  }

  void _onUpdateProfileImageEvent(
      UpdateProfileImageEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await updateProfileImage(event.imagePath);
      emit(ProfileUpdated());
      add(LoadProfileEvent());
    } catch (e) {
      emit(
        ProfileError(
            message: AppString.errorWhenChangePhotoProfile(e.toString())),
      );
    }
  }
}
