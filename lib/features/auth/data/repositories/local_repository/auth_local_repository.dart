import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:ilike/features/auth/data/models/user_hive_model.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';

abstract interface class AuthLocalRepository {
   // User related methods
  Future<Either<Failure, void>> cacheUser(UserEntity user);
  Future<Either<Failure, UserEntity?>> getCachedUser();
  Future<Either<Failure, void>> clearCachedUser();
  
  // Auth related methods
  Future<Either<Failure, void>> cacheAuthToken(String token);
  Future<Either<Failure, String?>> getAuthToken();
  Future<Either<Failure, bool>> isUserLoggedIn();
}

class AuthLocalRepositoryImpl implements AuthLocalRepository {
  final AuthLocalDataSource localDataSource;

  AuthLocalRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> cacheAuthToken(String token) async {
    try {
      await localDataSource.cacheAuthToken(token);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to cache auth token: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> cacheUser(UserEntity user) async {
    try {
      await localDataSource.cacheUser(UserHiveModel.fromEntity(user));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to cache user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCachedUser() async {
    try {
      await localDataSource.clearCachedUser();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear cached user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String?>> getAuthToken() async {
    try {
      final token = await localDataSource.getAuthToken();
      return token.fold(() => const Right(null), (token) => Right(token));
    } catch (e) {
      return Left(CacheFailure('Failed to get auth token: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCachedUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return user.fold(() => const Right(null), (user) => Right(user.toEntity()));
    } catch (e) {
      return Left(CacheFailure('Failed to get cached user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isUserLoggedIn() async {
    try {
      final isLoggedIn = await localDataSource.isUserLoggedIn();
      return Right(isLoggedIn);
    } catch (e) {
      return Left(CacheFailure('Failed to check if user is logged in: ${e.toString()}'));
    }
  }
}
