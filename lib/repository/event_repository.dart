import 'package:campuswhisper/core/repositories/base_repository.dart';
import 'package:campuswhisper/models/event_model.dart';
import 'package:campuswhisper/core/database/query_builder.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';

class EventRepository extends BaseRepository<EventModel> {
  @override
  String get collectionName => 'events';

  @override
  EventModel fromJson(Map<String, dynamic> json) => EventModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(EventModel model) => model.toJson();

  @override
  String getId(EventModel model) => model.id;

  // ═══════════════════════════════════════════════════════════════
  // SPECIALIZED QUERIES
  // ═══════════════════════════════════════════════════════════════

  /// Get events by category (with pagination)
  Future<PaginatedResult<EventModel>> getByCategory(
    String category, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('category', category)],
      sorts: [QuerySort.ascending('eventDate')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get upcoming events (with pagination)
  Future<PaginatedResult<EventModel>> getUpcoming({
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [
        QueryFilter.greaterThan('eventDate', DateTime.now()),
      ],
      sorts: [QuerySort.ascending('eventDate')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get events by organizer (with pagination)
  Future<PaginatedResult<EventModel>> getByOrganizer(
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
