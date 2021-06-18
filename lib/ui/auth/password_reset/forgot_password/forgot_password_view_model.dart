import 'package:injectable/injectable.dart';
import 'package:guardspot/data/user/user_service.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';
import 'package:guardspot/util/exceptions/api_exception.dart';
import 'package:guardspot/util/extensions/language_extensions.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class ForgotPasswordViewModel extends ViewStateViewModel {
  final UserService _userService;
  final BehaviorSubject<String> email = BehaviorSubject();

  ForgotPasswordViewModel(this._userService);

  void requestPasswordReset() {
    emitLoading();
    addSubscription(_userService
        .requestPasswordReset(email.value!)
        .asStream()
        .listen((_) => emitSuccess(data: "reset_password_success"),
            onError: (error) => _handleError(error)));
  }

  void _handleError(dynamic error) {
    switch (tryCast<ApiException>(error)?.apiError) {
      case ApiError.NOT_FOUND:
        emitError("reset_password_failure");
        break;
      default:
        emitForUnhandledError(error);
    }
  }

  @override
  void dispose() {
    super.dispose();
    email.close();
  }
}
