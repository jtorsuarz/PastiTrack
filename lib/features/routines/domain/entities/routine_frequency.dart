import 'package:pasti_track/core/config.dart';

enum RoutineFrequency {
  daily,
  weekly,
  custom;

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

  static List<RoutineFrequency> get allValues => RoutineFrequency.values;
}
