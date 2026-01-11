import 'package:campuswhisper/core/repositories/base_repository.dart';
import 'package:campuswhisper/models/faq_model.dart';
import 'package:campuswhisper/core/database/query_builder.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';

class FAQRepository extends BaseRepository<FAQModel> {
  @override
  String get collectionName => 'faqs';

  @override
  FAQModel fromJson(Map<String, dynamic> json) => FAQModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(FAQModel model) => model.toJson();

  @override
  String getId(FAQModel model) => model.id;

  // ═══════════════════════════════════════════════════════════════
  // SPECIALIZED QUERIES
  // ═══════════════════════════════════════════════════════════════

  /// Get FAQs by user (with pagination)
  Future<PaginatedResult<FAQModel>> getByUser(
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

  /// Get most popular FAQs (sorted by upvotes)
  Future<PaginatedResult<FAQModel>> getPopular({
    int limit = 10,
    dynamic startAfter,
  }) async {
    return query(
      sorts: [QuerySort.descending('upvote_count')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get recent FAQs
  Future<PaginatedResult<FAQModel>> getRecent({
    int limit = 5,
    dynamic startAfter,
  }) async {
    return query(
      sorts: [QuerySort.descending('created_at')],
      limit: limit,
      startAfter: startAfter,
    );
  }
}
