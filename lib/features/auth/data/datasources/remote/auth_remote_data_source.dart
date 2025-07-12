import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ilike/core/error/exceptions.dart';
import 'package:ilike/core/network/api_constants.dart';
import 'package:ilike/features/auth/data/models/api_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<ApiUserModel> login(String email, String password);
  Future<ApiUserModel> register(String name, String email, String password);
  Future<void> logout(String token);
  Future<ApiUserModel> getCurrentUser(String token);
  Future<void> refreshToken(String refreshToken);
}

Map<String, dynamic> parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw FormatException('Invalid token format');
  }

  final payload = parts[1];
  final normalized = base64Url.normalize(payload);
  final resp = utf8.decode(base64Url.decode(normalized));
  final payloadMap = json.decode(resp);
  return payloadMap;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<ApiUserModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}/users/login',
        data: {'email': email, 'password': password},
      );

      // Expecting { success: true, token: ..., user: { ... } }
      final userJson = Map<String, dynamic>.from(response.data['user'] ?? {});
      final token = response.data['token'] as String?;

      // Parse JWT token to get hasCompletedProfile
      if (token != null) {
        userJson['token'] = token;
        try {
          final tokenData = parseJwt(token);
          userJson['hasCompletedProfile'] =
              tokenData['hasCompletedProfile'] ?? false;
        } catch (e) {
          print('Error parsing JWT token: $e');
        }
      }

      // Backend uses 'id'; model expects '_id'
      if (userJson.containsKey('id') && !userJson.containsKey('_id')) {
        userJson['_id'] = userJson.remove('id');
      }
      final model = ApiUserModel.fromJson(userJson);
      return model;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Invalid email or password');
      }
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<ApiUserModel> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}/users/register',
        data: {'name': name, 'email': email, 'password': password},
      );

      final userJson = Map<String, dynamic>.from(response.data['user'] ?? {});
      final token = response.data['token'] as String?;

      // Parse JWT token to get hasCompletedProfile
      if (token != null) {
        userJson['token'] = token;
        try {
          final tokenData = parseJwt(token);
          userJson['hasCompletedProfile'] =
              tokenData['hasCompletedProfile'] ?? false;
        } catch (e) {
          print('Error parsing JWT token: $e');
        }
      }

      if (userJson.containsKey('id') && !userJson.containsKey('_id')) {
        userJson['_id'] = userJson.remove('id');
      }
      return ApiUserModel.fromJson(userJson);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw BadRequestException('Email already in use');
      }
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> logout(String token) async {
    try {
      await dio.post(
        '${ApiConstants.baseUrl}/users/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      // Even if logout fails, we still want to proceed
    }
  }

  @override
  Future<ApiUserModel> getCurrentUser(String token) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/users/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return ApiUserModel.fromJson(response.data);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> refreshToken(String refreshToken) async {
    try {
      await dio.post(
        '${ApiConstants.baseUrl}/users/refresh',
        data: {'refresh_token': refreshToken},
      );
    } catch (e) {
      throw ServerException();
    }
  }
}
