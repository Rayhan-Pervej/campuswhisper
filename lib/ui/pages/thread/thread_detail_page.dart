import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/utils/snackbar_helper.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';
import 'package:campuswhisper/ui/widgets/user_avatar.dart';
import 'package:campuswhisper/ui/pages/thread/widgets/comment_card.dart';
import 'package:campuswhisper/ui/pages/thread/widgets/comment_input.dart';

class ThreadDetailPage extends StatefulWidget {
  final Map<String, dynamic> thread;

  const ThreadDetailPage({super.key, required this.thread});

  @override
  State<ThreadDetailPage> createState() => _ThreadDetailPageState();
}

class _ThreadDetailPageState extends State<ThreadDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  String? _voteType; // 'up' or 'down'
  int _upvoteCount = 0;
  int _downvoteCount = 0;
  String? _replyToId;
  String? _replyToAuthor;

  // Mock comments data
  final List<Map<String, dynamic>> _comments = [
    {
      'id': '1',
      'authorName': 'Alice Johnson',
      'content': 'Great post! I totally agree with this.',
      'time': '1h ago',
      'upvotes': 5,
      'downvotes': 0,
      'replyToId': null,
    },
    {
      'id': '2',
      'authorName': 'Bob Smith',
      'content': 'Thanks for sharing! Very helpful.',
      'time': '30m ago',
      'upvotes': 3,
      'downvotes': 1,
      'replyToId': null,
    },
    {
      'id': '3',
      'authorName': 'Charlie Brown',
      'content': 'I had the same experience last week.',
      'time': '15m ago',
      'upvotes': 2,
      'downvotes': 0,
      'replyToId': '1',
    },
  ];

  @override
  void initState() {
    super.initState();
    _upvoteCount = widget.thread['upvoteCount'] ?? 0;
    _downvoteCount = widget.thread['downvoteCount'] ?? 0;
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  void _handleUpvote() {
    setState(() {
      if (_voteType == 'up') {
        // Remove upvote
        _upvoteCount--;
        _voteType = null;
      } else {
        // Add upvote
        if (_voteType == 'down') {
          _downvoteCount--;
        }
        _upvoteCount++;
        _voteType = 'up';
      }
    });
  }

  void _handleDownvote() {
    setState(() {
      if (_voteType == 'down') {
        // Remove downvote
        _downvoteCount--;
        _voteType = null;
      } else {
        // Add downvote
        if (_voteType == 'up') {
          _upvoteCount--;
        }
        _downvoteCount++;
        _voteType = 'down';
      }
    });
  }

  void _handleReply(String commentId, String authorName) {
    setState(() {
      _replyToId = commentId;
      _replyToAuthor = authorName;
    });
    _commentFocusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyToId = null;
      _replyToAuthor = null;
    });
  }

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final commentText = _commentController.text.trim();

    // TODO: Submit comment to backend
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    SnackbarHelper.showSuccess(
      context,
      _replyToId != null ? 'Reply posted!' : 'Comment posted!',
    );

    setState(() {
      _comments.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'authorName': 'Current User',
        'content': commentText,
        'time': 'Just now',
        'upvotes': 0,
        'downvotes': 0,
        'replyToId': _replyToId,
      });
    });

    _commentController.clear();
    _cancelReply();
  }

  List<Map<String, dynamic>> get _topLevelComments {
    return _comments.where((c) => c['replyToId'] == null).toList();
  }

  List<Map<String, dynamic>> _getReplies(String commentId) {
    return _comments.where((c) => c['replyToId'] == commentId).toList();
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: DefaultAppBar(
          title: 'Thread',
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () {
                SnackbarHelper.showInfo(context, 'Share feature coming soon');
              },
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_outline),
              onPressed: () {
                SnackbarHelper.showSuccess(context, 'Thread saved!');
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Thread content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Original post
                    _buildOriginalPost(colorScheme),

                    const Divider(height: 1),
                    AppDimensions.h16,

                    // Comments section
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.horizontalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BuildText(
                            text: 'Comments (${_comments.length})',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          AppDimensions.h16,

                          // Comments list
                          ..._topLevelComments.map((comment) {
                            return _buildCommentItem(comment, colorScheme);
                          }),

                          if (_comments.isEmpty)
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(AppDimensions.space32),
                                child: BuildText(
                                  text:
                                      'No comments yet. Be the first to comment!',
                                  fontSize: 14,
                                  color: colorScheme.onSurface.withAlpha(153),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Comment input
            _buildCommentInput(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildOriginalPost(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author info
          Row(
            children: [
              UserAvatar(
                name: widget.thread['userName'] ?? 'Unknown',
                size: AppDimensions.avatarSmall,
              ),
              AppDimensions.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BuildText(
                      text: widget.thread['userName'] ?? 'Unknown',
                      fontSize: AppDimensions.subtitleFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                    BuildText(
                      text: widget.thread['time'] ?? '',
                      fontSize: AppDimensions.bodyFontSize * 0.8,
                      color: colorScheme.onSurface.withAlpha(153),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // Show options menu
                },
              ),
            ],
          ),
          AppDimensions.h16,

          // Content
          BuildText(
            text: widget.thread['content'] ?? '',
            fontSize: AppDimensions.bodyFontSize,
            color: colorScheme.onSurface,
          ),
          AppDimensions.h16,

          // Tag
          if (widget.thread['tag'] != null)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.space12,
                vertical: AppDimensions.space4,
              ),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withAlpha(51),
                borderRadius: BorderRadius.circular(AppDimensions.radius16),
                border: Border.all(
                  color: colorScheme.secondary.withAlpha(77),
                  width: 1,
                ),
              ),
              child: BuildText(
                text: widget.thread['tag'],
                fontSize: AppDimensions.captionFontSize,
                color: colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          AppDimensions.h16,

          // Vote buttons
          Row(
            children: [
              _buildVoteButton(
                icon: Iconsax.arrow_up_3_outline,
                count: _upvoteCount,
                onTap: _handleUpvote,
                isActive: _voteType == 'up',
                color: colorScheme.primary,
              ),
              AppDimensions.w24,
              _buildVoteButton(
                icon: Iconsax.arrow_down_outline,
                count: _downvoteCount,
                onTap: _handleDownvote,
                isActive: _voteType == 'down',
                color: colorScheme.error,
              ),
              AppDimensions.w24,
              Icon(
                Iconsax.message_outline,
                size: AppDimensions.smallIconSize,
                color: colorScheme.onSurface.withAlpha(153),
              ),
              AppDimensions.w4,
              BuildText(
                text: _comments.length.toString(),
                fontSize: AppDimensions.captionFontSize,
                color: colorScheme.onSurface.withAlpha(153),
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoteButton({
    required IconData icon,
    required int count,
    required VoidCallback onTap,
    required bool isActive,
    required Color color,
  }) {
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
            Icon(
              icon,
              size: AppDimensions.smallIconSize,
              color: isActive ? color : color.withAlpha(153),
            ),
            AppDimensions.w4,
            BuildText(
              text: count.toString(),
              fontSize: AppDimensions.captionFontSize,
              color: isActive ? color : color.withAlpha(153),
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(
    Map<String, dynamic> comment,
    ColorScheme colorScheme,
  ) {
    final replies = _getReplies(comment['id']);
    final isReply = comment['replyToId'] != null;

    // Format comment data for CommentCard widget
    final formattedComment = {
      ...comment,
      'timestamp': comment['time'],
      'text': comment['content'],
    };

    return CommentCard(
      comment: formattedComment,
      isReply: isReply,
      onReply: isReply
          ? null
          : () => _handleReply(comment['id'], comment['authorName']),
      onUpvote: () {
        // TODO: Implement upvote logic
      },
      onDownvote: () {
        // TODO: Implement downvote logic
      },
      nestedReplies: replies
          .map((reply) => _buildCommentItem(reply, colorScheme))
          .toList(),
    );
  }

  Widget _buildCommentInput(ColorScheme colorScheme) {
    return CommentInput(
      controller: _commentController,
      focusNode: _commentFocusNode,
      onSubmit: _submitComment,
      replyToAuthor: _replyToAuthor,
      onCancelReply: _cancelReply,
    );
  }
}
