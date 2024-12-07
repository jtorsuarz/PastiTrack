import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:pasti_track/firebase_options.dart';

class AppPresetup {
  static final AppPresetup _instance = AppPresetup._internal();
  static AppPresetup get instance => _instance;
  factory AppPresetup() => _instance;
  AppPresetup._internal();

  static init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
