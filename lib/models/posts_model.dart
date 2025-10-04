import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String type;
  final String createdBy;
  final String content;
  final Timestamp? createdAt;
  final String? courseId;
  final String? title;
  final int upvoteCount;
  final int downvoteCount;
  final Timestamp? updatedAt;

  PostModel({
    required this.postId,
    required this.type,
    required this.createdBy,
    required this.content,
    required this.createdAt,
    this.courseId,
    this.title,
    this.upvoteCount = 0,
    this.downvoteCount = 0,
    this.updatedAt,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['post_id'],
      type: map['type'],
      createdBy: map['created_by'],
      content: map['content'],
      createdAt: map['created_at'],
      courseId: map['course_id'],
      title: map['title'],
      upvoteCount: map['upvote_count'] ?? 0,
      downvoteCount: map['downvote_count'] ?? 0,
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'type': type,
      'created_by': createdBy,
      'content': content,
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
      'course_id': courseId,
      'title': title,
      'upvote_count': upvoteCount,
      'downvote_count': downvoteCount,
      'updated_at': updatedAt,
    };
  }
}
