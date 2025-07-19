import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/core/usecase/usecase.dart';
import 'package:ilike/features/matches/domain/repositories/match_repository.dart';

class LikeUserUseCase implements UsecaseWithParams<bool, String> {
  final MatchRepository repository;

  LikeUserUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String userId) async {
    return await repository.likeUser(userId);
  }
}
