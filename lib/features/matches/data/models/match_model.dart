import 'package:ilike/features/matches/domain/entities/match_entity.dart';

class MatchModel extends MatchEntity {
  const MatchModel({
    required super.matchId,
    required super.matchedAt,
    required super.user,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      matchId: json['matchId'] ?? '',
      matchedAt: DateTime.parse(
        json['matchedAt'] ?? DateTime.now().toIso8601String(),
      ),
      user: MatchUserModel.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'matchedAt': matchedAt.toIso8601String(),
      'user': (user as MatchUserModel).toJson(),
    };
  }
}

class MatchUserModel extends MatchUserEntity {
  const MatchUserModel({
    required super.id,
    required super.name,
    super.age,
    super.gender,
    super.location,
    required super.photoUrls,
    super.bio,
    required super.interests,
  });

  factory MatchUserModel.fromJson(Map<String, dynamic> json) {
    return MatchUserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      age: json['age'],
      gender: json['gender'],
      location: json['location'],
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      bio: json['bio'],
      interests: List<String>.from(json['interests'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'location': location,
      'photoUrls': photoUrls,
      'bio': bio,
      'interests': interests,
    };
  }
}
