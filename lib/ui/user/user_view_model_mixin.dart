import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/user.dart';
import 'package:guardspot/ui/common/view_models/base_view_model.dart';
import 'package:guardspot/ui/user/user_view_model_delegate.dart';

mixin UserViewModelMixin<T> on BaseViewModel<T> {
  final UserViewModelDelegate _userViewModelDelegate = locator();

  int? getUserId() =>
      _userViewModelDelegate.currentUserInfo.valueWrapper?.value?.id;

  Stream<User?> get currentUserInfo => _userViewModelDelegate.currentUserInfo;

  @override
  void dispose() {
    super.dispose();
    _userViewModelDelegate.dispose();
  }
}
