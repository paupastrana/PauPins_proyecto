import 'user_model.dart';

class Comment {
  final String id;
  final String userId;
  final String pinId;
  final String content;
  final String? parentCommentId;
  final bool isEdited;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user;

  Comment({
    required this.id,
    required this.userId,
    required this.pinId,
    required this.content,
    this.parentCommentId,
    this.isEdited = false,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      pinId: json['pin_id'] as String,
      content: json['content'] as String,
      parentCommentId: json['parent_comment_id'] as String?,
      isEdited: json['is_edited'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      user: json['user'] != null ? User.fromJson(json['user'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'pin_id': pinId,
      'content': content,
      'parent_comment_id': parentCommentId,
      'is_edited': isEdited,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user?.toJson(),
    };
  }

  Comment copyWith({
    String? id,
    String? userId,
    String? pinId,
    String? content,
    String? parentCommentId,
    bool? isEdited,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
  }) {
    return Comment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      pinId: pinId ?? this.pinId,
      content: content ?? this.content,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      isEdited: isEdited ?? this.isEdited,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }
}
