import 'package:campuswhisper/core/repositories/base_repository.dart';
import 'package:campuswhisper/models/posts_model.dart';
import 'package:campuswhisper/core/database/query_builder.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';

class PostRepository extends BaseRepository<PostModel> {
  @override
  String get collectionName => 'posts';

  @override
  PostModel fromJson(Map<String, dynamic> json) => PostModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(PostModel model) => model.toJson();

  @override
  String getId(PostModel model) => model.postId;

  // ═══════════════════════════════════════════════════════════════
  // SPECIALIZED QUERIES (beyond base CRUD)
  // ═══════════════════════════════════════════════════════════════

  /// Get posts by type (with pagination)
  Future<PaginatedResult<PostModel>> getByType(
    String type, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('type', type)],
      sorts: [QuerySort.descending('created_at')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get posts by course (with pagination)
  Future<PaginatedResult<PostModel>> getByCourse(
    String courseId, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('course_id', courseId)],
      sorts: [QuerySort.descending('created_at')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get posts by user (with pagination)
  Future<PaginatedResult<PostModel>> getByUser(
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

  /// Get trending posts (high upvote count)
  Future<PaginatedResult<PostModel>> getTrending({
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
