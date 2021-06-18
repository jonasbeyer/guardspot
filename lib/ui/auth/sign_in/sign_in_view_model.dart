import 'package:injectable/injectable.dart';
import 'package:guardspot/data/user/user_repository.dart';
import 'package:guardspot/models/user.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';
import 'package:guardspot/util/exceptions/api_exception.dart';
import 'package:rxdart/rxdart.dart';
import 'package:guardspot/util/extensions/language_extensions.dart';

@injectable
class SignInViewModel extends ViewStateViewModel {
  final UserRepository _userRepository;

  final email = BehaviorSubject<String>();
  final password = BehaviorSubject<String>();

  SignInViewModel(this._userRepository);

  void signIn() {
    emitLoading();
    _userRepository
        .signIn(email.value!, password.value!)
        .then((user) => _handleSuccess(user))
        .catchError((error) => _handleError(error));
  }

  void _handleSuccess(User user) {
    emitSuccess(data: Destination.DASHBOARD);
  }

  void _handleError(dynamic error) {
    switch (tryCast<ApiException>(error)?.apiError) {
      case ApiError.UNAUTHORIZED:
        emitError("auth_invalid_credentials");
        break;
      case ApiError.FORBIDDEN:
        emitSuccess(data: Destination.PENDING_CONFIRMATION);
        break;
      default:
        emitForUnhandledError(error);
    }
  }

  @override
  void dispose() {
    super.dispose();
    email.close();
    password.close();
  }
}

enum Destination { DASHBOARD, PENDING_CONFIRMATION }
