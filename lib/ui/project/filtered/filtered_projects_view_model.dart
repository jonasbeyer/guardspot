import 'package:injectable/injectable.dart';
import 'package:guardspot/data/project/project_repository.dart';
import 'package:guardspot/data/user/user_repository.dart';
import 'package:guardspot/models/project.dart';
import 'package:guardspot/ui/common/view_models/base_view_model.dart';

@injectable
class FilteredProjectsDialogViewModel extends BaseViewModel<List<Project>> {
  final UserRepository _userRepository;
  final ProjectRepository _projectRepository;

  FilteredProjectsDialogViewModel(
    this._userRepository,
    this._projectRepository,
  );

  void setFilter(ProjectsFilter filter) async {
    final projects = _projectRepository.getFilteredProjects(filter);
    emit(await projects);
  }

  void addMeToProject(Project project) => _projectRepository
      .addUser(project, _userRepository.getCachedUser()!)
      .then((_) => removeProject(project));

  void restoreProject(Project project) => _projectRepository
      .archiveProject(project, false)
      .then((_) => removeProject(project));

  void deleteProject(Project project) => _projectRepository
      .deleteProject(project.id!)
      .then((_) => removeProject(project));

  void removeProject(Project project) {
    List<Project> projects = state!.where((p) => p.id != project.id).toList();
    emit(projects);
  }
}
