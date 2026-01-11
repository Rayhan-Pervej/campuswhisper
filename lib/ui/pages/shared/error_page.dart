import 'package:flutter/material.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/constants/error_messages.dart';
import 'package:icons_plus/icons_plus.dart';

class ErrorPage extends StatelessWidget {
  final String? title;
  final String? message;
  final String? errorCode;
  final VoidCallback? onRetry;
  final VoidCallback? onGoHome;
  final IconData? icon;

  const ErrorPage({
    super.key,
    this.title,
    this.message,
    this.errorCode,
    this.onRetry,
    this.onGoHome,
    this.icon,
  });

  // Predefined error pages
  factory ErrorPage.notFound({VoidCallback? onGoHome}) {
    return ErrorPage(
      title: '404',
      message: 'The page you are looking for doesn\'t exist or has been moved.',
      icon: Iconsax.search_normal_1_outline,
      errorCode: 'ERROR_404',
      onGoHome: onGoHome,
    );
  }

  factory ErrorPage.networkError({VoidCallback? onRetry, VoidCallback? onGoHome}) {
    return ErrorPage(
      title: 'No Internet Connection',
      message: 'Please check your internet connection and try again.',
      icon: Iconsax.wifi_outline,
      errorCode: 'ERROR_NETWORK',
      onRetry: onRetry,
      onGoHome: onGoHome,
    );
  }

  factory ErrorPage.serverError({VoidCallback? onRetry, VoidCallback? onGoHome}) {
    return ErrorPage(
      title: 'Server Error',
      message: 'Something went wrong on our end. We\'re working to fix it.',
      icon: Iconsax.cloud_cross_outline,
      errorCode: 'ERROR_500',
      onRetry: onRetry,
      onGoHome: onGoHome,
    );
  }

  factory ErrorPage.unauthorized({VoidCallback? onGoHome}) {
    return ErrorPage(
      title: 'Access Denied',
      message: 'You don\'t have permission to access this page.',
      icon: Iconsax.lock_outline,
      errorCode: 'ERROR_403',
      onGoHome: onGoHome,
    );
  }

  factory ErrorPage.maintenance({VoidCallback? onRetry}) {
    return ErrorPage(
      title: 'Under Maintenance',
      message: 'We\'re currently performing maintenance. Please check back soon.',
      icon: Iconsax.setting_2_outline,
      errorCode: 'ERROR_MAINTENANCE',
      onRetry: onRetry,
    );
  }

  factory ErrorPage.generic({
    String? message,
    VoidCallback? onRetry,
    VoidCallback? onGoHome,
  }) {
    return ErrorPage(
      title: 'Oops!',
      message: message ?? ErrorMessages.somethingWentWrong,
      icon: Iconsax.danger_outline,
      errorCode: 'ERROR_UNKNOWN',
      onRetry: onRetry,
      onGoHome: onGoHome,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppDimensions.space32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Error Icon
                Container(
                  width: AppDimensions.imageContainerMedium * 0.8,
                  height: AppDimensions.imageContainerMedium * 0.8,
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon ?? Iconsax.info_circle_outline,
                    size: AppDimensions.imageContainerMedium * 0.4,
                    color: colorScheme.error,
                  ),
                ),

                AppDimensions.h32,

                // Error Title
                if (title != null)
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: AppDimensions.titleFontSize + 4,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),

                if (title != null) AppDimensions.h12,

                // Error Message
                Text(
                  message ?? ErrorMessages.somethingWentWrong,
                  style: TextStyle(
                    fontSize: AppDimensions.bodyFontSize,
                    color: colorScheme.onSurface.withAlpha(153),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                if (errorCode != null) ...[
                  AppDimensions.h16,
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.space12,
                      vertical: AppDimensions.space8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppDimensions.radius8),
                    ),
                    child: Text(
                      'Error Code: $errorCode',
                      style: TextStyle(
                        fontSize: AppDimensions.captionFontSize,
                        color: colorScheme.onSurface.withAlpha(102),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],

                AppDimensions.h32,

                // Action Buttons
                Column(
                  children: [
                    if (onRetry != null)
                      SizedBox(
                        width: double.infinity,
                        height: AppDimensions.buttonHeight,
                        child: ElevatedButton.icon(
                          onPressed: onRetry,
                          icon: Icon(
                            Iconsax.refresh_outline,
                            size: AppDimensions.mediumIconSize,
                          ),
                          label: Text(
                            'Try Again',
                            style: TextStyle(
                              fontSize: AppDimensions.bodyFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radius12),
                            ),
                          ),
                        ),
                      ),
                    if (onRetry != null && onGoHome != null) AppDimensions.h12,
                    if (onGoHome != null)
                      SizedBox(
                        width: double.infinity,
                        height: AppDimensions.buttonHeight,
                        child: OutlinedButton.icon(
                          onPressed: onGoHome,
                          icon: Icon(
                            Iconsax.home_outline,
                            size: AppDimensions.mediumIconSize,
                          ),
                          label: Text(
                            'Go to Home',
                            style: TextStyle(
                              fontSize: AppDimensions.bodyFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colorScheme.primary,
                            side: BorderSide(color: colorScheme.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radius12),
                            ),
                          ),
                        ),
                      ),
                    if (onRetry == null && onGoHome == null)
                      SizedBox(
                        width: double.infinity,
                        height: AppDimensions.buttonHeight,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Iconsax.arrow_left_2_outline,
                            size: AppDimensions.mediumIconSize,
                          ),
                          label: Text(
                            'Go Back',
                            style: TextStyle(
                              fontSize: AppDimensions.bodyFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radius12),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                AppDimensions.h24,

                // Support Text
                Text(
                  'If this problem persists, please contact support',
                  style: TextStyle(
                    fontSize: AppDimensions.captionFontSize,
                    color: colorScheme.onSurface.withAlpha(102),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
