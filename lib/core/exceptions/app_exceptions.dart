/// Base exception class for all app exceptions
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AppException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network-related exceptions
class NetworkException extends AppException {
  NetworkException({
    required super.message,
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'NetworkException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Authentication exceptions
class AuthException extends AppException {
  AuthException({
    required super.message,
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'AuthException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Database exceptions
class DatabaseException extends AppException {
  DatabaseException({
    required super.message,
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'DatabaseException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Repository exceptions
class RepositoryException extends AppException {
  RepositoryException({
    required super.message,
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'RepositoryException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Validation exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  ValidationException({
    required super.message,
    super.code,
    super.originalError,
    this.fieldErrors,
  });

  @override
  String toString() {
    if (fieldErrors != null && fieldErrors!.isNotEmpty) {
      return 'ValidationException: $message\nErrors: ${fieldErrors!.entries.map((e) => '${e.key}: ${e.value}').join(', ')}';
    }
    return 'ValidationException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

/// Permission exceptions
class PermissionException extends AppException {
  PermissionException({
    required super.message,
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'PermissionException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Not found exceptions
class NotFoundException extends AppException {
  final String resourceType;
  final String resourceId;

  NotFoundException({
    required this.resourceType,
    required this.resourceId,
    super.code,
    super.originalError,
  }) : super(message: '$resourceType not found: $resourceId');

  @override
  String toString() => 'NotFoundException: $resourceType not found (ID: $resourceId)';
}

/// Cache exceptions
class CacheException extends AppException {
  CacheException({
    required super.message,
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'CacheException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Storage exceptions
class StorageException extends AppException {
  StorageException({
    required super.message,
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'StorageException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// File operation exceptions
class FileException extends AppException {
  final String? filePath;

  FileException({
    required super.message,
    this.filePath,
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'FileException: $message${filePath != null ? ' (File: $filePath)' : ''}${code != null ? ' (Code: $code)' : ''}';
}

/// Timeout exceptions
class TimeoutException extends AppException {
  final Duration timeout;

  TimeoutException({
    required this.timeout,
    super.code,
    super.originalError,
  }) : super(message: 'Operation timed out after ${timeout.inSeconds} seconds');

  @override
  String toString() => 'TimeoutException: Operation timed out after ${timeout.inSeconds} seconds';
}
