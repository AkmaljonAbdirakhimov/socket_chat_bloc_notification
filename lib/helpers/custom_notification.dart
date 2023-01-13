import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CustomNotification {
  static Future init(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initNotification = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await flutterLocalNotificationsPlugin.initialize(initNotification);
  }

  static Future show({
    dynamic id = 0,
    required String title,
    required String body,
    dynamic payload,
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'GoodChannelId',
      'GoodChannelName',
      sound: RawResourceAndroidNotificationSound('notification'),
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
    );
    const iosDetails = DarwinNotificationDetails(
      sound: 'notification.aiff',
    );
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }
}
