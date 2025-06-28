class UserEntity {
  final String? id;
  final String email;
  final String? username;
  final String? token;
  final String password;

  const UserEntity({
    this.id,
    required this.email,
    this.username,
    this.token,
    required this.password,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? username,
    String? token,
    String? password,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      token: token ?? this.token,
      password: password ?? this.password,
    );
  }
}
