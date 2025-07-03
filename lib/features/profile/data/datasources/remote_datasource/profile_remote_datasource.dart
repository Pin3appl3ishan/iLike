import 'dart:io';
import 'package:ilike/features/profile/data/models/profile_model.dart';
import 'package:dio/dio.dart';

/// All profile-related REST calls live here. The implementation relies on a
/// [Dio] instance that already has the base-url, interceptors and (optionally)
/// authentication headers configured by the service-locator.
abstract interface class ProfileRemoteDataSource {
  Future<ProfileModel?> getProfile(String userId);

  Future<void> createProfile(ProfileModel profile);

  Future<void> updateProfile(ProfileModel profile);

  Future<void> deleteProfile(String userId);

  Future<String> uploadPhoto(File imageFile);

  Future<void> deletePhoto(String photoUrl);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  // All profile routes are prefixed with "/profile" in the backend
  // (full path becomes /api/profile/... thanks to Dio's baseUrl).
  static const String _profileBase = '/profile';

  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<ProfileModel?> getProfile(String userId) async {
    // The backend already exposes a dedicated endpoint for the current user
    // (GET /profile/me). If a userId is passed, fall back to that route.
    final String endpoint =
        userId.isEmpty ? '$_profileBase/me' : '$_profileBase/$userId';

    final response = await dio.get(endpoint);
    if (response.statusCode == 200 && response.data != null) {
      final data = (response.data as Map<String, dynamic>);
      // Some back-ends wrap the payload in a "data" field – handle both cases.
      final json = data['data'] ?? data;
      return ProfileModel.fromJson(json as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<void> createProfile(ProfileModel profile) async {
    await dio.post('$_profileBase/setup', data: profile.toJson());
  }

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    await dio.put('$_profileBase/update', data: profile.toJson());
  }

  @override
  Future<void> deleteProfile(String userId) async {
    await dio.delete('$_profileBase/$userId');
  }

  @override
  Future<String> uploadPhoto(File imageFile) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path),
    });
    final response = await dio.post('$_profileBase/upload', data: formData);
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      return data['url'] as String;
    }
    throw Exception('Photo upload failed');
  }

  @override
  Future<void> deletePhoto(String photoUrl) async {
    await dio.delete('$_profileBase/photo', data: {'url': photoUrl});
  }
}
