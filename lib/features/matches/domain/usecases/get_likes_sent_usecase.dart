import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/core/usecase/usecase.dart';
import 'package:ilike/features/matches/domain/entities/potential_match_entity.dart';
import 'package:ilike/features/matches/domain/repositories/match_repository.dart';

class GetLikesSentUseCase
    implements UsecaseWithoutParams<List<PotentialMatchEntity>> {
  final MatchRepository repository;

  GetLikesSentUseCase(this.repository);

  @override
  Future<Either<Failure, List<PotentialMatchEntity>>> call() async {
    return await repository.getLikesSent();
  }
}
