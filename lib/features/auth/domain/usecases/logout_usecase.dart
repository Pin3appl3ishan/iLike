import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/core/usecase/usecase.dart';
import 'package:ilike/features/auth/domain/repositories/auth_repository.dart';

/// Use case for handling user logout
class LogoutUseCase implements UsecaseWithoutParams<Unit> {
  final IAuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call() async {
    final result = await repository.logout(); // returns Either<Failure, void>
    return result.map((_) => unit); // safely convert to Either<Failure, Unit>
  }
}
