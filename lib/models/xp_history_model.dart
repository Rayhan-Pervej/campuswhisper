import 'package:cloud_firestore/cloud_firestore.dart';

class XpHistoryModel {
  final String id;
  final String userId;
  final String type;
  final int amount;
  final Timestamp? timestamp;
  final String? relatedPost;

  XpHistoryModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.timestamp,
    this.relatedPost,
  });

  factory XpHistoryModel.fromMap(Map<String, dynamic> map) {
    return XpHistoryModel(
      id: map['id'],
      userId: map['user_id'],
      type: map['type'],
      amount: map['amount'],
      timestamp: map['timestamp'],
      relatedPost: map['related_post'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'amount': amount,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
      'related_post': relatedPost,
    };
  }
}
