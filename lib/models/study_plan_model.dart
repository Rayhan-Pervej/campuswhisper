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

  factory StudyPlanModel.fromJson(Map<String, dynamic> json) {
    return StudyPlanModel(
      id: json['id'] as String,
      year: json['year'] as int,
      semester: json['semester'] as int,
      courses: List<String>.from(json['courses'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'year': year,
      'semester': semester,
      'courses': courses,
    };
  }

  bool validate() {
    return id.isNotEmpty &&
           year > 0 &&
           semester > 0 &&
           courses.isNotEmpty;
  }
}