import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../../../routing/app_routes.dart';

class LostAndFoundItemCard extends StatelessWidget {
  final String itemName;
  final String description;
  final DateTime datePosted;
  final String location;
  final String category;
  final String status; // 'Lost' or 'Found'
  final String? imageUrl;
  final String posterName;
  final String? posterImageUrl;
  final String? contactInfo;
  final VoidCallback? onContact;
  final VoidCallback? onMarkResolved;
  final VoidCallback? onMenuTap;
  final bool isResolved;

  const LostAndFoundItemCard({
    super.key,
    required this.itemName,
    required this.description,
    required this.datePosted,
    required this.location,
    required this.category,
    required this.status,
    required this.posterName,
    this.imageUrl,
    this.posterImageUrl,
    this.contactInfo,
    this.onContact,
    this.onMarkResolved,
    this.onMenuTap,
    this.isResolved = false,
  });

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(datePosted);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
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
      return '${months[datePosted.month - 1]} ${datePosted.day}';
    }
  }

  String get posterInitials {
    final names = posterName.split(' ');
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
    final isLost = status == 'Lost';

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.itemDetail,
          arguments: {
            'item': {
              'itemName': itemName,
              'description': description,
              'datePosted': datePosted,
              'location': location,
              'category': category,
              'status': status,
              'posterName': posterName,
              'posterAvatar': posterImageUrl,
              'imageUrl': imageUrl,
              'isResolved': isResolved,
            },
          },
        );
      },
      borderRadius: BorderRadius.circular(AppDimensions.radius12),
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: AppDimensions.space8,
          horizontal: AppDimensions.horizontalPadding,
        ),
        elevation: AppDimensions.elevation2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Image (if available)
          if (imageUrl != null)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radius12),
                    topRight: Radius.circular(AppDimensions.radius12),
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
                // Status badge overlay
                Positioned(
                  top: AppDimensions.space12,
                  right: AppDimensions.space12,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.space12,
                      vertical: AppDimensions.space8,
                    ),
                    decoration: BoxDecoration(
                      color: isLost
                          ? colorScheme.error
                          : colorScheme.primary,
                      borderRadius: BorderRadius.circular(AppDimensions.radius16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isLost ? Iconsax.search_status_outline : Iconsax.lovely_outline,
                          size: AppDimensions.smallIconSize,
                          color: Colors.white,
                        ),
                        AppDimensions.w4,
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: AppDimensions.captionFontSize,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          Padding(
            padding: EdgeInsets.all(AppDimensions.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top section: Poster info and menu
                Row(
                  children: [
                    CircleAvatar(
                      radius: AppDimensions.avatarSmall / 2,
                      backgroundColor: colorScheme.primary,
                      backgroundImage: posterImageUrl != null
                          ? NetworkImage(posterImageUrl!)
                          : null,
                      child: posterImageUrl == null
                          ? Text(
                              posterInitials,
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
                            posterName,
                            style: TextStyle(
                              fontSize: AppDimensions.bodyFontSize,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: AppDimensions.captionFontSize,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isResolved)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.space8,
                          vertical: AppDimensions.space4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.radius8),
                          border: Border.all(
                            color: Colors.green,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Iconsax.tick_circle_bold,
                              size: AppDimensions.smallIconSize,
                              color: Colors.green,
                            ),
                            AppDimensions.w4,
                            Text(
                              'Resolved',
                              style: TextStyle(
                                fontSize: AppDimensions.captionFontSize,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    AppDimensions.w8,
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

                // Item Name
                Row(
                  children: [
                    Icon(
                      isLost ? Iconsax.search_status_1_outline : Iconsax.archive_tick_outline,
                      size: AppDimensions.mediumIconSize,
                      color: isLost ? colorScheme.error : colorScheme.primary,
                    ),
                    AppDimensions.w8,
                    Expanded(
                      child: Text(
                        itemName,
                        style: TextStyle(
                          fontSize: AppDimensions.titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
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

                // Item details
                _ItemDetail(
                  icon: Iconsax.location_outline,
                  text: location,
                  color: colorScheme.secondary,
                ),
                AppDimensions.h8,

                // Category tag
                Row(
                  children: [
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
                  ],
                ),

                if (!isResolved) ...[
                  AppDimensions.h16,
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onContact,
                          icon: Icon(
                            Iconsax.message_outline,
                            size: AppDimensions.smallIconSize,
                          ),
                          label: Text(
                            'Contact',
                            style: TextStyle(
                              fontSize: AppDimensions.bodyFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            padding: EdgeInsets.symmetric(
                              vertical: AppDimensions.space12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radius8),
                            ),
                          ),
                        ),
                      ),
                      AppDimensions.w12,
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onMarkResolved,
                          icon: Icon(
                            Iconsax.tick_circle_outline,
                            size: AppDimensions.smallIconSize,
                          ),
                          label: Text(
                            'Mark Resolved',
                            style: TextStyle(
                              fontSize: AppDimensions.bodyFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            side: const BorderSide(color: Colors.green),
                            padding: EdgeInsets.symmetric(
                              vertical: AppDimensions.space12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radius8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
                  'Item Options',
                  style: TextStyle(
                    fontSize: AppDimensions.subtitleFontSize,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                AppDimensions.h16,
                _MenuButton(
                  icon: Iconsax.edit_outline,
                  label: 'Edit Item',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                AppDimensions.h8,
                _MenuButton(
                  icon: Iconsax.share_outline,
                  label: 'Share Item',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                AppDimensions.h8,
                _MenuButton(
                  icon: Iconsax.bookmark_outline,
                  label: 'Save Item',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                AppDimensions.h8,
                _MenuButton(
                  icon: Iconsax.flag_outline,
                  label: 'Report Item',
                  onTap: () {
                    Navigator.pop(context);
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

class _ItemDetail extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _ItemDetail({
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
