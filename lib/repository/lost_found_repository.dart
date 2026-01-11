import 'package:campuswhisper/core/repositories/base_repository.dart';
import 'package:campuswhisper/models/lost_found_item_model.dart';
import 'package:campuswhisper/core/database/query_builder.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';

class LostFoundRepository extends BaseRepository<LostFoundItemModel> {
  @override
  String get collectionName => 'lost_found_items';

  @override
  LostFoundItemModel fromJson(Map<String, dynamic> json) => LostFoundItemModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(LostFoundItemModel model) => model.toJson();

  @override
  String getId(LostFoundItemModel model) => model.id;

  // ═══════════════════════════════════════════════════════════════
  // SPECIALIZED QUERIES
  // ═══════════════════════════════════════════════════════════════

  /// Get items by type (Lost or Found) - with pagination
  Future<PaginatedResult<LostFoundItemModel>> getByType(
    String type, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('type', type)],
      sorts: [QuerySort.descending('createdAt')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get items by category - with pagination
  Future<PaginatedResult<LostFoundItemModel>> getByCategory(
    String category, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('category', category)],
      sorts: [QuerySort.descending('createdAt')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get active items (not resolved) - with pagination
  Future<PaginatedResult<LostFoundItemModel>> getActive({
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('status', 'Active')],
      sorts: [QuerySort.descending('createdAt')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get items by user - with pagination
  Future<PaginatedResult<LostFoundItemModel>> getByUser(
    String userId, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('reportedBy', userId)],
      sorts: [QuerySort.descending('createdAt')],
      limit: limit,
      startAfter: startAfter,
    );
  }
}
