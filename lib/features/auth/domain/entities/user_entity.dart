class UserEntity {
  final String? id;
  final String email;
  final String? username;
  final String? token;
  final String? password;
  final bool? hasCompletedProfile;

  const UserEntity({
    this.id,
    required this.email,
    this.username,
    this.token,
    this.password,
    this.hasCompletedProfile,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? username,
    String? token,
    String? password,
    bool? hasCompletedProfile,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      token: token ?? this.token,
      password: password ?? this.password,
      hasCompletedProfile: hasCompletedProfile ?? this.hasCompletedProfile,
    );
  }
}
