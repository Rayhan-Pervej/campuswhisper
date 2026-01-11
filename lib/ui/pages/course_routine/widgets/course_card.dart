import 'package:flutter/material.dart';
import 'package:campuswhisper/routing/app_routes.dart';

class CourseCard extends StatelessWidget {
  final String courseId;
  final String section;
  final String room;
  final String days;
  final String time;
  final bool showDeleteIcon;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final Map<String, dynamic>? courseData;
  final String? semesterName;

  const CourseCard({
    super.key,
    required this.courseId,
    required this.section,
    required this.room,
    required this.days,
    required this.time,
    this.showDeleteIcon = false,
    this.onDelete,
    this.onEdit,
    this.courseData,
    this.semesterName,
  });

  void _navigateToCourseDetail(BuildContext context) {
    if (courseData != null && semesterName != null) {
      Navigator.pushNamed(
        context,
        AppRoutes.courseDetail,
        arguments: {
          'course': courseData,
          'semesterName': semesterName,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cs.onSurface.withAlpha(30),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: !showDeleteIcon && courseData != null && semesterName != null
                ? () => _navigateToCourseDetail(context)
                : null,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course ID Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        courseId,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: cs.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Section badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: cs.secondary.withAlpha(51),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: cs.secondary,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        'Sec $section',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Edit button (only when not in delete mode)
                    if (!showDeleteIcon && onEdit != null)
                      IconButton(
                        onPressed: onEdit,
                        icon: Icon(
                          Icons.edit_rounded,
                          size: 18,
                          color: cs.primary,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: cs.primary.withAlpha(30),
                          padding: const EdgeInsets.all(6),
                          minimumSize: const Size(32, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Room info
                Row(
                  children: [
                    Icon(
                      Icons.room_rounded,
                      size: 18,
                      color: cs.onSurface.withAlpha(153),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      room,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Days info
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 18,
                      color: cs.onSurface.withAlpha(153),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      days,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface.withAlpha(180),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Time info
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 18,
                      color: cs.onSurface.withAlpha(153),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ),

          // Delete button
          if (showDeleteIcon)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: cs.error,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: cs.onError,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}