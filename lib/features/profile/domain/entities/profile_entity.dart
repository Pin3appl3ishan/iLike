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
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
    this.createdAt,
    this.updatedAt,
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
    DateTime? createdAt,
    DateTime? updatedAt,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
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
    createdAt,
    updatedAt,
  ];
}
