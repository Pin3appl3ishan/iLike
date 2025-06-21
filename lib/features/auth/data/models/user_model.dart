import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
)
class UserModel extends UserEntity with EquatableMixin {
  @HiveField(0)
  String get idField => id;
  
  @HiveField(1)
  String get emailField => email;
  
  @HiveField(2)
  String? get nameField => name;
  
  @HiveField(3)
  String? get tokenField => token;

  const UserModel._({
    required super.id,
    required super.email,
    super.name,
    super.token,
  });
        
  factory UserModel({
    required String id,
    required String email,
    String? name,
    String? token,
  }) => UserModel._(
    id: id,
    email: email,
    name: name,
    token: token,
  );
  
  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        email: entity.email,
        name: entity.name,
        token: entity.token,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => 
      UserModel(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String?,
        token: json['token'] as String?,
      );
      
  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'token': token,
      };
  
  @override
  List<Object?> get props => [id, email, name, token];
  
  @override
  bool? get stringify => true;
  
  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        name: name,
        token: token,
      );

}
