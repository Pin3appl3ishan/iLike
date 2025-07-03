import 'dart:convert';
import 'package:ilike/features/profile/data/models/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel?> getCachedProfile();
  Future<void> cacheProfile(ProfileModel profile);
  Future<void> clearProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedProfileKey = 'CACHED_PROFILE';

  ProfileLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ProfileModel?> getCachedProfile() async {
    final jsonString = sharedPreferences.getString(cachedProfileKey);
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString);
      return ProfileModel.fromJson(jsonMap);
    }
    return null;
  }

  @override
  Future<void> cacheProfile(ProfileModel profile) async {
    final jsonString = json.encode(profile.toJson());
    await sharedPreferences.setString(cachedProfileKey, jsonString);
  }

  @override
  Future<void> clearProfile() async {
    await sharedPreferences.remove(cachedProfileKey);
  }
}