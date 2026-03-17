import 'user_model.dart';

enum NotificationType { like, comment, follow, pinSaved }

extension NotificationTypeExtension on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.like:
        return 'like';
      case NotificationType.comment:
        return 'comment';
      case NotificationType.follow:
        return 'follow';
      case NotificationType.pinSaved:
        return 'pin_saved';
    }
  }

  static NotificationType fromString(String value) {
    switch (value) {
      case 'like':
        return NotificationType.like;
      case 'comment':
        return NotificationType.comment;
      case 'follow':
        return NotificationType.follow;
      case 'pin_saved':
        return NotificationType.pinSaved;
      default:
        return NotificationType.like;
    }
  }
}

class Notification {
  final String id;
  final String userId;
  final String? triggeredByUserId;
  final NotificationType type;
  final String? pinId;
  final String? commentId;
  final String? content;
  final bool isRead;
  final DateTime createdAt;
  final User? triggeredByUser;

  Notification({
    required this.id,
    required this.userId,
    this.triggeredByUserId,
    required this.type,
    this.pinId,
    this.commentId,
    this.content,
    this.isRead = false,
    required this.createdAt,
    this.triggeredByUser,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      triggeredByUserId: json['triggered_by_user_id'] as String?,
      type: NotificationTypeExtension.fromString(json['type'] as String),
      pinId: json['pin_id'] as String?,
      commentId: json['comment_id'] as String?,
      content: json['content'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      triggeredByUser: json['triggered_by_user'] != null ? User.fromJson(json['triggered_by_user'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'triggered_by_user_id': triggeredByUserId,
      'type': type.value,
      'pin_id': pinId,
      'comment_id': commentId,
      'content': content,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'triggered_by_user': triggeredByUser?.toJson(),
    };
  }

  Notification copyWith({
    String? id,
    String? userId,
    String? triggeredByUserId,
    NotificationType? type,
    String? pinId,
    String? commentId,
    String? content,
    bool? isRead,
    DateTime? createdAt,
    User? triggeredByUser,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      triggeredByUserId: triggeredByUserId ?? this.triggeredByUserId,
      type: type ?? this.type,
      pinId: pinId ?? this.pinId,
      commentId: commentId ?? this.commentId,
      content: content ?? this.content,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      triggeredByUser: triggeredByUser ?? this.triggeredByUser,
    );
  }
}
