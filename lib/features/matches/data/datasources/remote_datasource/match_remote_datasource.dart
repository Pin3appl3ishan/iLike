import 'package:dio/dio.dart';
import 'package:ilike/core/network/api_constants.dart';
import 'package:ilike/features/matches/data/models/potential_match_model.dart';
import 'package:ilike/features/matches/data/models/match_model.dart';

/// All match-related REST calls live here. The implementation relies on a
/// [Dio] instance that already has the base-url, interceptors and (optionally)
/// authentication headers configured by the service-locator.
abstract interface class MatchRemoteDataSource {
  Future<List<PotentialMatchModel>> getPotentialMatches();
  Future<bool> likeUser(String userId);
  Future<void> dislikeUser(String userId);
  Future<List<MatchModel>> getMatches();
  Future<List<PotentialMatchModel>> getLikes();
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
  Future<void> dislikeUser(String userId) async {
    final response = await dio.delete(ApiConstants.dislikeUserEndpoint(userId));

    if (response.statusCode != 200 || response.data == null) {
      throw Exception('Failed to dislike user');
    }

    final data = response.data as Map<String, dynamic>;
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to dislike user');
    }
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
  Future<List<PotentialMatchModel>> getLikes() async {
    final response = await dio.get(ApiConstants.getLikes);

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true && data['data'] != null) {
        final List<dynamic> likesData = data['data'];
        return likesData
            .map((json) => PotentialMatchModel.fromJson(json))
            .toList();
      }
    }
    throw Exception('Failed to get likes');
  }
}
