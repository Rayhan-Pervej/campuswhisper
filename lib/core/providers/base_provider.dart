import 'package:flutter/material.dart';
import 'package:campuswhisper/core/utils/snackbar_helper.dart';

/// Provider states
enum ProviderState {
  initial,
  loading,
  loaded,
  error,
}

/// Base provider with user feedback capabilities
///
/// All providers should extend this to get:
/// - Loading states
/// - Error handling
/// - User feedback (success/error/warning/info messages)
/// - Safe operation wrapper
abstract class BaseProvider extends ChangeNotifier {
  ProviderState _state = ProviderState.initial;
  String? _errorMessage;

  // ═══════════════════════════════════════════════════════════════
  // STATE GETTERS
  // ═══════════════════════════════════════════════════════════════

  ProviderState get state => _state;
  String? get errorMessage => _errorMessage;

  bool get isInitial => _state == ProviderState.initial;
  bool get isLoading => _state == ProviderState.loading;
  bool get isLoaded => _state == ProviderState.loaded;
  bool get hasError => _state == ProviderState.error;

  // ═══════════════════════════════════════════════════════════════
  // STATE SETTERS
  // ═══════════════════════════════════════════════════════════════

  void setLoading() {
    _state = ProviderState.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void setLoaded() {
    _state = ProviderState.loaded;
    _errorMessage = null;
    notifyListeners();
  }

  void setError(String message) {
    _state = ProviderState.error;
    _errorMessage = message;
    notifyListeners();
  }

  void setInitial() {
    _state = ProviderState.initial;
    _errorMessage = null;
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════
  // USER FEEDBACK METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Show success message to user
  void showSuccess(BuildContext context, String message) {
    if (!context.mounted) return;
    SnackbarHelper.showSuccess(context, message);
  }

  /// Show error message to user
  void showError(BuildContext context, String message) {
    if (!context.mounted) return;
    SnackbarHelper.showError(context, message);
  }

  /// Show warning message to user
  void showWarning(BuildContext context, String message) {
    if (!context.mounted) return;
    SnackbarHelper.showWarning(context, message);
  }

  /// Show info message to user
  void showInfo(BuildContext context, String message) {
    if (!context.mounted) return;
    SnackbarHelper.showInfo(context, message);
  }

  // ═══════════════════════════════════════════════════════════════
  // SAFE OPERATION WRAPPER
  // ═══════════════════════════════════════════════════════════════

  /// Execute an operation with automatic error handling and user feedback
  ///
  /// Example:
  /// ```dart
  /// await safeOperation(
  ///   context,
  ///   operation: () => repository.create(post),
  ///   successMessage: 'Post created successfully!',
  ///   errorMessage: 'Failed to create post',
  /// );
  /// ```
  Future<T?> safeOperation<T>(
    BuildContext context, {
    required Future<T> Function() operation,
    String? successMessage,
    String? errorMessage,
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) setLoading();

      final result = await operation();

      if (showLoading) setLoaded();

      if (successMessage != null && context.mounted) {
        showSuccess(context, successMessage);
      }

      return result;
    } catch (e) {
      final message = errorMessage ?? 'Something went wrong';
      setError(e.toString());

      if (context.mounted) {
        showError(context, message);
      }

      return null;
    }
  }

  /// Execute an operation without changing provider state
  /// (useful for operations that don't affect main loading state)
  Future<T?> safeOperationQuiet<T>(
    BuildContext context, {
    required Future<T> Function() operation,
    String? successMessage,
    String? errorMessage,
  }) async {
    return safeOperation(
      context,
      operation: operation,
      successMessage: successMessage,
      errorMessage: errorMessage,
      showLoading: false,
    );
  }
}
