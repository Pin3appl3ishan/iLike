class MatchEntity {
  final String matchId;
  final DateTime matchedAt;
  final MatchUserEntity user;

  const MatchEntity({
    required this.matchId,
    required this.matchedAt,
    required this.user,
  });

  MatchEntity copyWith({
    String? matchId,
    DateTime? matchedAt,
    MatchUserEntity? user,
  }) {
    return MatchEntity(
      matchId: matchId ?? this.matchId,
      matchedAt: matchedAt ?? this.matchedAt,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'matchedAt': matchedAt.toIso8601String(),
      'user': user.toJson(),
    };
  }

  factory MatchEntity.fromJson(Map<String, dynamic> json) {
    return MatchEntity(
      matchId: json['matchId'] ?? '',
      matchedAt: DateTime.parse(
        json['matchedAt'] ?? DateTime.now().toIso8601String(),
      ),
      user: MatchUserEntity.fromJson(json['user'] ?? {}),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MatchEntity && other.matchId == matchId;
  }

  @override
  int get hashCode => matchId.hashCode;
}

class MatchUserEntity {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String location;
  final List<String> photoUrls;
  final String bio;
  final List<String> interests;
  final String? profilePicture;

  const MatchUserEntity({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.location,
    required this.photoUrls,
    required this.bio,
    required this.interests,
    this.profilePicture,
  });

  MatchUserEntity copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? location,
    List<String>? photoUrls,
    String? bio,
    List<String>? interests,
    String? profilePicture,
  }) {
    return MatchUserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      photoUrls: photoUrls ?? this.photoUrls,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'location': location,
      'photoUrls': photoUrls,
      'bio': bio,
      'interests': interests,
      'profilePicture': profilePicture,
    };
  }

  factory MatchUserEntity.fromJson(Map<String, dynamic> json) {
    return MatchUserEntity(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      location: json['location'] ?? '',
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      bio: json['bio'] ?? '',
      interests: List<String>.from(json['interests'] ?? []),
      profilePicture: json['profilePicture'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MatchUserEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
