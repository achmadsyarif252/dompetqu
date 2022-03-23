import 'package:dompet_q/provider/habit_prodivder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:rxdart/rxdart.dart';
import 'package:provider/provider.dart';

class LocalNotifyManager {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  var initSetting;
  BehaviorSubject<ReceiveNotification> get didReceiveLocalNotificationSubject =>
      BehaviorSubject<ReceiveNotification>();

  LocalNotifyManager.init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      requestIOSPermission();
    }
    initializePlatform();
  }

  requestIOSPermission() {
    flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()!
        .requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  initializePlatform() {
    var initSettingAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSettingIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceiveNotification notification = ReceiveNotification(
            id: id,
            title: title!,
            body: body!,
            payload: payload!,
          );
          didReceiveLocalNotificationSubject.add(notification);
        });
    initSetting = InitializationSettings(
      android: initSettingAndroid,
      iOS: initSettingIOS,
    );
  }

  setOnNotificationReceive(Function onNotificationReceive) {
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin!.initialize(
      initSetting,
      onSelectNotification: (String? payload) async {
        onNotificationClick(payload);
      },
    );
  }

  Future<void> showNotification() async {
    // int uncheckedHabit = Provider.of<HabbitProvider>(ctx).uncheckedHabbit;
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableLights: true,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin!.show(
      0,
      'Just Do It',
      'Ayo Cek Habit Yang Belum Dilakukan Bro..',
      platformChannel,
      payload: 'New Payload',
    );
  }

  Future<void> scheduledNotification() async {
    var scheduleNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID 2',
      'CHANNEL_NAME 2',
      channelDescription: 'CHANNEL_DESCRIPTION 2',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      timeoutAfter: 5000,
      enableLights: true,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin!.schedule(
      0,
      'DompetQ Schedule',
      'Hallo Gan',
      scheduleNotificationDateTime,
      platformChannel,
      payload: 'New Payload',
    );
  }

  Future<void> repeatNotification() async {
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID 3',
      'CHANNEL_NAME 3',
      channelDescription: 'CHANNEL_DESCRIPTION 3',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      timeoutAfter: 5000,
      enableLights: true,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin!.periodicallyShow(
      0,
      'DompetQ',
      'Repeat Notification',
      RepeatInterval.everyMinute,
      platformChannel,
      payload: 'New Payload',
    );
  }

  Future<void> showDailyAtTimeNotification(int remainingTask) async {
    var time = Time(07, 00, 00);
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      timeoutAfter: 5000,
      enableLights: true,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin!.showDailyAtTime(
      0,
      'Just Do It',
      'Tersisa $remainingTask Habit Yang Belum Dilakukan Gann...',
      time,
      platformChannel,
      payload: 'New Payload',
    );
  }

  Future<void> showWeeklyAtDayTimeNotification() async {
    var time = Time(15, 55, 0);
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      timeoutAfter: 5000,
      enableLights: true,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin!.showWeeklyAtDayAndTime(
      0,
      'DompetQ',
      'Weekly Notif Gan',
      Day.monday,
      time,
      platformChannel,
      payload: 'New Payload',
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin!.cancel(id);
  }

  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin!.cancelAll();
  }
}

LocalNotifyManager localNotifyManager = LocalNotifyManager.init();

class ReceiveNotification {
  final int id;
  final String title;
  final String body;
  final String payload;
  ReceiveNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}
