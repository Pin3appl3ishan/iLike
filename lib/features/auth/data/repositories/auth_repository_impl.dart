import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/auth/data/repositories/remote_repository/auth_remote_repository.dart';
import 'package:ilike/features/auth/data/repositories/local_repository/auth_local_repository.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';
import 'package:ilike/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteRepository remoteRepository;
  final AuthLocalRepository localRepository;

  AuthRepositoryImpl({
    required this.remoteRepository,
    required this.localRepository,
  });

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    final result = await remoteRepository.login(email, password);

    // if login is success, cache user in local storage
    return await result.fold((failure) async => Left(failure), (user) async {
      await localRepository.cacheUser(user);
      if (user.token != null) {
        await localRepository.cacheAuthToken(user.token!);
      }
      return Right(user);
    });
  }

  @override
  Future<Either<Failure, void>> logout() async {
    // Get the current token
    final tokenResult = await localRepository.getAuthToken();

    // Try to logout from the server if we have a token
    await tokenResult.fold((failure) => Future.value(null), (token) async {
      if (token != null) {
        await remoteRepository.logout(token);
      }
    });

    // Clear local data in any case
    await localRepository.clearCachedUser();
    return const Right(null);
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    String name,
    String email,
    String password,
  ) async {
    final result = await remoteRepository.register(name, email, password);

    // if register is success, cache user in local storage
    return await result.fold((failure) async => Left(failure), (user) async {
      await localRepository.cacheUser(user);
      if (user.token != null) {
        await localRepository.cacheAuthToken(user.token!);
      }
      return Right(user);
    });
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    // Get the token from local storage first
    final tokenResult = await localRepository.getAuthToken();

    return await tokenResult.fold((failure) => Left(failure), (token) async {
      if (token == null) {
        return Left(CacheFailure('No authentication token found'));
      }

      final result = await remoteRepository.getCurrentUser(token);

      // if get current user is successful, cache user in local storage
      return await result.fold((failure) => Left(failure), (user) async {
        await localRepository.cacheUser(user);
        if (user.token != null) {
          await localRepository.cacheAuthToken(user.token!);
        }
        return Right(user);
      });
    });
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    return await localRepository.isUserLoggedIn();
  }
}
