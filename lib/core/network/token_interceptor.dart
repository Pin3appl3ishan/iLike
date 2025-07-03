import 'package:dio/dio.dart';
import 'package:ilike/core/network/hive_service.dart';

/// Intercepts every outgoing request and, if a JWT is stored locally, adds it
/// as `Authorization: Bearer <token>` header.
class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = HiveService.getAuthToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
