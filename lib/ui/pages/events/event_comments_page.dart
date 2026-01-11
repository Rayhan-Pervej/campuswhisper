import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/utils/date_formatter.dart';
import 'package:campuswhisper/core/utils/snackbar_helper.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';
import 'package:campuswhisper/ui/widgets/user_avatar.dart';
import 'package:campuswhisper/ui/widgets/empty_state.dart';

class EventCommentsPage extends StatefulWidget {
  final String eventId;
  final String eventTitle;

  const EventCommentsPage({
    super.key,
    required this.eventId,
    required this.eventTitle,
  });

  @override
  State<EventCommentsPage> createState() => _EventCommentsPageState();
}

class _EventCommentsPageState extends State<EventCommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  final List<Map<String, dynamic>> _comments = [
    {
      'id': '1',
      'userName': 'Sarah Johnson',
      'userAvatar': null,
      'comment': 'Looking forward to this event! Will there be Q&A session?',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'likes': 5,
      'isLiked': false,
    },
    {
      'id': '2',
      'userName': 'Mike Chen',
      'userAvatar': null,
      'comment': 'Great initiative! Count me in 👍',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'likes': 3,
      'isLiked': false,
    },
    {
      'id': '3',
      'userName': 'Emma Davis',
      'userAvatar': null,
      'comment': 'What time does registration start? I don\'t want to miss it!',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'likes': 2,
      'isLiked': false,
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: DefaultAppBar(
        title: _comments.length == 1
            ? 'Comments (1)'
            : 'Comments (${_comments.length})',
      ),
      body: Column(
        children: [
          // Comment list
          Expanded(
            child: _comments.isEmpty
                ? EmptyState(
                    icon: Iconsax.message_text_outline,
                    message: 'No Comments Yet',
                    subtitle: 'Be the first to comment on this event',
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(AppDimensions.horizontalPadding),
                    itemCount: _comments.length,
                    separatorBuilder: (context, index) => Divider(
                      color: colorScheme.onSurface.withAlpha(26),
                      height: AppDimensions.space32,
                    ),
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return _buildCommentItem(comment, colorScheme);
                    },
                  ),
          ),

          // Comment input at bottom
          _buildCommentInput(colorScheme),
        ],
      ),
    );
  }

  Widget _buildCommentItem(
    Map<String, dynamic> comment,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(
              imageUrl: comment['userAvatar'],
              name: comment['userName'],
              size: 40,
            ),
            AppDimensions.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: BuildText(
                          text: comment['userName'],
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      BuildText(
                        text: DateFormatter.timeAgo(comment['timestamp']),
                        fontSize: 12,
                        color: colorScheme.onSurface.withAlpha(128),
                      ),
                    ],
                  ),
                  AppDimensions.h8,
                  BuildText(
                    text: comment['comment'],
                    fontSize: 14,
                    color: colorScheme.onSurface.withAlpha(204),
                    height: 1.4,
                  ),
                  AppDimensions.h12,
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _toggleLike(comment['id']),
                        borderRadius: BorderRadius.circular(AppDimensions.radius8),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.space8,
                            vertical: AppDimensions.space4,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                comment['isLiked']
                                    ? Iconsax.heart_bold
                                    : Iconsax.heart_outline,
                                size: 16,
                                color: comment['isLiked']
                                    ? colorScheme.error
                                    : colorScheme.onSurface.withAlpha(153),
                              ),
                              if (comment['likes'] > 0) ...[
                                AppDimensions.w4,
                                BuildText(
                                  text: comment['likes'].toString(),
                                  fontSize: 12,
                                  color: comment['isLiked']
                                      ? colorScheme.error
                                      : colorScheme.onSurface.withAlpha(153),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      AppDimensions.w16,
                      InkWell(
                        onTap: () {
                          _commentController.text = '@${comment['userName']} ';
                          _commentFocusNode.requestFocus();
                        },
                        borderRadius: BorderRadius.circular(AppDimensions.radius8),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.space8,
                            vertical: AppDimensions.space4,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.message_outline,
                                size: 16,
                                color: colorScheme.onSurface.withAlpha(153),
                              ),
                              AppDimensions.w4,
                              BuildText(
                                text: 'Reply',
                                fontSize: 12,
                                color: colorScheme.onSurface.withAlpha(153),
                              ),
                            ],
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
      ],
    );
  }

  Widget _buildCommentInput(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.space12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            UserAvatar(
              imageUrl: null,
              name: 'Current User',
              size: 36,
            ),
            AppDimensions.w12,
            Expanded(
              child: TextField(
                controller: _commentController,
                focusNode: _commentFocusNode,
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withAlpha(102),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.space16,
                    vertical: AppDimensions.space12,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            AppDimensions.w8,
            IconButton(
              onPressed: _postComment,
              icon: Icon(
                Iconsax.send_2_bold,
                color: colorScheme.primary,
              ),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.primaryContainer,
                padding: EdgeInsets.all(AppDimensions.space12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleLike(String commentId) {
    setState(() {
      final comment = _comments.firstWhere((c) => c['id'] == commentId);
      comment['isLiked'] = !comment['isLiked'];
      if (comment['isLiked']) {
        comment['likes']++;
      } else {
        comment['likes']--;
      }
    });
  }

  void _postComment() {
    if (_commentController.text.trim().isEmpty) {
      SnackbarHelper.showWarning(context, 'Please write a comment');
      return;
    }

    setState(() {
      _comments.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'userName': 'You',
        'userAvatar': null,
        'comment': _commentController.text.trim(),
        'timestamp': DateTime.now(),
        'likes': 0,
        'isLiked': false,
      });
    });

    _commentController.clear();
    _commentFocusNode.unfocus();

    SnackbarHelper.showSuccess(context, 'Comment posted');
  }
}
