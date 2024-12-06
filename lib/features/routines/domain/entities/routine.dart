import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pasti_track/core/config.dart';

class Routine {
  final String routineId;
  final String medicineId;
  final String frequency;
  final String dosageTime;
  final String? dayOfWeek;
  final List<String?>? customDays;
  final Map<String?, String?>? customTimes;
  final String? userId;
  final String dateUpdated;
  final String? description;

  Routine({
    required this.routineId,
    required this.medicineId,
    required this.frequency,
    required this.dosageTime,
    this.userId,
    this.dayOfWeek,
    this.customTimes,
    this.customDays,
    required this.dateUpdated,
    this.description,
  });

  Routine copyWith({
    String? routineId,
    String? medicineId,
    String? frequency,
    String? dosageTime,
    String? dayOfWeek,
    Map<String, String>? customTimes,
    List<String>? customDays,
    String? userId,
    String? dateUpdated,
    String? description,
  }) {
    return Routine(
      routineId: routineId ?? this.routineId,
      medicineId: medicineId ?? this.medicineId,
      frequency: frequency ?? this.frequency,
      dosageTime: dosageTime ?? this.dosageTime,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      customDays: customDays ?? this.customDays,
      customTimes: customTimes ?? this.customTimes,
      userId: userId ?? this.userId,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'routine_id': routineId,
      'medicine_id': medicineId,
      'frequency': frequency,
      'dosage_time': dosageTime,
      'day_of_week': dayOfWeek,
      'custom_days': customDays?.join(','),
      'custom_times': customTimes != null ? jsonEncode(customTimes) : null,
      'user_id': userId,
      'date_updated': dateUpdated,
      'description': description ?? '',
    };
  }

  Map<String, dynamic> toJsonWithoutId() {
    return {
      'medicine_id': medicineId,
      'frequency': frequency,
      'dosage_time': dosageTime,
      'day_of_week': dayOfWeek,
      'custom_days': customDays?.join(','),
      'custom_times': customTimes != null ? jsonEncode(customTimes) : null,
      'user_id': userId,
      'date_updated': dateUpdated,
      'description': description ?? '',
    };
  }

  factory Routine.fromMap(Map<String, dynamic> map) {
    return Routine(
      routineId: map['routine_id'] as String,
      medicineId: map['medicine_id'],
      frequency: map['frequency'],
      dosageTime: map['dosage_time'],
      dayOfWeek: map['day_of_week'],
      customDays: map['custom_days'] != "" && map['custom_days'] != null
          ? (map['custom_days'] as String).split(',').map((e) => e).toList()
          : null,
      customTimes: map['custom_times'] != "" && map['custom_times'] != null
          ? Map<String?, String?>.from(
              jsonDecode(map['custom_times'] as String))
          : null,
      userId: map['user_id'],
      description: map['description'] ?? '',
      dateUpdated: map['date_updated'] as String,
    );
  }

  TimeOfDay? get getTimeOfDay {
    if (dayOfWeek == null && customTimes == null) {
      return null;
    }
    final timeParts =
        dosageTime.split(":").map((part) => int.parse(part)).toList();
    return TimeOfDay(hour: timeParts[0], minute: timeParts[1]);
  }

  List<DateTime> get getCustomDays {
    if (customDays == null) {
      return [];
    }
    return customDays!
        .where(
            (item) => item != null && item.isNotEmpty) // Filtrar nulos y vacíos
        .map((e) => DateTime.parse(e!)) // Convertir cada String a DateTime
        .toList();
  }

  Map<DateTime, TimeOfDay> get getCustomTimes {
    if (customTimes == null) {
      return {};
    }

    return customTimes!.map((key, value) {
      final DateTime? dateTime = DateTime.tryParse(key!);
      if (dateTime == null) {
        throw FormatException(AppString.invalidKeyDataTime(key));
      }

      final timeParts = value!.split(':');
      if (timeParts.length != 2) {
        throw FormatException(AppString.invalidKeyDataTime(key));
      }
      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);
      if (hour == null || minute == null) {
        throw FormatException(AppString.invalidKeyDataTime(key));
      }

      return MapEntry(dateTime, TimeOfDay(hour: hour, minute: minute));
    });
  }
}
