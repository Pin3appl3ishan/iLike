import 'dart:io';
import 'package:ilike/features/profile/data/models/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

/// All profile-related REST calls live here. The implementation relies on a
/// [Dio] instance that already has the base-url, interceptors and (optionally)
/// authentication headers configured by the service-locator.
abstract interface class ProfileRemoteDataSource {
  Future<ProfileModel?> getProfile(String userId);

  Future<Map<String, dynamic>> createProfile(ProfileModel profile);

  Future<void> updateProfile(ProfileModel profile);

  Future<void> deleteProfile(String userId);

  Future<String> uploadPhoto(File imageFile);

  Future<String> uploadProfilePicture(File imageFile);

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
  Future<Map<String, dynamic>> createProfile(ProfileModel profile) async {
    // Photos are already uploaded individually, so just send profile data as JSON
    final response =
        await dio.post('$_profileBase/setup', data: profile.toJson());

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      return data;
    }

    throw Exception('Invalid response from profile setup');
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
    try {
      // Ensure we have a filename with extension
      String filename = imageFile.path.split('/').last;
      if (!filename.contains('.')) {
        filename = '$filename.png'; // Assume PNG for screenshots
      }

      print('[ProfileRemoteDataSource] Uploading file: $filename');
      print('[ProfileRemoteDataSource] File path: ${imageFile.path}');

      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          imageFile.path,
          filename: filename,
          contentType: MediaType('image', 'png'), // Explicitly set content type
        ),
      });

      // Use the individual upload endpoint for photo uploads during onboarding
      final response = await dio.post('$_profileBase/upload', data: formData);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true && data['url'] != null) {
          final String relativeUrl = data['url'] as String;
          // Use the base URL from Dio configuration instead of hardcoding
          final baseUrl = dio.options.baseUrl.replaceAll('/api', '');
          return '$baseUrl$relativeUrl';
        }
      }
      throw Exception('Invalid response format');
    } catch (e) {
      print('[ProfileRemoteDataSource] Failed to upload photo: $e');
      rethrow; // Let the caller handle the error
    }
  }

  @override
  Future<String> uploadProfilePicture(File imageFile) async {
    try {
      // Ensure we have a filename with extension
      String filename = imageFile.path.split('/').last;
      if (!filename.contains('.')) {
        filename = '$filename.png'; // Assume PNG for screenshots
      }

      print('[ProfileRemoteDataSource] Uploading profile picture: $filename');
      print('[ProfileRemoteDataSource] File path: ${imageFile.path}');

      final formData = FormData.fromMap({
        'profilePicture': await MultipartFile.fromFile(
          imageFile.path,
          filename: filename,
          contentType: MediaType('image', 'png'),
        ),
      });

      final response = await dio.put('$_profileBase/picture', data: formData);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true && data['data'] != null) {
          final String relativeUrl =
              data['data']['profilePictureUrl'] as String;
          // Use the base URL from Dio configuration instead of hardcoding
          final baseUrl = dio.options.baseUrl.replaceAll('/api', '');
          return '$baseUrl$relativeUrl';
        }
      }
      throw Exception('Invalid response format');
    } catch (e) {
      print('[ProfileRemoteDataSource] Failed to upload profile picture: $e');
      rethrow;
    }
  }

  @override
  Future<void> deletePhoto(String photoUrl) async {
    await dio.delete('$_profileBase/photo', data: {'url': photoUrl});
  }
}
