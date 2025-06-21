import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/auth/domain/repositories/auth_repository.dart';

/// Use case for checking if a user is currently logged in
class IsLoggedInUseCase {
  final AuthRepository repository;

  IsLoggedInUseCase(this.repository);

  /// Checks if a user is currently logged in
  /// 
  /// Returns [bool] indicating login status
  /// Returns [Failure] if there's an error checking the status
  Future<Either<Failure, bool>> call() async {
    try {
      final result = await repository.isLoggedIn();
      return result;
    } catch (e) {
      return Left(ServerFailure('Failed to check login status'));
    }
  }
}
