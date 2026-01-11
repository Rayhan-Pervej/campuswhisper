import 'package:campuswhisper/core/repositories/base_repository.dart';
import 'package:campuswhisper/models/hack_model.dart';
import 'package:campuswhisper/core/database/query_builder.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';

class HackRepository extends BaseRepository<HackModel> {
  @override
  String get collectionName => 'hacks';

  @override
  HackModel fromJson(Map<String, dynamic> json) => HackModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(HackModel model) => model.toJson();

  @override
  String getId(HackModel model) => model.id;

  // ═══════════════════════════════════════════════════════════════
  // SPECIALIZED QUERIES
  // ═══════════════════════════════════════════════════════════════

  /// Get hacks by tag (with pagination)
  Future<PaginatedResult<HackModel>> getByTag(
    String tag, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('tag', tag)],
      sorts: [QuerySort.descending('created_at')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get hacks by user (with pagination)
  Future<PaginatedResult<HackModel>> getByUser(
    String userId, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('created_by', userId)],
      sorts: [QuerySort.descending('created_at')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get most popular hacks (sorted by upvotes)
  Future<PaginatedResult<HackModel>> getPopular({
    int limit = 10,
    dynamic startAfter,
  }) async {
    return query(
      sorts: [QuerySort.descending('upvote_count')],
      limit: limit,
      startAfter: startAfter,
    );
  }
}