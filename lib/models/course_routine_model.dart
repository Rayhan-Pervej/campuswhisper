import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a single course in a semester
class CourseItem {
  final String id;
  final String courseName;
  final String courseCode;
  final String instructor;
  final String section;
  final double credit;
  final List<ClassSchedule> schedule;
  final String? room;
  final String? notes;

  const CourseItem({
    required this.id,
    required this.courseName,
    required this.courseCode,
    required this.instructor,
    required this.section,
    required this.credit,
    this.schedule = const [],
    this.room,
    this.notes,
  });

  factory CourseItem.fromJson(Map<String, dynamic> json) {
    return CourseItem(
      id: json['id'] as String,
      courseName: json['courseName'] as String,
      courseCode: json['courseCode'] as String,
      instructor: json['instructor'] as String,
      section: json['section'] as String,
      credit: (json['credit'] as num).toDouble(),
      schedule: (json['schedule'] as List<dynamic>?)
              ?.map((e) => ClassSchedule.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      room: json['room'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseName': courseName,
      'courseCode': courseCode,
      'instructor': instructor,
      'section': section,
      'credit': credit,
      'schedule': schedule.map((e) => e.toJson()).toList(),
      'room': room,
      'notes': notes,
    };
  }

  CourseItem copyWith({
    String? id,
    String? courseName,
    String? courseCode,
    String? instructor,
    String? section,
    double? credit,
    List<ClassSchedule>? schedule,
    String? room,
    String? notes,
  }) {
    return CourseItem(
      id: id ?? this.id,
      courseName: courseName ?? this.courseName,
      courseCode: courseCode ?? this.courseCode,
      instructor: instructor ?? this.instructor,
      section: section ?? this.section,
      credit: credit ?? this.credit,
      schedule: schedule ?? this.schedule,
      room: room ?? this.room,
      notes: notes ?? this.notes,
    );
  }
}

/// Represents a class schedule (day and time)
class ClassSchedule {
  final String day; // e.g., "Sunday", "Monday"
  final String startTime; // e.g., "08:00 AM"
  final String endTime; // e.g., "09:30 AM"

  const ClassSchedule({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory ClassSchedule.fromJson(Map<String, dynamic> json) {
    return ClassSchedule(
      day: json['day'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

/// Represents a semester with courses
class SemesterRoutine {
  final String id;
  final String userId;
  final String semesterName; // e.g., "Summer 2025"
  final List<CourseItem> courses;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  const SemesterRoutine({
    required this.id,
    required this.userId,
    required this.semesterName,
    this.courses = const [],
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  factory SemesterRoutine.fromJson(Map<String, dynamic> json) {
    return SemesterRoutine(
      id: json['id'] as String,
      userId: json['userId'] as String,
      semesterName: json['semesterName'] as String,
      courses: (json['courses'] as List<dynamic>?)
              ?.map((e) => CourseItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'semesterName': semesterName,
      'courses': courses.map((e) => e.toJson()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'isActive': isActive,
    };
  }

  SemesterRoutine copyWith({
    String? id,
    String? userId,
    String? semesterName,
    List<CourseItem>? courses,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return SemesterRoutine(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      semesterName: semesterName ?? this.semesterName,
      courses: courses ?? this.courses,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  // Helper getters
  int get totalCourses => courses.length;
  double get totalCredits => courses.fold(0.0, (total, course) => total + course.credit);
}
