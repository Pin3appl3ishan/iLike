import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';

import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class SaveProfile {
  final IProfileRepository repository;

  SaveProfile(this.repository);

  Future<Either<Failure, String?>> call({
    required String name,
    required String gender,
    required String location,
    required List<String> intentions,
    required int age,
    required String bio,
    required List<String> interests,
    required String height,
    List<String> photoUrls = const [],
  }) async {
    try {
      // First upload all photos and get their server URLs
      final List<String> serverPhotoUrls = [];
      for (final photoPath in photoUrls) {
        if (photoPath.startsWith('/data/') || photoPath.startsWith('/cache/')) {
          // This is a local file path, upload it
          final uploadResult = await repository.uploadPhoto(photoPath);
          if (uploadResult.isRight()) {
            final url = uploadResult.getOrElse(() => '');
            if (url.isNotEmpty) {
              serverPhotoUrls.add(url);
            }
          }
        } else {
          // Already a server URL
          serverPhotoUrls.add(photoPath);
        }
      }

      // Create profile with server photo URLs
      final profile = ProfileEntity(
        name: name,
        gender: gender,
        location: location,
        intentions: intentions,
        age: age,
        bio: bio,
        interests: interests,
        height: height,
        photoUrls: serverPhotoUrls,
        isProfileComplete: true,
      );

      final result = await repository.saveProfile(profile);
      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
