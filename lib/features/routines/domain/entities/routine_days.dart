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

  static int numericValue(val) {
    switch (val) {
      case AppString.monday:
        return 1;
      case AppString.tuesday:
        return 2;
      case AppString.wednesday:
        return 3;
      case AppString.thursday:
        return 4;
      case AppString.friday:
        return 5;
      case AppString.saturday:
        return 6;
      case AppString.sunday:
        return 7;
      default:
        throw ArgumentError(AppString.errorInvalidFrecuency(val.toString()));
    }
  }

  static List<RoutineDays> get allValues => RoutineDays.values;
}
