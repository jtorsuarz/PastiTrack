import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:pasti_track/firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AppPresetup {
  static final AppPresetup _instance = AppPresetup._internal();
  static AppPresetup get instance => _instance;
  factory AppPresetup() => _instance;
  AppPresetup._internal();

  static init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Madrid'));
  }
}
