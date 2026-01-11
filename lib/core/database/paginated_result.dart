/// Paginated result wrapper for database queries
///
/// This standardizes pagination across all database types
class PaginatedResult<T> {
  final List<T> items;
  final dynamic cursor; // Next page cursor (can be DocumentSnapshot, int offset, etc.)
  final bool hasMore;
  final int totalCount; // Optional: total items (if available)

  const PaginatedResult({
    required this.items,
    this.cursor,
    required this.hasMore,
    this.totalCount = 0,
  });

  /// Empty result
  factory PaginatedResult.empty() => PaginatedResult(
        items: [],
        cursor: null,
        hasMore: false,
        totalCount: 0,
      );

  /// Check if result is empty
  bool get isEmpty => items.isEmpty;

  /// Check if result is not empty
  bool get isNotEmpty => items.isNotEmpty;

  /// Number of items in current page
  int get length => items.length;

  /// Map items to different type
  PaginatedResult<R> map<R>(R Function(T) mapper) {
    return PaginatedResult<R>(
      items: items.map(mapper).toList(),
      cursor: cursor,
      hasMore: hasMore,
      totalCount: totalCount,
    );
  }
}
