import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String university;
  final String department;
  final String? batch;
  final int xp;
  final int contributions;
  final List<String>? badges;
  final List<String>? favoriteCourses;
  final bool? notifyMe;
  final String? theme;
  final String role;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  UserModel({
    required this.uid,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.university,
    required this.department,
    this.batch,
    required this.xp,
    required this.contributions,
    this.badges,
    this.favoriteCourses,
    this.notifyMe,
    this.theme,
    required this.role,
    this.createdAt,
    this.lastLogin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      university: json['university'] as String,
      department: json['department'] as String,
      batch: json['batch'] as String?,
      xp: json['xp'] ?? 0,
      contributions: json['contributions'] ?? 0,
      badges: json['badges'] != null ? List<String>.from(json['badges']) : null,
      favoriteCourses: json['favorite_courses'] != null
          ? List<String>.from(json['favorite_courses'])
          : null,
      notifyMe: json['notify_me'] as bool?,
      theme: json['theme'] as String?,
      role: json['role'] as String,
      createdAt: json['created_at'] != null ? _parseDateTime(json['created_at']) : null,
      lastLogin: json['last_login'] != null ? _parseDateTime(json['last_login']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'university': university,
      'department': department,
      'batch': batch,
      'xp': xp,
      'contributions': contributions,
      'badges': badges,
      'favorite_courses': favoriteCourses,
      'notify_me': notifyMe,
      'theme': theme,
      'role': role,
      'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'last_login': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
    };
  }

  bool validate() {
    return uid.isNotEmpty &&
           email.isNotEmpty &&
           firstName.isNotEmpty &&
           lastName.isNotEmpty;
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
