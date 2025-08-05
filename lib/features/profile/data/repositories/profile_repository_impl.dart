import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/profile/data/datasources/local_datasource/profile_local_datasource.dart';
import 'package:ilike/features/profile/data/datasources/remote_datasource/profile_remote_datasource.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';
import 'dart:io';

class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileLocalDataSource localDataSource;
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, ProfileEntity?>> getProfile() async {
    try {
      // First try to get from cache
      final cachedProfile = await localDataSource.getCachedProfile();

      // Try to get from remote
      try {
        final remoteProfile = await remoteDataSource.getProfile('');
        if (remoteProfile != null) {
          // Update cache with latest data
          await localDataSource.cacheProfile(remoteProfile);
          return Right(remoteProfile.toEntity());
        }
      } catch (e) {
        print('[ProfileRepository] Failed to fetch from remote: $e');

        // If it's a 404, return null to indicate no profile exists
        if (e.toString().contains('404')) {
          print('[ProfileRepository] Profile not found (404)');
          // Clear any cached profile since server says none exists
          await localDataSource.clearProfile();
          return const Right(null);
        }

        // For other errors, if we have cache, return cache
        if (cachedProfile != null) {
          return Right(cachedProfile.toEntity());
        }
      }

      // If both remote and cache fail
      return const Left(ServerFailure('Failed to get profile'));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, String?>> saveProfile(ProfileEntity profile) async {
    final profileModel = ProfileModel.fromEntity(profile);

    try {
      // Debug log the profile data
      print('[ProfileRepository] Saving profile data:');
      print('Name: ${profileModel.name}');
      print('Gender: ${profileModel.gender}');
      print('Location: ${profileModel.location}');
      print('Intentions: ${profileModel.intentions}');
      print('Age: ${profileModel.age}');
      print('Bio: ${profileModel.bio}');
      print('Interests: ${profileModel.interests}');
      print('Height: ${profileModel.height}');
      print('PhotoUrls: ${profileModel.photoUrls}');
      print('Full JSON: ${profileModel.toJson()}');

      // Save to remote first
      final response = await remoteDataSource.createProfile(profileModel);

      // Extract new token if provided
      String? newToken;
      if (response['token'] != null) {
        newToken = response['token'] as String;
        print('[ProfileRepository] Received new token: $newToken');
      }

      // Then cache locally
      await localDataSource.cacheProfile(profileModel);
      return Right(newToken);
    } catch (e) {
      print('[ProfileRepository] Failed to save profile: $e');
      // If remote fails, at least cache locally
      await localDataSource.cacheProfile(profileModel);
      return Left(ServerFailure('Failed to save profile'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(ProfileEntity profile) async {
    final profileModel = ProfileModel.fromEntity(
      profile.copyWith(updatedAt: DateTime.now()),
    );

    try {
      // Update remote first
      await remoteDataSource.updateProfile(profileModel);

      // Then update cache
      await localDataSource.cacheProfile(profileModel);
      return Right(null);
    } catch (e) {
      // If remote fails, at least update cache
      await localDataSource.cacheProfile(profileModel);
      return Left(ServerFailure('Failed to update profile'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfile() async {
    try {
      // Delete from remote first
      await remoteDataSource.deleteProfile('');

      // Then clear cache
      await localDataSource.clearProfile();
      return Right(null);
    } catch (e) {
      // If remote fails, still clear cache
      await localDataSource.clearProfile();
      return Left(ServerFailure('Failed to delete profile'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadPhoto(String imagePath) async {
    try {
      // Remove file:// prefix if present
      final path =
          imagePath.startsWith('file://') ? imagePath.substring(7) : imagePath;

      final file = File(path);
      final photoUrl = await remoteDataSource.uploadPhoto(file);
      return Right(photoUrl);
    } catch (e) {
      print('[ProfileRepository] Upload failed: $e');
      return Left(NetworkFailure('Failed to upload photo'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePhoto(String photoUrl) async {
    try {
      await remoteDataSource.deletePhoto(photoUrl);
      return Right(null);
    } catch (e) {
      // Log error but don't fail the operation
      print('Failed to delete photo: $e');
      return Left(ServerFailure('Failed to delete photo'));
    }
  }
}
