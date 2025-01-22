import 'package:intl/intl.dart';
import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:pasti_track/features/events/domain/entities/event_status.dart';
import 'package:pasti_track/features/medicines/data/datasources/medicament_local_datasource.dart';
import 'package:pasti_track/features/medicines/domain/entities/medicament.dart';

class EventEntity {
  final String eventId;
  final String routineId;
  final String medicineId;
  final DateTime dateScheduled;
  EventStatus status;
  final DateTime? dateDone;
  final DateTime dateUpdated;
  int registrationScheduledNotification;

  EventEntity({
    required this.eventId,
    required this.routineId,
    required this.medicineId,
    required this.dateScheduled,
    required this.dateUpdated,
    required this.status,
    this.dateDone,
    this.registrationScheduledNotification = 0,
  });

  factory EventEntity.fromJson(Map<String, dynamic> json) {
    var scheduleStatus = json['registration_scheduled_notification'];
    if (scheduleStatus is String) {
      int? tryNumer = int.tryParse(scheduleStatus);

      if (tryNumer is int) {
        scheduleStatus = tryNumer == 1 ? 1 : 0;
      } else {
        bool? tryBool = bool.tryParse(scheduleStatus);
        scheduleStatus = tryBool! ? 1 : 0;
      }
    }

    return EventEntity(
      eventId: json['event_id'] as String,
      routineId: json['routine_id'] as String,
      medicineId: json['medicine_id'] as String,
      dateScheduled: DateTime.parse(json['date_scheduled'] as String),
      status: EventStatus.values.byName(json['status'] as String),
      dateDone: json['date_done'] != null
          ? DateTime.parse(json['date_done'] as String)
          : null,
      dateUpdated: DateTime.parse(json['date_updated'] as String),
      registrationScheduledNotification: scheduleStatus,
    );
  }

  Map<String, dynamic> toJson() {
    AppLogger.p("EventEntity.eventId", eventId);
    return {
      'event_id': eventId,
      'routine_id': routineId,
      'medicine_id': medicineId,
      'date_scheduled': dateScheduled.toIso8601String(),
      'status': status.name,
      'date_done': dateDone?.toIso8601String(),
      'date_updated': dateUpdated.toIso8601String(),
      'registration_scheduled_notification': registrationScheduledNotification,
    };
  }

  Map<String, dynamic> toJsonWithoutId() {
    return {
      'routine_id': routineId,
      'medicine_id': medicineId,
      'date_scheduled': dateScheduled.toIso8601String(),
      'status': status.name,
      'date_done': dateDone?.toIso8601String(),
      'date_updated': dateUpdated.toIso8601String(),
      'registration_scheduled_notification': registrationScheduledNotification,
    };
  }

  Future<String> medicationName() async {
    MedicamentLocalDataSource db = MedicamentLocalDataSource();
    Medicament medicament = await db.getMedicationById(medicineId);
    return medicament.name;
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
    return formatter.format(dateTime);
  }
}
