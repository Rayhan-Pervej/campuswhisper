import 'package:cloud_firestore/cloud_firestore.dart';

/// Comment Vote Model - Stored in subcollection for scalability
///
/// Firestore Path: posts/{postId}/comments/{commentId}/votes/{userId}
///
/// This allows unlimited votes without hitting Firestore's 1MB document limit
class CommentVoteModel {
  final String userId;
  final String type;  // 'upvote' or 'downvote'
  final DateTime timestamp;

  const CommentVoteModel({
    required this.userId,
    required this.type,
    required this.timestamp,
  });

  factory CommentVoteModel.fromJson(Map<String, dynamic> json) {
    return CommentVoteModel(
      userId: json['userId'] as String,
      type: json['type'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'type': type,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
