import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:guardspot/fcm/handler/navigation_intent.dart';

const _CHANNEL_ID = "default_notifications";
const _CHANNEL_NAME = "Default";

abstract class Notification<T> {
  late T data;
  late String type;

  Notification(String type, Map<String, dynamic> data) {
    this.type = type;
    this.data = parse(data);
  }

  T parse(Map<String, dynamic> data);

  int get id;

  String get title;

  String get body;

  NavigationIntent get intent;

  Future<AndroidNotificationDetails> get androidDetails =>
      Future.value(AndroidNotificationDetails(_CHANNEL_ID, _CHANNEL_NAME, ""));

  Future<IOSNotificationDetails> get iOSDetails =>
      Future.value(IOSNotificationDetails());
}
