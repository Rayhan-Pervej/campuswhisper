import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String parentId;  // ID of post/event/competition
  final String parentType;  // 'post', 'event', 'competition', etc.
  final String content;
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final String? replyToId;  // For nested replies
  final String? replyToAuthor;
  final int upvotes;
  final int downvotes;
  final List<String> upvotedBy;
  final List<String> downvotedBy;
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
    this.upvotes = 0,
    this.downvotes = 0,
    this.upvotedBy = const [],
    this.downvotedBy = const [],
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
      upvotes: json['upvotes'] as int? ?? 0,
      downvotes: json['downvotes'] as int? ?? 0,
      upvotedBy: List<String>.from(json['upvotedBy'] ?? []),
      downvotedBy: List<String>.from(json['downvotedBy'] ?? []),
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
      'upvotes': upvotes,
      'downvotes': downvotes,
      'upvotedBy': upvotedBy,
      'downvotedBy': downvotedBy,
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
    int? upvotes,
    int? downvotes,
    List<String>? upvotedBy,
    List<String>? downvotedBy,
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
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      upvotedBy: upvotedBy ?? this.upvotedBy,
      downvotedBy: downvotedBy ?? this.downvotedBy,
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
  int get score => upvotes - downvotes;
  bool get isReply => replyToId != null;
  bool get isTopLevel => replyToId == null;
}
