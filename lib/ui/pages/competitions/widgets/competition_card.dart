import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../core/theme/app_dimensions.dart';

class CompetitionCard extends StatelessWidget {
  final String title;
  final String organizer;
  final String description;
  final DateTime registrationDeadline;
  final DateTime eventDate;
  final String duration;
  final String location;
  final String category;
  final String status;
  final String prizePool;
  final int participantCount;
  final String teamSize;
  final bool isFeatured;
  final String? imageUrl;
  final String? organizerImageUrl;
  final bool isRegistered;
  final bool isAdmin;
  final VoidCallback? onRegister;
  final VoidCallback? onShare;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CompetitionCard({
    super.key,
    required this.title,
    required this.organizer,
    required this.description,
    required this.registrationDeadline,
    required this.eventDate,
    required this.duration,
    required this.location,
    required this.category,
    required this.status,
    required this.prizePool,
    required this.participantCount,
    required this.teamSize,
    this.isFeatured = false,
    this.imageUrl,
    this.organizerImageUrl,
    this.isRegistered = false,
    this.isAdmin = false,
    this.onRegister,
    this.onShare,
    this.onEdit,
    this.onDelete,
  });

  String get organizerInitials {
    final names = organizer.split(' ');
    if (names.isEmpty) return '';
    if (names.length == 1) {
      return names[0].isNotEmpty ? names[0][0].toUpperCase() : '';
    }
    final firstInitial = names[0].isNotEmpty ? names[0][0].toUpperCase() : '';
    final lastInitial = names[1].isNotEmpty ? names[1][0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  String get formattedRegistrationDeadline {
    final now = DateTime.now();
    final difference = registrationDeadline.difference(now);

    if (difference.isNegative) {
      return 'Registration Closed';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ${difference.inMinutes % 60}m left';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days left';
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
      return 'Ends ${months[registrationDeadline.month - 1]} ${registrationDeadline.day}';
    }
  }

  String get formattedEventDate {
    final now = DateTime.now();
    final difference = eventDate.difference(now);

    if (difference.isNegative) {
      if (difference.inDays.abs() < 7) {
        return 'Ended ${difference.inDays.abs()} days ago';
      }
      return 'Ended';
    } else if (difference.inDays == 0) {
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
      return '${months[eventDate.month - 1]} ${eventDate.day}, ${eventDate.year}';
    }
  }

  Color getStatusColor(ColorScheme colorScheme) {
    switch (status) {
      case 'Registration Open':
        return Colors.green;
      case 'Ongoing':
        return colorScheme.secondary;
      case 'Upcoming':
        return colorScheme.primary;
      case 'Ended':
        return colorScheme.onSurface.withAlpha(153);
      default:
        return colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = getStatusColor(colorScheme);

    return Card(
      margin: EdgeInsets.symmetric(
        vertical: AppDimensions.space8,
        horizontal: AppDimensions.horizontalPadding,
      ),
      elevation: isFeatured ? AppDimensions.elevation2 : AppDimensions.elevation1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        side: isFeatured
            ? BorderSide(
                color: colorScheme.primary.withAlpha(128),
                width: 2,
              )
            : BorderSide.none,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured badge
          if (isFeatured)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: AppDimensions.space8,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withAlpha(204),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radius12),
                  topRight: Radius.circular(AppDimensions.radius12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.star_bold,
                    size: AppDimensions.smallIconSize,
                    color: colorScheme.onPrimary,
                  ),
                  AppDimensions.w8,
                  Text(
                    'FEATURED COMPETITION',
                    style: TextStyle(
                      fontSize: AppDimensions.captionFontSize,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

          // Competition Image (if available)
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isFeatured ? 0 : AppDimensions.radius12),
                topRight: Radius.circular(isFeatured ? 0 : AppDimensions.radius12),
              ),
              child: Image.network(
                imageUrl!,
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
                            organizer,
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
                              color: colorScheme.onSurface.withAlpha(153),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isAdmin)
                      IconButton(
                        onPressed: () => _showAdminMenu(context),
                        icon: Icon(
                          Icons.more_vert,
                          size: AppDimensions.mediumIconSize,
                          color: colorScheme.onSurface.withAlpha(153),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
                AppDimensions.h16,

                // Competition Title
                Text(
                  title,
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

                // Status badge and Category
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.space12,
                        vertical: AppDimensions.space8,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(26),
                        borderRadius: BorderRadius.circular(AppDimensions.radius16),
                        border: Border.all(
                          color: statusColor.withAlpha(77),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: AppDimensions.captionFontSize,
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    AppDimensions.w8,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.space12,
                        vertical: AppDimensions.space8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer.withAlpha(51),
                        borderRadius: BorderRadius.circular(AppDimensions.radius16),
                        border: Border.all(
                          color: colorScheme.secondary.withAlpha(77),
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
                  ],
                ),
                AppDimensions.h16,

                // Registration deadline with countdown
                if (status == 'Registration Open')
                  Container(
                    padding: EdgeInsets.all(AppDimensions.space12),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(26),
                      borderRadius: BorderRadius.circular(AppDimensions.radius8),
                      border: Border.all(
                        color: Colors.green.withAlpha(77),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.clock_outline,
                          size: AppDimensions.smallIconSize,
                          color: Colors.green,
                        ),
                        AppDimensions.w8,
                        Text(
                          'Registration: ',
                          style: TextStyle(
                            fontSize: AppDimensions.bodyFontSize,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          formattedRegistrationDeadline,
                          style: TextStyle(
                            fontSize: AppDimensions.bodyFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (status == 'Registration Open') AppDimensions.h12,

                // Competition details
                _CompetitionDetail(
                  icon: Iconsax.calendar_outline,
                  label: 'Event Date',
                  text: formattedEventDate,
                  color: colorScheme.primary,
                ),
                AppDimensions.h8,
                _CompetitionDetail(
                  icon: Iconsax.timer_outline,
                  label: 'Duration',
                  text: duration,
                  color: colorScheme.secondary,
                ),
                AppDimensions.h8,
                _CompetitionDetail(
                  icon: Iconsax.location_outline,
                  label: 'Location',
                  text: location,
                  color: colorScheme.secondary,
                ),
                AppDimensions.h16,

                // Prize and team info
                Container(
                  padding: EdgeInsets.all(AppDimensions.space12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withAlpha(26),
                        colorScheme.secondary.withAlpha(26),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radius8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.cup_outline,
                              size: AppDimensions.mediumIconSize,
                              color: colorScheme.primary,
                            ),
                            AppDimensions.w8,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Prize Pool',
                                  style: TextStyle(
                                    fontSize: AppDimensions.captionFontSize,
                                    color: colorScheme.onSurface.withAlpha(153),
                                  ),
                                ),
                                Text(
                                  prizePool,
                                  style: TextStyle(
                                    fontSize: AppDimensions.bodyFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: AppDimensions.space32,
                        width: 1,
                        color: colorScheme.onSurface.withAlpha(51),
                      ),
                      AppDimensions.w12,
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.profile_2user_outline,
                              size: AppDimensions.mediumIconSize,
                              color: colorScheme.secondary,
                            ),
                            AppDimensions.w8,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Team Size',
                                    style: TextStyle(
                                      fontSize: AppDimensions.captionFontSize,
                                      color: colorScheme.onSurface.withAlpha(153),
                                    ),
                                  ),
                                  Text(
                                    teamSize,
                                    style: TextStyle(
                                      fontSize: AppDimensions.captionFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.secondary,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AppDimensions.h16,

                // Participant count
                Row(
                  children: [
                    Icon(
                      Iconsax.profile_2user_outline,
                      size: AppDimensions.smallIconSize,
                      color: colorScheme.onSurface.withAlpha(153),
                    ),
                    AppDimensions.w8,
                    Text(
                      '$participantCount participants registered',
                      style: TextStyle(
                        fontSize: AppDimensions.bodyFontSize,
                        color: colorScheme.onSurface.withAlpha(179),
                      ),
                    ),
                  ],
                ),
                AppDimensions.h16,

                // Action buttons based on competition status
                Row(
                  children: [
                    // Primary action button - changes based on status
                    Expanded(
                      child: ElevatedButton(
                        onPressed: status == 'Ongoing' || status == 'Ended'
                            ? null
                            : onRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: status == 'Ongoing'
                              ? colorScheme.secondaryContainer
                              : status == 'Ended'
                                  ? colorScheme.surfaceContainerHighest
                                  : isRegistered
                                      ? colorScheme.surface
                                      : colorScheme.primary,
                          foregroundColor: status == 'Ongoing'
                              ? colorScheme.onSecondaryContainer
                              : status == 'Ended'
                                  ? colorScheme.onSurface
                                  : isRegistered
                                      ? colorScheme.primary
                                      : colorScheme.onPrimary,
                          padding: EdgeInsets.symmetric(
                            vertical: AppDimensions.space12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radius8),
                            side: isRegistered &&
                                    status != 'Ongoing' &&
                                    status != 'Ended'
                                ? BorderSide(
                                    color: colorScheme.primary,
                                    width: 1.5,
                                  )
                                : BorderSide.none,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              status == 'Ongoing'
                                  ? Iconsax.eye_outline
                                  : status == 'Ended'
                                      ? Iconsax.medal_star_outline
                                      : isRegistered
                                          ? Iconsax.tick_circle_bold
                                          : Iconsax.tick_circle_outline,
                              size: AppDimensions.mediumIconSize,
                            ),
                            AppDimensions.w8,
                            Text(
                              status == 'Ongoing'
                                  ? 'View Details'
                                  : status == 'Ended'
                                      ? 'View Results'
                                      : isRegistered
                                          ? 'Registered'
                                          : 'Register Now',
                              style: TextStyle(
                                fontSize: AppDimensions.bodyFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppDimensions.w12,
                    IconButton(
                      onPressed: onShare,
                      icon: Icon(
                        Iconsax.share_outline,
                        size: AppDimensions.mediumIconSize,
                        color: colorScheme.primary,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: colorScheme.primaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radius8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAdminMenu(BuildContext context) {
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
                  'Admin Options',
                  style: TextStyle(
                    fontSize: AppDimensions.subtitleFontSize,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                AppDimensions.h16,
                _MenuButton(
                  icon: Iconsax.edit_outline,
                  label: 'Edit Competition',
                  onTap: () {
                    Navigator.pop(context);
                    if (onEdit != null) onEdit!();
                  },
                ),
                AppDimensions.h8,
                _MenuButton(
                  icon: Iconsax.profile_2user_outline,
                  label: 'View Participants',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                AppDimensions.h8,
                _MenuButton(
                  icon: Iconsax.trash_outline,
                  label: 'Delete Competition',
                  onTap: () {
                    Navigator.pop(context);
                    if (onDelete != null) onDelete!();
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

class _CompetitionDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String text;
  final Color color;

  const _CompetitionDetail({
    required this.icon,
    required this.label,
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
