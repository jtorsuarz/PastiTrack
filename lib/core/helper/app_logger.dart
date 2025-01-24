// ignore_for_file: avoid_print
import 'package:pasti_track/core/config.dart';

class AppLogger {
  static p(module, message) {
    if (AppDotEnv.activeAppLogger) {
      print("================================================");
      print('$module => $message');
      print("================================================");
    }
  }
}
