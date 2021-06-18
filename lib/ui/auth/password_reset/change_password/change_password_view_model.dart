import 'package:injectable/injectable.dart';
import 'package:guardspot/data/user/user_service.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class ChangePasswordViewModel extends ViewStateViewModel {
  final UserService _userService;
  final BehaviorSubject<String> password = BehaviorSubject();

  ChangePasswordViewModel(this._userService);

  void submitPassword(String token) async {
    emitLoading();
    try {
      await _userService.changePassword(token, password.value!);
      emitSuccess();
    } catch (e) {
      emitForUnhandledError(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    password.close();
  }
}
