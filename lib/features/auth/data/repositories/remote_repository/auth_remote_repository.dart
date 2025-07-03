import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/exceptions.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';

abstract interface class AuthRemoteRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> register(
    String name,
    String email,
    String password,
  );
  Future<Either<Failure, void>> logout(String token);
  Future<Either<Failure, UserEntity>> getCurrentUser(String token);
  Future<Either<Failure, void>> refreshToken(String refreshToken);
}

class AuthRemoteRepositoryImpl implements AuthRemoteRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRemoteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final user = await remoteDataSource.login(email, password);
      // Convert ApiUserModel to UserEntity using the model's toEntity method
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on UnauthorizedException {
      return const Left(UnauthorizedFailure('Invalid email or password'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final user = await remoteDataSource.register(name, email, password);
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on ValidationException catch (e) {
      final Map<String, String> stringErrors = (e.errors ?? {}).map(
        (key, value) => MapEntry(key, value.toString()),
      );
      return Left(ValidationFailure(e.message, stringErrors));  
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> logout(String token) async {
    try {
      await remoteDataSource.logout(token);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser(String token) async {
    try {
      final user = await remoteDataSource.getCurrentUser(token);
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on UnauthorizedException {
      return const Left(
        UnauthorizedFailure('Session expired. Please log in again.'),
      );
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> refreshToken(String refreshToken) async {
    try {
      await remoteDataSource.refreshToken(refreshToken);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on UnauthorizedException {
      return const Left(UnauthorizedFailure('Invalid refresh token'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }
}
