import 'package:injectable/injectable.dart';
import 'package:guardspot/models/user.dart';
import 'package:guardspot/data/user/user_repository.dart';
import 'package:guardspot/ui/common/view_models/base_view_model.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class UserViewModelDelegate extends BaseViewModel {
  final UserRepository _userRepository;

  UserViewModelDelegate(this._userRepository);

  void signOut() => _userRepository.signOut();

  int? getUserId() => _userRepository.getCachedUser()?.id;

  ValueStream<User?> get currentUserInfo => _userRepository.getObservableUser();
}
