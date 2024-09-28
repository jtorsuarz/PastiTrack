import 'package:bloc/bloc.dart';
import 'package:pasti_track/features/auth/domain/usecases/password_recovery.dart';

part 'password_recovery_event.dart';
part 'password_recovery_state.dart';

class PasswordRecoveryBloc
    extends Bloc<PasswordRecoveryEvent, PasswordRecoveryState> {
  final PasswordRecoveryUseCase passwordRecoveryUseCase;

  PasswordRecoveryBloc(this.passwordRecoveryUseCase)
      : super(PasswordRecoveryInitial()) {
    on<PasswordRecoveryRequested>((event, emit) async {
      emit(PasswordRecoveryLoading());

      try {
        await passwordRecoveryUseCase.call(event.email);
        emit(PasswordRecoverySuccess());
      } catch (error) {
        emit(PasswordRecoveryFailure(error.toString()));
      }
    });
  }
}
