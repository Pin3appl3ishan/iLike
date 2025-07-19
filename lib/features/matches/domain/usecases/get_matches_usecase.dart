import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/core/usecase/usecase.dart';
import 'package:ilike/features/matches/domain/entities/match_entity.dart';
import 'package:ilike/features/matches/domain/repositories/match_repository.dart';

class GetMatchesUseCase implements UsecaseWithoutParams<List<MatchEntity>> {
  final MatchRepository repository;

  GetMatchesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MatchEntity>>> call() async {
    return await repository.getMatches();
  }
}
