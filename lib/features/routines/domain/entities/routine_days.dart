import 'package:pasti_track/core/config.dart';

enum RoutineDays {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  // Método para convertir los valores del enum a un texto legible
  String get description {
    switch (this) {
      case RoutineDays.monday:
        return AppString.monday;
      case RoutineDays.tuesday:
        return AppString.tuesday;
      case RoutineDays.wednesday:
        return AppString.wednesday;
      case RoutineDays.thursday:
        return AppString.thursday;
      case RoutineDays.friday:
        return AppString.friday;
      case RoutineDays.saturday:
        return AppString.saturday;
      case RoutineDays.sunday:
        return AppString.sunday;
    }
  }

  // Método para convertir un texto a un enum (por si llega de la base de datos o Firestore)
  static RoutineDays fromString(String value) {
    switch (value) {
      case AppString.monday:
        return RoutineDays.monday;
      case AppString.tuesday:
        return RoutineDays.tuesday;
      case AppString.wednesday:
        return RoutineDays.wednesday;
      case AppString.thursday:
        return RoutineDays.thursday;
      case AppString.friday:
        return RoutineDays.friday;
      case AppString.saturday:
        return RoutineDays.saturday;
      case AppString.sunday:
        return RoutineDays.sunday;
      default:
        throw ArgumentError(AppString.errorInvalidFrecuency(value));
    }
  }

  // Método que devuelve una lista de todos los valores del enum
  static List<RoutineDays> get allValues => RoutineDays.values;
}
