import 'dart:convert';

import 'package:fimber/fimber.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:guardspot/fcm/notifications/report_notification.dart';
import 'package:guardspot/fcm/notifications/notification.dart';
import 'package:guardspot/main.dart';

@lazySingleton
class NotificationHandler {
  void init() {
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onBackgroundMessage(_handleMessage);
  }

  static Future<void> _handleMessage(RemoteMessage message) async {
    // if (!preferenceStorage.notificationsEnabled.get()) {
    //   Fimber.d("User disabled notifications, not showing.");
    //   return;
    // }

    Notification notification;
    String notificationType = message.data["type"];

    switch (notificationType) {
      case "report":
        notification = ReportNotification(message.data);
        break;
      default:
        Fimber.d("Unknown notification type: $notificationType");
        return;
    }

    await _showNotification(notification);
  }

  static Future<void> _showNotification(Notification notification) async {
    NotificationDetails platform = NotificationDetails(
      iOS: await notification.iOSDetails,
      android: await notification.androidDetails,
    );

    await notificationsPlugin!.show(
      notification.id,
      notification.title,
      notification.body,
      platform,
      payload: jsonEncode(notification.intent),
    );
  }
}
