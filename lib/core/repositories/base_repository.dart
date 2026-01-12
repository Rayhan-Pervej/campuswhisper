import 'package:campuswhisper/core/database/database_service.dart';
import 'package:campuswhisper/core/database/query_builder.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';
import 'package:campuswhisper/main.dart'; // For global database instance

/// Base repository for all data models
///
/// T = Model type (e.g., PostModel, EventModel)
///
/// This eliminates 80% code duplication across repositories!
/// All common CRUD + pagination logic is here.
abstract class BaseRepository<T> {
  /// Collection name in database
  String get collectionName;

  /// Convert JSON to Model
  T fromJson(Map<String, dynamic> json);

  /// Convert Model to JSON
  Map<String, dynamic> toJson(T model);

  /// Get model ID
  String getId(T model);

  // ═══════════════════════════════════════════════════════════════
  // CRUD OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Create a new document
  Future<String> create(T model) async {
    try {
      final json = toJson(model);
      final modelId = getId(model);
      return await database.create(
        collection: collectionName,
        data: json,
        id: modelId.isEmpty ? null : modelId,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Failed to create ${collectionName.substring(0, collectionName.length - 1)}',
        code: 'CREATE_FAILED',
        originalError: e,
      );
    }
  }

  /// Get document by ID
  Future<T?> getById(String id) async {
    try {
      final json = await database.getById(
        collection: collectionName,
        id: id,
      );

      if (json == null) return null;
      return fromJson(json);
    } catch (e) {
      throw RepositoryException(
        message: 'Failed to get ${collectionName.substring(0, collectionName.length - 1)}',
        code: 'GET_FAILED',
        originalError: e,
      );
    }
  }

  /// Update existing document
  Future<void> update(T model) async {
    try {
      final json = toJson(model);
      await database.update(
        collection: collectionName,
        id: getId(model),
        data: json,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Failed to update ${collectionName.substring(0, collectionName.length - 1)}',
        code: 'UPDATE_FAILED',
        originalError: e,
      );
    }
  }

  /// Delete document
  Future<void> delete(String id) async {
    try {
      await database.delete(
        collection: collectionName,
        id: id,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Failed to delete ${collectionName.substring(0, collectionName.length - 1)}',
        code: 'DELETE_FAILED',
        originalError: e,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // QUERY OPERATIONS (with pagination)
  // ═══════════════════════════════════════════════════════════════

  /// Get all documents (paginated)
  Future<PaginatedResult<T>> getAll({
    List<QuerySort>? sorts,
    int limit = 20,
    dynamic startAfter,
  }) async {
    try {
      final result = await database.query(
        collection: collectionName,
        sorts: sorts,
        limit: limit,
        startAfter: startAfter,
      );

      return result.map((json) => fromJson(json));
    } catch (e) {
      throw RepositoryException(
        message: 'Failed to get all ${collectionName}',
        code: 'QUERY_FAILED',
        originalError: e,
      );
    }
  }

  /// Query with filters (paginated)
  Future<PaginatedResult<T>> query({
    List<QueryFilter>? filters,
    List<QuerySort>? sorts,
    int limit = 20,
    dynamic startAfter,
  }) async {
    try {
      final result = await database.query(
        collection: collectionName,
        filters: filters,
        sorts: sorts,
        limit: limit,
        startAfter: startAfter,
      );

      return result.map((json) => fromJson(json));
    } catch (e) {
      throw RepositoryException(
        message: 'Failed to query ${collectionName}',
        code: 'QUERY_FAILED',
        originalError: e,
      );
    }
  }

  /// Count documents
  Future<int> count({List<QueryFilter>? filters}) async {
    try {
      return await database.count(
        collection: collectionName,
        filters: filters,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Failed to count ${collectionName}',
        code: 'COUNT_FAILED',
        originalError: e,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // REAL-TIME SUBSCRIPTIONS
  // ═══════════════════════════════════════════════════════════════

  /// Listen to document changes
  Stream<T?> listen(String id) {
    return database
        .listen(collection: collectionName, id: id)
        .map((json) => json != null ? fromJson(json) : null);
  }

  /// Listen to query results
  Stream<List<T>> listenToQuery({
    List<QueryFilter>? filters,
    List<QuerySort>? sorts,
    int? limit,
  }) {
    return database
        .listenToQuery(
          collection: collectionName,
          filters: filters,
          sorts: sorts,
          limit: limit,
        )
        .map((jsonList) => jsonList.map((json) => fromJson(json)).toList());
  }
}

/// Repository exception
class RepositoryException implements Exception {
  final String message;
  final String code;
  final dynamic originalError;

  RepositoryException({
    required this.message,
    required this.code,
    this.originalError,
  });

  @override
  String toString() => 'RepositoryException: $message (Code: $code)';
}
