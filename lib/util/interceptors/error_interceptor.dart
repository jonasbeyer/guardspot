import 'package:dio/dio.dart';
import 'package:guardspot/util/exceptions/api_exception.dart';

class ErrorInterceptor extends InterceptorsWrapper {
  @override
  void onError(DioError error, ErrorInterceptorHandler handler) {
    throw new ApiException(_parseDioError(error));
  }

  static ApiError _parseDioError(DioError error) {
    if (error.response == null) {
      return ApiError.NETWORK_UNAVAILABLE;
    }

    int? statusCode = error.response!.statusCode;
    switch (statusCode) {
      case 401:
        return ApiError.UNAUTHORIZED;
      case 403:
        return ApiError.FORBIDDEN;
      case 404:
        return ApiError.NOT_FOUND;
      case 500:
        return ApiError.SERVER_ERROR;
      default:
        return ApiError.NOT_IMPLEMENTED;
    }
  }
}
