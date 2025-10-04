import 'dart:io';
import 'package:campuswhisper/models/scholarship_result_model.dart';
import 'package:campuswhisper/models/transcript_model.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ScholarshipProvider extends ChangeNotifier {
  // State variables
  bool _isLoading = false;
  File? _uploadedFile;
  TranscriptData? _transcriptData;
  ScholarshipResult? _scholarshipResult;
  String? _errorMessage;
  bool _hasProcessedFile = false;
  bool _isExpand = false;

  // Getters
  bool get isLoading => _isLoading;
  File? get uploadedFile => _uploadedFile;
  TranscriptData? get transcriptData => _transcriptData;
  ScholarshipResult? get scholarshipResult => _scholarshipResult;
  String? get errorMessage => _errorMessage;
  bool get hasProcessedFile => _hasProcessedFile;
  bool get hasValidTranscript => _transcriptData != null;
  bool get hasScholarshipResult => _scholarshipResult != null;
  bool get isExpand => _isExpand;

  // Upload and process transcript
  Future<void> uploadAndProcessTranscript(File file) async {
    try {
      _setLoading(true);
      _clearError();

      // Validate file
      if (!await _validatePDFFile(file)) {
        throw Exception('Invalid PDF file or file size exceeds 5MB');
      }

      _uploadedFile = file;
      notifyListeners();

      // Parse PDF
      await _parseTranscriptPDF(file);

      // Calculate scholarship eligibility
      if (_transcriptData != null) {
        _calculateScholarshipEligibility();
        _hasProcessedFile = true;
      }
    } catch (e) {
      _setError('Error processing transcript: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Validate PDF file
  Future<bool> _validatePDFFile(File file) async {
    try {
      // Check file size (5MB limit)
      final fileSize = await file.length();
      if (fileSize > 5 * 1024 * 1024) {
        return false;
      }

      // Check if it's a valid PDF
      final bytes = await file.readAsBytes();
      final document = PdfDocument(inputBytes: bytes);
      document.dispose();

      return true;
    } catch (e) {
      return false;
    }
  }

  // Parse transcript PDF and extract data
  Future<void> _parseTranscriptPDF(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final document = PdfDocument(inputBytes: bytes);

      // Create PdfTextExtractor instance
      PdfTextExtractor extractor = PdfTextExtractor(document);

      // Extract text from all pages
      String extractedText = extractor.extractText();

      document.dispose();

      // Parse the extracted text
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

  // Parse extracted text into TranscriptData
  TranscriptData? _parseTranscriptText(String text) {
    try {
      final lines = text.split('\n');

      // Extract student information
      String studentName = '';
      String studentId = '';
      String major = '';
      String minor = '';
      double totalCreditsAttempted = 0.0;
      double totalCreditsEarned = 0.0;
      double cumulativeGPA = 0.0;

      // Parse student info
      for (String line in lines) {
        if (line.contains('Name:')) {
          studentName = line.split('Name:')[1].split('Major')[0].trim();
        }
        if (line.contains('ID:')) {
          final match = RegExp(r'ID:\s*(\d+)').firstMatch(line);
          if (match != null) {
            studentId = match.group(1) ?? '';
          }
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

      // Parse courses (simplified - you may need to enhance this based on actual format)
      List<TranscriptCourse> courses = [];
      List<SemesterData> semesters = [];

      // This is a simplified parser - you'll need to enhance based on actual transcript format
      _parseCoursesAndSemesters(lines, courses, semesters);

      return TranscriptData(
        studentName: studentName,
        studentId: studentId,
        major: major,
        minor: minor,
        totalCreditsAttempted: totalCreditsAttempted,
        totalCreditsEarned: totalCreditsEarned,
        cumulativeGPA: cumulativeGPA,
        courses: courses,
        semesters: semesters,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing transcript: $e');
      }
      return null;
    }
  }

  // Parse courses and semesters from text
  void _parseCoursesAndSemesters(
    List<String> lines,
    List<TranscriptCourse> courses,
    List<SemesterData> semesters,
  ) {
    // This is a complex parsing logic that depends on your transcript format
    // For now, implementing a basic structure
    String currentSemester = '';

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();

      // Detect semester headers
      if (_isSemesterHeader(line)) {
        currentSemester = line;
        continue;
      }

      // Parse course lines
      if (_isCourseData(line)) {
        final course = _parseCourseFromLine(line, currentSemester);
        if (course != null) {
          courses.add(course);
        }
      }
    }
  }

  bool _isSemesterHeader(String line) {
    return line.contains('SPRING') ||
        line.contains('SUMMER') ||
        line.contains('AUTUMN') ||
        line.contains('FALL');
  }

  bool _isCourseData(String line) {
    // Check if line contains course code pattern (e.g., CSE101, MAT104)
    return RegExp(r'^[A-Z]{3}\d{3}').hasMatch(line);
  }

  TranscriptCourse? _parseCourseFromLine(String line, String semester) {
    try {
      // This is a simplified parser - adjust based on your actual format
      final parts = line.split(RegExp(r'\s+'));
      if (parts.length < 6) return null;

      return TranscriptCourse(
        courseCode: parts[0],
        courseTitle: parts.sublist(1, parts.length - 5).join(' '),
        type: '', // Extract if available
        grade: parts[parts.length - 5],
        courseCredit: double.tryParse(parts[parts.length - 4]) ?? 0.0,
        creditEarned: double.tryParse(parts[parts.length - 3]) ?? 0.0,
        creditForGPA: double.tryParse(parts[parts.length - 2]) ?? 0.0,
        gradePoint: double.tryParse(parts[parts.length - 1]) ?? 0.0,
        semester: semester,
      );
    } catch (e) {
      return null;
    }
  }

  // Add this method anywhere in the ScholarshipProvider class:

  bool _checkRecentSemesterCredits() {
    if (_transcriptData == null || _transcriptData!.semesters.isEmpty) {
      return false;
    }

    final semesters = _transcriptData!.semesters;

    // Check last 2 semesters (or available semesters if less than 2)
    int semestersToCheck = semesters.length >= 2 ? 2 : semesters.length;

    for (
      int i = semesters.length - semestersToCheck;
      i < semesters.length;
      i++
    ) {
      if (semesters[i].semesterCredits < 12) {
        return false;
      }
    }

    return true;
  }

  // Calculate scholarship eligibility based on IUB policy
  void _calculateScholarshipEligibility() {
    if (_transcriptData == null) return;

    final cgpa = _transcriptData!.cumulativeGPA;
    final creditsEarned = _transcriptData!.totalCreditsEarned;

    List<String> metRequirements = [];
    List<String> unmetRequirements = [];

    // Check minimum credit requirement (36 credits)
    if (creditsEarned >= 36) {
      metRequirements.add(
        'Completed minimum 36 credit hours (${creditsEarned.toStringAsFixed(1)} credits earned)',
      );
    } else {
      unmetRequirements.add(
        'Need to complete 36 credit hours (currently have ${creditsEarned.toStringAsFixed(1)} credits)',
      );
    }
    bool hasValidRecentSemesters = _checkRecentSemesterCredits();
    if (hasValidRecentSemesters) {
      metRequirements.add('Maintained minimum 12 credits in recent semesters');
    } else {
      unmetRequirements.add(
        'Must take at least 12 credits per semester (check last 2 semesters)',
      );
    }

    // Check CGPA requirements for scholarship
    if (cgpa >= 3.70) {
      metRequirements.add(
        'CGPA meets scholarship criteria (${cgpa.toStringAsFixed(2)})',
      );
    } else {
      unmetRequirements.add(
        'CGPA below minimum requirement (current: ${cgpa.toStringAsFixed(2)}, minimum: 3.70)',
      );
    }

    // Determine scholarship percentage based on CGPA
    int scholarshipPercentage = 0;
    if (cgpa >= 3.95) {
      scholarshipPercentage = 100;
    } else if (cgpa >= 3.86) {
      scholarshipPercentage = 75;
    } else if (cgpa >= 3.80) {
      scholarshipPercentage = 50;
    } else if (cgpa >= 3.70) {
      scholarshipPercentage = 30;
    }

    // Create scholarship result
    if (creditsEarned >= 36 && cgpa >= 3.70 && hasValidRecentSemesters) {
      _scholarshipResult = ScholarshipResult.eligible(
        percentage: scholarshipPercentage,
        cgpa: cgpa,
        credits: creditsEarned,
        metRequirements: metRequirements,
      );
    } else {
      String reason = '';
      List<String> reasonParts = [];

      if (creditsEarned < 36) {
        reasonParts.add(
          'You need to complete at least 36 credit hours to be eligible for merit scholarship',
        );
      }
      if (cgpa < 3.70) {
        reasonParts.add(
          'Your CGPA (${cgpa.toStringAsFixed(2)}) is below the minimum requirement of 3.70',
        );
      }
      if (!hasValidRecentSemesters) {
        reasonParts.add(
          'You must maintain at least 12 credits per semester in recent semesters',
        );
      }

      if (reasonParts.length == 1) {
        reason = '${reasonParts[0]}.';
      } else if (reasonParts.length == 2) {
        reason = '${reasonParts[0]} and ${reasonParts[1]}.';
      } else if (reasonParts.length == 3) {
        reason = '${reasonParts[0]}, ${reasonParts[1]}, and ${reasonParts[2]}.';
      }

      _scholarshipResult = ScholarshipResult.notEligible(
        reason: reason,
        cgpa: cgpa,
        credits: creditsEarned,
        unmetRequirements: unmetRequirements,
      );
    }

    notifyListeners();
  }

  // Reset all data
  void resetData() {
    _uploadedFile = null;
    _transcriptData = null;
    _scholarshipResult = null;
    _errorMessage = null;
    _hasProcessedFile = false;
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

  // Get scholarship info for display
  String get displayScholarshipPercentage {
    if (_scholarshipResult == null) return '0%';
    return _scholarshipResult!.displayPercentage;
  }

  String get displayCGPA {
    if (_transcriptData == null) return '0.00';
    return _transcriptData!.cumulativeGPA.toStringAsFixed(2);
  }

  String get displayCreditsEarned {
    if (_transcriptData == null) return '0';
    return _transcriptData!.totalCreditsEarned.toStringAsFixed(0);
  }

  String get scholarshipSummaryMessage {
    if (_scholarshipResult == null) {
      return 'Upload your transcript to check scholarship eligibility';
    }
    return _scholarshipResult!.summaryMessage;
  }

  void expandFaq() {
    _isExpand = !_isExpand;
    notifyListeners();
  }
}
