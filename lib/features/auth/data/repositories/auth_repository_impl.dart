import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:ilike/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:ilike/features/auth/data/models/api_user_model.dart';
import 'package:ilike/features/auth/data/models/user_hive_model.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';
import 'package:ilike/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      // Try to login remotely
      final apiUser = await remoteDataSource.login(email, password);
      
      // Convert to Hive model and save locally
      final userHiveModel = UserHiveModel(
        id: apiUser.id,
        email: apiUser.email,
        name: apiUser.name,
        token: apiUser.token,
        password: password, // Note: In a real app, use proper password hashing
      );
      
      await localDataSource.saveUser(userHiveModel);
      
      return Right(userHiveModel.toEntity());
    } on ServerException {
      return Left(ServerFailure('Server error occurred'));
    } on UnauthorizedException {
      return Left(UnauthorizedFailure('Invalid email or password'));
    } on CacheFailure {
      return Left(CacheFailure('Failed to save user data locally'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(String name, String email, String password) async {
    try {
      // Try to register remotely
      final apiUser = await remoteDataSource.register(name, email, password);
      
      // Convert to Hive model and save locally
      final userHiveModel = UserHiveModel(
        id: apiUser.id,
        email: apiUser.email,
        name: apiUser.name,
        token: apiUser.token,
        password: password, // Note: In a real app, use proper password hashing
      );
      
      await localDataSource.saveUser(userHiveModel);
      
      return Right(userHiveModel.toEntity());
    } on ServerException {
      return Left(ServerFailure('Server error occurred'));
    } on BadRequestException {
      return Left(ValidationFailure('Email already in use'));
    } on CacheFailure {
      return Left(CacheFailure('Failed to save user data locally'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearAll();
      return const Right(unit);
    } on ServerException {
      // Even if logout fails remotely, we still want to clear local data
      await localDataSource.clearAll();
      return const Right(unit);
    } on CacheFailure {
      return Left(CacheFailure('Failed to clear local data'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      // In this implementation, we consider the user logged in if we have a token
      final user = await localDataSource.getUser('current');
      return Right(user != null && user.token != null);
    } on CacheFailure {
      return Left(CacheFailure('Failed to check login status'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await localDataSource.getUser('current');
      if (user != null) {
        return Right(user.toEntity());
      } else {
        return Left(CacheFailure('No user found'));
      }
    } on CacheFailure {
      return Left(CacheFailure('Failed to get current user'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }
}
