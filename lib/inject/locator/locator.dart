import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:guardspot/inject/locator/locator.config.dart';

final locator = GetIt.instance;

@InjectableInit()
Future<void> configureLocator() async => $initGetIt(
      locator,
      environment: kIsWeb ? "web" : "mobile",
    );
