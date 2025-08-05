import 'package:dio/dio.dart';
import 'package:ilike/core/network/hive_service.dart';

/// Intercepts every outgoing request and, if a JWT is stored locally, adds it
/// as `Authorization: Bearer <token>` header.
class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = HiveService.getAuthToken();
    print('[TokenInterceptor] Token from Hive: $token'); // Debug log
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      print('[TokenInterceptor] Added token to request headers'); // Debug log
    } else {
      print('[TokenInterceptor] No token found in Hive'); // Debug log
    }
    super.onRequest(options, handler);
  }
}
