import 'package:cloud_firestore/cloud_firestore.dart';

class VoteModel {
  final String voteId;
  final String postId;
  final String voterId;
  final String voteType;
  final DateTime createdAt;

  VoteModel({
    required this.voteId,
    required this.postId,
    required this.voterId,
    required this.voteType,
    required this.createdAt,
  });

  factory VoteModel.fromJson(Map<String, dynamic> json) {
    return VoteModel(
      voteId: json['vote_id'] as String,
      postId: json['post_id'] as String,
      voterId: json['voter_id'] as String,
      voteType: json['vote_type'] as String,
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vote_id': voteId,
      'post_id': postId,
      'voter_id': voterId,
      'vote_type': voteType,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  bool validate() {
    return voteId.isNotEmpty &&
           postId.isNotEmpty &&
           voterId.isNotEmpty &&
           voteType.isNotEmpty;
  }

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
