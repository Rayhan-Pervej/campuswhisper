import 'package:campuswhisper/core/database/query_builder.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';

/// Abstract database service interface
/// This allows easy migration between Firestore, SQL, MongoDB, etc.
///
/// TO MIGRATE DATABASES:
/// 1. Create new adapter (e.g., SQLAdapter extends DatabaseService)
/// 2. Implement all methods for new database
/// 3. Switch adapter in main.dart
/// 4. App continues working - no repository changes needed!
abstract class DatabaseService {
  /// Initialize database connection
  Future<void> initialize();

  /// Close database connection
  Future<void> close();

  // ═══════════════════════════════════════════════════════════════
  // DOCUMENT OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Create a new document
  /// Returns the generated document ID
  Future<String> create({
    required String collection,
    required Map<String, dynamic> data,
    String? id,
  });

  /// Get a single document by ID
  /// Returns null if not found
  Future<Map<String, dynamic>?> getById({
    required String collection,
    required String id,
  });

  /// Update an existing document
  Future<void> update({
    required String collection,
    required String id,
    required Map<String, dynamic> data,
  });

  /// Delete a document
  Future<void> delete({
    required String collection,
    required String id,
  });

  // ═══════════════════════════════════════════════════════════════
  // QUERY OPERATIONS (with pagination)
  // ═══════════════════════════════════════════════════════════════

  /// Query documents with filters, sorting, pagination
  Future<PaginatedResult<Map<String, dynamic>>> query({
    required String collection,
    List<QueryFilter>? filters,
    List<QuerySort>? sorts,
    int? limit,
    dynamic startAfter, // Cursor for pagination
  });

  /// Count documents matching filters
  Future<int> count({
    required String collection,
    List<QueryFilter>? filters,
  });

  // ═══════════════════════════════════════════════════════════════
  // BATCH OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Execute multiple operations in a transaction
  Future<void> runTransaction(Future<void> Function() operations);

  /// Batch write operations
  Future<void> batchWrite(List<BatchOperation> operations);

  // ═══════════════════════════════════════════════════════════════
  // REAL-TIME SUBSCRIPTIONS
  // ═══════════════════════════════════════════════════════════════

  /// Listen to document changes in real-time
  Stream<Map<String, dynamic>?> listen({
    required String collection,
    required String id,
  });

  /// Listen to query results in real-time
  Stream<List<Map<String, dynamic>>> listenToQuery({
    required String collection,
    List<QueryFilter>? filters,
    List<QuerySort>? sorts,
    int? limit,
  });
}

/// Batch operation types
class BatchOperation {
  final BatchOperationType type;
  final String collection;
  final String? id;
  final Map<String, dynamic>? data;

  BatchOperation({
    required this.type,
    required this.collection,
    this.id,
    this.data,
  });
}

enum BatchOperationType { create, update, delete }
