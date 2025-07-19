import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/entities/potential_match_entity.dart';
import '../../domain/repositories/match_repository.dart';
import '../datasources/remote_datasource/match_remote_datasource.dart';

class MatchRepositoryImpl implements MatchRepository {
  final MatchRemoteDataSource remoteDataSource;

  MatchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PotentialMatchEntity>>>
      getPotentialMatches() async {
    try {
      final matches = await remoteDataSource.getPotentialMatches();
      return Right(matches);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> likeUser(String userId) async {
    try {
      final isMatch = await remoteDataSource.likeUser(userId);
      return Right(isMatch);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> dislikeUser(String userId) async {
    try {
      final result = await remoteDataSource.dislikeUser(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<MatchEntity>>> getMatches() async {
    try {
      final matches = await remoteDataSource.getMatches();
      return Right(matches);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> checkMatch(String userId) async {
    try {
      final isMatch = await remoteDataSource.checkMatch(userId);
      return Right(isMatch);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, MatchEntity>> getMatchById(String matchId) async {
    try {
      final match = await remoteDataSource.getMatchById(matchId);
      return Right(match);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<PotentialMatchEntity>>> getLikes() async {
    try {
      final likes = await remoteDataSource.getLikes();
      return Right(likes);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<PotentialMatchEntity>>> getLikesSent() async {
    try {
      final likesSent = await remoteDataSource.getLikesSent();
      return Right(likesSent);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
