import 'package:guardspot/app/router.dart';
import 'package:injectable/injectable.dart';
import 'package:guardspot/data/project/project_repository.dart';
import 'package:guardspot/models/project.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';

@injectable
class ArchiveDeleteProjectViewModel extends ViewStateViewModel {
  final ProjectRepository _projectRepository;

  ArchiveDeleteProjectViewModel(this._projectRepository);

  void delete(Project project) async {
    emitLoading();
    try {
      await _projectRepository.deleteProject(project.id!);
      emitSuccess(data: DashboardScreenRoute());
    } catch (e) {
      emitForUnhandledError(e);
    }
  }

  void archive(Project project) async {
    emitLoading();
    try {
      await _projectRepository.archiveProject(project, true);
      emitSuccess();
    } catch (e) {
      emitForUnhandledError(e);
    }
  }
}
