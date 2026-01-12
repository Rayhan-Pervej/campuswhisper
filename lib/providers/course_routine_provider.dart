// import 'package:campuswhisper/core/providers/paginated_provider.dart';
// import 'package:campuswhisper/core/database/paginated_result.dart';
// import 'package:campuswhisper/models/course_routine_model.dart';
// import 'package:campuswhisper/repository/course_routine_repository.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class CourseRoutineProvider extends PaginatedProvider<SemesterRoutine> {
//   final CourseRoutineRepository _repository = CourseRoutineRepository();
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // ═══════════════════════════════════════════════════════════════
//   // REQUIRED OVERRIDES from PaginatedProvider
//   // ═══════════════════════════════════════════════════════════════

//   @override
//   Future<PaginatedResult<SemesterRoutine>> fetchFirstPage() async {
//     final userId = _auth.currentUser?.uid;
//     if (userId == null) {
//       throw Exception('User not authenticated');
//     }

//     return await _repository.getUserRoutines(
//       userId: userId,
//       limit: 20,
//     );
//   }

//   @override
//   Future<PaginatedResult<SemesterRoutine>> fetchNextPage(cursor) async {
//     final userId = _auth.currentUser?.uid;
//     if (userId == null) {
//       throw Exception('User not authenticated');
//     }

//     return await _repository.getUserRoutines(
//       userId: userId,
//       limit: 20,
//       startAfter: cursor,
//     );
//   }

//   // ═══════════════════════════════════════════════════════════════
//   // SEMESTER OPERATIONS
//   // ═══════════════════════════════════════════════════════════════

//   /// Add a new semester
//   Future<void> addSemester(String semesterName) async {
//     final userId = _auth.currentUser?.uid;
//     if (userId == null) {
//       throw Exception('User not authenticated');
//     }

//     setLoading();

//     try {
//       final newSemester = SemesterRoutine(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         userId: userId,
//         semesterName: semesterName,
//         courses: [],
//         createdAt: DateTime.now(),
//         isActive: true,
//       );

//       // Save to backend
//       await _repository.create(newSemester);

//       // Optimistic UI update
//       addItem(newSemester);

//       setLoaded();
//     } catch (e) {
//       setError('Failed to add semester: ${e.toString()}');
//     }
//   }

//   /// Update semester name
//   Future<void> updateSemester(String semesterId, String newName) async {
//     setLoading();

//     try {
//       final semester = items.firstWhere((s) => s.id == semesterId);
//       final updatedSemester = semester.copyWith(
//         semesterName: newName,
//         updatedAt: DateTime.now(),
//       );

//       // Update in backend
//       await _repository.update(updatedSemester);

//       // Update in local list
//       updateItem(updatedSemester, (s) => s.id == semesterId);

//       setLoaded();
//     } catch (e) {
//       setError('Failed to update semester: ${e.toString()}');
//     }
//   }

//   /// Delete a semester
//   Future<void> deleteSemester(String semesterId) async {
//     setLoading();

//     try {
//       // Delete from backend
//       await _repository.delete(semesterId);

//       // Remove from local list
//       removeItem((s) => s.id == semesterId);

//       setLoaded();
//     } catch (e) {
//       setError('Failed to delete semester: ${e.toString()}');
//     }
//   }

//   // ═══════════════════════════════════════════════════════════════
//   // COURSE OPERATIONS
//   // ═══════════════════════════════════════════════════════════════

//   /// Add a course to a semester
//   Future<void> addCourse({
//     required String semesterId,
//     required Map<String, dynamic> courseData,
//   }) async {
//     setLoading();

//     try {
//       // Convert schedule maps to ClassSchedule objects
//       final scheduleList = courseData['schedule'] as List<dynamic>? ?? [];
//       final schedule = scheduleList.map((s) {
//         if (s is Map<String, dynamic>) {
//           return ClassSchedule.fromJson(s);
//         }
//         return s as ClassSchedule;
//       }).toList();

//       final newCourse = CourseItem(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         courseName: courseData['courseName'] ?? '',
//         courseCode: courseData['courseCode'] ?? '',
//         instructor: courseData['instructor'] ?? '',
//         section: courseData['section'] ?? '',
//         credit: (courseData['credit'] is String)
//             ? double.tryParse(courseData['credit']) ?? 0.0
//             : (courseData['credit'] ?? 0.0).toDouble(),
//         schedule: schedule,
//         room: courseData['room'],
//         notes: courseData['notes'],
//       );

//       // Update in backend
//       await _repository.addCourseToSemester(
//         semesterId: semesterId,
//         course: newCourse,
//       );

//       // Update local state
//       final semester = items.firstWhere((s) => s.id == semesterId);
//       final updatedCourses = [...semester.courses, newCourse];
//       final updatedSemester = semester.copyWith(
//         courses: updatedCourses,
//         updatedAt: DateTime.now(),
//       );
//       updateItem(updatedSemester, (s) => s.id == semesterId);

//       setLoaded();
//     } catch (e) {
//       setError('Failed to add course: ${e.toString()}');
//     }
//   }

//   /// Update a course
//   Future<void> updateCourse({
//     required String semesterId,
//     required String courseId,
//     required Map<String, dynamic> courseData,
//   }) async {
//     setLoading();

//     try {
//       final semester = items.firstWhere((s) => s.id == semesterId);
//       final oldCourse = semester.courses.firstWhere((c) => c.id == courseId);

//       // Convert schedule maps to ClassSchedule objects if provided
//       List<ClassSchedule> schedule = oldCourse.schedule;
//       if (courseData['schedule'] != null) {
//         final scheduleList = courseData['schedule'] as List<dynamic>;
//         schedule = scheduleList.map((s) {
//           if (s is Map<String, dynamic>) {
//             return ClassSchedule.fromJson(s);
//           }
//           return s as ClassSchedule;
//         }).toList();
//       }

//       final updatedCourse = CourseItem(
//         id: courseId,
//         courseName: courseData['courseName'] ?? oldCourse.courseName,
//         courseCode: courseData['courseCode'] ?? oldCourse.courseCode,
//         instructor: courseData['instructor'] ?? oldCourse.instructor,
//         section: courseData['section'] ?? oldCourse.section,
//         credit: courseData['credit'] != null
//             ? (courseData['credit'] is String)
//                 ? double.tryParse(courseData['credit']) ?? oldCourse.credit
//                 : (courseData['credit'] as num).toDouble()
//             : oldCourse.credit,
//         schedule: schedule,
//         room: courseData['room'] ?? oldCourse.room,
//         notes: courseData['notes'] ?? oldCourse.notes,
//       );

//       // Update in backend
//       await _repository.updateCourseInSemester(
//         semesterId: semesterId,
//         courseId: courseId,
//         updatedCourse: updatedCourse,
//       );

//       // Update local state
//       final updatedCourses = semester.courses.map((c) {
//         if (c.id == courseId) return updatedCourse;
//         return c;
//       }).toList();

//       final updatedSemester = semester.copyWith(
//         courses: updatedCourses,
//         updatedAt: DateTime.now(),
//       );
//       updateItem(updatedSemester, (s) => s.id == semesterId);

//       setLoaded();
//     } catch (e) {
//       setError('Failed to update course: ${e.toString()}');
//     }
//   }

//   /// Delete a course from a semester
//   Future<void> deleteCourse({
//     required String semesterId,
//     required String courseId,
//   }) async {
//     setLoading();

//     try {
//       // Delete from backend
//       await _repository.removeCourseFromSemester(
//         semesterId: semesterId,
//         courseId: courseId,
//       );

//       // Update local state
//       final semester = items.firstWhere((s) => s.id == semesterId);
//       final updatedCourses = semester.courses.where((c) => c.id != courseId).toList();
//       final updatedSemester = semester.copyWith(
//         courses: updatedCourses,
//         updatedAt: DateTime.now(),
//       );
//       updateItem(updatedSemester, (s) => s.id == semesterId);

//       setLoaded();
//     } catch (e) {
//       setError('Failed to delete course: ${e.toString()}');
//     }
//   }

//   // ═══════════════════════════════════════════════════════════════
//   // HELPER METHODS
//   // ═══════════════════════════════════════════════════════════════

//   /// Get a specific semester by ID
//   SemesterRoutine? getSemesterById(String semesterId) {
//     try {
//       return items.firstWhere((s) => s.id == semesterId);
//     } catch (e) {
//       return null;
//     }
//   }

//   /// Get total credits across all semesters
//   double get totalCredits {
//     return items.fold(0.0, (total, semester) => total + semester.totalCredits);
//   }

//   /// Get total courses across all semesters
//   int get totalCourses {
//     return items.fold(0, (total, semester) => total + semester.totalCourses);
//   }

//   /// Check if any semester has courses (for showing delete mode button)
//   bool get hasAnyCourses {
//     return items.any((semester) => semester.courses.isNotEmpty);
//   }
// }
