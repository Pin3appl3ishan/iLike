import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';
import 'package:ilike/features/auth/domain/repositories/auth_repository.dart';
import 'package:ilike/core/usecase/usecase.dart';

/// Use case for retrieving the currently authenticated user
class GetCurrentUserUseCase implements UsecaseWithoutParams<UserEntity> {
  final IAuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getCurrentUser();
  }
}
