// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      gender: json['gender'] as String,
      location: json['location'] as String,
      intentions: (json['intentions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      age: (json['age'] as num).toInt(),
      bio: json['bio'] as String,
      interests:
          (json['interests'] as List<dynamic>).map((e) => e as String).toList(),
      height: json['height'] as String,
      photoUrls:
          (json['photoUrls'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'gender': instance.gender,
      'location': instance.location,
      'intentions': instance.intentions,
      'age': instance.age,
      'bio': instance.bio,
      'interests': instance.interests,
      'height': instance.height,
      'photoUrls': instance.photoUrls,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
