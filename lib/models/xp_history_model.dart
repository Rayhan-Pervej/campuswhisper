import 'package:cloud_firestore/cloud_firestore.dart';

class XpHistoryModel {
  final String id;
  final String userId;
  final String type;
  final int amount;
  final DateTime timestamp;
  final String? relatedPost;

  XpHistoryModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.timestamp,
    this.relatedPost,
  });

  factory XpHistoryModel.fromJson(Map<String, dynamic> json) {
    return XpHistoryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String,
      amount: json['amount'] as int,
      timestamp: _parseDateTime(json['timestamp']),
      relatedPost: json['related_post'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'amount': amount,
      'timestamp': Timestamp.fromDate(timestamp),
      'related_post': relatedPost,
    };
  }

  bool validate() {
    return id.isNotEmpty &&
           userId.isNotEmpty &&
           type.isNotEmpty &&
           amount >= 0;
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
