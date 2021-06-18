import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:guardspot/data/user/user_store.dart';

@injectable
class AuthInterceptor extends InterceptorsWrapper {
  final UserStore _userStore;

  AuthInterceptor(this._userStore);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    String? userToken = _userStore.getAuthenticationToken();
    Map<String, dynamic> headers = options.headers;

    if (userToken != null) {
      headers["Authorization"] = "Bearer $userToken";
    }

    return handler.next(options);
  }
}
