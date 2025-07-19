import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/match_entity.dart';
import '../entities/potential_match_entity.dart';

abstract class MatchRepository {
  /// Get potential matches for the current user
  Future<Either<Failure, List<PotentialMatchEntity>>> getPotentialMatches();

  /// Like a user
  Future<Either<Failure, bool>> likeUser(String userId);

  /// Dislike a user
  Future<Either<Failure, bool>> dislikeUser(String userId);

  /// Get all matches for the current user
  Future<Either<Failure, List<MatchEntity>>> getMatches();

  /// Check if it's a mutual match
  Future<Either<Failure, bool>> checkMatch(String userId);

  /// Get match by id
  Future<Either<Failure, MatchEntity>> getMatchById(String matchId);

  /// Get users who have liked the current user
  Future<Either<Failure, List<PotentialMatchEntity>>> getLikes();

  /// Get users that the current user has liked
  Future<Either<Failure, List<PotentialMatchEntity>>> getLikesSent();
}
