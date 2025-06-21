import 'package:hive/hive.dart';
import 'package:ilike/core/constants/hive_constants.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserEntity user);
  Future<UserEntity?> getCachedUser();
  Future<void> clearUserCache();
  Future<String?> getAuthToken();
  Future<void> cacheAuthToken(String token);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<UserEntity> userBox;
  final Box<String> tokenBox;

  AuthLocalDataSourceImpl({
    required this.userBox,
    required this.tokenBox,
  });

  @override
  Future<void> cacheUser(UserEntity user) async {
    await userBox.put(HiveConstants.currentUserKey, user);
  }

  @override
  Future<UserEntity?> getCachedUser() async {
    return userBox.get(HiveConstants.currentUserKey);
  }

  @override
  Future<void> clearUserCache() async {
    await userBox.clear();
    await tokenBox.clear();
  }

  @override
  Future<String?> getAuthToken() async {
    return tokenBox.get(HiveConstants.authTokenKey);
  }

  @override
  Future<void> cacheAuthToken(String token) async {
    await tokenBox.put(HiveConstants.authTokenKey, token);
  }
}
