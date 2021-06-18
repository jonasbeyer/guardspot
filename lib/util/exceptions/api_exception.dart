import 'package:dio/dio.dart';

// extend from DioError to prevent Dio type exception
class ApiException extends DioError {
  ApiError apiError;

  ApiException(this.apiError)
      : super(
          type: DioErrorType.response,
          requestOptions: RequestOptions(path: ""),
        );
}

enum ApiError {
  NETWORK_UNAVAILABLE,
  UNAUTHORIZED,
  FORBIDDEN,
  NOT_FOUND,
  SERVER_ERROR,
  NOT_IMPLEMENTED,
}
