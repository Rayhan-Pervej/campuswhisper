class TranscriptData {
  final String studentName;
  final String studentId;
  final String major;
  final String minor;
  final double totalCreditsAttempted;
  final double totalCreditsEarned;
  final double cumulativeGPA;
  final List<TranscriptCourse> courses;
  final List<SemesterData> semesters;

  TranscriptData({
    required this.studentName,
    required this.studentId,
    required this.major,
    required this.minor,
    required this.totalCreditsAttempted,
    required this.totalCreditsEarned,
    required this.cumulativeGPA,
    required this.courses,
    required this.semesters,
  });

  factory TranscriptData.fromMap(Map<String, dynamic> map) {
    return TranscriptData(
      studentName: map['studentName'] ?? '',
      studentId: map['studentId'] ?? '',
      major: map['major'] ?? '',
      minor: map['minor'] ?? '',
      totalCreditsAttempted: (map['totalCreditsAttempted'] ?? 0).toDouble(),
      totalCreditsEarned: (map['totalCreditsEarned'] ?? 0).toDouble(),
      cumulativeGPA: (map['cumulativeGPA'] ?? 0.0).toDouble(),
      courses: (map['courses'] as List?)
              ?.map((x) => TranscriptCourse.fromMap(x))
              .toList() ??
          [],
      semesters: (map['semesters'] as List?)
              ?.map((x) => SemesterData.fromMap(x))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentName': studentName,
      'studentId': studentId,
      'major': major,
      'minor': minor,
      'totalCreditsAttempted': totalCreditsAttempted,
      'totalCreditsEarned': totalCreditsEarned,
      'cumulativeGPA': cumulativeGPA,
      'courses': courses.map((x) => x.toMap()).toList(),
      'semesters': semesters.map((x) => x.toMap()).toList(),
    };
  }

  bool get hasCompletedMinimumCredits => totalCreditsEarned >= 36;
}

class TranscriptCourse {
  final String courseCode;
  final String courseTitle;
  final String type;
  final String grade;
  final double courseCredit;
  final double creditEarned;
  final double creditForGPA;
  final double gradePoint;
  final String semester;

  TranscriptCourse({
    required this.courseCode,
    required this.courseTitle,
    required this.type,
    required this.grade,
    required this.courseCredit,
    required this.creditEarned,
    required this.creditForGPA,
    required this.gradePoint,
    required this.semester,
  });

  factory TranscriptCourse.fromMap(Map<String, dynamic> map) {
    return TranscriptCourse(
      courseCode: map['courseCode'] ?? '',
      courseTitle: map['courseTitle'] ?? '',
      type: map['type'] ?? '',
      grade: map['grade'] ?? '',
      courseCredit: (map['courseCredit'] ?? 0).toDouble(),
      creditEarned: (map['creditEarned'] ?? 0).toDouble(),
      creditForGPA: (map['creditForGPA'] ?? 0).toDouble(),
      gradePoint: (map['gradePoint'] ?? 0).toDouble(),
      semester: map['semester'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseCode': courseCode,
      'courseTitle': courseTitle,
      'type': type,
      'grade': grade,
      'courseCredit': courseCredit,
      'creditEarned': creditEarned,
      'creditForGPA': creditForGPA,
      'gradePoint': gradePoint,
      'semester': semester,
    };
  }

  bool get isPassed => grade != 'W' && grade != 'F' && creditEarned > 0;
}

class SemesterData {
  final String semesterName;
  final double semesterCredits;
  final double semesterGPA;
  final List<TranscriptCourse> courses;

  SemesterData({
    required this.semesterName,
    required this.semesterCredits,
    required this.semesterGPA,
    required this.courses,
  });

  factory SemesterData.fromMap(Map<String, dynamic> map) {
    return SemesterData(
      semesterName: map['semesterName'] ?? '',
      semesterCredits: (map['semesterCredits'] ?? 0).toDouble(),
      semesterGPA: (map['semesterGPA'] ?? 0.0).toDouble(),
      courses: (map['courses'] as List?)
              ?.map((x) => TranscriptCourse.fromMap(x))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'semesterName': semesterName,
      'semesterCredits': semesterCredits,
      'semesterGPA': semesterGPA,
      'courses': courses.map((x) => x.toMap()).toList(),
    };
  }
}