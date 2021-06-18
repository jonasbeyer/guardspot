import 'package:injectable/injectable.dart';
import 'package:guardspot/data/project/project_repository.dart';
import 'package:guardspot/models/project.dart';
import 'package:guardspot/ui/common/view_models/base_view_model.dart';

@injectable
class ProjectDetailsViewModel extends BaseViewModel<Project?> {
  final ProjectRepository _projectRepository;

  ProjectDetailsViewModel(this._projectRepository);

  int getProjectId() => state!.id!;

  void setProjectId(int projectId) => addSubscription(_projectRepository
      .observeProject(projectId)
      .listen(emit, onError: emitFailure));

  void updateSubscription(bool subscribed) =>
      _projectRepository.subscribe(state!, subscribed);

  void restoreProject() => _projectRepository.archiveProject(state!, false);
}
