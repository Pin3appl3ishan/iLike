import 'package:dio/dio.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<UserModel> getProfile(String userId, String token);
  Future<void> updateProfile(String userId, Map<String, dynamic> data, String token);
  Future<List<UserModel>> getAllUsers(String token);
  Future<void> likeUser(String userId, String targetId, String token);
  Future<void> dislikeUser(String userId, String targetId, String token);
  Future<List<UserModel>> getMatches(String userId, String token);
  Future<void> logout(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  AuthRemoteDataSourceImpl({required this.dio, this.baseUrl = 'http://your-backend-url:5000/api/users'});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '$baseUrl/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      final userData = response.data['data'];
      return UserModel.fromJson(userData);
    } on DioException catch (e) {
      throw ServerFailure(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    try {
      final response = await dio.post(
        '$baseUrl/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      
      final userData = response.data['data'];
      return UserModel.fromJson(userData);
    } on DioException catch (e) {
      throw ServerFailure(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<UserModel> getProfile(String userId, String token) async {
    try {
      final response = await dio.get(
        '$baseUrl/profile/$userId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerFailure(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<void> updateProfile(String userId, Map<String, dynamic> data, String token) async {
    try {
      await dio.put(
        '$baseUrl/profile/$userId',
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw ServerFailure(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<List<UserModel>> getAllUsers(String token) async {
    try {
      final response = await dio.get(
        baseUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return (response.data['data'] as List)
          .map((user) => UserModel.fromJson(user))
          .toList();
    } on DioException catch (e) {
      throw ServerFailure(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<void> likeUser(String userId, String targetId, String token) async {
    try {
      await dio.post(
        '$baseUrl/like/$targetId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw ServerFailure(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<void> dislikeUser(String userId, String targetId, String token) async {
    try {
      await dio.post(
        '$baseUrl/dislike/$targetId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw ServerFailure(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<List<UserModel>> getMatches(String userId, String token) async {
    try {
      final response = await dio.get(
        '$baseUrl/matches',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return (response.data['data'] as List)
          .map((user) => UserModel.fromJson(user))
          .toList();
    } on DioException catch (e) {
      throw ServerFailure(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<void> logout(String token) async {
    try {
      await dio.post(
        '$baseUrl/logout',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw ServerFailure(e.response?.data['message'] ?? e.message);
    }
  }
}
