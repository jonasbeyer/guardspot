import 'package:injectable/injectable.dart';
import 'package:guardspot/data/user/user_service.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';

@injectable
class ConfirmEmailViewModel extends ViewStateViewModel {
  final UserService _userService;

  ConfirmEmailViewModel(this._userService);

  void confirmEmail(String code) async {
    emitLoading();

    try {
      await _userService.confirmEmail(code);
      emitSuccess();
    } catch (e) {
      emitError("an_error_occurred");
    }
  }
}
