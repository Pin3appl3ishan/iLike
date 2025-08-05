import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/profile_entity.dart';

part 'profile_model.g.dart';

@JsonSerializable(
  createToJson: true,
  includeIfNull: false,
  explicitToJson: true,
)
class ProfileModel extends ProfileEntity {
  @JsonKey(includeFromJson: true, includeToJson: false)
  final String? id;

  @JsonKey(required: true)
  final String name;

  @JsonKey(required: true)
  final String gender;

  @JsonKey(required: true)
  final String location;

  @JsonKey(required: true)
  final List<String> intentions;

  @JsonKey(required: true)
  final int age;

  @JsonKey(required: true)
  final String bio;

  @JsonKey(required: true)
  final List<String> interests;

  @JsonKey(required: true)
  final String height;

  @JsonKey(required: true)
  final List<String> photoUrls;

  @JsonKey(defaultValue: '')
  final String? profilePicture;

  @JsonKey(includeFromJson: true, includeToJson: false)
  final DateTime? createdAt;

  @JsonKey(includeFromJson: true, includeToJson: false)
  final DateTime? updatedAt;

  @JsonKey(defaultValue: true)
  final bool? isProfileComplete;

  const ProfileModel({
    this.id,
    required this.name,
    required this.gender,
    required this.location,
    required this.intentions,
    required this.age,
    required this.bio,
    required this.interests,
    required this.height,
    required this.photoUrls,
    this.profilePicture,
    this.createdAt,
    this.updatedAt,
    this.isProfileComplete,
  }) : super(
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
          profilePicture: profilePicture,
          createdAt: createdAt,
          updatedAt: updatedAt,
          isProfileComplete: isProfileComplete,
        );

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  ProfileModel copyWith({
    String? id,
    String? name,
    String? gender,
    String? location,
    List<String>? intentions,
    int? age,
    String? bio,
    List<String>? interests,
    String? height,
    List<String>? photoUrls,
    String? profilePicture,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isProfileComplete,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      intentions: intentions ?? this.intentions,
      age: age ?? this.age,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      height: height ?? this.height,
      photoUrls: photoUrls ?? this.photoUrls,
      profilePicture: profilePicture ?? this.profilePicture,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }

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
      profilePicture: entity.profilePicture,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isProfileComplete: entity.isProfileComplete,
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
      profilePicture: profilePicture,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isProfileComplete: isProfileComplete,
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
    required String profilePicture,
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
      profilePicture: profilePicture,
      isProfileComplete: true,
    );
  }
}
