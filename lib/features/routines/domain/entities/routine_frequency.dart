import 'package:pasti_track/core/config.dart';

enum RoutineFrequency {
  daily,
  weekly,
  custom;

  // Método para convertir los valores del enum a un texto legible
  String get description {
    switch (this) {
      case RoutineFrequency.daily:
        return AppString.daily;
      case RoutineFrequency.weekly:
        return AppString.weekly;
      case RoutineFrequency.custom:
        return AppString.customized;
    }
  }

  // Método para convertir un texto a un enum (por si llega de la base de datos o Firestore)
  static RoutineFrequency fromString(String value) {
    switch (value) {
      case AppString.daily:
        return RoutineFrequency.daily;
      case AppString.weekly:
        return RoutineFrequency.weekly;
      case AppString.customized:
        return RoutineFrequency.custom;
      default:
        throw ArgumentError(AppString.errorInvalidFrecuency(value));
    }
  }

  // Método que devuelve una lista de todos los valores del enum
  static List<RoutineFrequency> get allValues => RoutineFrequency.values;
}
