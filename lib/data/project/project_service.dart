import 'dart:async';

import 'package:dio/dio.dart';
import 'package:guardspot/util/enum_util.dart';
import 'package:injectable/injectable.dart';
import 'package:guardspot/models/project.dart';

@lazySingleton
class ProjectService {
  final Dio dio;

  ProjectService(this.dio);

  Future<Project> createProject(Project project) async {
    Response response = await dio.post("projects", data: project.toJson());
    return Project.fromJson(response.data);
  }

  Future<Project> updateProject(int projectId, Project project) async {
    Response response =
        await dio.put("projects/$projectId", data: project.toJson());
    return Project.fromJson(response.data);
  }

  Future<void> subscribe(int projectId, bool subscribe) => subscribe
      ? dio.post("projects/$projectId/subscribe")
      : dio.post("projects/$projectId/unsubscribe");

  Future<void> deleteProject(int projectId) =>
      dio.delete("projects/$projectId");

  Future<Project> addUser(int projectId, int userId) async {
    Response response =
        await dio.post("projects/$projectId/users", data: {"id": userId});
    return Project.fromJson(response.data);
  }

  Future<void> removeUser(int projectId, int userId) =>
      dio.delete("projects/$projectId/users/$userId");

  Future<List<Project>> getMyProjects() async {
    Response<List<dynamic>> response = await dio.get("projects");
    return response.data!.map((data) => Project.fromJson(data)).toList();
  }

  Future<List<Project>> getFilteredProjects(ProjectsFilter filter) async {
    Response<List<dynamic>> response =
        await dio.get("projects/${asName(filter)}");
    return response.data!.map((data) => Project.fromJson(data)).toList();
  }

  Future<Project> getProject(int projectId) async {
    Response response = await dio.get('projects/$projectId');
    return Project.fromJson(response.data);
  }
}
