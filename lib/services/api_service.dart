import 'package:dio/dio.dart';
import '../constants/api.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<Response> post(String path, Map<String, dynamic> data,
      {String? token}) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        options: Options(
          headers: token != null ? {
            'Authorization': 'Bearer $token',
          } : null,
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> get(String path, {String? token}) async {
    try {
      final response = await _dio.get(
        path,
        options: Options(
          headers: token != null ? {
            'Authorization': 'Bearer $token',
          } : null,
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

