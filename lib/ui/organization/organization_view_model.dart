import 'package:injectable/injectable.dart';
import 'package:guardspot/data/organization/organization_service.dart';
import 'package:guardspot/models/organization.dart';
import 'package:guardspot/ui/common/view_models/base_view_model.dart';

@injectable
class OrganizationViewModel extends BaseViewModel<Organization> {
  final OrganizationService _organizationService;

  OrganizationViewModel(this._organizationService);

  void fetchOrganizationDetails() {
    _organizationService
        .getCurrentOrganization()
        .then((organization) => emit(organization))
        .catchError((error) => emitFailure(error));
  }
}
