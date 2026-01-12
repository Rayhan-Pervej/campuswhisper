import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';

class CommentCard extends StatelessWidget {
  final Map<String, dynamic> comment;
  final bool isReply;
  final VoidCallback? onReply;
  final VoidCallback? onUpvote;
  final VoidCallback? onDownvote;
  final List<Widget>? nestedReplies;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isOwner;
  final String? userVoteType; // 'upvote', 'downvote', or null

  const CommentCard({
    super.key,
    required this.comment,
    this.isReply = false,
    this.onReply,
    this.onUpvote,
    this.onDownvote,
    this.nestedReplies,
    this.onEdit,
    this.onDelete,
    this.isOwner = false,
    this.userVoteType,
  });

  String _getUserInitials(String userName) {
    final parts = userName.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : 'U';
    }
    final firstInitial = parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '';
    final lastInitial = parts[1].isNotEmpty ? parts[1][0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: isReply ? AppDimensions.space32 : 0,
            bottom: AppDimensions.space12,
          ),
          padding: EdgeInsets.all(AppDimensions.space12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radius12),
            border: Border.all(color: colorScheme.onSurface.withAlpha(26)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Comment header - matching thread card style
              Row(
                children: [
                  // User avatar - matching thread card style
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: colorScheme.primary,
                    backgroundImage: comment['userImageUrl'] != null
                        ? NetworkImage(comment['userImageUrl']!)
                        : null,
                    child: comment['userImageUrl'] == null
                        ? Text(
                            _getUserInitials(comment['authorName'] ?? 'Unknown'),
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontSize: 12,
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
                        BuildText(
                          text: comment['authorName'] ?? 'Unknown',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        Row(
                          children: [
                            BuildText(
                              text: comment['timestamp'] ?? '',
                              fontSize: 12,
                              color: colorScheme.onSurface.withAlpha(153),
                            ),
                            if (comment['isEdited'] == true) ...[
                              AppDimensions.w4,
                              BuildText(
                                text: '• edited',
                                fontSize: 12,
                                color: colorScheme.onSurface.withAlpha(102),
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Three dot menu (only show if user owns the comment)
                  if (isOwner)
                    IconButton(
                      onPressed: () => _showOptionsMenu(context),
                      icon: Icon(
                        Icons.more_vert,
                        size: 20,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
              AppDimensions.h8,

              // Comment text
              BuildText(
                text: comment['text'] ?? '',
                fontSize: 14,
              ),
              AppDimensions.h8,

              // Comment actions - matching thread card style with active state
              Row(
                children: [
                  _buildActionButton(
                    context: context,
                    icon: Iconsax.arrow_up_3_outline,
                    label: comment['upvotes']?.toString() ?? '0',
                    onTap: onUpvote ?? () {},
                    color: colorScheme.primary,
                    isActive: userVoteType == 'upvote',
                  ),
                  AppDimensions.w16,
                  _buildActionButton(
                    context: context,
                    icon: Iconsax.arrow_down_outline,
                    label: comment['downvotes']?.toString() ?? '0',
                    onTap: onDownvote ?? () {},
                    color: colorScheme.error,
                    isActive: userVoteType == 'downvote',
                  ),
                  AppDimensions.w16,
                  if (!isReply && onReply != null)
                    _buildActionButton(
                      context: context,
                      icon: Iconsax.message_outline,
                      label: 'Reply',
                      onTap: onReply!,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      isActive: false,
                    ),
                ],
              ),
            ],
          ),
        ),

        // Nested replies
        if (nestedReplies != null && nestedReplies!.isNotEmpty)
          ...nestedReplies!,
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    bool isActive = false,
  }) {
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
            Icon(icon, size: 16, color: displayColor),
            AppDimensions.w4,
            BuildText(
              text: label,
              fontSize: 12,
              color: displayColor,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
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
                  'Comment Options',
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
                'Delete Comment',
                style: TextStyle(
                  fontSize: AppDimensions.subtitleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete this comment? This action cannot be undone.',
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
              child: const Text('Delete'),
            ),
          ],
        );
      },
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
