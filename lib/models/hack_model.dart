import 'package:cloud_firestore/cloud_firestore.dart';

class HackModel {
  final String id;
  final String text;
  final String tag;
  final String createdBy;
  final int upvoteCount;
  final Timestamp? createdAt;

  HackModel({
    required this.id,
    required this.text,
    required this.tag,
    required this.createdBy,
    required this.upvoteCount,
    this.createdAt,
  });

  factory HackModel.fromMap(Map<String, dynamic> map) {
    return HackModel(
      id: map['id'],
      text: map['text'],
      tag: map['tag'],
      createdBy: map['created_by'],
      upvoteCount: map['upvote_count'] ?? 0,
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'tag': tag,
      'created_by': createdBy,
      'upvote_count': upvoteCount,
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}