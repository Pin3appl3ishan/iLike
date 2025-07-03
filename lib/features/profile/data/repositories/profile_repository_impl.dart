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
      if (cachedProfile != null) {
        return Right(cachedProfile.toEntity());
      }

      // If not in cache, get from remote
      // final remoteProfile = await remoteDataSource.getProfile(userId);
      // if (remoteProfile != null) {
      //   await localDataSource.cacheProfile(remoteProfile);
      //   return remoteProfile.toEntity();
      // }

      return Left(CacheFailure('Failed to get profile'));
    } catch (e) {
      // Fallback to cache only
      final cachedProfile = await localDataSource.getCachedProfile();
      return Right(cachedProfile?.toEntity());
    }
  }

  @override
  Future<Either<Failure, void>> saveProfile(ProfileEntity profile) async {
    final profileModel = ProfileModel.fromEntity(profile);

    try {
      // Save to remote first
      await remoteDataSource.createProfile(profileModel);

      // Then cache locally
      await localDataSource.cacheProfile(profileModel);
      return Right(null);
    } catch (e) {
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
      final file = File(imagePath);
      final photoUrl = await remoteDataSource.uploadPhoto(file);
      return Right(photoUrl);
    } catch (e) {
      // For now, return local path as fallback
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
