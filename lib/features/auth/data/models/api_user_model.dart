import 'package:json_annotation/json_annotation.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';

part 'api_user_model.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ApiUserModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String email;
  final String? bio;
  final String? avatar;
  final List<String>? likes;
  final List<String>? followers;
  @JsonKey(includeToJson: false)
  final String? token;
  @JsonKey(defaultValue: false)
  final bool hasCompletedProfile;

  const ApiUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
    this.avatar,
    this.likes,
    this.followers,
    this.token,
    this.hasCompletedProfile = false,
  });

  factory ApiUserModel.fromJson(Map<String, dynamic> json) =>
      _$ApiUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiUserModelToJson(this);

  // Convert API model to domain entity
  UserEntity toEntity({String? password}) {
    return UserEntity(
      id: id,
      email: email,
      username: name,
      token: token,
      password: password, // Password is required in UserEntity
      hasCompletedProfile: hasCompletedProfile, // Use the existing value
    );
  }
}
