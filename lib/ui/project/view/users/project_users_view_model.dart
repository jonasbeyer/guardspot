import 'package:injectable/injectable.dart';
import 'package:guardspot/data/organization/organization_service.dart';
import 'package:guardspot/data/project/project_repository.dart';
import 'package:guardspot/models/project.dart';
import 'package:guardspot/models/user.dart';
import 'package:guardspot/ui/common/view_models/base_view_model.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class ProjectUsersViewModel extends BaseViewModel {
  final OrganizationService _organizationService;
  final ProjectRepository _projectRepository;

  final BehaviorSubject<List<User>> _organizationMembers = BehaviorSubject();
  final BehaviorSubject<List<User>> _projectMembers = BehaviorSubject();

  late Project _project;

  ProjectUsersViewModel(this._organizationService, this._projectRepository);

  void setProject(Project project) {
    _project = project;
    _projectMembers.add(project.users);
    _organizationService
        .getUsers()
        .then((members) => _organizationMembers.add(members));
  }

  Future<void> toggleMembership(ProjectMembership membership) async {
    User user = membership.user;
    bool newIsProjectMemberState = !membership.isProjectMember;

    Future<void> toggleRequest = membership.isProjectMember
        ? _projectRepository.removeUser(_project, user)
        : _projectRepository.addUser(_project, user);

    await toggleRequest;

    if (newIsProjectMemberState) {
      final list = _projectMembers.value;
      list!.add(membership.user);
      _projectMembers.add(list);
    } else {
      final list =
          _projectMembers.value!.where((it) => it.id != user.id!).toList();
      _projectMembers.add(list);
    }
  }

  Stream<List<ProjectMembership>> get memberships => Rx.combineLatest2(
        _organizationMembers,
        _projectMembers,
        (List<User> a, List<User> b) => a
            .map((orgMember) => ProjectMembership(
                  user: orgMember,
                  isProjectMember: b
                      .any((projectMember) => orgMember.id == projectMember.id),
                ))
            .toList(),
      );

  @override
  void dispose() {
    super.dispose();
    _organizationMembers.close();
  }
}

class ProjectMembership {
  ProjectMembership({
    required this.user,
    required this.isProjectMember,
  });

  User user;
  bool isProjectMember;
}
