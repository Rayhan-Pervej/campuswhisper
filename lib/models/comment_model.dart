import 'package:cloud_firestore/cloud_firestore.dart';

/// Comment Model - Scalable Facebook-Style Architecture
/// Uses subcollections for votes instead of arrays (supports 20000+ likes/comments)
///
/// Firestore Structure:
/// posts/{postId}/comments/{commentId}
///   - Uses subcollection: posts/{postId}/comments/{commentId}/votes/{userId}
///   - Avoids 1MB document size limit
///   - Scales to millions of votes
class CommentModel {
  final String id;
  final String parentId;  // ID of post/event/competition
  final String parentType;  // 'post', 'event', 'competition', etc.
  final String content;
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final String? replyToId;  // For nested replies (another comment ID)
  final String? replyToAuthor;

  // Counts only (actual votes stored in subcollection)
  final int upvoteCount;
  final int downvoteCount;
  final int replyCount;  // Number of replies

  // Status
  final bool isEdited;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isDeleted;

  const CommentModel({
    required this.id,
    required this.parentId,
    required this.parentType,
    required this.content,
    required this.authorId,
    required this.authorName,
    this.authorAvatarUrl,
    this.replyToId,
    this.replyToAuthor,
    this.upvoteCount = 0,
    this.downvoteCount = 0,
    this.replyCount = 0,
    this.isEdited = false,
    required this.createdAt,
    this.updatedAt,
    this.isDeleted = false,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      parentId: json['parentId'] as String,
      parentType: json['parentType'] as String,
      content: json['content'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorAvatarUrl: json['authorAvatarUrl'] as String?,
      replyToId: json['replyToId'] as String?,
      replyToAuthor: json['replyToAuthor'] as String?,
      upvoteCount: json['upvote_count'] as int? ?? json['upvotes'] as int? ?? 0,
      downvoteCount: json['downvote_count'] as int? ?? json['downvotes'] as int? ?? 0,
      replyCount: json['reply_count'] as int? ?? 0,
      isEdited: json['isEdited'] as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentId': parentId,
      'parentType': parentType,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatarUrl': authorAvatarUrl,
      'replyToId': replyToId,
      'replyToAuthor': replyToAuthor,
      'upvote_count': upvoteCount,
      'downvote_count': downvoteCount,
      'reply_count': replyCount,
      'isEdited': isEdited,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'isDeleted': isDeleted,
    };
  }

  CommentModel copyWith({
    String? id,
    String? parentId,
    String? parentType,
    String? content,
    String? authorId,
    String? authorName,
    String? authorAvatarUrl,
    String? replyToId,
    String? replyToAuthor,
    int? upvoteCount,
    int? downvoteCount,
    int? replyCount,
    bool? isEdited,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return CommentModel(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      parentType: parentType ?? this.parentType,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      replyToId: replyToId ?? this.replyToId,
      replyToAuthor: replyToAuthor ?? this.replyToAuthor,
      upvoteCount: upvoteCount ?? this.upvoteCount,
      downvoteCount: downvoteCount ?? this.downvoteCount,
      replyCount: replyCount ?? this.replyCount,
      isEdited: isEdited ?? this.isEdited,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CommentModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  // Helper getters
  int get score => upvoteCount - downvoteCount;
  bool get isReply => replyToId != null;
  bool get isTopLevel => replyToId == null;
}
