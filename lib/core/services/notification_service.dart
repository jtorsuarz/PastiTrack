import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/helper/app_logger.dart';
import 'package:pasti_track/features/events/domain/entities/event_entity.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

const hourlyReminderChannel = 'hourly_reminder_channel';
const hourlyReminder = 'Hourly Reminder';
const reminderRegisterPendingDoses = 'Reminder to register pending doses';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeGeneralNotifications() async {
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

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> initializeEventNotifications(ctx, useCase, bloc, event) async {
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
          _onDidReceiveNotificationResponse(
              response, ctx, useCase, bloc, event),
    );
  }

  Future<void> _onDidReceiveNotificationResponse(
      NotificationResponse response, ctx, useCase, bloc, event) async {
    var eventRecieved = response.payload!;

    if (response.actionId != null) {
      if (response.actionId == 'ACCEPT') {
        useCase.call(eventRecieved);
        bloc.add(event);
      }
    } else {
      Map<String, dynamic> eventMap = jsonDecode(eventRecieved);
      EventEntity event = EventEntity.fromJson(eventMap);
      GoRouter.of(ctx)
          .pushReplacement(AppUrls.eventRegisterTakePath, extra: event);
    }
  }

  Future<void> showNotification(
      {required int id, required String title, required String body}) async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      hourlyReminderChannel,
      hourlyReminder,
      channelDescription: reminderRegisterPendingDoses,
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
    required EventEntity objectEntity,
  }) async {
    String entityJson = jsonEncode(objectEntity.toJson());

    AppLogger.p(
        "module", tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)));

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          AppDotEnv.notificationUniqueChannelId,
          AppDotEnv.notificationChannelName,
          channelDescription: AppDotEnv.notificationChannelDescription,
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
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: entityJson,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
