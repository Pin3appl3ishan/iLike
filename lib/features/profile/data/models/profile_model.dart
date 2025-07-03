import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/profile_entity.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel extends ProfileEntity {
  const ProfileModel({
    super.id,
    required super.name,
    required super.gender,
    required super.location,
    required super.intentions,
    required super.age,
    required super.bio,
    required super.interests,
    required super.height,
    required super.photoUrls,
    super.createdAt,
    super.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      name: entity.name,
      gender: entity.gender,
      location: entity.location,
      intentions: entity.intentions,
      age: entity.age,
      bio: entity.bio,
      interests: entity.interests,
      height: entity.height,
      photoUrls: entity.photoUrls,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      name: name,
      gender: gender,
      location: location,
      intentions: intentions,
      age: age,
      bio: bio,
      interests: interests,
      height: height,
      photoUrls: photoUrls,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // For onboarding data conversion
  factory ProfileModel.fromOnboardingData({
    required String name,
    required String gender,  
    required String location,
    required List<String> intentions,
    required int age,
    required String bio,
    required List<String> interests,
    required String height,
    List<String> photoUrls = const [],
  }) {
    return ProfileModel(
      name: name,
      gender: gender,
      location: location,
      intentions: intentions,
      age: age,
      bio: bio,
      interests: interests,
      height: height,
      photoUrls: photoUrls,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}