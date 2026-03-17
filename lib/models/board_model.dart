class Board {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String? coverImageUrl;
  final bool isPrivate;
  final int pinCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Board({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.coverImageUrl,
    this.isPrivate = false,
    this.pinCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      coverImageUrl: json['cover_image_url'] as String?,
      isPrivate: json['is_private'] as bool? ?? false,
      pinCount: json['pin_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'cover_image_url': coverImageUrl,
      'is_private': isPrivate,
      'pin_count': pinCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Board copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? coverImageUrl,
    bool? isPrivate,
    int? pinCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Board(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      isPrivate: isPrivate ?? this.isPrivate,
      pinCount: pinCount ?? this.pinCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
