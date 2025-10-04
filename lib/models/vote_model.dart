import 'package:cloud_firestore/cloud_firestore.dart';

class VoteModel {
  final String voteId;
  final String postId;
  final String voterId;
  final String voteType;
  final Timestamp? createdAt;

  VoteModel({
    required this.voteId,
    required this.postId,
    required this.voterId,
    required this.voteType,
    this.createdAt,
  });

  factory VoteModel.fromMap(Map<String, dynamic> map) {
    return VoteModel(
      voteId: map['vote_id'],
      postId: map['post_id'],
      voterId: map['voter_id'],
      voteType: map['vote_type'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vote_id': voteId,
      'post_id': postId,
      'voter_id': voterId,
      'vote_type': voteType,
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
