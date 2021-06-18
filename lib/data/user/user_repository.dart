import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:guardspot/data/user/user_service.dart';
import 'package:guardspot/data/user/user_store.dart';
import 'package:guardspot/models/user.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class UserRepository {
  final UserService _userService;
  final UserStore _userStore;
  final FirebaseMessaging _firebaseMessaging;

  UserRepository(
    this._userService,
    this._userStore,
    this._firebaseMessaging,
  ) {
    // refreshUserOnInit();
  }

  Future<User> signIn(String email, String password) async {
    String? fcmTokenId = !kIsWeb ? await _firebaseMessaging.getToken() : null;
    User user = await _userService.signIn(email, password, fcmTokenId);

    _userStore.saveUser(user);
    return user;
  }

  Future<void> signUp(
    String name,
    String email,
    String password, {
    String? urlJoinCode,
  }) {
    return _userService.signUp(name, email, password, urlJoinCode: urlJoinCode);
  }

  void signOut() => _userStore.deleteUser();

  void refreshUserOnInit() {
    Stream<bool> isSignedIn = _userStore.observeAuthState();
    isSignedIn.listen((bool isSignedIn) async {
      if (isSignedIn) {
        User user = await _userService.getMe();
        _userStore.saveUser(user);
      } else {
        _userStore.deleteUser();
      }
    });
  }

  bool isSignedIn() => _userStore.isAuthenticated();

  User? getCachedUser() => _userStore.getCachedUser();

  ValueStream<User?> getObservableUser() => _userStore.observeUser();
}
