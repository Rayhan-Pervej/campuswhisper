import 'package:campuswhisper/core/repositories/base_repository.dart';
import 'package:campuswhisper/models/comment_model.dart';
import 'package:campuswhisper/core/database/query_builder.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';

class CommentRepository extends BaseRepository<CommentModel> {
  @override
  String get collectionName => 'comments';

  @override
  CommentModel fromJson(Map<String, dynamic> json) => CommentModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(CommentModel model) => model.toJson();

  @override
  String getId(CommentModel model) => model.id;

  // ═══════════════════════════════════════════════════════════════
  // SPECIALIZED QUERIES
  // ═══════════════════════════════════════════════════════════════

  /// Get comments by parent (post/event/competition) - with pagination
  Future<PaginatedResult<CommentModel>> getByParent(
    String parentId,
    String parentType, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [
        QueryFilter.equals('parentId', parentId),
        QueryFilter.equals('parentType', parentType),
      ],
      sorts: [QuerySort.descending('createdAt')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get top-level comments (no reply-to) - with pagination
  Future<PaginatedResult<CommentModel>> getTopLevel(
    String parentId,
    String parentType, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [
        QueryFilter.equals('parentId', parentId),
        QueryFilter.equals('parentType', parentType),
        QueryFilter.equals('replyToId', null),
      ],
      sorts: [QuerySort.descending('createdAt')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get replies to a specific comment - with pagination
  Future<PaginatedResult<CommentModel>> getReplies(
    String commentId, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('replyToId', commentId)],
      sorts: [QuerySort.ascending('createdAt')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get comments by user - with pagination
  Future<PaginatedResult<CommentModel>> getByUser(
    String userId, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('authorId', userId)],
      sorts: [QuerySort.descending('createdAt')],
      limit: limit,
      startAfter: startAfter,
    );
  }
}
