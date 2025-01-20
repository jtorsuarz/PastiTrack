import 'package:pasti_track/core/helper/app_logger.dart';

class EventEntity {
  final String eventId;
  final String routineId;
  final String medicineId;
  final DateTime dateScheduled;
  final bool status;
  final DateTime? dateDone;
  final DateTime dateUpdated;

  EventEntity({
    required this.eventId,
    required this.routineId,
    required this.medicineId,
    required this.dateScheduled,
    required this.dateUpdated,
    required this.status,
    this.dateDone,
  });

  factory EventEntity.fromJson(Map<String, dynamic> json) {
    AppLogger.p("EventEntity.fromJson", json);
    return EventEntity(
      eventId: json['event_id'] as String,
      routineId: json['routine_id'] as String,
      medicineId: json['medicine_id'] as String,
      dateScheduled: DateTime.parse(json['date_scheduled'] as String),
      status: getStatus(json['status']),
      dateDone: json['date_done'] != null
          ? DateTime.parse(json['date_done'] as String)
          : null,
      dateUpdated: DateTime.parse(json['date_updated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'routine_id': routineId,
      'medicine_id': medicineId,
      'date_scheduled': dateScheduled.toIso8601String(),
      'status': status,
      'date_done': dateDone?.toIso8601String(),
      'date_updated': dateUpdated.toIso8601String(),
    };
  }

  Map<String, dynamic> toJsonWithoutId() {
    return {
      'routine_id': routineId,
      'medicine_id': medicineId,
      'date_scheduled': dateScheduled.toIso8601String(),
      'status': status,
      'date_done': dateDone?.toIso8601String(),
      'date_updated': dateUpdated.toIso8601String(),
    };
  }

  static bool getStatus(status) =>
      (status is int) ? status == 1 : status == true;
}
