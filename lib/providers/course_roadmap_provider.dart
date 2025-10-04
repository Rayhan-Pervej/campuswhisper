// providers/course_roadmap_provider.dart

import 'dart:convert';
import 'package:campuswhisper/models/department_roadmap_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CourseRoadmapProvider extends ChangeNotifier {
  // State variables
  List<DepartmentRoadmapModel> _departments = [];
  DepartmentRoadmapModel? _selectedDepartment;
  RoadmapItem? _selectedCourse;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<DepartmentRoadmapModel> get departments => _departments;
  DepartmentRoadmapModel? get selectedDepartment => _selectedDepartment;
  RoadmapItem? get selectedCourse => _selectedCourse;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasData => _departments.isNotEmpty;

  // Get list of department codes for dropdown
  List<String> get departmentCodes =>
      _departments.map((dept) => dept.code).toList();

  // Get list of department names for display
  List<Map<String, String>> get departmentOptions => _departments
      .map((dept) => {'code': dept.code, 'name': dept.name})
      .toList();

  // Load roadmap data from JSON
  Future<void> loadRoadmapData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final String response = await rootBundle.loadString(
        'assets/data/course_roadmap.json',
      );
      final data = json.decode(response);

      _departments = (data['departments'] as List)
          .map((item) => DepartmentRoadmapModel.fromMap(item))
          .toList();

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load roadmap data: $e';
      notifyListeners();
    }
  }

  // Select department by code
  void selectDepartment(String departmentCode) {
    _selectedDepartment = _departments.firstWhere(
      (dept) => dept.code == departmentCode,
      orElse: () => _departments.first,
    );
    _selectedCourse = null;

    notifyListeners();
  }

  // Select a specific course
  void selectCourse(RoadmapItem course) {
    _selectedCourse = course;
    notifyListeners();
  }

  // Clear selected course
  void clearSelectedCourse() {
    _selectedCourse = null;
    notifyListeners();
  }

  // Get total credits for selected department
  int get totalCredits {
    if (_selectedDepartment == null) return 0;
    return _selectedDepartment!.roadmap.fold(
      0,
      (sum, semester) => sum + semester.credits,
    );
  }

  // Get number of semesters
  int get totalSemesters => _selectedDepartment?.roadmap.length ?? 0;

  // Check if a course is a prerequisite for another course
  bool isPrerequisiteFor(String courseId) {
    if (_selectedDepartment == null) return false;

    for (var semester in _selectedDepartment!.roadmap) {
      for (var item in semester.items) {
        if (item.prerequisites.contains(courseId)) {
          return true;
        }
      }
    }
    return false;
  }

  // Get all courses that depend on a specific course
  List<RoadmapItem> getDependentCourses(String courseId) {
    if (_selectedDepartment == null) return [];

    List<RoadmapItem> dependents = [];
    for (var semester in _selectedDepartment!.roadmap) {
      for (var item in semester.items) {
        if (item.prerequisites.contains(courseId)) {
          dependents.add(item);
        }
      }
    }
    return dependents;
  }

  // Get course by ID
  RoadmapItem? getCourseById(String courseId) {
    if (_selectedDepartment == null) return null;

    for (var semester in _selectedDepartment!.roadmap) {
      for (var item in semester.items) {
        if (item.id == courseId) {
          return item;
        }
      }
    }
    return null;
  }

  // Get courses by type
  List<RoadmapItem> getCoursesByType(String type) {
    if (_selectedDepartment == null) return [];

    List<RoadmapItem> courses = [];
    for (var semester in _selectedDepartment!.roadmap) {
      courses.addAll(
        semester.items.where(
          (item) => item.type.toLowerCase() == type.toLowerCase(),
        ),
      );
    }
    return courses;
  }

  // Get statistics
  Map<String, int> get courseTypeDistribution {
    if (_selectedDepartment == null) return {};

    Map<String, int> distribution = {};
    for (var semester in _selectedDepartment!.roadmap) {
      for (var item in semester.items) {
        distribution[item.type] = (distribution[item.type] ?? 0) + 1;
      }
    }
    return distribution;
  }

  // Reset provider state
  void reset() {
    _selectedDepartment = null;
    _selectedCourse = null;
    _errorMessage = null;
    notifyListeners();
  }
}
