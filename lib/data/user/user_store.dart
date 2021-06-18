import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:guardspot/models/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class UserStore {
  static const String _SESSION_USER = "session_user";

  final SharedPreferences _preferences;
  final BehaviorSubject<User?> _observableUser = BehaviorSubject();

  UserStore(this._preferences) {
    _observableUser.add(getUser());
  }

  void saveUser(User? user) {
    if (user == null) return;

    _observableUser.add(user);
    _preferences.setString(_SESSION_USER, jsonEncode(user));
  }

  void deleteUser() {
    _observableUser.add(null);
    _preferences.remove(_SESSION_USER);
  }

  User? getUser() {
    String? rawJsonString = _preferences.getString(_SESSION_USER);
    if (rawJsonString == null) {
      return null;
    }

    return User.fromJson(jsonDecode(rawJsonString));
  }

  User? getCachedUser() => _observableUser.value;

  String? getAuthenticationToken() => getCachedUser()?.token;

  ValueStream<User?> observeUser() => _observableUser;

  Stream<bool> observeAuthState() =>
      _observableUser.map((_) => isAuthenticated()).distinct();

  bool isAuthenticated() => getAuthenticationToken() != null;

  bool hasOrganization() => getCachedUser()?.organizationId != null;
}
