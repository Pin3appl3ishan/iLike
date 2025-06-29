import 'package:hive/hive.dart';
import 'package:ilike/features/auth/domain/entities/user_entity.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 0)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String? username;

  @HiveField(3)
  final String? token;

  @HiveField(4)
  final String password;

  UserHiveModel({
    required this.id,
    required this.email,
    this.username,
    this.token,
    required this.password,
  });

  factory UserHiveModel.fromEntity(UserEntity entity) {
    if (entity.password == null) {
      throw ArgumentError('Cannot create UserHiveModel with null password');
    }

    return UserHiveModel(
      id: entity.id ?? '',
      email: entity.email,
      username: entity.username,
      token: entity.token,
      password: entity.password!,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      username: username,
      token: token,
      password: password,
    );
  }
}
