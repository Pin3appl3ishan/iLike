import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/profile/domain/entities/profile_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IProfileRepository {
  Future<Either<Failure, ProfileEntity?>> getProfile();
  Future<Either<Failure, String?>> saveProfile(ProfileEntity profile);
  Future<Either<Failure, void>> updateProfile(ProfileEntity profile);
  Future<Either<Failure, void>> deleteProfile();
  Future<Either<Failure, String>> uploadPhoto(String imagePath);
  Future<Either<Failure, void>> deletePhoto(String photoUrl);
}
