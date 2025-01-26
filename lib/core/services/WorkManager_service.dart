// ignore_for_file: file_names
import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:pasti_track/core/tasks/notify_hourly_reminder.dart';
import 'package:pasti_track/core/tasks/register_daily_notifications.dart';
import 'package:workmanager/workmanager.dart';

class WorkManagerService {
  static const hourlyReminderTask = "hourly_reminder";
  static const dailyNotificationTask = "daily_notification";

  void registerTasks() {
    AppLogger.p("WorkManagerService", "registerTasks");

    /// Tarea: Recordatorio general cada hora
    Workmanager().registerPeriodicTask(
      hourlyReminderTask,
      hourlyReminderTask,
      initialDelay: const Duration(seconds: 10),
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.unmetered,
        requiresBatteryNotLow: false,
        requiresStorageNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
      ),
    );

    /// Tarea: Registro de notificaciones diarias
    Workmanager().registerPeriodicTask(
      hourlyReminderTask,
      hourlyReminderTask,
      initialDelay: const Duration(seconds: 10),
      frequency: const Duration(days: 1),
      constraints: Constraints(
        networkType: NetworkType.unmetered,
        requiresBatteryNotLow: false,
        requiresStorageNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
      ),
    );
  }

  static void callbackDispatcher() {
    AppLogger.p("WorkManagerService", "callbackDispatcher");
    Workmanager().executeTask((task, inputData) async {
      AppLogger.p("WorkManagerService", "executeTask");
      AppLogger.p("WorkManagerService  executeTask", task);
      switch (task) {
        case hourlyReminderTask:
          await NotifyHourlyReminderTask.execute();
          break;
        case dailyNotificationTask:
          await RegisterDailyNotificationsTask.execute();
          break;
        default:
          return Future.value(false);
      }
      return Future.value(true);
    });
  }

  // cancel all tasks
  static void cancelAllTasks() {
    Workmanager().cancelAll();
  }
}
