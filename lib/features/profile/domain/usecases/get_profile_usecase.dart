import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final IProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, ProfileEntity?>> call() async {
    return await repository.getProfile();
  }
}
