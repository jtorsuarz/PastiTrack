import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/constants/app_string.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseAuth.instance;

    return MultiBlocProvider(
      providers: AppProviders.get(firebase),
      child: MaterialApp.router(
        title: AppString.appTitle,
        theme: AppTheme(selectedColor: 2).theme(isDarkMode: false),
        darkTheme: AppTheme(selectedColor: 2).theme(isDarkMode: true),
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
