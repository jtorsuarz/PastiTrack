import 'package:flutter/material.dart';

class AppLogger {
  static p(module, message) {
    debugPrint('$module => $message');
  }
}
