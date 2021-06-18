import 'package:injectable/injectable.dart';
import 'package:guardspot/data/websocket/socket_response.dart';
import 'package:guardspot/data/websocket/update_message.dart';
import 'package:guardspot/models/project.dart';
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';
import 'package:guardspot/util/extensions/web_socket_extensions.dart';

@lazySingleton
class ProjectDatabase {
  final BehaviorSubject<List<Project>?> _projects = BehaviorSubject();

  void replaceAll(List<Project>? projects) => _projects.add(projects);

  void insertAll(List<Project> projects) {
    final updatedList = _projects.value ?? [];
    updatedList.addAll(projects);
    replaceAll(updatedList);
  }

  void insertOne(Project project) {
    if (getOne(project.id!) != null) {
      updateOne(project);
    } else {
      insertAll([project]);
    }
  }

  void updateOne(Project project) {
    final updatedList = _projects.value
        ?.map((it) => it.id == project.id ? project : it)
        .toList();
    replaceAll(updatedList);
  }

  void deleteOne(Project project) => deleteOneById(project.id!);

  void deleteOneById(int projectId) {
    final updatedList =
        _projects.value?.where((e) => e.id != projectId).toList();
    replaceAll(updatedList);
  }

  Project? getOne(int projectId) => (_projects.value ?? [])
      .firstWhereOrNull((project) => project.id == projectId);

  Stream<Project?> observeOne(int id) =>
      _projects.map((list) => list?.firstWhereOrNull((it) => it.id == id));

  Stream<List<Project>?> observeAll() => _projects;

  void applyWebsocketUpdate(SocketResponse response) {
    int projectId = response.identifier.modelId!;
    UpdateMessage message = response.message;

    if (message.typeName == ModelType.PROJECT) {
      Project project = message.data;
      switch (message.event) {
        case ModelEvent.ADD:
          insertOne(project);
          break;
        case ModelEvent.UPDATE:
          updateOne(project);
          break;
        case ModelEvent.REMOVE:
          deleteOne(project);
      }
    } else if (message.typeName == ModelType.USER) {
      Project project = this.getOne(projectId)!;
      updateOne(project.copyWith(
        users: project.users.merge(message.typedAs()),
      ));
    }
  }
}
