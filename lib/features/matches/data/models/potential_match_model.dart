import 'package:ilike/features/matches/domain/entities/potential_match_entity.dart';

class PotentialMatchModel extends PotentialMatchEntity {
  const PotentialMatchModel({
    required super.id,
    required super.name,
    required super.age,
    required super.gender,
    required super.location,
    required super.bio,
    required super.photoUrls,
    required super.interests,
    required super.intentions,
    required super.height,
    super.profilePicture,
  });

  factory PotentialMatchModel.fromJson(Map<String, dynamic> json) {
    return PotentialMatchModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      location: json['location'] ?? '',
      bio: json['bio'] ?? '',
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      interests: List<String>.from(json['interests'] ?? []),
      intentions: List<String>.from(json['intentions'] ?? []),
      height: json['height'] ?? '',
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'location': location,
      'bio': bio,
      'photoUrls': photoUrls,
      'interests': interests,
      'intentions': intentions,
      'height': height,
      'profilePicture': profilePicture,
    };
  }
}
