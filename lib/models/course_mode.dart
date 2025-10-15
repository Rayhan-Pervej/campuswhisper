class CourseModel {
  final String id;
  final String courseId;
  final String section;
  final String room;
  final List<String> days;
  final String startTime;
  final String endTime;

  CourseModel({
    required this.id,
    required this.courseId,
    required this.section,
    required this.room,
    required this.days,
    required this.startTime,
    required this.endTime,
  });

  String get daysDisplay {
    return days.join('-');
  }

  String get timeDisplay {
    return '$startTime to $endTime';
  }
}

class RoutineModel {
  final String semester;
  final List<CourseModel> courses;

  RoutineModel({
    required this.semester,
    required this.courses,
  });
}