import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/core/usecase/usecase.dart';
import 'package:ilike/features/matches/domain/repositories/match_repository.dart';

class DislikeUserUseCase implements UsecaseWithParams<void, String> {
  final MatchRepository repository;

  DislikeUserUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String userId) async {
    return await repository.dislikeUser(userId);
  }
}
