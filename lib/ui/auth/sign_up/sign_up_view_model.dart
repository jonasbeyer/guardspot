import 'package:injectable/injectable.dart';
import 'package:guardspot/data/user/user_repository.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';
import 'package:guardspot/util/exceptions/api_exception.dart';
import 'package:guardspot/util/extensions/language_extensions.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class SignUpViewModel extends ViewStateViewModel {
  final name = BehaviorSubject();
  final email = BehaviorSubject<String>();
  final password = BehaviorSubject<String>();
  final urlJoinCode = BehaviorSubject<String?>();

  final UserRepository _userRepository;

  SignUpViewModel(this._userRepository);

  Future<void> signUp() async {
    emitLoading();

    try {
      await _userRepository.signUp(
        name.value!,
        email.value!,
        password.value!,
        urlJoinCode: urlJoinCode.value,
      );
      emitSuccess();
    } catch (error) {
      _handleError(error);
    }
  }

  void setJoinCode(String? code) => urlJoinCode.add(code);

  void _handleError(dynamic error) {
    switch (tryCast<ApiException>(error)?.apiError) {
      case ApiError.FORBIDDEN:
        emitError("email_forgiven");
        break;
      default:
        emitForUnhandledError(error);
    }
  }

  @override
  void dispose() {
    super.dispose();
    name.close();
    email.close();
    password.close();
    urlJoinCode.close();
  }
}
