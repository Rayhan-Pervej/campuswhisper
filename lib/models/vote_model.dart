import 'package:cloud_firestore/cloud_firestore.dart';

class VoteModel {
  final String userId;
  final String voteType;  // "upvote" or "downvote"
  final DateTime createdAt;

  const VoteModel({
    required this.userId,
    required this.voteType,
    required this.createdAt,
  });

  factory VoteModel.fromJson(Map<String, dynamic> json) {
    return VoteModel(
      userId: json['user_id'] as String,
      voteType: json['vote_type'] as String,
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'vote_type': voteType,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  VoteModel copyWith({
    String? userId,
    String? voteType,
    DateTime? createdAt,
  }) {
    return VoteModel(
      userId: userId ?? this.userId,
      voteType: voteType ?? this.voteType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VoteModel && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;

  bool validate() {
    return userId.isNotEmpty && voteType.isNotEmpty;
  }

  // Helper getters
  bool get isUpvote => voteType == 'upvote';
  bool get isDownvote => voteType == 'downvote';

  static DateTime _parseDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.parse(value);
    } else if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return DateTime.now();
  }
}
