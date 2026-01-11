import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/ui/widgets/user_avatar.dart';

class CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback onSubmit;
  final String? replyToAuthor;
  final VoidCallback? onCancelReply;
  final String hintText;

  const CommentInput({
    super.key,
    required this.controller,
    required this.onSubmit,
    this.focusNode,
    this.replyToAuthor,
    this.onCancelReply,
    this.hintText = 'Write a comment...',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.onSurface.withAlpha(26)),
        ),
      ),
      padding: EdgeInsets.all(AppDimensions.space12),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reply indicator
            if (replyToAuthor != null)
              Container(
                padding: EdgeInsets.all(AppDimensions.space8),
                margin: EdgeInsets.only(bottom: AppDimensions.space8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withAlpha(77),
                  borderRadius: BorderRadius.circular(AppDimensions.radius8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.reply, size: 16, color: colorScheme.primary),
                    AppDimensions.w8,
                    Expanded(
                      child: BuildText(
                        text: 'Replying to $replyToAuthor',
                        fontSize: 12,
                        color: colorScheme.primary,
                      ),
                    ),
                    if (onCancelReply != null)
                      InkWell(
                        onTap: onCancelReply,
                        borderRadius: BorderRadius.circular(AppDimensions.radius8),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ),

            // Comment input field
            Row(
              children: [
                UserAvatar(name: 'Current User', size: 32),
                AppDimensions.w12,
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface.withAlpha(153),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radius16 * 1.5,
                        ),
                        borderSide: BorderSide(
                          color: colorScheme.onSurface.withAlpha(51),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radius16 * 1.5,
                        ),
                        borderSide: BorderSide(
                          color: colorScheme.onSurface.withAlpha(51),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radius16 * 1.5,
                        ),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.space16,
                        vertical: AppDimensions.space12,
                      ),
                      isDense: true,
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                  ),
                ),
                AppDimensions.w8,
                IconButton(
                  onPressed: onSubmit,
                  icon: Icon(Iconsax.send_2_bold, color: colorScheme.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
