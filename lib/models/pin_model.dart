import 'user_model.dart';

class Pin {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String imageUrl;
  final String? sourceUrl;
  final String? dominantColor;
  final int? imageWidth;
  final int? imageHeight;
  final bool isSaved;
  final int viewCount;
  final int likeCount;
  final int commentCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user;
  final bool isLiked;

  Pin({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.imageUrl,
    this.sourceUrl,
    this.dominantColor,
    this.imageWidth,
    this.imageHeight,
    this.isSaved = false,
    this.viewCount = 0,
    this.likeCount = 0,
    this.commentCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.isLiked = false,
  });

  double? get aspectRatio {
    if (imageWidth != null && imageHeight != null && imageHeight! > 0) {
      return imageWidth! / imageHeight!;
    }
    return null;
  }

  factory Pin.fromJson(Map<String, dynamic> json) {
    return Pin(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String,
      sourceUrl: json['source_url'] as String?,
      dominantColor: json['dominant_color'] as String?,
      imageWidth: json['image_width'] as int?,
      imageHeight: json['image_height'] as int?,
      isSaved: json['is_saved'] as bool? ?? false,
      viewCount: json['view_count'] as int? ?? 0,
      likeCount: json['like_count'] as int? ?? 0,
      commentCount: json['comment_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      user: json['user'] != null ? User.fromJson(json['user'] as Map<String, dynamic>) : null,
      isLiked: json['is_liked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'source_url': sourceUrl,
      'dominant_color': dominantColor,
      'image_width': imageWidth,
      'image_height': imageHeight,
      'is_saved': isSaved,
      'view_count': viewCount,
      'like_count': likeCount,
      'comment_count': commentCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user?.toJson(),
      'is_liked': isLiked,
    };
  }

  Pin copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? imageUrl,
    String? sourceUrl,
    String? dominantColor,
    int? imageWidth,
    int? imageHeight,
    bool? isSaved,
    int? viewCount,
    int? likeCount,
    int? commentCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
    bool? isLiked,
  }) {
    return Pin(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      dominantColor: dominantColor ?? this.dominantColor,
      imageWidth: imageWidth ?? this.imageWidth,
      imageHeight: imageHeight ?? this.imageHeight,
      isSaved: isSaved ?? this.isSaved,
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
