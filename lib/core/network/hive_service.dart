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
      final appDocumentDir =
          await path_provider.getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDir.path);

      // Register adapters
      Hive.registerAdapter(UserHiveModelAdapter());

      // Open boxes
      await Future.wait([
        Hive.openBox<UserHiveModel>(_userBox),
        Hive.openBox<String>(_tokenBox),
      ]);
      print('[HiveService] Initialized successfully'); // Debug log
    } catch (e) {
      print('[HiveService] Initialization failed: $e'); // Debug log
      throw const CacheFailure('Failed to initialize Hive');
    }
  }

  static Future<void> close() async {
    try {
      await Hive.close();
      print('[HiveService] Closed successfully'); // Debug log
    } catch (e) {
      print('[HiveService] Close failed: $e'); // Debug log
      throw const CacheFailure('Failed to close Hive');
    }
  }

  static Box<UserHiveModel> get userBox => Hive.box<UserHiveModel>(_userBox);
  static Box<String> get tokenBox => Hive.box<String>(_tokenBox);

  static const String _authTokenKey = 'auth_token';

  static Future<void> cacheAuthToken(String token) async {
    try {
      await tokenBox.put(_authTokenKey, token);
      print('[HiveService] Token cached successfully: $token'); // Debug log
    } catch (e) {
      print('[HiveService] Failed to cache token: $e'); // Debug log
      throw const CacheFailure('Failed to cache auth token');
    }
  }

  static String? getAuthToken() {
    try {
      final token = tokenBox.get(_authTokenKey);
      print('[HiveService] Retrieved token: $token'); // Debug log
      return token;
    } catch (e) {
      print('[HiveService] Failed to get token: $e'); // Debug log
      throw const CacheFailure('Failed to get auth token');
    }
  }

  static Future<void> cacheUser(UserHiveModel user) async {
    try {
      await userBox.put('current_user', user);
      print(
        '[HiveService] User cached successfully: ${user.email}',
      ); // Debug log
    } catch (e) {
      print('[HiveService] Failed to cache user: $e'); // Debug log
      throw const CacheFailure('Failed to cache user');
    }
  }

  static Future<Option<UserHiveModel>> getCachedUser() async {
    try {
      final user = userBox.get('current_user');
      print('[HiveService] Retrieved user: ${user?.email}'); // Debug log
      return user != null ? optionOf(user) : none();
    } catch (e) {
      print('[HiveService] Failed to get cached user: $e'); // Debug log
      return none();
    }
  }

  static Future<void> clearCachedUser() async {
    try {
      await userBox.delete('current_user');
      await tokenBox.delete(_authTokenKey);
      print('[HiveService] Cleared cached user and token'); // Debug log
    } catch (e) {
      print('[HiveService] Failed to clear cached user: $e'); // Debug log
      throw const CacheFailure('Failed to clear cached user');
    }
  }

  static Future<bool> isUserLoggedIn() async {
    try {
      final token = getAuthToken();
      final isLoggedIn = token != null && token.isNotEmpty;
      print(
        '[HiveService] isUserLoggedIn check: $isLoggedIn (token: $token)',
      ); // Debug log
      return isLoggedIn;
    } catch (e) {
      print('[HiveService] Failed to check login status: $e'); // Debug log
      return false;
    }
  }

  static Future<void> clearAllData() async {
    try {
      await userBox.clear();
      await tokenBox.clear();
      print('[HiveService] Cleared all data'); // Debug log
    } catch (e) {
      print('[HiveService] Failed to clear all data: $e'); // Debug log
      throw const CacheFailure('Failed to clear Hive data');
    }
  }
}
