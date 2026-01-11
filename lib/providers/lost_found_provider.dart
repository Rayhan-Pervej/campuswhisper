import 'package:flutter/material.dart';
import 'package:campuswhisper/core/providers/paginated_provider.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';
import 'package:campuswhisper/models/lost_found_item_model.dart';
import 'package:campuswhisper/repository/lost_found_repository.dart';
import 'package:campuswhisper/core/database/query_builder.dart';

class LostFoundProvider extends PaginatedProvider<LostFoundItemModel> {
  final LostFoundRepository _repository = LostFoundRepository();

  String? _currentType; // 'Lost' or 'Found'
  String? _currentCategory;
  bool _showActiveOnly = true;

  // ═══════════════════════════════════════════════════════════════
  // PAGINATION IMPLEMENTATION
  // ═══════════════════════════════════════════════════════════════

  @override
  Future<PaginatedResult<LostFoundItemModel>> fetchFirstPage() async {
    if (_showActiveOnly) {
      return await _repository.getActive(limit: 20);
    } else if (_currentType != null) {
      return await _repository.getByType(_currentType!, limit: 20);
    } else if (_currentCategory != null) {
      return await _repository.getByCategory(_currentCategory!, limit: 20);
    } else {
      return await _repository.getAll(
        sorts: [QuerySort.descending('createdAt')],
        limit: 20,
      );
    }
  }

  @override
  Future<PaginatedResult<LostFoundItemModel>> fetchNextPage(cursor) async {
    if (_showActiveOnly) {
      return await _repository.getActive(limit: 20, startAfter: cursor);
    } else if (_currentType != null) {
      return await _repository.getByType(
        _currentType!,
        limit: 20,
        startAfter: cursor,
      );
    } else if (_currentCategory != null) {
      return await _repository.getByCategory(
        _currentCategory!,
        limit: 20,
        startAfter: cursor,
      );
    } else {
      return await _repository.getAll(
        sorts: [QuerySort.descending('createdAt')],
        limit: 20,
        startAfter: cursor,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // CRUD OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  Future<void> createLostFoundItem(BuildContext context, LostFoundItemModel item) async {
    final itemId = await safeOperation(
      context,
      operation: () => _repository.create(item),
      successMessage: 'Item reported successfully!',
      errorMessage: 'Failed to report item. Please try again.',
    );

    if (itemId != null) {
      addItem(item);
    }
  }

  Future<void> updateLostFoundItem(BuildContext context, LostFoundItemModel item) async {
    await safeOperation(
      context,
      operation: () => _repository.update(item),
      successMessage: 'Item updated successfully!',
      errorMessage: 'Failed to update item. Please try again.',
    );

    updateItem(item, (i) => i.id == item.id);
  }

  Future<void> deleteLostFoundItem(BuildContext context, String itemId) async {
    await safeOperation(
      context,
      operation: () => _repository.delete(itemId),
      successMessage: 'Item deleted successfully!',
      errorMessage: 'Failed to delete item. Please try again.',
    );

    removeItem((i) => i.id == itemId);
  }

  Future<LostFoundItemModel?> getItemById(String itemId) async {
    return await _repository.getById(itemId);
  }

  // ═══════════════════════════════════════════════════════════════
  // LOST & FOUND SPECIFIC OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  Future<void> markAsResolved(
    BuildContext context,
    String itemId,
  ) async {
    // TODO: Implement mark as resolved logic
    showSuccess(context, 'Item marked as resolved!');
  }

  Future<void> contactPoster(
    BuildContext context,
    String itemId,
    String message,
  ) async {
    // TODO: Implement contact poster logic
    showSuccess(context, 'Message sent to poster!');
  }

  // ═══════════════════════════════════════════════════════════════
  // FILTER METHODS
  // ═══════════════════════════════════════════════════════════════

  Future<void> filterByType(String type) async {
    _currentType = type;
    _currentCategory = null;
    _showActiveOnly = false;
    await refresh();
  }

  Future<void> filterByCategory(String category) async {
    _currentCategory = category;
    _currentType = null;
    _showActiveOnly = false;
    await refresh();
  }

  Future<void> showActive() async {
    _showActiveOnly = true;
    _currentType = null;
    _currentCategory = null;
    await refresh();
  }

  Future<void> clearFilters() async {
    _currentType = null;
    _currentCategory = null;
    _showActiveOnly = true;
    await refresh();
  }

  /// Get items reported by user
  Future<List<LostFoundItemModel>> getUserItems(String userId) async {
    final result = await _repository.getByUser(userId, limit: 100);
    return result.items;
  }
}
