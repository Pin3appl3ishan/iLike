// lib/core/network/hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
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

  static Future<void> clearAllData() async {
    try {
      await userBox.clear();
      await tokenBox.clear();
    } catch (e) {
      throw const CacheFailure('Failed to clear Hive data');
    }
  }
}