import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications(useCase) async {
    // Initialize timezone data
    tz_data.initializeTimeZones();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
    );

    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) =>
          _onDidReceiveNotificationResponse(response, useCase),
    );
  }

  Future<void> _onDidReceiveNotificationResponse(
      NotificationResponse response, useCase) async {
    String eventId = response.payload!;

    if (response.actionId != null) {
      if (response.actionId == 'ACCEPT') {
        useCase.call(eventId);
      }
    } else {
      // if click notification
      print("Toma de medicamento en pantalla ${response.payload}");
    }
  }

  Future<void> showNotification(
      {required int id, required String title, required String body}) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      AppDotEnv.notificationUniqueChannelId,
      AppDotEnv.notificationChannelName,
      channelDescription: AppDotEnv.notificationChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    AppLogger.p(
        "module", tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)));

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'pasti_track_channel',
          'PastiTrack Notifications',
          channelDescription: 'Notifications for medication reminders',
          importance: Importance.max,
          priority: Priority.max,
          additionalFlags: Int32List.fromList([4]),
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              'ACCEPT',
              'Aceptar',
              showsUserInterface: true,
              titleColor: Colors.green[800],
            ),
            AndroidNotificationAction(
              'REJECT',
              'Rechazar',
              showsUserInterface: true,
              titleColor: Colors.red[800],
            ),
          ],
        ),
      ),
      // androidAllowWhileIdle: true,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: id.toString(),
    );
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
