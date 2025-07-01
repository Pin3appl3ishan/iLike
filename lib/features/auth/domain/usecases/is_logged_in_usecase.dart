import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/core/usecase/usecase.dart';
import 'package:ilike/features/auth/domain/repositories/auth_repository.dart';

/// Use case for checking if a user is currently logged in
class IsLoggedInUseCase implements UsecaseWithoutParams<bool> {
  final IAuthRepository repository;

  IsLoggedInUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call() async {
    return await repository.isLoggedIn();
  }
}
