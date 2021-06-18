import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guardspot/util/extensions/theme_extensions.dart';

@lazySingleton
class PreferenceStorage {
  final StringPreference selectedTheme;
  final StringPreference notificationSound;
  final BooleanPreference notificationVibration;
  final BooleanPreference notificationsEnabled;
  final BooleanPreference mapsSatelliteMode;

  PreferenceStorage(SharedPreferences prefs)
      : selectedTheme =
            StringPreference("pref_theme", ThemeMode.dark.storageKey, prefs),
        notificationsEnabled =
            BooleanPreference("pref_notifications_enabled", true, prefs),
        notificationSound =
            StringPreference("pref_notifications_sound", "", prefs),
        notificationVibration =
            BooleanPreference("pref_notifications_vibration", false, prefs),
        mapsSatelliteMode =
            BooleanPreference("pref_satellite_mode", true, prefs);
}

abstract class Preference<T> {
  // ignore: close_sinks
  BehaviorSubject<T> subject = BehaviorSubject();

  void set(T value);
  T get();
}

class BooleanPreference extends Preference<bool> {
  final String name;
  final bool defaultValue;
  final SharedPreferences preferences;

  BooleanPreference(this.name, this.defaultValue, this.preferences) {
    subject.add(get());
  }

  @override
  void set(bool value) {
    preferences.setBool(name, value);
    subject.add(value);
  }

  @override
  bool get() => preferences.getBool(name) ?? defaultValue;
}

class StringPreference extends Preference<String> {
  final String name;
  final String defaultValue;
  final SharedPreferences preferences;

  StringPreference(this.name, this.defaultValue, this.preferences) {
    subject.add(get());
  }

  void set(String value) {
    preferences.setString(name, value);
    subject.add(value);
  }

  String get() => preferences.getString(name) ?? defaultValue;
}
