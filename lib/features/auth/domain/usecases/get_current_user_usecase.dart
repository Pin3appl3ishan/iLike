import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';
import 'package:ilike/features/auth/domain/repositories/auth_repository.dart';

/// Use case for retrieving the currently authenticated user
class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  /// Retrieves the currently authenticated user
  /// 
  /// Returns [UserEntity] if a user is authenticated
  /// Returns [Failure] if no user is authenticated or an error occurs
  Future<Either<Failure, UserEntity>> call() async {
    try {
      final result = await repository.getCurrentUser();
      return result;
    } catch (e) {
      return Left(ServerFailure('Failed to get current user'));
    }
  }
}
