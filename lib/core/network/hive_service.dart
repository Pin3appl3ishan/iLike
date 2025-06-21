import 'package:hive_flutter/hive_flutter.dart';
import 'package:ilike/core/constants/hive_constants.dart';
import 'package:ilike/features/auth/data/models/user_hive_model.g.dart';

class HiveService {
  static bool _isInitialized = false;
  
  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      try {
        // Initialize Hive with the app's documents directory
        await Hive.initFlutter();
        
        // Register adapters
        if (!Hive.isAdapterRegistered(0)) {
          Hive.registerAdapter(UserHiveModelAdapter());
        }
        
        // Open boxes
        await Future.wait([
          Hive.openBox<UserHiveModel>(HiveTableConstant.userBox),
          Hive.openBox<String>(HiveTableConstant.tokenBox),
        ]);
        
        _isInitialized = true;
      } catch (e) {
        throw Exception('Failed to initialize Hive: $e');
      }
    }
  }

  // User Queries
  Future<void> saveUser(UserHiveModel user) async {
    try {
      await ensureInitialized();
      final box = Hive.box<UserHiveModel>(HiveTableConstant.userBox);
      await box.put(user.id, user);
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await ensureInitialized();
      final box = Hive.box<UserHiveModel>(HiveTableConstant.userBox);
      await box.delete(id);
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  Future<UserHiveModel?> getUser(String id) async {
    try {
      await ensureInitialized();
      final box = Hive.box<UserHiveModel>(HiveTableConstant.userBox);
      return box.get(id);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<UserHiveModel?> getUserByEmail(String email) async {
    try {
      await ensureInitialized();
      final box = Hive.box<UserHiveModel>(HiveTableConstant.userBox);
      return box.values.firstWhere(
        (user) => user.email == email,
        orElse: () => null,
      );
    } catch (e) {
      throw Exception('Failed to get user by email: $e');
    }
  }

  // Clear all data (for logout)
  Future<void> clearAll() async {
    try {
      await ensureInitialized();
      await Future.wait([
        Hive.box<UserHiveModel>(HiveTableConstant.userBox).clear(),
        Hive.box<String>(HiveTableConstant.tokenBox).clear(),
      ]);
    } catch (e) {
      throw Exception('Failed to clear data: $e');
    }
  }
  
  // Save and get token
  Future<void> saveToken(String token) async {
    try {
      await ensureInitialized();
      final box = Hive.box<String>(HiveTableConstant.tokenBox);
      await box.put('auth_token', token);
    } catch (e) {
      throw Exception('Failed to save token: $e');
    }
  }
  
  Future<String?> getToken() async {
    try {
      await ensureInitialized();
      final box = Hive.box<String>(HiveTableConstant.tokenBox);
      return box.get('auth_token');
    } catch (e) {
      throw Exception('Failed to get token: $e');
    }
  }
}
