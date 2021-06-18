import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:guardspot/app/config/network_config.dart';
import 'package:guardspot/util/interceptors/auth_interceptor.dart';
import 'package:guardspot/util/interceptors/error_interceptor.dart';

@module
abstract class DataModule {
  // Dio
  @lazySingleton
  Dio provideDio(AuthInterceptor authInterceptor) {
    Dio dio = Dio()
      ..options.baseUrl = NetworkConfig.API_ENDPOINT
      ..options.contentType = Headers.formUrlEncodedContentType
      ..interceptors.addAll([authInterceptor, ErrorInterceptor()]);

    return dio;
  }
}
