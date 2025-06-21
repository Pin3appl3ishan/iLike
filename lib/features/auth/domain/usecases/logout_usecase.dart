import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/auth/domain/repositories/auth_repository.dart';

/// Use case for handling user logout
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  /// Executes the logout use case
  /// 
  /// Returns [Unit] if logout is successful
  /// Returns [Failure] if logout fails
  Future<Either<Failure, Unit>> call() async {
    try {
      final result = await repository.logout();
      return result.fold(
        (failure) => Left(failure),
        (_) => const Right(unit),
      );
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred during logout'));
    }
  }
}
