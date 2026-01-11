import 'package:campuswhisper/core/providers/base_provider.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';

/// Base provider for paginated lists
///
/// T = Model type (e.g., PostModel, EventModel)
///
/// Handles:
/// - Pagination state (items, cursor, hasMore)
/// - Loading more items
/// - Refreshing
/// - Optimistic UI updates
abstract class PaginatedProvider<T> extends BaseProvider {
  List<T> _items = [];
  dynamic _cursor;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  // ═══════════════════════════════════════════════════════════════
  // GETTERS
  // ═══════════════════════════════════════════════════════════════

  List<T> get items => _items;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
  bool get isEmpty => _items.isEmpty && !isLoading;
  int get itemCount => _items.length;

  // ═══════════════════════════════════════════════════════════════
  // ABSTRACT METHODS (must be implemented by subclasses)
  // ═══════════════════════════════════════════════════════════════

  /// Fetch first page of items
  Future<PaginatedResult<T>> fetchFirstPage();

  /// Fetch next page of items
  Future<PaginatedResult<T>> fetchNextPage(dynamic cursor);

  // ═══════════════════════════════════════════════════════════════
  // PAGINATION METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Load initial data (first page)
  Future<void> loadInitial() async {
    setLoading();

    try {
      final result = await fetchFirstPage();

      _items = result.items;
      _cursor = result.cursor;
      _hasMore = result.hasMore;

      setLoaded();
    } catch (e) {
      setError(e.toString());
    }
  }

  /// Load more items (next page)
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || isLoading) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final result = await fetchNextPage(_cursor);

      _items.addAll(result.items);
      _cursor = result.cursor;
      _hasMore = result.hasMore;

      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMore = false;
      setError(e.toString());
    }
  }

  /// Refresh data (reset to first page)
  Future<void> refresh() async {
    _items.clear();
    _cursor = null;
    _hasMore = true;
    notifyListeners();

    await loadInitial();
  }

  // ═══════════════════════════════════════════════════════════════
  // LIST MANIPULATION (for optimistic UI updates)
  // ═══════════════════════════════════════════════════════════════

  /// Add item to the beginning of the list
  void addItem(T item) {
    _items.insert(0, item);
    notifyListeners();
  }

  /// Update item in the list
  void updateItem(T item, bool Function(T) matcher) {
    final index = _items.indexWhere(matcher);
    if (index != -1) {
      _items[index] = item;
      notifyListeners();
    }
  }

  /// Remove item from the list
  void removeItem(bool Function(T) matcher) {
    _items.removeWhere(matcher);
    notifyListeners();
  }

  /// Clear all items
  void clearItems() {
    _items.clear();
    _cursor = null;
    _hasMore = true;
    notifyListeners();
  }

  /// Replace all items
  void setItems(List<T> items) {
    _items = items;
    notifyListeners();
  }
}
