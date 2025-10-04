import 'package:cloud_firestore/cloud_firestore.dart';

class BadgeHistoryModel {
  final String id;
  final String userId;
  final String badgeName;
  final Timestamp awardedAt;

  BadgeHistoryModel({
    required this.id,
    required this.userId,
    required this.badgeName,
    required this.awardedAt,
  });

  factory BadgeHistoryModel.fromMap(Map<String, dynamic> map) {
    return BadgeHistoryModel(
      id: map['id'],
      userId: map['user_id'],
      badgeName: map['badge_name'],
      awardedAt: map['awarded_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'badge_name': badgeName,
      'awarded_at': awardedAt,
    };
  }
}