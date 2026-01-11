/// Query filter for database operations
class QueryFilter {
  final String field;
  final FilterOperator operator;
  final dynamic value;

  const QueryFilter({
    required this.field,
    required this.operator,
    required this.value,
  });

  // Factory constructors for common filters
  factory QueryFilter.equals(String field, dynamic value) =>
      QueryFilter(field: field, operator: FilterOperator.equals, value: value);

  factory QueryFilter.greaterThan(String field, dynamic value) =>
      QueryFilter(field: field, operator: FilterOperator.greaterThan, value: value);

  factory QueryFilter.lessThan(String field, dynamic value) =>
      QueryFilter(field: field, operator: FilterOperator.lessThan, value: value);

  factory QueryFilter.arrayContains(String field, dynamic value) =>
      QueryFilter(field: field, operator: FilterOperator.arrayContains, value: value);

  factory QueryFilter.isIn(String field, List<dynamic> values) =>
      QueryFilter(field: field, operator: FilterOperator.isIn, value: values);
}

enum FilterOperator {
  equals,
  notEquals,
  greaterThan,
  greaterThanOrEqual,
  lessThan,
  lessThanOrEqual,
  arrayContains,
  arrayContainsAny,
  isIn,
  isNotIn,
}

/// Query sorting
class QuerySort {
  final String field;
  final bool descending;

  const QuerySort({
    required this.field,
    this.descending = false,
  });

  factory QuerySort.ascending(String field) =>
      QuerySort(field: field, descending: false);

  factory QuerySort.descending(String field) =>
      QuerySort(field: field, descending: true);
}
