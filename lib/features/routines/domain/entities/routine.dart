import 'dart:convert';

import 'package:flutter/material.dart';

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
      customDays: map['custom_days'] != ""
          ? (map['custom_days'] as String).split(',').map((e) => e).toList()
          : null,
      customTimes: map['custom_times'] != ""
          ? Map<String?, String?>.from(
              jsonDecode(map['custom_times'] as String))
          : null,
      userId: map['user_id'],
      description: map['description'] ?? '',
      dateUpdated: map['date_updated'] as String,
    );
  }
}
