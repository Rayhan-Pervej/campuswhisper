import 'package:flutter/material.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';

class DialogHelper {
  // Show confirmation dialog (Yes/No)
  static Future<bool> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) async {
    final colorScheme = Theme.of(context).colorScheme;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: AppDimensions.titleFontSize,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: AppDimensions.bodyFontSize,
            color: colorScheme.onSurface.withAlpha(179),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              cancelText,
              style: TextStyle(
                color: colorScheme.onSurface.withAlpha(153),
                fontSize: AppDimensions.bodyFontSize,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radius8),
              ),
            ),
            child: Text(
              confirmText,
              style: TextStyle(
                color: Colors.white,
                fontSize: AppDimensions.bodyFontSize,
              ),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  // Show delete confirmation dialog
  static Future<bool> showDeleteConfirmation(
    BuildContext context, {
    required String itemName,
    String? customMessage,
  }) async {
    final colorScheme = Theme.of(context).colorScheme;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
        ),
        title: Text(
          'Delete $itemName?',
          style: TextStyle(
            fontSize: AppDimensions.titleFontSize,
            fontWeight: FontWeight.bold,
            color: colorScheme.error,
          ),
        ),
        content: Text(
          customMessage ?? 'This action cannot be undone. Are you sure you want to delete this $itemName?',
          style: TextStyle(
            fontSize: AppDimensions.bodyFontSize,
            color: colorScheme.onSurface.withAlpha(179),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: colorScheme.onSurface.withAlpha(153),
                fontSize: AppDimensions.bodyFontSize,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radius8),
              ),
            ),
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: AppDimensions.bodyFontSize,
              ),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  // Show alert/info dialog
  static Future<void> showAlert(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) async {
    final colorScheme = Theme.of(context).colorScheme;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: AppDimensions.titleFontSize,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: AppDimensions.bodyFontSize,
            color: colorScheme.onSurface.withAlpha(179),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radius8),
              ),
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                color: Colors.white,
                fontSize: AppDimensions.bodyFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show loading dialog
  static void showLoading(BuildContext context, {String? message}) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: colorScheme.primary,
              ),
              if (message != null) ...[
                AppDimensions.h16,
                Text(
                  message,
                  style: TextStyle(
                    fontSize: AppDimensions.bodyFontSize,
                    color: colorScheme.onSurface.withAlpha(179),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Hide loading dialog
  static void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }
}
