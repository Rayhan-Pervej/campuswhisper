class StudyPlanModel {
  final String id;
  final int year;
  final int semester;
  final List<String> courses;

  StudyPlanModel({
    required this.id,
    required this.year,
    required this.semester,
    required this.courses,
  });

  factory StudyPlanModel.fromMap(Map<String, dynamic> map) {
    return StudyPlanModel(
      id: map['id'],
      year: map['year'],
      semester: map['semester'],
      courses: List<String>.from(map['courses'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'year': year,
      'semester': semester,
      'courses': courses,
    };
  }
}