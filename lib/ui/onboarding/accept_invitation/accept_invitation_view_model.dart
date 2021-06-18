import 'package:injectable/injectable.dart';
import 'package:guardspot/data/organization/organization_service.dart';
import 'package:guardspot/data/user/user_store.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';

@injectable
class AcceptInvitationViewModel extends ViewStateViewModel {
  final UserStore _userStore;
  final OrganizationService _organizationService;

  AcceptInvitationViewModel(
    this._userStore,
    this._organizationService,
  );

  bool isSignedIn() => _userStore.isAuthenticated();

  void acceptJoinUrl(String secret) {
    if (!isSignedIn()) {
      return;
    }

    emitLoading();
    try {
      _organizationService.acceptJoinUrl(secret);
      emitSuccess();
    } catch (e) {
      emitForUnhandledError(e);
    }
  }
}
