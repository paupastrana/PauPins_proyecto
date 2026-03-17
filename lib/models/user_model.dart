class User {
  final String id;
  final String email;
  final String username;
  final String? firstName;
  final String? lastName;
  final String? bio;
  final String? profileImageUrl;
  final String? coverImageUrl;
  final bool isVerified;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLogin;
  final int followersCount;
  final int followingCount;
  final int pinsCount;
  final bool isFollowing;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.firstName,
    this.lastName,
    this.bio,
    this.profileImageUrl,
    this.coverImageUrl,
    this.isVerified = false,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.lastLogin,
    this.followersCount = 0,
    this.followingCount = 0,
    this.pinsCount = 0,
    this.isFollowing = false,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      bio: json['bio'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      coverImageUrl: json['cover_image_url'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastLogin: json['last_login'] != null ? DateTime.parse(json['last_login'] as String) : null,
      followersCount: json['followers_count'] as int? ?? 0,
      followingCount: json['following_count'] as int? ?? 0,
      pinsCount: json['pins_count'] as int? ?? 0,
      isFollowing: json['is_following'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'bio': bio,
      'profile_image_url': profileImageUrl,
      'cover_image_url': coverImageUrl,
      'is_verified': isVerified,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
      'followers_count': followersCount,
      'following_count': followingCount,
      'pins_count': pinsCount,
      'is_following': isFollowing,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    String? bio,
    String? profileImageUrl,
    String? coverImageUrl,
    bool? isVerified,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
    int? followersCount,
    int? followingCount,
    int? pinsCount,
    bool? isFollowing,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLogin: lastLogin ?? this.lastLogin,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      pinsCount: pinsCount ?? this.pinsCount,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
