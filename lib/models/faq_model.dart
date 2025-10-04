import 'package:cloud_firestore/cloud_firestore.dart';

class FAQModel {
  final String id;
  final String question;
  final String answer;
  final String createdBy;
  final int upvoteCount;
  final Timestamp? createdAt;

  FAQModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.createdBy,
    required this.upvoteCount,
    this.createdAt,
  });

  factory FAQModel.fromMap(Map<String, dynamic> map) {
    return FAQModel(
      id: map['id'],
      question: map['question'],
      answer: map['answer'],
      createdBy: map['created_by'],
      upvoteCount: map['upvote_count'] ?? 0,
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'created_by': createdBy,
      'upvote_count': upvoteCount,
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}