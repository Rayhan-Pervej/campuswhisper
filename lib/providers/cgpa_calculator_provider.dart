import 'dart:io';
import 'package:campuswhisper/models/course_input_model.dart';
import 'package:campuswhisper/models/transcript_model.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class CgpaCalculatorProvider extends ChangeNotifier {
  // State variables
  bool _isLoading = false;
  File? _uploadedFile;
  TranscriptData? _transcriptData;
  String? _errorMessage;

  // CGPA calculation data
  double _currentCgpa = 0.0;
  double _totalCreditsEarned = 0.0;
  double _calculatedCgpa = 0.0;
  double _totalCalculatedCredits = 0.0;

  // Course input management
  List<RegularCourseInput> _regularCourses = [];
  final List<RetakeCourseInput> _retakeCourses = [];

  // Calculation courses
  final List<CalculationCourse> _calculationCourses = [];
  final List<RetakeCalculationCourse> _retakeCalculationCourses = [];

  // Getters
  bool get isLoading => _isLoading;
  File? get uploadedFile => _uploadedFile;
  TranscriptData? get transcriptData => _transcriptData;
  String? get errorMessage => _errorMessage;
  bool get hasTranscriptData => _transcriptData != null;

  double get currentCgpa => _currentCgpa;
  double get totalCreditsEarned => _totalCreditsEarned;
  double get calculatedCgpa => _calculatedCgpa;
  double get totalCalculatedCredits => _totalCalculatedCredits;

  List<RegularCourseInput> get regularCourses => _regularCourses;
  List<RetakeCourseInput> get retakeCourses => _retakeCourses;
  List<CalculationCourse> get calculationCourses => _calculationCourses;
  List<RetakeCalculationCourse> get retakeCalculationCourses =>
      _retakeCalculationCourses;

  String get displayCurrentCgpa => _currentCgpa.toStringAsFixed(2);
  String get displayCreditsEarned => _totalCreditsEarned.toStringAsFixed(0);
  String get displayCalculatedCgpa => _calculatedCgpa.toStringAsFixed(2);
  String get displayTotalCalculatedCredits =>
      _totalCalculatedCredits.toStringAsFixed(0);

  bool get hasValidCalculations =>
      _calculationCourses.isNotEmpty || _retakeCalculationCourses.isNotEmpty;

  // Initialize with default courses
  CgpaCalculatorProvider() {
    _initializeDefaultCourses();
  }

  void _initializeDefaultCourses() {
    _regularCourses = [
      RegularCourseInput(),
      RegularCourseInput(),
      RegularCourseInput(),
    ];
  }

  // Upload and process transcript
  Future<void> uploadAndProcessTranscript(File file) async {
    try {
      _setLoading(true);
      _clearError();

      if (!await _validatePDFFile(file)) {
        throw Exception('Invalid PDF file or file size exceeds 5MB');
      }

      _uploadedFile = file;
      notifyListeners();

      await _parseTranscriptPDF(file);

      if (_transcriptData != null) {
        _loadTranscriptData();
        _recalculateAll();
      }
    } catch (e) {
      _setError('Error processing transcript: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Clear transcript data - NEW METHOD
  void clearTranscriptData() {
    _uploadedFile = null;
    _transcriptData = null;
    _currentCgpa = 0.0;
    _totalCreditsEarned = 0.0;
    _clearError();
    _recalculateAll();
    notifyListeners();
  }

  // Course management methods
  void addRegularCourse() {
    _regularCourses.add(RegularCourseInput());
    notifyListeners();
  }

  void removeRegularCourse(int index) {
    if (index >= 0 &&
        index < _regularCourses.length &&
        _regularCourses.length > 1) {
      _regularCourses[index].dispose();
      _regularCourses.removeAt(index);
      _recalculateAll();
      notifyListeners();
    }
  }

  void addRetakeCourse() {
    _retakeCourses.add(RetakeCourseInput());
    notifyListeners();
  }

  void removeRetakeCourse(int index) {
    if (index >= 0 && index < _retakeCourses.length) {
      _retakeCourses[index].dispose();
      _retakeCourses.removeAt(index);
      _recalculateAll();
      notifyListeners();
    }
  }

  // Update methods for course inputs
  void updateRegularCourse(int index) {
    if (index >= 0 && index < _regularCourses.length) {
      _recalculateAll();
      notifyListeners();
    }
  }

  void updateRetakeCourse(int index) {
    if (index >= 0 && index < _retakeCourses.length) {
      _recalculateAll();
      notifyListeners();
    }
  }

  // Clear all calculations - FIXED METHOD
  void clearCalculations() {
    // Clear calculation lists
    _calculationCourses.clear();
    _retakeCalculationCourses.clear();

    // Reset UI inputs - properly clear all fields including dropdowns
    for (var course in _regularCourses) {
      course.clear();
    }
    for (var course in _retakeCourses) {
      course.dispose();
    }
    _retakeCourses.clear();

    // Reset CGPA values
    if (_transcriptData != null) {
      // If we have transcript data, revert to original values
      _calculatedCgpa = _currentCgpa;
      _totalCalculatedCredits = _totalCreditsEarned;
    } else {
      // If no transcript, reset everything to zero
      _calculatedCgpa = 0.0;
      _totalCalculatedCredits = 0.0;
    }

    notifyListeners();
    Future.microtask(() => notifyListeners());
  }

  // Recalculate all courses and CGPA
  void _recalculateAll() {
    _updateCalculationCourses();
    _calculateCgpa();
  }

  // Update calculation courses from UI inputs
  void _updateCalculationCourses() {
    // Clear existing calculations
    _calculationCourses.clear();
    _retakeCalculationCourses.clear();

    // Process regular courses
    for (var courseInput in _regularCourses) {
      if (courseInput.isValid) {
        _calculationCourses.add(
          CalculationCourse(
            courseName: courseInput.courseName.isEmpty
                ? 'Course'
                : courseInput.courseName,
            credits: courseInput.credits,
            grade: courseInput.grade,
            gradePoint: GradeOption.getGradePoint(courseInput.grade),
          ),
        );
      }
    }

    // Process retake courses
    for (var retakeInput in _retakeCourses) {
      if (retakeInput.isValid) {
        _retakeCalculationCourses.add(
          RetakeCalculationCourse(
            courseName: retakeInput.courseName.isEmpty
                ? 'Retake Course'
                : retakeInput.courseName,
            credits: retakeInput.credits,
            previousGrade: retakeInput.previousGrade,
            newGrade: retakeInput.newGrade,
            previousGradePoint: GradeOption.getGradePoint(
              retakeInput.previousGrade,
            ),
            newGradePoint: GradeOption.getGradePoint(retakeInput.newGrade),
          ),
        );
      }
    }
  }

  // Calculate CGPA with new courses and retakes
  void _calculateCgpa() {
    // Start with original transcript data or zeros if no transcript
    double totalGradePoints = hasTranscriptData
        ? (_currentCgpa * _totalCreditsEarned)
        : 0.0;
    double totalCredits = hasTranscriptData ? _totalCreditsEarned : 0.0;

    // Add regular courses
    for (var course in _calculationCourses) {
      totalGradePoints += course.gradePoint * course.credits;
      totalCredits += course.credits;
    }

    // Handle retake courses (replace previous grade with new grade)
    for (var retake in _retakeCalculationCourses) {
      // Remove previous grade points and add new ones
      totalGradePoints -= retake.previousGradePoint * retake.credits;
      totalGradePoints += retake.newGradePoint * retake.credits;
      // Credits don't change for retakes
    }

    // Calculate new CGPA
    _calculatedCgpa = totalCredits > 0 ? totalGradePoints / totalCredits : 0.0;
    _totalCalculatedCredits = totalCredits;

    // Ensure CGPA is within valid range
    _calculatedCgpa = _calculatedCgpa.clamp(0.0, 4.0);
  }

  // Get academic status based on CGPA
  String getAcademicStatus(double cgpa) {
    if (cgpa >= 3.75) return 'Excellent';
    if (cgpa >= 3.50) return 'Very Good';
    if (cgpa >= 3.25) return 'Good';
    if (cgpa >= 3.00) return 'Satisfactory';
    if (cgpa >= 2.50) return 'Below Average';
    return 'Poor';
  }

  String get currentAcademicStatus => getAcademicStatus(_calculatedCgpa);

  // Check if there's improvement in CGPA
  bool get hasImprovement => _calculatedCgpa > _currentCgpa;
  double get cgpaImprovement => _calculatedCgpa - _currentCgpa;
  String get improvementText {
    if (!hasTranscriptData) return '';
    if (hasImprovement) {
      return '+${cgpaImprovement.toStringAsFixed(3)}';
    } else if (cgpaImprovement < 0) {
      return cgpaImprovement.toStringAsFixed(3);
    }
    return 'No change';
  }

  // Validate PDF file
  Future<bool> _validatePDFFile(File file) async {
    try {
      final fileSize = await file.length();
      if (fileSize > 5 * 1024 * 1024) return false;

      final bytes = await file.readAsBytes();
      final document = PdfDocument(inputBytes: bytes);
      document.dispose();

      return true;
    } catch (e) {
      return false;
    }
  }

  // Parse transcript PDF
  Future<void> _parseTranscriptPDF(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final document = PdfDocument(inputBytes: bytes);

      PdfTextExtractor extractor = PdfTextExtractor(document);
      String extractedText = extractor.extractText();
      document.dispose();

      _transcriptData = _parseTranscriptText(extractedText);

      if (_transcriptData == null) {
        throw Exception(
          'Unable to parse transcript data. Please ensure this is a valid IUB transcript.',
        );
      }
    } catch (e) {
      throw Exception('Error reading PDF: ${e.toString()}');
    }
  }

  // Parse transcript text
  TranscriptData? _parseTranscriptText(String text) {
    try {
      final lines = text.split('\n');

      String studentName = '';
      String studentId = '';
      String major = '';
      String minor = '';
      double totalCreditsAttempted = 0.0;
      double totalCreditsEarned = 0.0;
      double cumulativeGPA = 0.0;

      for (String line in lines) {
        if (line.contains('Name:')) {
          studentName = line.split('Name:')[1].split('Major')[0].trim();
        }
        if (line.contains('ID:')) {
          final match = RegExp(r'ID:\s*(\d+)').firstMatch(line);
          if (match != null) studentId = match.group(1) ?? '';
        }
        if (line.contains('Major(s):')) {
          major = line.split('Major(s):')[1].split('Minor:')[0].trim();
        }
        if (line.contains('Minor:')) {
          minor = line.split('Minor:')[1].trim();
        }
        if (line.contains('Total Credits Attempted')) {
          final match = RegExp(
            r'Total Credits Attempted\s*:\s*([\d.]+)',
          ).firstMatch(line);
          if (match != null) {
            totalCreditsAttempted =
                double.tryParse(match.group(1) ?? '0') ?? 0.0;
          }
        }
        if (line.contains('Total Credits Earned')) {
          final match = RegExp(
            r'Total Credits Earned\s*:\s*([\d.]+)',
          ).firstMatch(line);
          if (match != null) {
            totalCreditsEarned = double.tryParse(match.group(1) ?? '0') ?? 0.0;
          }
        }
        if (line.contains('Cumulative GPA')) {
          final match = RegExp(
            r'Cumulative GPA\s*:\s*([\d.]+)',
          ).firstMatch(line);
          if (match != null) {
            cumulativeGPA = double.tryParse(match.group(1) ?? '0') ?? 0.0;
          }
        }
      }

      return TranscriptData(
        studentName: studentName,
        studentId: studentId,
        major: major,
        minor: minor,
        totalCreditsAttempted: totalCreditsAttempted,
        totalCreditsEarned: totalCreditsEarned,
        cumulativeGPA: cumulativeGPA,
        courses: [], // Simplified for CGPA calculation
        semesters: [], // Simplified for CGPA calculation
      );
    } catch (e) {
      if (kDebugMode) print('Error parsing transcript: $e');
      return null;
    }
  }

  // Load data from transcript
  void _loadTranscriptData() {
    if (_transcriptData == null) return;

    _currentCgpa = _transcriptData!.cumulativeGPA;
    _totalCreditsEarned = _transcriptData!.totalCreditsEarned;

    // Initialize calculation with current data
    _calculatedCgpa = _currentCgpa;
    _totalCalculatedCredits = _totalCreditsEarned;

    notifyListeners();
  }

  // Reset all data
  void resetData() {
    _uploadedFile = null;
    _transcriptData = null;
    _errorMessage = null;
    _currentCgpa = 0.0;
    _totalCreditsEarned = 0.0;
    _calculatedCgpa = 0.0;
    _totalCalculatedCredits = 0.0;

    // Dispose existing courses
    for (var course in _regularCourses) {
      course.dispose();
    }
    for (var course in _retakeCourses) {
      course.dispose();
    }

    _calculationCourses.clear();
    _retakeCalculationCourses.clear();

    // Reinitialize default courses
    _initializeDefaultCourses();

    notifyListeners();
  }

  // Utility methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // Dispose all text controllers
    for (var course in _regularCourses) {
      course.dispose();
    }
    for (var course in _retakeCourses) {
      course.dispose();
    }
    super.dispose();
  }
}

// Keep existing calculation models
class CalculationCourse {
  final String courseName;
  final double credits;
  final String grade;
  final double gradePoint;

  CalculationCourse({
    required this.courseName,
    required this.credits,
    required this.grade,
    required this.gradePoint,
  });
}

class RetakeCalculationCourse {
  final String courseName;
  final double credits;
  final String previousGrade;
  final String newGrade;
  final double previousGradePoint;
  final double newGradePoint;

  RetakeCalculationCourse({
    required this.courseName,
    required this.credits,
    required this.previousGrade,
    required this.newGrade,
    required this.previousGradePoint,
    required this.newGradePoint,
  });

  double get gradeImprovement => newGradePoint - previousGradePoint;
}
