// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiUserModel _$ApiUserModelFromJson(Map<String, dynamic> json) => ApiUserModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String?,
      avatar: json['avatar'] as String?,
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      followers: (json['followers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      token: json['token'] as String?,
      hasCompletedProfile: json['hasCompletedProfile'] as bool? ?? false,
    );

Map<String, dynamic> _$ApiUserModelToJson(ApiUserModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      if (instance.bio case final value?) 'bio': value,
      if (instance.avatar case final value?) 'avatar': value,
      if (instance.likes case final value?) 'likes': value,
      if (instance.followers case final value?) 'followers': value,
      'hasCompletedProfile': instance.hasCompletedProfile,
    };
