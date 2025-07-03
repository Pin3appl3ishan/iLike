import 'package:dio/dio.dart';

class DioErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage;

    if (err.response != null) {
      final statusCode = err.response?.statusCode ?? 0;
      if (statusCode >= 300) {
        errorMessage =
            err.response?.data['message']?.toString() ??
            err.response?.statusMessage ??
            'Unknown error';
      } else {
        errorMessage = 'Something went wrong';
      }
    } else {
      errorMessage = 'Connection error';
    }

    final customError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      error: errorMessage,
      type: err.type,
    );

    super.onError(customError, handler);
  }
}
