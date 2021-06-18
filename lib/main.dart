import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:guardspot/app/app.dart';
import 'package:guardspot/app/url_strategy/configure_nonweb.dart'
    if (dart.library.html) 'package:guardspot/app/url_strategy/configure_web.dart';
import 'package:guardspot/data/location/location_service.dart';
import 'package:guardspot/data/user/user_service.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:rxdart/rxdart.dart';

FlutterLocalNotificationsPlugin? notificationsPlugin;
BehaviorSubject<String>? notificationSelected;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    Fimber.plantTree(DebugTree());
  }

  await configureLocator();
  configureApp();
  runApp(App());

  if (!kIsWeb) {
    initNotificationsPlugin();
    startLocationTracking();
  }
}

Future<void> startLocationTracking() async {
  final UserService userService = locator();
  final LocationService locationService = locator();

  const int MAP_LOCATION_UPDATE_INTERVAL = 8000;
  const int MAP_LOCATION_UPDATE_DISPLACEMENT = 10;

  locationService
      .observeCurrentLocation(
        distanceFilter: MAP_LOCATION_UPDATE_DISPLACEMENT,
        timeInterval: MAP_LOCATION_UPDATE_INTERVAL,
      )
      .listen((it) => userService
          .updateLocation(it.latitude, it.longitude)
          .catchError((e) => Fimber.e("Location update failed")));
}

void initNotificationsPlugin() {
  final android = AndroidInitializationSettings("mipmap/ic_launcher");
  final ios = IOSInitializationSettings();
  final platform = InitializationSettings(android: android, iOS: ios);

  notificationSelected = BehaviorSubject();
  notificationsPlugin = FlutterLocalNotificationsPlugin();
  notificationsPlugin!.initialize(
    platform,
    onSelectNotification: (it) async => notificationSelected!.add(it!),
  );
}
