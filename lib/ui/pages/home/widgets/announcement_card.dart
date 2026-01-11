import 'package:flutter/material.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const AnnouncementCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radius12),
      child: Container(
        margin: EdgeInsets.only(bottom: AppDimensions.space12),
        padding: EdgeInsets.all(AppDimensions.space16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          border: Border.all(color: colorScheme.onSurface.withAlpha(26)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(AppDimensions.space8),
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(AppDimensions.radius8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            AppDimensions.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildText(
                    text: title,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  AppDimensions.h4,
                  BuildText(
                    text: description,
                    fontSize: 14,
                    color: colorScheme.onSurface.withAlpha(153),
                  ),
                  AppDimensions.h8,
                  BuildText(
                    text: time,
                    fontSize: 12,
                    color: colorScheme.onSurface.withAlpha(102),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
