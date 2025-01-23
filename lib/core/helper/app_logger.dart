// ignore_for_file: avoid_print

class AppLogger {
  static p(module, message) {
    print("================================================");
    print('$module => $message');
    print("================================================");
  }
}
