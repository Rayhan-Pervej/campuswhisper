import 'package:cloud_firestore/cloud_firestore.dart';

class HackModel {
  final String id;
  final String text;
  final String tag;
  final String createdBy;
  final int upvoteCount;
  final DateTime createdAt;

  HackModel({
    required this.id,
    required this.text,
    required this.tag,
    required this.createdBy,
    required this.upvoteCount,
    required this.createdAt,
  });

  factory HackModel.fromJson(Map<String, dynamic> json) {
    return HackModel(
      id: json['id'] as String,
      text: json['text'] as String,
      tag: json['tag'] as String,
      createdBy: json['created_by'] as String,
      upvoteCount: json['upvote_count'] ?? 0,
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'tag': tag,
      'created_by': createdBy,
      'upvote_count': upvoteCount,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  bool validate() {
    return id.isNotEmpty &&
           text.isNotEmpty &&
           tag.isNotEmpty &&
           createdBy.isNotEmpty;
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