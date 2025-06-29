// lib/core/network/hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/auth/data/models/user_hive_model.dart';

class HiveService {
  static const String _userBox = 'user_box';
  static const String _tokenBox = 'token_box';

  static Future<void> init() async {
    try {
      final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDir.path);
      
      // Register adapters
      Hive.registerAdapter(UserHiveModelAdapter());
      
      // Open boxes
      await Future.wait([
        Hive.openBox<UserHiveModel>(_userBox),
        Hive.openBox<String>(_tokenBox),
      ]);
    } catch (e) {
      throw const CacheFailure('Failed to initialize Hive');
    }
  }

  static Future<void> close() async {
    try {
      await Hive.close();
    } catch (e) {
      throw const CacheFailure('Failed to close Hive');
    }
  }

  static Box<UserHiveModel> get userBox => Hive.box<UserHiveModel>(_userBox);
  static Box<String> get tokenBox => Hive.box<String>(_tokenBox);

  static const String _authTokenKey = 'auth_token';

  static Future<void> cacheAuthToken(String token) async {
    try {
      await tokenBox.put(_authTokenKey, token);
    } catch (e) {
      throw const CacheFailure('Failed to cache auth token');
    }
  }

  static String? getAuthToken() {
    try {
      return tokenBox.get(_authTokenKey);
    } catch (e) {
      throw const CacheFailure('Failed to get auth token');
    }
  }

  static Future<void> cacheUser(UserHiveModel user) async {
    try {
      await userBox.put('current_user', user);
    } catch (e) {
      throw const CacheFailure('Failed to cache user');
    }
  }

  static Future<Option<UserHiveModel>> getCachedUser() async {
    try {
      final user = userBox.get('current_user');
      return user != null ? optionOf(user) : none();
    } catch (e) {
      return none();
    }
  }

  static Future<void> clearCachedUser() async {
    try {
      await userBox.delete('current_user');
      await tokenBox.delete(_authTokenKey);
    } catch (e) {
      throw const CacheFailure('Failed to clear cached user');
    }
  }

  static Future<bool> isUserLoggedIn() async {
    try {
      final token = await getAuthToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<void> clearAllData() async {
    try {
      await userBox.clear();
      await tokenBox.clear();
    } catch (e) {
      throw const CacheFailure('Failed to clear Hive data');
    }
  }
}