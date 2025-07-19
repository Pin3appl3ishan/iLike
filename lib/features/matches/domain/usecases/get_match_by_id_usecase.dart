import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/core/usecase/usecase.dart';
import 'package:ilike/features/matches/domain/entities/match_entity.dart';
import 'package:ilike/features/matches/domain/repositories/match_repository.dart';

class GetMatchByIdUseCase implements UsecaseWithParams<MatchEntity, String> {
  final MatchRepository repository;

  GetMatchByIdUseCase(this.repository);

  @override
  Future<Either<Failure, MatchEntity>> call(String matchId) async {
    return await repository.getMatchById(matchId);
  }
}
