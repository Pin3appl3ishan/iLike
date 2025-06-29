import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/auth/data/models/user_hive_model.dart';
import 'package:ilike/core/network/hive_service.dart';

abstract interface class AuthLocalDataSource {
  Future<void> cacheUser(UserHiveModel user);
  Future<Option<UserHiveModel>> getCachedUser();
  Future<void> clearCachedUser();
  Future<bool> isUserLoggedIn();
  Future<void> cacheAuthToken(String token);
  Future<Option<String>> getAuthToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl();

  @override
  Future<void> cacheAuthToken(String token) async {
    await  HiveService.cacheAuthToken(token);
  }

  @override
  Future<void> cacheUser(UserHiveModel user) async {
    try {
      await HiveService.cacheUser(user);
    } catch (e) {
      throw CacheFailure('Failed to cache user: $e');
    }
  }

  @override
  Future<void> clearCachedUser() async {
    await HiveService.clearCachedUser();
  }

  @override
  Future<Option<String>> getAuthToken() async {
    try {
      final token = HiveService.getAuthToken();
      return token != null ? Some(token) : const None();
    } catch (e) {
      return const None();
    }
  }

  @override
  Future<Option<UserHiveModel>> getCachedUser() async {
    try {
      final user = await HiveService.getCachedUser();
      return user;
    } catch (e) {
      return const None();
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    return await HiveService.isUserLoggedIn();
  }
  
}
