import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:guardspot/data/project/project_repository.dart';
import 'package:guardspot/models/project.dart';
import 'package:guardspot/ui/common/view_models/base_view_model.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class ProjectListViewModel extends BaseViewModel {
  final ProjectRepository _projectRepository;

  final _projects = BehaviorSubject<List<Project>>();
  final _query = BehaviorSubject.seeded("");

  StreamSubscription? _loadProjectsSubscription;

  ProjectListViewModel(this._projectRepository);

  void loadProjects() {
    _loadProjectsSubscription?.cancel();
    _loadProjectsSubscription = _projectRepository
        .observeMyProjects()
        .listen((projects) => _projects.add(projects!));
  }

  void setQuery(String query) => _query.add(query);

  void retry() => loadProjects();

  Stream<List<Project>> get filteredProjects {
    return Rx.combineLatest2(_projects, _query, (
      List<Project> projects,
      String query,
    ) {
      final r = RegExp(r"" + query + "", caseSensitive: false);
      return projects.where((project) => project.name!.contains(r)).toList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _projects.close();
    _query.close();
    _loadProjectsSubscription?.cancel();
  }
}
