import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campuswhisper/core/database/database_service.dart';
import 'package:campuswhisper/core/database/query_builder.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';

/// Firestore implementation of DatabaseService
///
/// This is the current implementation.
/// To migrate to SQL: Create SQLAdapter with same interface
class FirestoreAdapter implements DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> initialize() async {
    // Configure Firestore settings
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  @override
  Future<void> close() async {
    // Firestore doesn't need explicit closing
    // But SQL databases would close connection here
  }

  @override
  Future<String> create({
    required String collection,
    required Map<String, dynamic> data,
    String? id,
  }) async {
    try {
      DocumentReference docRef = id != null && id.isNotEmpty
          ? _firestore.collection(collection).doc(id)
          : _firestore.collection(collection).doc();

      // Prepare data with timestamps if not already present
      final Map<String, dynamic> dataToSave = {
        ...data,
      };

      // Only add server timestamps if not already set
      if (!dataToSave.containsKey('created_at') && !dataToSave.containsKey('createdAt')) {
        dataToSave['created_at'] = FieldValue.serverTimestamp();
      }
      if (!dataToSave.containsKey('updated_at') && !dataToSave.containsKey('updatedAt')) {
        dataToSave['updated_at'] = FieldValue.serverTimestamp();
      }

      await docRef.set(dataToSave);

      return docRef.id;
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to create document',
        code: 'CREATE_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<Map<String, dynamic>?> getById({
    required String collection,
    required String id,
  }) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(collection).doc(id).get();

      if (!doc.exists) return null;

      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to get document',
        code: 'GET_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> update({
    required String collection,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).doc(id).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to update document',
        code: 'UPDATE_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> delete({
    required String collection,
    required String id,
  }) async {
    try {
      await _firestore.collection(collection).doc(id).delete();
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to delete document',
        code: 'DELETE_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<PaginatedResult<Map<String, dynamic>>> query({
    required String collection,
    List<QueryFilter>? filters,
    List<QuerySort>? sorts,
    int? limit,
    dynamic startAfter,
  }) async {
    try {
      Query query = _firestore.collection(collection);

      // Apply filters
      if (filters != null) {
        for (var filter in filters) {
          query = _applyFilter(query, filter);
        }
      }

      // Apply sorting
      if (sorts != null) {
        for (var sort in sorts) {
          query = query.orderBy(sort.field, descending: sort.descending);
        }
      }

      // Apply pagination cursor
      if (startAfter != null && startAfter is DocumentSnapshot) {
        query = query.startAfterDocument(startAfter);
      }

      // Apply limit (+1 to check if more exist)
      final pageSize = limit ?? 20;
      query = query.limit(pageSize + 1);

      QuerySnapshot snapshot = await query.get();

      // Check if more pages exist
      bool hasMore = snapshot.docs.length > pageSize;
      List<DocumentSnapshot> docs = snapshot.docs;

      if (hasMore) {
        docs = docs.sublist(0, pageSize);
      }

      return PaginatedResult<Map<String, dynamic>>(
        items: docs.map((doc) => doc.data() as Map<String, dynamic>).toList(),
        cursor: docs.isNotEmpty ? docs.last : null,
        hasMore: hasMore,
      );
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to query documents',
        code: 'QUERY_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<int> count({
    required String collection,
    List<QueryFilter>? filters,
  }) async {
    try {
      Query query = _firestore.collection(collection);

      if (filters != null) {
        for (var filter in filters) {
          query = _applyFilter(query, filter);
        }
      }

      AggregateQuerySnapshot snapshot = await query.count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to count documents',
        code: 'COUNT_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> runTransaction(Future<void> Function() operations) async {
    try {
      await _firestore.runTransaction((transaction) async {
        await operations();
      });
    } catch (e) {
      throw DatabaseException(
        message: 'Transaction failed',
        code: 'TRANSACTION_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> batchWrite(List<BatchOperation> operations) async {
    try {
      WriteBatch batch = _firestore.batch();

      for (var op in operations) {
        switch (op.type) {
          case BatchOperationType.create:
            batch.set(_firestore.collection(op.collection).doc(op.id), op.data!);
            break;
          case BatchOperationType.update:
            batch.update(_firestore.collection(op.collection).doc(op.id!), op.data!);
            break;
          case BatchOperationType.delete:
            batch.delete(_firestore.collection(op.collection).doc(op.id!));
            break;
        }
      }

      await batch.commit();
    } catch (e) {
      throw DatabaseException(
        message: 'Batch write failed',
        code: 'BATCH_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Stream<Map<String, dynamic>?> listen({
    required String collection,
    required String id,
  }) {
    return _firestore
        .collection(collection)
        .doc(id)
        .snapshots()
        .map((doc) => doc.data());
  }

  @override
  Stream<List<Map<String, dynamic>>> listenToQuery({
    required String collection,
    List<QueryFilter>? filters,
    List<QuerySort>? sorts,
    int? limit,
  }) {
    Query query = _firestore.collection(collection);

    if (filters != null) {
      for (var filter in filters) {
        query = _applyFilter(query, filter);
      }
    }

    if (sorts != null) {
      for (var sort in sorts) {
        query = query.orderBy(sort.field, descending: sort.descending);
      }
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════

  Query _applyFilter(Query query, QueryFilter filter) {
    switch (filter.operator) {
      case FilterOperator.equals:
        return query.where(filter.field, isEqualTo: filter.value);
      case FilterOperator.notEquals:
        return query.where(filter.field, isNotEqualTo: filter.value);
      case FilterOperator.greaterThan:
        return query.where(filter.field, isGreaterThan: filter.value);
      case FilterOperator.greaterThanOrEqual:
        return query.where(filter.field, isGreaterThanOrEqualTo: filter.value);
      case FilterOperator.lessThan:
        return query.where(filter.field, isLessThan: filter.value);
      case FilterOperator.lessThanOrEqual:
        return query.where(filter.field, isLessThanOrEqualTo: filter.value);
      case FilterOperator.arrayContains:
        return query.where(filter.field, arrayContains: filter.value);
      case FilterOperator.arrayContainsAny:
        return query.where(filter.field, arrayContainsAny: filter.value);
      case FilterOperator.isIn:
        return query.where(filter.field, whereIn: filter.value);
      case FilterOperator.isNotIn:
        return query.where(filter.field, whereNotIn: filter.value);
    }
  }
}

/// Custom database exception
class DatabaseException implements Exception {
  final String message;
  final String code;
  final dynamic originalError;

  DatabaseException({
    required this.message,
    required this.code,
    this.originalError,
  });

  @override
  String toString() => 'DatabaseException: $message (Code: $code)';
}
