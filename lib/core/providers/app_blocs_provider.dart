import 'package:pasti_track/core/theme/bloc/theme_bloc.dart';
import 'package:pasti_track/features/events/data/datasources/event_local_datasource.dart';
import 'package:pasti_track/features/events/data/datasources/event_remote_datasource.dart';
import 'package:pasti_track/features/events/data/repositories/event_repository_impl.dart';
import 'package:pasti_track/features/events/domain/usecases/get_all_events.dart';
import 'package:pasti_track/features/events/domain/usecases/mark_event_as_done.dart';
import 'package:pasti_track/features/events/presentation/bloc/events_bloc.dart';
import 'package:pasti_track/features/medicines/data/datasources/medicament_local_datasource.dart';
import 'package:pasti_track/features/medicines/data/datasources/medicament_remote_datasource.dart';
import 'package:pasti_track/features/medicines/data/repositories/medicament_repository_impl.dart';
import 'package:pasti_track/features/medicines/domain/usecases/add_medicament.dart';
import 'package:pasti_track/features/medicines/domain/usecases/delete_medicament.dart';
import 'package:pasti_track/features/medicines/domain/usecases/get_medications.dart';
import 'package:pasti_track/features/medicines/domain/usecases/update_medicament.dart';
import 'package:pasti_track/features/medicines/presentation/bloc/medicament_bloc.dart';

import 'package:pasti_track/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:pasti_track/features/profile/domain/usecases/change_password_use_case.dart';
import 'package:pasti_track/features/profile/domain/usecases/load_profile_use_case.dart';
import 'package:pasti_track/features/profile/domain/usecases/update_profile_image_use_case.dart';
import 'package:pasti_track/features/profile/domain/usecases/update_profile_use_case.dart';
import 'package:pasti_track/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pasti_track/features/profile/presentation/bloc/profile_event.dart';
import 'package:pasti_track/features/routines/data/datasources/routine_local_datasource.dart';
import 'package:pasti_track/features/routines/data/datasources/routine_remote_datasource.dart';
import 'package:pasti_track/features/routines/data/repositories/routine_repository_impl.dart';
import 'package:pasti_track/features/routines/domain/usecases/delete_event.dart';
import 'package:pasti_track/features/routines/domain/usecases/add_event.dart';
import 'package:pasti_track/features/routines/domain/usecases/add_routine.dart';
import 'package:pasti_track/features/routines/domain/usecases/delete_event_by_routine.dart';
import 'package:pasti_track/features/routines/domain/usecases/delete_routine.dart';
import 'package:pasti_track/features/routines/domain/usecases/get_all_routines.dart';
import 'package:pasti_track/features/routines/domain/usecases/get_events_by_routine.dart';
import 'package:pasti_track/features/routines/domain/usecases/get_medications.dart';
import 'package:pasti_track/features/routines/domain/usecases/update_routine.dart';
import 'package:pasti_track/features/routines/presentation/bloc/routine_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:pasti_track/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pasti_track/features/auth/domain/usecases/password_recovery.dart';
import 'package:pasti_track/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:pasti_track/features/auth/domain/usecases/signup_user_usecase.dart';
import 'package:pasti_track/features/auth/presentation/bloc/auth_bloc.dart';

class AppBlocProviders {
  static final _authRepoImpl = AuthRepositoryImpl(AuthRemoteDataSource());
  static final _profileRepoImpl = ProfileRepositoryImpl();
  static final _medicamentRepoImpl = MedicamentRepositoryImpl(
    MedicamentLocalDataSource(),
    MedicamentRemoteDataSource(),
  );
  static final _eventRepoImpl =
      EventRepositoryImpl(EventLocalDataSource(), EventRemoteDataSource());
  static final _routineRepoImpl = RoutineRepositoryImpl(
    RoutineLocalDataSource(),
    RoutineRemoteDataSource(),
  );

  static List<SingleChildWidget> get(firebase) {
    return [
      BlocProvider(create: (context) => ThemeBloc()),
      BlocProvider(
        create: (context) => AuthBloc(
          firebase,
          SignInUseCase(_authRepoImpl),
          SignUpUserUseCase(_authRepoImpl),
          PasswordRecoveryUseCase(_authRepoImpl),
        )..add(AuthCheckRequested()),
      ),
      BlocProvider(
        create: (context) => ProfileBloc(
          LoadProfileUseCase(_profileRepoImpl),
          UpdateProfileUseCase(_profileRepoImpl),
          ChangePasswordUseCase(_profileRepoImpl),
          UpdateProfileImageUseCase(_profileRepoImpl),
        )..add(LoadProfileEvent()),
      ),
      BlocProvider(
        create: (ctx) => MedicamentBloc(
          GetAllMedicaments(_medicamentRepoImpl),
          AddMedicament(_medicamentRepoImpl),
          UpdateMedicament(_medicamentRepoImpl),
          DeleteMedicament(_medicamentRepoImpl),
        )..add(LoadMedicationsEvent()),
      ),
      BlocProvider(
        create: (ctx) => RoutineBloc(
          GetAllMedications(_medicamentRepoImpl),
          GetAllRoutines(_routineRepoImpl),
          AddRoutine(_routineRepoImpl),
          UpdateRoutine(_routineRepoImpl),
          DeleteRoutine(_routineRepoImpl),
          GetEventsByRoutine(_eventRepoImpl),
          DeleteEventByRoutine(_eventRepoImpl),
          AddEvent(_eventRepoImpl),
          DeleteEvent(_eventRepoImpl),
        )..add(
            LoadRoutinesEvent(),
          ),
      ),
      BlocProvider(
        create: (ctx) => EventsBloc(
            MarkEventAsDone(_eventRepoImpl), GetAllEvents(_eventRepoImpl))
          ..add(
            LoadingEventsEvent(),
          ),
      )
    ];
  }
}
