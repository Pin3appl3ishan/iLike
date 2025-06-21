import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/auth/data/models/user_hive_model.dart';
import 'package:ilike/core/network/hive_service.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';

abstract class AuthLocalDataSource {
  Future<UserHiveModel?> getUser(String id);
  Future<UserHiveModel?> getUserByEmail(String email);
  Future<Unit> saveUser(UserHiveModel user);
  Future<Unit> deleteUser(String id);
  Future<Unit> clearAll();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final HiveService hiveService;

  AuthLocalDataSourceImpl({required this.hiveService});

  @override
  Future<UserHiveModel?> getUser(String id) async {
    try {
      return await hiveService.getUser(id);
    } catch (e) {
      throw CacheFailure('Failed to get user: $e');
    }
  }

  @override
  Future<UserHiveModel?> getUserByEmail(String email) async {
    try {
      return await hiveService.getUserByEmail(email);
    } catch (e) {
      throw CacheFailure('Failed to get user by email: $e');
    }
  }

  @override
  Future<Unit> saveUser(UserHiveModel user) async {
    try {
      await hiveService.saveUser(user);
      return unit;
    } catch (e) {
      throw CacheFailure('Failed to save user: $e');
    }
  }

  @override
  Future<Unit> deleteUser(String id) async {
    try {
      await hiveService.deleteUser(id);
      return unit;
    } catch (e) {
      throw CacheFailure('Failed to delete user: $e');
    }
  }

  @override
  Future<Unit> clearAll() async {
    try {
      await hiveService.clearAll();
      return unit;
    } catch (e) {
      throw CacheFailure('Failed to clear data: $e');
    }
  }
}
