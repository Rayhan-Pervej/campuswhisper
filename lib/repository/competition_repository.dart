import 'package:campuswhisper/core/repositories/base_repository.dart';
import 'package:campuswhisper/models/competition_model.dart';
import 'package:campuswhisper/core/database/query_builder.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';

class CompetitionRepository extends BaseRepository<CompetitionModel> {
  @override
  String get collectionName => 'competitions';

  @override
  CompetitionModel fromJson(Map<String, dynamic> json) => CompetitionModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(CompetitionModel model) => model.toJson();

  @override
  String getId(CompetitionModel model) => model.id;

  // ═══════════════════════════════════════════════════════════════
  // SPECIALIZED QUERIES
  // ═══════════════════════════════════════════════════════════════

  /// Get competitions by status (with pagination)
  Future<PaginatedResult<CompetitionModel>> getByStatus(
    String status, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('status', status)],
      sorts: [QuerySort.descending('deadline')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get active competitions with open registration (with pagination)
  Future<PaginatedResult<CompetitionModel>> getRegistrationOpen({
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [
        QueryFilter.equals('status', 'Active'),
        QueryFilter.greaterThan('deadline', DateTime.now()),
      ],
      sorts: [QuerySort.ascending('deadline')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get competitions by organizer (with pagination)
  Future<PaginatedResult<CompetitionModel>> getByOrganizer(
    String organizerId, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('organizerId', organizerId)],
      sorts: [QuerySort.descending('createdAt')],
      limit: limit,
      startAfter: startAfter,
    );
  }
}
