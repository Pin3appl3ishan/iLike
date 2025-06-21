import 'package:json_annotation/json_annotation.dart';

part 'api_user_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
)
class ApiUserModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String email;
  final String? bio;
  final String? avatar;
  final List<String>? likes;
  final List<String>? followers;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? token;

  const ApiUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
    this.avatar,
    this.likes,
    this.followers,
    this.token,
  });

  factory ApiUserModel.fromJson(Map<String, dynamic> json) => 
      _$ApiUserModelFromJson(json);
      
  Map<String, dynamic> toJson() => _$ApiUserModelToJson(this);
  
  // Convert API model to domain entity
  Map<String, dynamic> toEntity() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'bio': bio,
      'avatar': avatar,
      'token': token,
    };
  }
}
