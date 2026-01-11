import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../../../routing/app_routes.dart';

class EventCard extends StatelessWidget {
  final String eventTitle;
  final String organizerName;
  final String description;
  final DateTime eventDate;
  final String location;
  final String category;
  final int interestedCount;
  final int goingCount;
  final String? eventImageUrl;
  final String? organizerImageUrl;
  final VoidCallback? onInterested;
  final VoidCallback? onGoing;
  final VoidCallback? onShare;
  final VoidCallback? onMenuTap;
  final bool isInterested;
  final bool isGoing;

  const EventCard({
    super.key,
    required this.eventTitle,
    required this.organizerName,
    required this.description,
    required this.eventDate,
    required this.location,
    required this.category,
    this.interestedCount = 0,
    this.goingCount = 0,
    this.eventImageUrl,
    this.organizerImageUrl,
    this.onInterested,
    this.onGoing,
    this.onShare,
    this.onMenuTap,
    this.isInterested = false,
    this.isGoing = false,
  });

  String get formattedDate {
    final now = DateTime.now();
    final difference = eventDate.difference(now);

    if (difference.inDays == 0) {
      return 'Today at ${eventDate.hour}:${eventDate.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Tomorrow at ${eventDate.hour}:${eventDate.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return '${weekdays[eventDate.weekday - 1]}, ${eventDate.hour}:${eventDate.minute.toString().padLeft(2, '0')}';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[eventDate.month - 1]} ${eventDate.day}, ${eventDate.hour}:${eventDate.minute.toString().padLeft(2, '0')}';
    }
  }

  String get organizerInitials {
    final names = organizerName.split(' ');
    if (names.isEmpty) return '';
    if (names.length == 1) {
      return names[0].isNotEmpty ? names[0][0].toUpperCase() : '';
    }
    final firstInitial = names[0].isNotEmpty ? names[0][0].toUpperCase() : '';
    final lastInitial = names[1].isNotEmpty ? names[1][0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.eventDetail,
          arguments: {
            'event': {
              'eventTitle': eventTitle,
              'organizerName': organizerName,
              'description': description,
              'eventDate': eventDate,
              'location': location,
              'category': category,
              'interestedCount': interestedCount,
              'goingCount': goingCount,
              'eventImageUrl': eventImageUrl,
              'organizerImageUrl': organizerImageUrl,
              'isInterested': isInterested,
              'isGoing': isGoing,
            },
          },
        );
      },
      borderRadius: BorderRadius.circular(AppDimensions.radius12),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: AppDimensions.space2),
        elevation: AppDimensions.elevation1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image (if available)
          if (eventImageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radius12),
                topRight: Radius.circular(AppDimensions.radius12),
              ),
              child: Image.network(
                eventImageUrl!,
                height: AppDimensions.imageContainerMedium,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: AppDimensions.imageContainerMedium,
                    color: colorScheme.primaryContainer,
                    child: Icon(
                      Iconsax.gallery_outline,
                      size: AppDimensions.largeIconSize,
                      color: colorScheme.primary,
                    ),
                  );
                },
              ),
            ),

          Padding(
            padding: EdgeInsets.all(AppDimensions.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top section: Organizer info and menu
                Row(
                  children: [
                    CircleAvatar(
                      radius: AppDimensions.avatarSmall / 2,
                      backgroundColor: colorScheme.primary,
                      backgroundImage: organizerImageUrl != null
                          ? NetworkImage(organizerImageUrl!)
                          : null,
                      child: organizerImageUrl == null
                          ? Text(
                              organizerInitials,
                              style: TextStyle(
                                color: colorScheme.onPrimary,
                                fontSize: AppDimensions.captionFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    AppDimensions.w12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            organizerName,
                            style: TextStyle(
                              fontSize: AppDimensions.bodyFontSize,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Organizer',
                            style: TextStyle(
                              fontSize: AppDimensions.captionFontSize,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onMenuTap ?? () => _showOptionsMenu(context),
                      icon: Icon(
                        Icons.more_vert,
                        size: AppDimensions.mediumIconSize,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                AppDimensions.h16,

                // Event Title
                Text(
                  eventTitle,
                  style: TextStyle(
                    fontSize: AppDimensions.titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                AppDimensions.h12,

                // Description
                Text(
                  description,
                  style: TextStyle(
                    fontSize: AppDimensions.bodyFontSize,
                    color: colorScheme.onSurface,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                AppDimensions.h16,

                // Event details
                _EventDetail(
                  icon: Iconsax.calendar_outline,
                  text: formattedDate,
                  color: colorScheme.primary,
                ),
                AppDimensions.h8,
                _EventDetail(
                  icon: Iconsax.location_outline,
                  text: location,
                  color: colorScheme.secondary,
                ),
                AppDimensions.h8,

                // Category tag
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.space12,
                    vertical: AppDimensions.space4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppDimensions.radius16),
                    border: Border.all(
                      color: colorScheme.secondary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: AppDimensions.captionFontSize,
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AppDimensions.h16,

                // Action buttons
                Row(
                  children: [
                    _ActionButton(
                      icon: Iconsax.heart_outline,
                      count: interestedCount,
                      onTap: onInterested,
                      color: isInterested
                          ? colorScheme.error
                          : colorScheme.onSurface.withOpacity(0.6),
                    ),
                    AppDimensions.w24,
                    _ActionButton(
                      icon: Iconsax.tick_circle_outline,
                      count: goingCount,
                      onTap: onGoing,
                      color: isGoing
                          ? colorScheme.primary
                          : colorScheme.onSurface.withOpacity(0.6),
                    ),
                    AppDimensions.w24,
                    _ActionButton(
                      icon: Iconsax.share_outline,
                      count: 0,
                      onTap: onShare,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius16),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.space16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Event Options',
                  style: TextStyle(
                    fontSize: AppDimensions.subtitleFontSize,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                AppDimensions.h16,
                _MenuButton(
                  icon: Iconsax.edit_outline,
                  label: 'Edit Event',
                  onTap: () {
                    Navigator.pop(context);
                    // Handle edit
                  },
                ),
                AppDimensions.h8,
                _MenuButton(
                  icon: Iconsax.share_outline,
                  label: 'Share Event',
                  onTap: () {
                    Navigator.pop(context);
                    // Handle share
                  },
                ),
                AppDimensions.h8,
                _MenuButton(
                  icon: Iconsax.calendar_add_outline,
                  label: 'Add to Calendar',
                  onTap: () {
                    Navigator.pop(context);
                    // Handle add to calendar
                  },
                ),
                AppDimensions.h8,
                _MenuButton(
                  icon: Iconsax.flag_outline,
                  label: 'Report Event',
                  onTap: () {
                    Navigator.pop(context);
                    // Handle report
                  },
                  isDestructive: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EventDetail extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _EventDetail({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: AppDimensions.smallIconSize, color: color),
        AppDimensions.w8,
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: AppDimensions.bodyFontSize,
              color: colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback? onTap;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.count,
    this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radius8),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.space8,
          vertical: AppDimensions.space4,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppDimensions.smallIconSize, color: color),
            if (count > 0) ...[
              AppDimensions.w4,
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: AppDimensions.captionFontSize,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isDestructive ? colorScheme.error : colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radius8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space12,
        ),
        child: Row(
          children: [
            Icon(icon, size: AppDimensions.mediumIconSize, color: color),
            AppDimensions.w12,
            Text(
              label,
              style: TextStyle(
                fontSize: AppDimensions.bodyFontSize,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
