import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import '../model/alarm_model.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('app_logo');
  final StreamController<ReceivedNotification>
      didReceiveLocalNotificationStream =
      StreamController<ReceivedNotification>.broadcast();

  // final StreamController<String> selectNotificationStream =
  //     StreamController<String>.broadcast();

  AndroidNotificationChannel? channel;
  bool isFlutterLocalNotificationsInitialized = false;
  final List<DarwinNotificationCategory> darwinNotificationCategories =
      <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      'textCategory',
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
  ];

  Future init() async {
    setupFlutterNotifications();
    tz.initializeTimeZones();
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationStream.add(
          ReceivedNotification(
            id: id,
            title: title ?? '',
            body: body ?? '',
            payload: payload ?? '',
          ),
        );
      },
      notificationCategories: darwinNotificationCategories,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the AndroidManifest.xml file to override the
    /// default FCM channel to enable heads up notifications.

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.

    isFlutterLocalNotificationsInitialized = true;
  }

  addNotification(List<AlarmModel> alarms) async {
    flutterLocalNotificationsPlugin.cancelAll();

    for (AlarmModel alarmModel in alarms) {
      tz.TZDateTime finalDateTime = tz.TZDateTime.fromMillisecondsSinceEpoch(
          tz.getLocation('Asia/Riyadh'), alarmModel.time!);

      int random = Random().nextInt(pow(2, 31).toInt());
      await flutterLocalNotificationsPlugin.zonedSchedule(
          random,
          'Medicine Reminder',
          "It's ${alarmModel.medicine ?? 'Medicine'} time",
          finalDateTime,
          NotificationDetails(
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
              android: AndroidNotificationDetails(
                  'scheduledMedicine$random', 'Medicine Reminder',
                  channelDescription: 'Medicine Reminder',
                  playSound: true,
                  enableVibration: true,
                  // sound:  RawResourceAndroidNotificationSound('azan'),
                  importance: Importance.max,
                  priority: Priority.high,
                  styleInformation: const BigTextStyleInformation(''))),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: alarmModel.alarmId,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    }
  }

  MethodChannel platform =
      const MethodChannel('dexterx.dev/flutter_local_notifications_example');
  String portName = 'notification_send_port';

  /// A notification action which triggers a url launch event
  // String urlLaunchActionId = 'id_1';

  /// A notification action which triggers a App navigation event
  // String navigationActionId = 'id_3';

  /// Defines a iOS/MacOS notification category for text input actions.

  /// Defines a iOS/MacOS notification category for plain actions.
  // String darwinNotificationCategoryPlain = 'plainCategory';
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}
