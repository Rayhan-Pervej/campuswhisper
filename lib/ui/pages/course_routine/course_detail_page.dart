import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/utils/dialog_helper.dart';
import 'package:campuswhisper/core/utils/snackbar_helper.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';

class CourseDetailPage extends StatefulWidget {
  final Map<String, dynamic> course;
  final String semesterName;

  const CourseDetailPage({
    super.key,
    required this.course,
    required this.semesterName,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  bool _isStarred = false;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final days = widget.course['days'] as List<dynamic>?;
    final daysList = days?.map((d) => d.toString()).toList() ?? [];

    return Scaffold(
      appBar: DefaultAppBar(
        title: widget.course['courseId'] ?? 'Course Details',
        actions: [
          IconButton(
            icon: Icon(
              _isStarred ? Icons.star : Icons.star_border,
              color: _isStarred ? Colors.amber : null,
            ),
            onPressed: () {
              setState(() {
                _isStarred = !_isStarred;
              });
              SnackbarHelper.showSuccess(
                context,
                _isStarred
                    ? 'Course added to favorites'
                    : 'Course removed from favorites',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course header card
            _buildHeaderCard(colorScheme),
            AppDimensions.h24,

            // Schedule info card
            _buildScheduleCard(colorScheme, daysList),
            AppDimensions.h24,

            // Days breakdown card
            _buildDaysBreakdownCard(colorScheme, daysList),
            AppDimensions.h24,

            // Notifications toggle
            _buildNotificationCard(colorScheme),
            AppDimensions.h24,

            // Quick actions
            _buildQuickActions(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.primary.withAlpha(204)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.space12,
                  vertical: AppDimensions.space8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(AppDimensions.radius8),
                ),
                child: BuildText(
                  text: 'Section ${widget.course['section'] ?? 'N/A'}',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.space12,
                  vertical: AppDimensions.space8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(AppDimensions.radius8),
                ),
                child: BuildText(
                  text: widget.semesterName,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          AppDimensions.h16,
          BuildText(
            text: widget.course['courseId'] ?? 'Unknown Course',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          AppDimensions.h8,
          Row(
            children: [
              Icon(
                Iconsax.clock_outline,
                size: 16,
                color: Colors.white.withAlpha(204),
              ),
              AppDimensions.w8,
              BuildText(
                text:
                    '${widget.course['startTime'] ?? 'N/A'} - ${widget.course['endTime'] ?? 'N/A'}',
                fontSize: 14,
                color: Colors.white.withAlpha(204),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(ColorScheme colorScheme, List<String> daysList) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        border: Border.all(color: colorScheme.onSurface.withAlpha(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.calendar_1_outline,
                size: 20,
                color: colorScheme.primary,
              ),
              AppDimensions.w8,
              BuildText(
                text: 'Schedule',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          AppDimensions.h16,
          _buildInfoRow(
            colorScheme,
            Iconsax.location_outline,
            'Room',
            widget.course['room'] ?? 'TBA',
          ),
          AppDimensions.h12,
          _buildInfoRow(
            colorScheme,
            Iconsax.calendar_outline,
            'Days',
            daysList.isNotEmpty ? daysList.join(', ') : 'No days selected',
          ),
          AppDimensions.h12,
          _buildInfoRow(
            colorScheme,
            Iconsax.clock_outline,
            'Time',
            '${widget.course['startTime'] ?? 'N/A'} - ${widget.course['endTime'] ?? 'N/A'}',
          ),
        ],
      ),
    );
  }

  Widget _buildDaysBreakdownCard(
    ColorScheme colorScheme,
    List<String> daysList,
  ) {
    final Map<String, String> dayNames = {
      'S': 'Saturday',
      'M': 'Monday',
      'T': 'Tuesday',
      'W': 'Wednesday',
      'R': 'Thursday',
      'F': 'Friday',
      'A': 'Saturday (Alt)',
    };

    return Container(
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        border: Border.all(color: colorScheme.onSurface.withAlpha(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.calendar_2_outline,
                size: 20,
                color: colorScheme.primary,
              ),
              AppDimensions.w8,
              BuildText(
                text: 'Class Days',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          AppDimensions.h16,
          if (daysList.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.space16),
                child: BuildText(
                  text: 'No class days scheduled',
                  fontSize: 14,
                  color: colorScheme.onSurface.withAlpha(153),
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: daysList.map((day) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.space16,
                    vertical: AppDimensions.space12,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withAlpha(77),
                    borderRadius: BorderRadius.circular(AppDimensions.radius8),
                    border: Border.all(color: colorScheme.primary),
                  ),
                  child: Column(
                    children: [
                      BuildText(
                        text: day,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                      AppDimensions.h4,
                      BuildText(
                        text: dayNames[day] ?? day,
                        fontSize: 12,
                        color: colorScheme.primary,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        border: Border.all(color: colorScheme.onSurface.withAlpha(26)),
      ),
      child: Row(
        children: [
          Icon(
            Iconsax.notification_outline,
            size: 20,
            color: colorScheme.primary,
          ),
          AppDimensions.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildText(
                  text: 'Class Reminders',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                AppDimensions.h4,
                BuildText(
                  text: 'Get notified before class starts',
                  fontSize: 12,
                  color: colorScheme.onSurface.withAlpha(153),
                ),
              ],
            ),
          ),
          Switch(
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              SnackbarHelper.showSuccess(
                context,
                value
                    ? 'Notifications enabled'
                    : 'Notifications disabled',
              );
            },
            activeTrackColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildText(
          text: 'Quick Actions',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        AppDimensions.h16,
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                colorScheme,
                Iconsax.share_outline,
                'Share',
                () {
                  SnackbarHelper.showInfo(
                    context,
                    'Share feature coming soon',
                  );
                },
              ),
            ),
            AppDimensions.w12,
            Expanded(
              child: _buildActionButton(
                colorScheme,
                Iconsax.note_add_outline,
                'Add Note',
                () {
                  SnackbarHelper.showInfo(
                    context,
                    'Notes feature coming soon',
                  );
                },
              ),
            ),
          ],
        ),
        AppDimensions.h12,
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                colorScheme,
                Iconsax.calendar_add_outline,
                'Export',
                () {
                  SnackbarHelper.showInfo(
                    context,
                    'Export feature coming soon',
                  );
                },
              ),
            ),
            AppDimensions.w12,
            Expanded(
              child: _buildActionButton(
                colorScheme,
                Iconsax.trash_outline,
                'Delete',
                () async {
                  final confirmed = await DialogHelper.showConfirmation(
                    context,
                    title: 'Delete Course',
                    message:
                        'Are you sure you want to delete this course from your routine?',
                    confirmText: 'Delete',
                    cancelText: 'Cancel',
                  );

                  if (confirmed && mounted) {
                    Navigator.pop(context, true); // Return true to indicate deletion
                    SnackbarHelper.showSuccess(
                      context,
                      'Course deleted successfully',
                    );
                  }
                },
                isDestructive: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    ColorScheme colorScheme,
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radius12),
      child: Container(
        padding: EdgeInsets.all(AppDimensions.space16),
        decoration: BoxDecoration(
          color: isDestructive
              ? colorScheme.error.withAlpha(26)
              : colorScheme.primaryContainer.withAlpha(51),
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          border: Border.all(
            color: isDestructive ? colorScheme.error : colorScheme.primary,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isDestructive ? colorScheme.error : colorScheme.primary,
              size: 24,
            ),
            AppDimensions.h8,
            BuildText(
              text: label,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDestructive ? colorScheme.error : colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    ColorScheme colorScheme,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: colorScheme.onSurface.withAlpha(153),
        ),
        AppDimensions.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildText(
                text: label,
                fontSize: 12,
                color: colorScheme.onSurface.withAlpha(153),
              ),
              AppDimensions.h4,
              BuildText(
                text: value,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
