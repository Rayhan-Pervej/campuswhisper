import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../../../providers/comment_provider.dart';

class ThreadCard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String userName;
  final String content;
  final String tag;
  final String time;
  final int upvoteCount;
  final int downvoteCount;
  final int commentCount;
  final String? userImageUrl;
  final VoidCallback? onUpvote;
  final VoidCallback? onDownvote;
  final VoidCallback? onComment;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? userVoteType; // 'upvote', 'downvote', or null
  final String postId;
  final String createdBy;
  final String currentUserId;

  const ThreadCard({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.content,
    required this.tag,
    required this.time,
    this.upvoteCount = 0,
    this.downvoteCount = 0,
    this.commentCount = 0,
    this.userImageUrl,
    this.onUpvote,
    this.onDownvote,
    this.onComment,
    this.onEdit,
    this.onDelete,
    this.userVoteType,
    required this.postId,
    required this.createdBy,
    required this.currentUserId,
  });

  String get userInitials {
    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.symmetric(vertical: AppDimensions.space2),
      elevation: AppDimensions.elevation1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section: User photo, name, and menu
            Row(
              children: [
                // User avatar
                CircleAvatar(
                  radius: AppDimensions.avatarSmall / 2,
                  backgroundColor: colorScheme.primary,
                  backgroundImage: userImageUrl != null
                      ? NetworkImage(userImageUrl!)
                      : null,
                  child: userImageUrl == null
                      ? Text(
                          userInitials,
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: AppDimensions.captionFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                AppDimensions.w12,
                // User name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: AppDimensions.subtitleFontSize,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),

                      Text(
                        time,
                        style: TextStyle(
                          fontSize: AppDimensions.bodyFontSize * .8,
                          fontWeight: FontWeight.w400,
                          color: colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Three dot menu (only show if user owns the post)
                if (createdBy == currentUserId)
                  IconButton(
                    onPressed: () => _showOptionsMenu(context),
                    icon: Icon(
                      Icons.more_vert,
                      size: AppDimensions.mediumIconSize,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            AppDimensions.h12,
            // Content section
            Text(
              content,
              style: TextStyle(
                fontSize: AppDimensions.bodyFontSize,
                color: colorScheme.onSurface,
                height: 1.5,
              ),
            ),
            AppDimensions.h16,
            // Tag section
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
                tag,
                style: TextStyle(
                  fontSize: AppDimensions.captionFontSize,
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            AppDimensions.h16,
            // Bottom section: Actions
            Row(
              children: [
                // Upvote
                _ActionButton(
                  icon: Iconsax.arrow_up_3_outline,
                  count: upvoteCount,
                  onTap: onUpvote,
                  color: colorScheme.primary,
                  isActive: userVoteType == 'upvote',
                ),
                AppDimensions.w24,
                // Downvote
                _ActionButton(
                  icon: Iconsax.arrow_down_outline,
                  count: downvoteCount,
                  onTap: onDownvote,
                  color: colorScheme.error,
                  isActive: userVoteType == 'downvote',
                ),
                AppDimensions.w24,
                // Comment (fetch dynamic count from Firestore)
                _DynamicCommentButton(
                  postId: postId,
                  fallbackCount: commentCount < 0 ? 0 : commentCount,
                  onTap: onComment,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ],
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
                  'Thread Options',
                  style: TextStyle(
                    fontSize: AppDimensions.subtitleFontSize,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                AppDimensions.h16,
                // Edit button
                _MenuButton(
                  icon: Iconsax.edit_outline,
                  label: 'Edit',
                  onTap: () {
                    Navigator.pop(context);
                    if (onEdit != null) {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        onEdit!();
                      });
                    }
                  },
                ),
                AppDimensions.h8,
                // Delete button
                _MenuButton(
                  icon: Iconsax.trash_outline,
                  label: 'Delete',
                  onTap: () {
                    Navigator.pop(context);
                    Future.delayed(const Duration(milliseconds: 100), () {
                      _showDeleteConfirmation(context);
                    });
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

  void _showDeleteConfirmation(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius16),
          ),
          title: Row(
            children: [
              Icon(
                Iconsax.danger_outline,
                color: colorScheme.error,
                size: AppDimensions.mediumIconSize,
              ),
              AppDimensions.w8,
              Text(
                'Delete Post',
                style: TextStyle(
                  fontSize: AppDimensions.subtitleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete this post? This action cannot be undone.',
            style: TextStyle(
              fontSize: AppDimensions.bodyFontSize,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (onDelete != null) {
                  onDelete!();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback? onTap;
  final Color color;
  final bool isActive;

  const _ActionButton({
    required this.icon,
    required this.count,
    this.onTap,
    required this.color,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayColor = isActive ? color : color.withValues(alpha: 0.6);
    final bgColor = isActive ? color.withValues(alpha: 0.1) : Colors.transparent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radius8),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.space8,
          vertical: AppDimensions.space4,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppDimensions.smallIconSize, color: displayColor),
            AppDimensions.w4,
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: AppDimensions.captionFontSize,
                color: displayColor,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
              ),
            ),
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

/// Dynamic comment button that fetches real-time count from Firestore
class _DynamicCommentButton extends StatelessWidget {
  final String postId;
  final int fallbackCount;
  final VoidCallback? onTap;
  final Color color;

  const _DynamicCommentButton({
    required this.postId,
    required this.fallbackCount,
    this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final commentProvider = context.read<CommentProvider>();

    return FutureBuilder<int>(
      future: commentProvider.getCommentCount(postId),
      builder: (context, snapshot) {
        // Use fetched count if available, otherwise use fallback
        final count = snapshot.data ?? fallbackCount;

        return _ActionButton(
          icon: Iconsax.message_outline,
          count: count,
          onTap: onTap,
          color: color,
        );
      },
    );
  }
}
