import 'dart:convert';
import 'package:guardspot/fcm/handler/navigation_intent.dart';
import 'package:guardspot/fcm/notifications/notification.dart';
import 'package:guardspot/models/report.dart';

class ReportNotification extends Notification<Report> {
  ReportNotification(Map<String, dynamic> data) : super("report", data);

  @override
  Report parse(Map<String, dynamic> data) =>
      Report.fromJson(json.decode(data["model"]));

  @override
  int get id => (data.id.toString() + type).hashCode;

  @override
  String get title => "Meldung von: ${data.user!.name}";

  @override
  String get body => data.message!;

  @override
  NavigationIntent get intent => NavigationIntent("report", data);
}
