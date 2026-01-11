import 'package:campuswhisper/core/repositories/base_repository.dart';
import 'package:campuswhisper/core/database/query_builder.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';
import 'package:campuswhisper/models/course_routine_model.dart';

class CourseRoutineRepository extends BaseRepository<SemesterRoutine> {
  @override
  String get collectionName => 'course_routines';

  @override
  SemesterRoutine fromJson(Map<String, dynamic> json) {
    return SemesterRoutine.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(SemesterRoutine model) {
    return model.toJson();
  }

  @override
  String getId(SemesterRoutine model) {
    return model.id;
  }

  /// Get all routines for a specific user
  Future<PaginatedResult<SemesterRoutine>> getUserRoutines({
    required String userId,
    int limit = 20,
    dynamic startAfter,
  }) async {
    return await query(
      filters: [
        QueryFilter(field: 'userId', operator: FilterOperator.equals, value: userId),
        QueryFilter(field: 'isActive', operator: FilterOperator.equals, value: true),
      ],
      sorts: [
        QuerySort(field: 'createdAt', descending: true),
      ],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get a specific semester routine for a user
  Future<SemesterRoutine?> getUserSemester({
    required String userId,
    required String semesterId,
  }) async {
    try {
      final result = await query(
        filters: [
          QueryFilter(field: 'userId', operator: FilterOperator.equals, value: userId),
          QueryFilter(field: 'id', operator: FilterOperator.equals, value: semesterId),
        ],
        limit: 1,
      );

      if (result.items.isEmpty) return null;
      return result.items.first;
    } catch (e) {
      throw RepositoryException(
        message: 'Failed to get user semester',
        code: 'GET_USER_SEMESTER_FAILED',
        originalError: e,
      );
    }
  }

  /// Add a course to a semester
  Future<void> addCourseToSemester({
    required String semesterId,
    required CourseItem course,
  }) async {
    try {
      final semester = await getById(semesterId);
      if (semester == null) {
        throw RepositoryException(
          message: 'Semester not found',
          code: 'SEMESTER_NOT_FOUND',
        );
      }

      final updatedCourses = [...semester.courses, course];
      final updatedSemester = semester.copyWith(
        courses: updatedCourses,
        updatedAt: DateTime.now(),
      );

      await update(updatedSemester);
    } catch (e) {
      throw RepositoryException(
        message: 'Failed to add course to semester',
        code: 'ADD_COURSE_FAILED',
        originalError: e,
      );
    }
  }

  /// Update a course in a semester
  Future<void> updateCourseInSemester({
    required String semesterId,
    required String courseId,
    required CourseItem updatedCourse,
  }) async {
    try {
      final semester = await getById(semesterId);
      if (semester == null) {
        throw RepositoryException(
          message: 'Semester not found',
          code: 'SEMESTER_NOT_FOUND',
        );
      }

      final updatedCourses = semester.courses.map((course) {
        if (course.id == courseId) {
          return updatedCourse;
        }
        return course;
      }).toList();

      final updatedSemester = semester.copyWith(
        courses: updatedCourses,
        updatedAt: DateTime.now(),
      );

      await update(updatedSemester);
    } catch (e) {
      throw RepositoryException(
        message: 'Failed to update course',
        code: 'UPDATE_COURSE_FAILED',
        originalError: e,
      );
    }
  }

  /// Remove a course from a semester
  Future<void> removeCourseFromSemester({
    required String semesterId,
    required String courseId,
  }) async {
    try {
      final semester = await getById(semesterId);
      if (semester == null) {
        throw RepositoryException(
          message: 'Semester not found',
          code: 'SEMESTER_NOT_FOUND',
        );
      }

      final updatedCourses = semester.courses.where((course) => course.id != courseId).toList();
      final updatedSemester = semester.copyWith(
        courses: updatedCourses,
        updatedAt: DateTime.now(),
      );

      await update(updatedSemester);
    } catch (e) {
      throw RepositoryException(
        message: 'Failed to remove course',
        code: 'REMOVE_COURSE_FAILED',
        originalError: e,
      );
    }
  }

  /// Listen to user's routines in real-time
  Stream<List<SemesterRoutine>> listenToUserRoutines({
    required String userId,
  }) {
    return listenToQuery(
      filters: [
        QueryFilter(field: 'userId', operator: FilterOperator.equals, value: userId),
        QueryFilter(field: 'isActive', operator: FilterOperator.equals, value: true),
      ],
      sorts: [
        QuerySort(field: 'createdAt', descending: true),
      ],
    );
  }
}
