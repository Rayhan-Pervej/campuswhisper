import 'package:campuswhisper/core/repositories/base_repository.dart';
import 'package:campuswhisper/models/club_model.dart';
import 'package:campuswhisper/core/database/query_builder.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';

class ClubRepository extends BaseRepository<ClubModel> {
  @override
  String get collectionName => 'clubs';

  @override
  ClubModel fromJson(Map<String, dynamic> json) => ClubModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(ClubModel model) => model.toJson();

  @override
  String getId(ClubModel model) => model.id;

  // ═══════════════════════════════════════════════════════════════
  // SPECIALIZED QUERIES
  // ═══════════════════════════════════════════════════════════════

  /// Get clubs by category (with pagination)
  Future<PaginatedResult<ClubModel>> getByCategory(
    String category, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('category', category)],
      sorts: [QuerySort.descending('memberCount')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get clubs by member (with pagination)
  Future<PaginatedResult<ClubModel>> getByMember(
    String userId, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.arrayContains('members', userId)],
      sorts: [QuerySort.descending('createdAt')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get clubs by president (with pagination)
  Future<PaginatedResult<ClubModel>> getByPresident(
    String presidentId, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('presidentId', presidentId)],
      sorts: [QuerySort.descending('createdAt')],
      limit: limit,
      startAfter: startAfter,
    );
  }
}
