import 'package:dio/dio.dart';
import 'package:ilike/core/network/api_constants.dart';
import 'package:ilike/features/matches/data/models/match_model.dart';
import 'package:ilike/features/matches/data/models/potential_match_model.dart';

abstract class MatchRemoteDataSource {
  /// Get potential matches for the current user
  /// Throws a ServerException for all error codes
  Future<List<PotentialMatchModel>> getPotentialMatches();

  /// Like a user
  /// Returns true if it's a mutual match
  /// Throws a ServerException for all error codes
  Future<bool> likeUser(String userId);

  /// Dislike a user
  /// Throws a ServerException for all error codes
  Future<bool> dislikeUser(String userId);

  /// Get all matches for the current user
  /// Throws a ServerException for all error codes
  Future<List<MatchModel>> getMatches();

  /// Check if it's a mutual match
  /// Throws a ServerException for all error codes
  Future<bool> checkMatch(String userId);

  /// Get match by id
  /// Throws a ServerException for all error codes
  Future<MatchModel> getMatchById(String matchId);

  /// Get users who have liked the current user
  /// Throws a ServerException for all error codes
  Future<List<PotentialMatchModel>> getLikes();

  /// Get users that the current user has liked
  /// Throws a ServerException for all error codes
  Future<List<PotentialMatchModel>> getLikesSent();
}

class MatchRemoteDataSourceImpl implements MatchRemoteDataSource {
  final Dio dio;

  MatchRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PotentialMatchModel>> getPotentialMatches() async {
    final response = await dio.get(ApiConstants.getPotentialMatches);

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true && data['data'] != null) {
        final List<dynamic> matchesData = data['data'];
        return matchesData
            .map((json) => PotentialMatchModel.fromJson(json))
            .toList();
      }
    }
    throw Exception('Failed to get potential matches');
  }

  @override
  Future<bool> likeUser(String userId) async {
    final response = await dio.post(ApiConstants.likeUserEndpoint(userId));

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true) {
        return data['isMatch'] ?? false;
      }
    }
    throw Exception('Failed to like user');
  }

  @override
  Future<bool> dislikeUser(String userId) async {
    final response = await dio.delete(ApiConstants.dislikeUserEndpoint(userId));

    if (response.statusCode != 200 || response.data == null) {
      throw Exception('Failed to dislike user');
    }

    final data = response.data as Map<String, dynamic>;
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to dislike user');
    }
    return true;
  }

  @override
  Future<List<MatchModel>> getMatches() async {
    final response = await dio.get(ApiConstants.getMatches);

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true && data['data'] != null) {
        final List<dynamic> matchesData = data['data'];
        return matchesData.map((json) => MatchModel.fromJson(json)).toList();
      }
    }
    throw Exception('Failed to get matches');
  }

  @override
  Future<bool> checkMatch(String userId) async {
    final response = await dio.get(ApiConstants.checkMatchEndpoint(userId));

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true) {
        return data['isMatch'] ?? false;
      }
    }
    throw Exception('Failed to check match');
  }

  @override
  Future<MatchModel> getMatchById(String matchId) async {
    final response = await dio.get(ApiConstants.getMatchByIdEndpoint(matchId));

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true && data['data'] != null) {
        return MatchModel.fromJson(data['data']);
      }
    }
    throw Exception('Failed to get match by id');
  }

  @override
  Future<List<PotentialMatchModel>> getLikes() async {
    final response = await dio.get(ApiConstants.getLikes);

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true && data['data'] != null) {
        final List<dynamic> likesData = data['data'];
        return likesData
            .map((json) => PotentialMatchModel.fromJson(json['user']))
            .toList();
      }
    }
    throw Exception('Failed to get likes');
  }

  @override
  Future<List<PotentialMatchModel>> getLikesSent() async {
    final response = await dio.get(ApiConstants.likesSent);

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true && data['data'] != null) {
        final List<dynamic> likesSentData = data['data'];
        return likesSentData
            .map((json) => PotentialMatchModel.fromJson(json['user']))
            .toList();
      }
    }
    throw Exception('Failed to get likes sent');
  }
}
