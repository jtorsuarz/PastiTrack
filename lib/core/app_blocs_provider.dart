import 'package:pasti_track/core/theme/bloc/theme_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/single_child_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:pasti_track/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pasti_track/features/auth/domain/usecases/password_recovery.dart';
import 'package:pasti_track/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:pasti_track/features/auth/domain/usecases/signup_user_usecase.dart';
import 'package:pasti_track/features/auth/presentation/bloc/auth_bloc.dart';

class AppBlocProviders {
  static List<SingleChildWidget> get(firebase) => [
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(
          create: (context) => AuthBloc(
            firebase,
            SignInUseCase(AuthRepositoryImpl(AuthRemoteDataSource())),
            SignUpUserUseCase(AuthRepositoryImpl(AuthRemoteDataSource())),
            PasswordRecoveryUseCase(AuthRepositoryImpl(AuthRemoteDataSource())),
          )..add(AuthCheckRequested()),
        ),
      ];
}
