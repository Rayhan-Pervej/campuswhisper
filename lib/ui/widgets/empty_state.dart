import 'package:flutter/material.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:icons_plus/icons_plus.dart';

class EmptyState extends StatelessWidget {
  final IconData? icon;
  final String message;
  final String? subtitle;
  final Widget? action;

  const EmptyState({
    super.key,
    this.icon,
    required this.message,
    this.subtitle,
    this.action,
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
              icon ?? Iconsax.box_outline,
              size: AppDimensions.largeIconSize * 2,
              color: colorScheme.onSurface.withAlpha(77),
            ),
            AppDimensions.h24,
            Text(
              message,
              style: TextStyle(
                fontSize: AppDimensions.titleFontSize,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withAlpha(153),
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              AppDimensions.h8,
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: AppDimensions.bodyFontSize,
                  color: colorScheme.onSurface.withAlpha(128),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              AppDimensions.h24,
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
