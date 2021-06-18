import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardspot/data/user/user_service.dart';
import 'package:guardspot/models/user.dart';
import 'package:guardspot/data/user/user_repository.dart';
import 'package:guardspot/data/user/user_store.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_repository_test.mocks.dart';

@GenerateMocks([UserService, UserStore, FirebaseMessaging])
void main() {
  late UserStore userStore;
  late UserService userService;
  late FirebaseMessaging messaging;
  late UserRepository repository;

  setUp(() {
    userStore = MockUserStore();
    userService = MockUserService();
    messaging = MockFirebaseMessaging();

    repository = UserRepository(
      userService,
      userStore,
      messaging,
    );
  });

  test("signIn", () async {
    String password = "123456";
    String fcmToken = "ABCDEFGHIJKLMNOP";

    User user = User(id: 1, email: "john.doe@example.com", token: "12345678");

    when(messaging.getToken()).thenAnswer((_) async => fcmToken);
    when(userService.signIn(user.email!, password, fcmToken))
        .thenAnswer((_) async => user);

    await repository.signIn(user.email!, password);
    expect(verify(userStore.saveUser(captureAny)).captured.single, user);
  });

  test("isSignedIn", () {
    when(userStore.isAuthenticated()).thenReturn(true);
    expect(repository.isSignedIn(), true);
  });

  test("signOut", () {
    repository.signOut();
    verify(userStore.deleteUser());
  });
}
