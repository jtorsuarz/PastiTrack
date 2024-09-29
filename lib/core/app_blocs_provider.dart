// ignore: depend_on_referenced_packages
import 'package:provider/single_child_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:pasti_track/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pasti_track/features/auth/domain/usecases/password_recovery.dart';
import 'package:pasti_track/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:pasti_track/features/auth/domain/usecases/signup_user_usecase.dart';
import 'package:pasti_track/features/auth/presentation/auth_wrapper/bloc/auth_bloc.dart';
import 'package:pasti_track/features/auth/presentation/password_recovery/bloc/password_recovery_bloc.dart';
import 'package:pasti_track/features/auth/presentation/sign_in/bloc/sign_in_bloc.dart';
import 'package:pasti_track/features/auth/presentation/sign_up/bloc/sign_up_bloc.dart';

class AppBlocProviders {
  static List<SingleChildWidget> get(firebase) => [
        BlocProvider(
          create: (context) => AuthBloc(firebase)..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (context) => SignInBloc(
            SignInUseCase(
              AuthRepositoryImpl(AuthRemoteDataSource()),
            ),
          ),
        ),
        BlocProvider<SignUpBloc>(
          create: (context) => SignUpBloc(
            SignUpUserUseCase(AuthRepositoryImpl(AuthRemoteDataSource())),
          ),
        ),
        BlocProvider<PasswordRecoveryBloc>(
          create: (context) => PasswordRecoveryBloc(
            PasswordRecoveryUseCase(AuthRepositoryImpl(AuthRemoteDataSource())),
          ),
        ),
      ];
}
