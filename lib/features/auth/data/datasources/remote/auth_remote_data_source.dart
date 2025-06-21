import 'package:dio/dio.dart';
import 'package:ilike/core/error/exceptions.dart';
import 'package:ilike/core/network/api_constants.dart';
import 'package:ilike/features/auth/data/models/api_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<ApiUserModel> login(String email, String password);
  Future<ApiUserModel> register(String name, String email, String password);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<ApiUserModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return ApiUserModel.fromJson(response.data);
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
  Future<ApiUserModel> register(String name, String email, String password) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      return ApiUserModel.fromJson(response.data);
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
  Future<void> logout() async {
    try {
      await dio.post('${ApiConstants.baseUrl}/auth/logout');
    } catch (e) {
      // Even if logout fails, we still want to proceed
    }
  }
}
