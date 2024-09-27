import 'package:bloc/bloc.dart';
import 'package:pasti_track/core/constants/app_string.dart';
import 'package:pasti_track/core/errors/failures.dart';
import 'package:pasti_track/features/auth/domain/usecases/sign_in_usecase.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInUseCase signInUseCase;

  SignInBloc(this.signInUseCase) : super(SignInInitial()) {
    on<SignInButtonPressed>(_onSignInButtonPressed);
  }

  void _onSignInButtonPressed(
      SignInButtonPressed event, Emitter<SignInState> emit) async {
    emit(SignInLoading());

    try {
      await signInUseCase.call(event.email, event.password);
      emit(SignInSuccess());
    } catch (e) {
      if (e is Failure) {
        emit(SignInFailure(e.message));
      } else {
        emit(
          SignInFailure(AppString.unexpectedErrorOcurred),
        );
      }
    }
  }
}
