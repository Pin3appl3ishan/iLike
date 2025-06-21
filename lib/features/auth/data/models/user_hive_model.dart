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
  final String? name;
  
  @HiveField(3)
  final String? token;
  
  @HiveField(4)
  final String password; // Note: In a real app, never store plain passwords

  UserHiveModel({
    required this.id,
    required this.email,
    this.name,
    this.token,
    required this.password,
  });

  // Convert from Entity to Hive Model
  factory UserHiveModel.fromEntity(UserEntity entity, {required String password}) {
    return UserHiveModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      token: entity.token,
      password: password,
    );
  }

  // Convert to Entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      token: token,
    );
  }
}
