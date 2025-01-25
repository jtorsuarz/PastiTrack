import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/helper/app_presetup.dart';
import 'package:pasti_track/core/services/WorkManager_service.dart';
import 'package:pasti_track/core/theme/bloc/theme_bloc.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() => WorkManagerService.callbackDispatcher();

void main() async {
  await AppPresetup.init();
  Workmanager().initialize(callbackDispatcher,
      isInDebugMode: AppDotEnv.isDebugModeWorkManager);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseAuth.instance;

    return MultiBlocProvider(
      providers: AppBlocProviders.get(firebase),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: AppString.appTitle,
            theme: state.themeData,
            darkTheme: AppTheme(selectedColor: state.selectedColor)
                .theme(isDarkMode: true),
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
