import 'package:bloc/bloc.dart';
import 'package:pasti_track/features/auth/domain/usecases/signup_user_usecase.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpUserUseCase signUpUserUseCase;

  SignUpBloc(this.signUpUserUseCase) : super(SignUpInitial()) {
    on<SignUpSubmitted>((event, emit) async {
      emit(SignUpLoading()); // Cambiar a estado de carga
      try {
        await signUpUserUseCase.call(
            email: event.email, password: event.password);
        emit(SignUpSuccess()); // Emitir estado de éxito
      } catch (error) {
        emit(SignUpFailure(error.toString())); // Emitir estado de fallo
      }
    });
  }
}
