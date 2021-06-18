import 'package:injectable/injectable.dart';
import 'package:guardspot/data/organization/organization_service.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class CreateOrganizationViewModel extends ViewStateViewModel {
  final OrganizationService _organizationService;
  final BehaviorSubject<String> name = BehaviorSubject();

  CreateOrganizationViewModel(this._organizationService);

  Future<void> createOrganization() async {
    emitLoading();

    try {
      await _organizationService.createOrganization(name.value!);
      emitSuccess();
    } catch (e) {
      emitForUnhandledError(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    name.close();
  }
}
