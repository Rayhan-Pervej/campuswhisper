import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String type;
  final String createdBy;
  final String? createdByName; // User's display name
  final String content;
  final DateTime createdAt;
  final String? courseId;
  final String? title;
  final int upvoteCount;
  final int downvoteCount;
  final int commentCount;
  final DateTime? updatedAt;

  PostModel({
    required this.postId,
    required this.type,
    required this.createdBy,
    this.createdByName,
    required this.content,
    required this.createdAt,
    this.courseId,
    this.title,
    this.upvoteCount = 0,
    this.downvoteCount = 0,
    this.commentCount = 0,
    this.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['post_id'] as String,
      type: json['type'] as String,
      createdBy: json['created_by'] as String,
      createdByName: json['created_by_name'] as String?,
      content: json['content'] as String,
      createdAt: _parseDateTime(json['created_at']),
      courseId: json['course_id'] as String?,
      title: json['title'] as String?,
      upvoteCount: json['upvote_count'] ?? 0,
      downvoteCount: json['downvote_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      updatedAt: json['updated_at'] != null ? _parseDateTime(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'type': type,
      'created_by': createdBy,
      'created_by_name': createdByName,
      'content': content,
      'created_at': Timestamp.fromDate(createdAt),
      'course_id': courseId,
      'title': title,
      'upvote_count': upvoteCount,
      'downvote_count': downvoteCount,
      'comment_count': commentCount,
      'updated_at': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  bool validate() {
    return postId.isNotEmpty &&
           type.isNotEmpty &&
           createdBy.isNotEmpty &&
           content.isNotEmpty;
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
