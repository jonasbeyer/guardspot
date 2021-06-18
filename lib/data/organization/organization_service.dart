import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:guardspot/models/url_response.dart';
import 'package:guardspot/models/organization.dart';
import 'package:guardspot/models/user.dart';
import 'package:guardspot/util/enum_util.dart';

@lazySingleton
class OrganizationService {
  final Dio dio;

  OrganizationService(this.dio);

  Future<void> createOrganization(String name) =>
      dio.post("organization", data: {"name": name});

  Future<void> updateOrganization(String name) =>
      dio.put("organization", data: {"name": name});

  Future<void> deleteOrganization() => dio.delete("organization");

  Future<Organization> getCurrentOrganization() async {
    Response<Map<String, dynamic>> response = await dio.get("organization");
    return Organization.fromJson(response.data!);
  }

  Future<List<User>> getUsers() async {
    Response<List<dynamic>> response = await dio.get("organization/users");
    return response.data!
        .map((i) => User.fromJson(i as Map<String, dynamic>))
        .toList();
  }

  Future<void> addUser(String email) =>
      dio.post('organization/users', data: {"email": email});

  Future<void> removeUser(String email) =>
      dio.delete('organization/users', data: {"email": email});

  Future<User> updateUserRole(int userId, UserRole role) async {
    Response response = await dio
        .put('organization/users/$userId', data: {"role": asName(role)});
    return User.fromJson(response.data);
  }

  Future<UrlResponse> getJoinUrl() async {
    Response response = await dio.post('organization/join_url');
    return UrlResponse.fromJson(response.data);
  }

  Future<void> deleteJoinUrl() => dio.delete('organization/join_url');

  Future<User> acceptJoinUrl(String urlJoinCode) async {
    Response response = await dio.post('organization/join_url/accept',
        data: {"url_join_code": urlJoinCode});

    return User.fromJson(response.data);
  }
}
