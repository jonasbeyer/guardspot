import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:guardspot/models/schedule_entry.dart';
import 'package:guardspot/models/user.dart';

@lazySingleton
class UserService {
  final Dio dio;

  UserService(this.dio);

  Future<void> signUp(
    String name,
    String email,
    String password, {
    String? urlJoinCode,
  }) async {
    await dio.post(
      "users/sign_up",
      data: {
        'name': name,
        'email': email,
        'password': password,
        'url_join_code': urlJoinCode
      }..removeWhere((k, v) => v == null),
    );
  }

  Future<User> signIn(
    String email,
    String password, [
    String? pushToken,
  ]) async {
    Response response = await dio.post(
      "users/sign_in",
      data: {
        "email": email,
        "password": password,
        "push_token": pushToken,
      }..removeWhere((k, v) => v == null),
    );

    return User.fromJson(response.data);
  }

  Future<void> confirmEmail(String code) =>
      dio.post("users/confirm_email", data: {"code": code});

  Future<void> resendConfirmationEmail(String email) =>
      dio.post("users/resend_confirmation_email", data: {"email": email});

  Future<void> requestPasswordReset(String email) =>
      dio.post("users/reset_password", data: {"email": email});

  Future<void> changePassword(String token, String password) {
    return dio.post("users/change_password", data: {
      "token": token,
      "password": password,
    });
  }

  Future<User> getMe() async {
    Response response = await dio.get<Map<String, dynamic>>("users/me");
    return User.fromJson(response.data!);
  }

  Future<List<ScheduleEntry>> getMySchedule() async {
    Response<List<dynamic>> response = await dio.get("users/me/schedule");
    return response.data!
        .map((dynamic data) => ScheduleEntry.fromJson(data))
        .toList();
  }

  Future<void> updateLocation(double latitude, double longitude) {
    return dio.post("users/update_location", data: {
      "latitude": latitude,
      "longitude": longitude,
    });
  }
}
