class PotentialMatchEntity {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String location;
  final String bio;
  final List<String> photoUrls;
  final List<String> interests;
  final List<String> intentions;
  final String height;

  const PotentialMatchEntity({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.location,
    required this.bio,
    required this.photoUrls,
    required this.interests,
    required this.intentions,
    required this.height,
  });

  PotentialMatchEntity copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? location,
    String? bio,
    List<String>? photoUrls,
    List<String>? interests,
    List<String>? intentions,
    String? height,
  }) {
    return PotentialMatchEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      photoUrls: photoUrls ?? this.photoUrls,
      interests: interests ?? this.interests,
      intentions: intentions ?? this.intentions,
      height: height ?? this.height,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'location': location,
      'bio': bio,
      'photoUrls': photoUrls,
      'interests': interests,
      'intentions': intentions,
      'height': height,
    };
  }

  factory PotentialMatchEntity.fromJson(Map<String, dynamic> json) {
    return PotentialMatchEntity(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      location: json['location'] ?? '',
      bio: json['bio'] ?? '',
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      interests: List<String>.from(json['interests'] ?? []),
      intentions: List<String>.from(json['intentions'] ?? []),
      height: json['height'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PotentialMatchEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
