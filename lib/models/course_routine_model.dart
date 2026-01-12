import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a single class schedule (day and time)
class ClassSchedule {
  final String day;
  final String startTime;
  final String endTime;

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

/// Represents a single course in a routine
class CourseItem {
  final String courseCode;
  final String courseName;
  final int credits;
  final String instructor;
  final String room;
  final List<ClassSchedule> schedule;
  final String color;

  const CourseItem({
    required this.courseCode,
    required this.courseName,
    required this.credits,
    required this.instructor,
    required this.room,
    this.schedule = const [],
    required this.color,
  });

  factory CourseItem.fromJson(Map<String, dynamic> json) {
    return CourseItem(
      courseCode: json['courseCode'] as String,
      courseName: json['courseName'] as String,
      credits: json['credits'] as int,
      instructor: json['instructor'] as String,
      room: json['room'] as String,
      schedule: (json['schedule'] as List<dynamic>?)
              ?.map((e) => ClassSchedule.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      color: json['color'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseCode': courseCode,
      'courseName': courseName,
      'credits': credits,
      'instructor': instructor,
      'room': room,
      'schedule': schedule.map((e) => e.toJson()).toList(),
      'color': color,
    };
  }

  CourseItem copyWith({
    String? courseCode,
    String? courseName,
    int? credits,
    String? instructor,
    String? room,
    List<ClassSchedule>? schedule,
    String? color,
  }) {
    return CourseItem(
      courseCode: courseCode ?? this.courseCode,
      courseName: courseName ?? this.courseName,
      credits: credits ?? this.credits,
      instructor: instructor ?? this.instructor,
      room: room ?? this.room,
      schedule: schedule ?? this.schedule,
      color: color ?? this.color,
    );
  }
}

/// Represents a course routine for a user
class CourseRoutineModel {
  final String id;
  final String userId;
  final String semester;
  final String year;
  final List<CourseItem> courses;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const CourseRoutineModel({
    required this.id,
    required this.userId,
    required this.semester,
    required this.year,
    this.courses = const [],
    required this.createdAt,
    this.updatedAt,
  });

  factory CourseRoutineModel.fromJson(Map<String, dynamic> json) {
    return CourseRoutineModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      semester: json['semester'] as String,
      year: json['year'] as String,
      courses: (json['courses'] as List<dynamic>?)
              ?.map((e) => CourseItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'semester': semester,
      'year': year,
      'courses': courses.map((e) => e.toJson()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  CourseRoutineModel copyWith({
    String? id,
    String? userId,
    String? semester,
    String? year,
    List<CourseItem>? courses,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseRoutineModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      semester: semester ?? this.semester,
      year: year ?? this.year,
      courses: courses ?? this.courses,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CourseRoutineModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  // Helper getters
  int get totalCourses => courses.length;
  int get totalCredits => courses.fold(0, (total, course) => total + course.credits);
}
