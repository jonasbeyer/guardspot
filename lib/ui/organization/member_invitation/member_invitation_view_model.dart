import 'package:injectable/injectable.dart';
import 'package:guardspot/data/organization/organization_service.dart';
import 'package:guardspot/ui/common/view_models/base_view_model.dart';

@injectable
class MemberInvitationViewModel extends BaseViewModel {
  final OrganizationService _organizationService;

  MemberInvitationViewModel(this._organizationService);

  Future<String> fetchJoinUrl() =>
      _organizationService.getJoinUrl().then((response) => response.url);
}
