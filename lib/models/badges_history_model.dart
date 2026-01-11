import 'package:cloud_firestore/cloud_firestore.dart';

class BadgeHistoryModel {
  final String id;
  final String userId;
  final String badgeName;
  final DateTime awardedAt;

  BadgeHistoryModel({
    required this.id,
    required this.userId,
    required this.badgeName,
    required this.awardedAt,
  });

  factory BadgeHistoryModel.fromJson(Map<String, dynamic> json) {
    return BadgeHistoryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      badgeName: json['badge_name'] as String,
      awardedAt: _parseDateTime(json['awarded_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'badge_name': badgeName,
      'awarded_at': Timestamp.fromDate(awardedAt),
    };
  }

  bool validate() {
    return id.isNotEmpty &&
           userId.isNotEmpty &&
           badgeName.isNotEmpty;
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
