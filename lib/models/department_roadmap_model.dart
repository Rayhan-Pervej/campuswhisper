
class DepartmentRoadmapModel {
  final String code;
  final String name;
  final List<CourseRoadmap> roadmap;

  DepartmentRoadmapModel({
    required this.code,
    required this.name,
    required this.roadmap,
  });

  factory DepartmentRoadmapModel.fromMap(Map<String, dynamic> map) {
    return DepartmentRoadmapModel(
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      roadmap: (map['roadmap'] as List? ?? [])
          .map((item) => CourseRoadmap.fromMap(item))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'roadmap': roadmap.map((item) => item.toMap()).toList(),
    };
  }
}

class CourseRoadmap {
  final String semester;
  final int credits;
  final List<RoadmapItem> items;

  CourseRoadmap({
    required this.semester,
    required this.credits,
    required this.items,
  });

  factory CourseRoadmap.fromMap(Map<String, dynamic> map) {
    return CourseRoadmap(
      semester: map['semester'] ?? '',
      credits: map['credits'] ?? 0,
      items: (map['items'] as List? ?? [])
          .map((item) => RoadmapItem.fromMap(item))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'semester': semester,
      'credits': credits,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}

class RoadmapItem {
  final String id;
  final String title;
  final int credit;
  final bool lab;
  final List<String> prerequisites;
  final String type;
  final bool isPlaceholder;

  RoadmapItem({
    required this.id,
    required this.title,
    required this.credit,
    this.lab = false,
    List<String>? prerequisites,
    required this.type,
    this.isPlaceholder = false,
  }) : prerequisites = prerequisites ?? [];

  factory RoadmapItem.fromMap(Map<String, dynamic> map) {
    return RoadmapItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      credit: map['credit'] ?? 0,
      lab: map['lab'] ?? false,
      prerequisites: map['prerequisites'] != null
          ? List<String>.from(map['prerequisites'])
          : [],
      type: map['type'] ?? '',
      isPlaceholder: map['isPlaceholder'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'credit': credit,
      'lab': lab,
      'prerequisites': prerequisites,
      'type': type,
      'isPlaceholder': isPlaceholder,
    };
  }

  // Helper method to check if course has prerequisites
  bool get hasPrerequisites => prerequisites.isNotEmpty;

  // Helper method to get prerequisite display string
  String get prerequisitesDisplay => prerequisites.join(', ');
}