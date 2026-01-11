import 'package:cloud_firestore/cloud_firestore.dart';

class FAQModel {
  final String id;
  final String question;
  final String answer;
  final String createdBy;
  final int upvoteCount;
  final DateTime createdAt;

  FAQModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.createdBy,
    required this.upvoteCount,
    required this.createdAt,
  });

  factory FAQModel.fromJson(Map<String, dynamic> json) {
    return FAQModel(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      createdBy: json['created_by'] as String,
      upvoteCount: json['upvote_count'] ?? 0,
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'created_by': createdBy,
      'upvote_count': upvoteCount,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  bool validate() {
    return id.isNotEmpty &&
           question.isNotEmpty &&
           answer.isNotEmpty &&
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
