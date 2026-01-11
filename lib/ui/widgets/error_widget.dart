import 'package:flutter/material.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/constants/error_messages.dart';
import 'package:icons_plus/icons_plus.dart';

class ErrorStateWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const ErrorStateWidget({
    super.key,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.space32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.info_circle_outline,
              size: AppDimensions.largeIconSize * 2,
              color: colorScheme.error,
            ),
            AppDimensions.h24,
            Text(
              'Oops!',
              style: TextStyle(
                fontSize: AppDimensions.titleFontSize + 4,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            AppDimensions.h8,
            Text(
              message ?? ErrorMessages.somethingWentWrong,
              style: TextStyle(
                fontSize: AppDimensions.bodyFontSize,
                color: colorScheme.onSurface.withAlpha(153),
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              AppDimensions.h24,
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(
                  Iconsax.refresh_outline,
                  size: AppDimensions.mediumIconSize,
                ),
                label: Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.space24,
                    vertical: AppDimensions.space12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
