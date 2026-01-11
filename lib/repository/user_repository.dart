import 'package:campuswhisper/core/repositories/base_repository.dart';
import 'package:campuswhisper/models/user_model.dart';
import 'package:campuswhisper/core/database/query_builder.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';

class UserRepository extends BaseRepository<UserModel> {
  @override
  String get collectionName => 'users';

  @override
  UserModel fromJson(Map<String, dynamic> json) => UserModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(UserModel model) => model.toJson();

  @override
  String getId(UserModel model) => model.id;

  // ═══════════════════════════════════════════════════════════════
  // SPECIALIZED QUERIES
  // ═══════════════════════════════════════════════════════════════

  /// Get users by department (with pagination)
  Future<PaginatedResult<UserModel>> getByDepartment(
    String department, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('department', department)],
      sorts: [QuerySort.ascending('first_name')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get users by university (with pagination)
  Future<PaginatedResult<UserModel>> getByUniversity(
    String university, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('university', university)],
      sorts: [QuerySort.ascending('first_name')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get users by role (with pagination)
  Future<PaginatedResult<UserModel>> getByRole(
    String role, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('role', role)],
      sorts: [QuerySort.ascending('first_name')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get top contributors (sorted by XP)
  Future<PaginatedResult<UserModel>> getTopContributors({
    int limit = 10,
    dynamic startAfter,
  }) async {
    return query(
      sorts: [QuerySort.descending('xp')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get users by department and year
  Future<PaginatedResult<UserModel>> getByDepartmentAndYear(
    String department,
    int year, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [
        QueryFilter.equals('department', department),
        QueryFilter.equals('year', year),
      ],
      sorts: [QuerySort.ascending('first_name')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // USER-SPECIFIC UPDATES
  // ═══════════════════════════════════════════════════════════════

  /// Update last login timestamp for a user
  Future<void> updateLastLogin(String userId) async {
    try {
      // Get the user first
      final user = await getById(userId);
      if (user == null) return;

      // Create updated user with new lastLogin
      final updatedUser = UserModel(
        uid: user.uid,
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        university: user.university,
        department: user.department,
        batch: user.batch,
        xp: user.xp,
        contributions: user.contributions,
        badges: user.badges,
        favoriteCourses: user.favoriteCourses,
        notifyMe: user.notifyMe,
        theme: user.theme,
        role: user.role,
        createdAt: user.createdAt,
        lastLogin: DateTime.now(), // Update this field
      );

      await update(updatedUser);
    } catch (e) {
      throw RepositoryException(
        message: 'Failed to update last login',
        code: 'UPDATE_LAST_LOGIN_FAILED',
        originalError: e,
      );
    }
  }
}
