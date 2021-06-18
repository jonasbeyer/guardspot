import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:guardspot/data/organization/organization_service.dart';
import 'package:guardspot/models/user.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class MemberListViewModel extends ViewStateViewModel {
  final BehaviorSubject<List<User>> _memberships = BehaviorSubject();
  final BehaviorSubject<String> _nameFilter = BehaviorSubject.seeded("");

  final OrganizationService _organizationService;

  MemberListViewModel(this._organizationService);

  void fetchMembers() {
    _organizationService.getUsers().then((users) => _memberships.add(users));
  }

  void updateMemberRole(int userId, UserRole role) {
    emitLoading();
    _organizationService
        .updateUserRole(userId, role)
        .then((user) => _memberships.add(_memberships.value!
            .map((it) => it.id == userId ? user : it)
            .toList()))
        .then((_) => emitSuccess())
        .catchError((e) => emitForUnhandledError(e));
  }

  void removeMember(String email) {
    emitLoading();
    _organizationService
        .removeUser(email)
        .then((user) => _memberships
            .add(_memberships.value!.where((it) => it.email != email).toList()))
        .then((_) => emitSuccess())
        .catchError((e) => emitForUnhandledError(e));
  }

  void changeNameFilter(String query) => _nameFilter.add(query);

  Stream<int> get memberCount => _memberships.map((list) => list.length);

  Stream<List<User>> get users => Rx.combineLatest2(_memberships, _nameFilter, (
        List<User> users,
        String query,
      ) {
        final r = RegExp(r"" + query + "", caseSensitive: false);
        return users.where((user) => user.name!.contains(r)).toList();
      });

  @override
  void dispose() {
    super.dispose();
    _memberships.close();
    _nameFilter.close();
  }
}
