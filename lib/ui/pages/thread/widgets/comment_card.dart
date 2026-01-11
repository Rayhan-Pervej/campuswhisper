import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/ui/widgets/user_avatar.dart';

class CommentCard extends StatelessWidget {
  final Map<String, dynamic> comment;
  final bool isReply;
  final VoidCallback? onReply;
  final VoidCallback? onUpvote;
  final VoidCallback? onDownvote;
  final List<Widget>? nestedReplies;

  const CommentCard({
    super.key,
    required this.comment,
    this.isReply = false,
    this.onReply,
    this.onUpvote,
    this.onDownvote,
    this.nestedReplies,
  });

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
              // Comment header
              Row(
                children: [
                  UserAvatar(
                    name: comment['authorName'] ?? 'Unknown',
                    size: 32,
                  ),
                  AppDimensions.w8,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BuildText(
                          text: comment['authorName'] ?? 'Unknown',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        BuildText(
                          text: comment['timestamp'] ?? '',
                          fontSize: 12,
                          color: colorScheme.onSurface.withAlpha(153),
                        ),
                      ],
                    ),
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

              // Comment actions
              Row(
                children: [
                  _buildCommentAction(
                    context: context,
                    icon: Iconsax.arrow_up_outline,
                    label: comment['upvotes']?.toString() ?? '0',
                    onTap: onUpvote ?? () {},
                  ),
                  AppDimensions.w8,
                  _buildCommentAction(
                    context: context,
                    icon: Iconsax.arrow_down_outline,
                    label: comment['downvotes']?.toString() ?? '0',
                    onTap: onDownvote ?? () {},
                  ),
                  AppDimensions.w16,
                  if (!isReply && onReply != null)
                    _buildCommentAction(
                      context: context,
                      icon: Iconsax.message_outline,
                      label: 'Reply',
                      onTap: onReply!,
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

  Widget _buildCommentAction({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radius8),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.space4,
          vertical: AppDimensions.space2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: colorScheme.onSurface.withAlpha(153)),
            AppDimensions.w4,
            BuildText(
              text: label,
              fontSize: 12,
              color: colorScheme.onSurface.withAlpha(153),
            ),
          ],
        ),
      ),
    );
  }
}
