import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:guardspot/data/project/project_database.dart';
import 'package:guardspot/data/project/project_service.dart';
import 'package:guardspot/data/websocket/socket_event.dart';
import 'package:guardspot/data/websocket/socket_service.dart';
import 'package:guardspot/models/project.dart';
import 'package:guardspot/models/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:guardspot/util/extensions/language_extensions.dart';

@lazySingleton
class ProjectRepository {
  final ProjectDatabase _projectDb;
  final ProjectService _projectService;
  final SocketService _socketService;

  ProjectRepository(
    this._projectService,
    this._socketService,
    this._projectDb,
  );

  Future<void> saveProject(Project project) {
    Future<Project> result = project.id == null
        ? _projectService.createProject(project)
        : _projectService.updateProject(project.id!, project);

    return result.then((project) => _projectDb.insertOne(project));
  }

  Future<void> archiveProject(Project project, bool archived) => _projectService
      .updateProject(project.id!, Project(archived: archived))
      .then((project) => _projectDb.updateOne(project));

  Future<void> subscribe(Project project, bool subscribed) =>
      _projectService.subscribe(project.id!, subscribed).then((_) =>
          _projectDb.updateOne(project.copyWith(subscribed: subscribed)));

  Future<void> deleteProject(int projectId) => _projectService
      .deleteProject(projectId)
      .then((_) => _projectDb.deleteOneById(projectId));

  Future<void> addUser(Project project, User user) => _projectService
      .addUser(project.id!, user.id!)
      .then((project) => _projectDb.insertOne(project));

  Future<void> removeUser(Project project, User user) => _projectService
      .removeUser(project.id!, user.id!)
      .then((_) => _projectDb.updateOne(project.withoutUser(user)));

  Future<List<Project>> getFilteredProjects(ProjectsFilter filter) =>
      _projectService.getFilteredProjects(filter);

  Stream<List<Project>?> observeMyProjects() {
    return Stream.fromFuture(_projectService.getMyProjects())
        .doOnData((projects) => _projectDb.replaceAll(projects))
        .flatMap((_) => _projectDb.observeAll().map((projects) => projects!
            .sortedWith((a, b) => b.createdAt!.compareTo(a.createdAt!))
            .where((project) => !project.archived!)
            .toList()));
  }

  Stream<Project?> observeProject(int projectId) {
    StreamSubscription subscription = _socketService
        .subscribe(channel: "ProjectChannel", modelId: projectId)
        .listen((SocketEvent socketEvent) async {
      if (socketEvent is OnSubscriptionRejected)
        _projectDb.deleteOneById(projectId);
      if (socketEvent is OnDataReceived)
        _projectDb.applyWebsocketUpdate(socketEvent.data);
    });

    return _projectDb
        .observeOne(projectId)
        .doOnCancel(() => subscription.cancel());
  }
}
