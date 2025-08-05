import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String? id;
  final String name;
  final String gender;
  final String location;
  final List<String> intentions;
  final int age;
  final String bio;
  final List<String> interests;
  final String height;
  final List<String> photoUrls;
  final String? profilePicture;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isProfileComplete;

  const ProfileEntity({
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
  });

  ProfileEntity copyWith({
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
    return ProfileEntity(
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'location': location,
      'intentions': intentions,
      'age': age,
      'bio': bio,
      'interests': interests,
      'height': height,
      'photoUrls': photoUrls,
      'profilePicture': profilePicture,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isProfileComplete': isProfileComplete,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    gender,
    location,
    intentions,
    age,
    bio,
    interests,
    height,
    photoUrls,
    profilePicture,
    createdAt,
    updatedAt,
    isProfileComplete,
  ];
}
