import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class AppModule {
  @preResolve
  Future<SharedPreferences> provideSharedPreferences() =>
      SharedPreferences.getInstance();

  @preResolve
  Future<FirebaseMessaging> provideFirebaseMessaging() async {
    await Firebase.initializeApp();
    return FirebaseMessaging.instance;
  }
}
