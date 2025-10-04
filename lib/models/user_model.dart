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
  final Timestamp? createdAt;
  final Timestamp? lastLogin;

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

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      university: map['university'],
      department: map['department'],
      batch: map['batch'],
      xp: map['xp'] ?? 0,
      contributions: map['contributions'] ?? 0,
      badges: map['badges'] != null ? List<String>.from(map['badges']) : null,
      favoriteCourses: map['favorite_courses'] != null
          ? List<String>.from(map['favorite_courses'])
          : null,
      notifyMe: map['notify_me'],
      theme: map['theme'],
      role: map['role'],
      createdAt: map['created_at'],
      lastLogin: map['last_login'],
    );
  }

  Map<String, dynamic> toMap() {
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
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
      'last_login': lastLogin,
    };
  }
}
