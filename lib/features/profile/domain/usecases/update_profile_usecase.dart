import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final IProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, void>> call(ProfileEntity profile) async {
    return await repository.updateProfile(profile);
  }
}
