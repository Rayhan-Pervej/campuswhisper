import 'package:flutter/material.dart';

// Model for regular course input
class RegularCourseInput {
  final String id;
  final TextEditingController nameController;
  String? selectedCredit;
  String? selectedGrade;

  RegularCourseInput({String? id})
    : id =
          id ?? '${DateTime.now().millisecondsSinceEpoch}_${Object().hashCode}',
      nameController = TextEditingController();

  bool get isValid => selectedCredit != null && selectedGrade != null;

  bool get hasAnyData =>
      nameController.text.isNotEmpty ||
      selectedCredit != null ||
      selectedGrade != null;

  String get courseName => nameController.text.trim();
  double get credits => double.tryParse(selectedCredit ?? '0') ?? 0.0;
  String get grade => selectedGrade ?? '';

  // FIXED: Clear method now resets all fields including dropdowns
  void clear() {
    nameController.clear();
    selectedCredit = null;
    selectedGrade = null;
  }

  void dispose() {
    nameController.dispose();
  }

  RegularCourseInput copy() {
    final newCourse = RegularCourseInput();
    newCourse.nameController.text = nameController.text;
    newCourse.selectedCredit = selectedCredit;
    newCourse.selectedGrade = selectedGrade;
    return newCourse;
  }
}

// Model for retake course input
class RetakeCourseInput {
  final String id;
  final TextEditingController nameController;
  String? selectedCredit;
  String? selectedPreviousGrade;
  String? selectedNewGrade;

  RetakeCourseInput({String? id})
    : id =
          id ?? '${DateTime.now().millisecondsSinceEpoch}_${Object().hashCode}',
      nameController = TextEditingController();

  bool get isValid =>
      selectedCredit != null &&
      selectedPreviousGrade != null &&
      selectedNewGrade != null;

  bool get hasAnyData =>
      nameController.text.isNotEmpty ||
      selectedCredit != null ||
      selectedPreviousGrade != null ||
      selectedNewGrade != null;

  String get courseName => nameController.text.trim();
  double get credits => double.tryParse(selectedCredit ?? '0') ?? 0.0;
  String get previousGrade => selectedPreviousGrade ?? '';
  String get newGrade => selectedNewGrade ?? '';

  // FIXED: Clear method now resets all fields including dropdowns
  void clear() {
    nameController.clear();
    selectedCredit = null;
    selectedPreviousGrade = null;
    selectedNewGrade = null;
  }

  void dispose() {
    nameController.dispose();
  }

  RetakeCourseInput copy() {
    final newCourse = RetakeCourseInput();
    newCourse.nameController.text = nameController.text;
    newCourse.selectedCredit = selectedCredit;
    newCourse.selectedPreviousGrade = selectedPreviousGrade;
    newCourse.selectedNewGrade = selectedNewGrade;
    return newCourse;
  }
}

// Grade and credit options for dropdowns
class GradeOption {
  final String value;
  final String text;
  final double gradePoint;

  const GradeOption({
    required this.value,
    required this.text,
    required this.gradePoint,
  });

  static const List<GradeOption> allGrades = [
    GradeOption(value: 'A', text: 'A', gradePoint: 4.0),
    GradeOption(value: 'A-', text: 'A-', gradePoint: 3.7),
    GradeOption(value: 'B+', text: 'B+', gradePoint: 3.3),
    GradeOption(value: 'B', text: 'B', gradePoint: 3.0),
    GradeOption(value: 'B-', text: 'B-', gradePoint: 2.7),
    GradeOption(value: 'C+', text: 'C+', gradePoint: 2.3),
    GradeOption(value: 'C', text: 'C', gradePoint: 2.0),
    GradeOption(value: 'C-', text: 'C-', gradePoint: 1.7),
    GradeOption(value: 'D+', text: 'D+', gradePoint: 1.3),
    GradeOption(value: 'D', text: 'D', gradePoint: 1.0),
    GradeOption(value: 'D-', text: 'D-', gradePoint: 0.7),
    GradeOption(value: 'F', text: 'F', gradePoint: 0.0),
  ];

  static double getGradePoint(String grade) {
    return allGrades
        .firstWhere(
          (g) => g.value == grade,
          orElse: () =>
              const GradeOption(value: 'F', text: 'F', gradePoint: 0.0),
        )
        .gradePoint;
  }
}

class CreditOption {
  final String value;
  final String text;
  final double credits;

  const CreditOption({
    required this.value,
    required this.text,
    required this.credits,
  });

  static const List<CreditOption> allCredits = [
    CreditOption(value: '1.0', text: '1.0', credits: 1.0),
    CreditOption(value: '3.0', text: '3.0', credits: 3.0),
    CreditOption(value: '6.0', text: '6.0', credits: 6.0),
  ];

  static double getCredits(String creditValue) {
    return allCredits
        .firstWhere(
          (c) => c.value == creditValue,
          orElse: () =>
              const CreditOption(value: '3.0', text: '3.0', credits: 3.0),
        )
        .credits;
  }
}
