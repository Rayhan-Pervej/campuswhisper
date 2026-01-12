import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/utils/snackbar_helper.dart';
import 'package:campuswhisper/core/utils/date_formatter.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';
import 'package:campuswhisper/ui/widgets/default_divider.dart';
import 'package:campuswhisper/ui/pages/thread/widgets/comment_card.dart';
import 'package:campuswhisper/ui/pages/thread/widgets/comment_input.dart';
import 'package:campuswhisper/models/comment_model.dart';
import 'package:campuswhisper/providers/comment_provider.dart';
import 'package:campuswhisper/providers/user_provider.dart';
import 'package:campuswhisper/providers/post_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ThreadDetailPage extends StatefulWidget {
  final Map<String, dynamic> thread;

  const ThreadDetailPage({super.key, required this.thread});

  @override
  State<ThreadDetailPage> createState() => _ThreadDetailPageState();
}

class _ThreadDetailPageState extends State<ThreadDetailPage> {
  @override
  void initState() {
    super.initState();

    // Initialize comments for this post using proper provider pattern
    final postId = widget.thread['post_id'] ?? widget.thread['id'] ?? '';
    final currentUser = FirebaseAuth.instance.currentUser;

    if (postId.isNotEmpty) {
      // Use Future.microtask as per Provider best practices for async in initState
      Future.microtask(() async {
        if (!mounted) return;

        // Fetch fresh post data first
        await _refreshPostData(postId);

        // Load user's vote status for this post
        if (!mounted) return;
        if (currentUser != null) {
          await context.read<PostProvider>().getUserVote(
            postId,
            currentUser.uid,
          );
        }

        // Initialize comment provider for this post (handles loading state internally)
        if (!mounted) return;
        await context.read<CommentProvider>().initializeForPost(
          postId,
          currentUser?.uid,
        );
      });
    }
  }

  /// Fetch fresh post data from Firestore to sync comment count
  Future<void> _refreshPostData(String postId) async {
    try {
      final postProvider = context.read<PostProvider>();
      final freshPost = await postProvider.getPostById(postId);

      if (freshPost != null && mounted) {
        setState(() {
          // Update widget.thread with fresh data (comment_count)
          widget.thread['comment_count'] = freshPost.commentCount;
          widget.thread['upvoteCount'] = freshPost.upvoteCount;
          widget.thread['downvoteCount'] = freshPost.downvoteCount;
        });
      }
    } catch (e) {
      // Silently fail, use cached data
    }
  }

  void _handleUpvote() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final postId = widget.thread['post_id'] ?? widget.thread['id'] ?? '';
    if (postId.isEmpty) return;

    context.read<PostProvider>().upvotePost(postId, currentUser.uid);
  }

  void _handleDownvote() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final postId = widget.thread['post_id'] ?? widget.thread['id'] ?? '';
    if (postId.isEmpty) return;

    context.read<PostProvider>().downvotePost(postId, currentUser.uid);
  }

  Future<void> _submitComment() async {
    final commentProvider = context.read<CommentProvider>();
    final userProvider = context.read<UserProvider>();
    final postProvider = context.read<PostProvider>();

    // Get current user info
    final currentUser = userProvider.currentUser;
    if (currentUser == null) {
      SnackbarHelper.showError(context, 'Please login to comment');
      return;
    }

    // Get post ID
    final postId = widget.thread['post_id'] ?? widget.thread['id'] ?? '';
    if (postId.isEmpty) {
      SnackbarHelper.showError(context, 'Invalid post');
      return;
    }

    // Submit comment via provider (handles all business logic)
    await commentProvider.submitComment(
      context: context,
      postId: postId,
      userId: currentUser.uid,
      authorName: '${currentUser.firstName} ${currentUser.lastName}',
      onCommentCreated: () async {
        // Callback: Update PostProvider to reflect new comment count
        await _refreshPostData(postId);
        postProvider.refresh();
      },
    );
  }

  Future<void> _handleRefresh() async {
    final postId = widget.thread['post_id'] ?? widget.thread['id'] ?? '';
    if (postId.isEmpty) return;

    final currentUser = FirebaseAuth.instance.currentUser;

    // Refresh post data
    await _refreshPostData(postId);

    if (!mounted) return;

    // Reload vote status
    if (currentUser != null) {
      await context.read<PostProvider>().getUserVote(postId, currentUser.uid);
    }

    if (!mounted) return;

    // Refresh comments via provider
    await context.read<CommentProvider>().refreshComments(
      postId,
      currentUser?.uid,
    );
  }

  void _showPostOptions(BuildContext context, String postId) {
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
                  'Post Options',
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
                    Future.delayed(const Duration(milliseconds: 100), () {
                      // TODO: Implement edit functionality
                      SnackbarHelper.showInfo(
                        context,
                        'Edit post feature coming soon',
                      );
                    });
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
                      _confirmDeletePost(context, postId);
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

  void _confirmDeletePost(BuildContext context, String postId) {
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
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to thread list
                context.read<PostProvider>().deletePost(context, postId);
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

  String _getUserInitials(String userName) {
    final parts = userName.split(' ');
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
    AppDimensions.init(context);
    final colorScheme = Theme.of(context).colorScheme;
    final postId = widget.thread['post_id'] ?? widget.thread['id'] ?? '';
    final currentUser = FirebaseAuth.instance.currentUser;
    final isOwner = currentUser?.uid == widget.thread['createdBy'];

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // Refresh posts when navigating back to update comment counts
          context.read<PostProvider>().refresh();
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: DefaultAppBar(
            title: 'Comments',
            actions: [
              if (isOwner)
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // Show options menu (edit, delete)
                    _showPostOptions(context, postId);
                  },
                ),
            ],
          ),
          body: Column(
            children: [
              // Thread content with pull-to-refresh
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Original post - wrapped in Consumer to get vote state
                        Consumer<PostProvider>(
                          builder: (context, postProvider, child) {
                            return _buildOriginalPost(
                              colorScheme,
                              postProvider,
                            );
                          },
                        ),

                        const DefaultDivider(),
                        AppDimensions.h16,

                        // Comments section with Consumer
                        Consumer<CommentProvider>(
                          builder: (context, commentProvider, child) {
                            // Show loading state
                            if (commentProvider.isLoading) {
                              return _buildLoadingState(colorScheme);
                            }

                            final comments = commentProvider.comments;

                            // Show empty state
                            if (comments.isEmpty) {
                              return _buildEmptyState(colorScheme);
                            }

                            // Show comments list
                            return _buildCommentsList(
                              comments,
                              commentProvider,
                              colorScheme,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Comment input
              _buildCommentInput(colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOriginalPost(
    ColorScheme colorScheme,
    PostProvider postProvider,
  ) {
    final postId = widget.thread['post_id'] ?? widget.thread['id'] ?? '';
    final userVoteType = postProvider.getCachedVote(postId);

    // Try to get fresh post data from provider's cached items
    // Fall back to widget.thread data if not found
    int upvoteCount;
    int downvoteCount;

    try {
      final post = postProvider.items.firstWhere((p) => p.postId == postId);
      upvoteCount = post.upvoteCount;
      downvoteCount = post.downvoteCount;
    } catch (e) {
      // If post not found in provider, use widget.thread data
      upvoteCount = widget.thread['upvoteCount'] ?? 0;
      downvoteCount = widget.thread['downvoteCount'] ?? 0;
    }

    return Container(
      padding: EdgeInsets.all(AppDimensions.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author info
          Row(
            children: [
              // User avatar with proper styling like thread card
              CircleAvatar(
                radius: AppDimensions.avatarSmall / 2,
                backgroundColor: colorScheme.primary,
                backgroundImage: widget.thread['userImageUrl'] != null
                    ? NetworkImage(widget.thread['userImageUrl']!)
                    : null,
                child: widget.thread['userImageUrl'] == null
                    ? Text(
                        _getUserInitials(
                          widget.thread['userName'] ?? 'Unknown',
                        ),
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
                count: upvoteCount,
                onTap: _handleUpvote,
                isActive: userVoteType == 'upvote',
                color: colorScheme.primary,
              ),
              AppDimensions.w24,
              _buildVoteButton(
                icon: Iconsax.arrow_down_outline,
                count: downvoteCount,
                onTap: _handleDownvote,
                isActive: userVoteType == 'downvote',
                color: colorScheme.error,
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
    final displayColor = isActive ? color : color.withValues(alpha: 0.6);
    final bgColor = isActive
        ? color.withValues(alpha: 0.1)
        : Colors.transparent;

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
            BuildText(
              text: count.toString(),
              fontSize: AppDimensions.captionFontSize,
              color: displayColor,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildText(
            text: 'Comments',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          AppDimensions.h32,
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(colorScheme.primary),
            ),
          ),
          AppDimensions.h32,
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildText(
            text: 'Comments (0)',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          AppDimensions.h32,
          Center(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.space32),
              child: Column(
                children: [
                  Icon(
                    Icons.comment_outlined,
                    size: AppDimensions.largeIconSize * 1.5,
                    color: colorScheme.onSurface.withAlpha(77),
                  ),
                  AppDimensions.h16,
                  BuildText(
                    text: 'No comments yet',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withAlpha(153),
                    textAlign: TextAlign.center,
                  ),
                  AppDimensions.h8,
                  BuildText(
                    text: 'Be the first to comment!',
                    fontSize: 14,
                    color: colorScheme.onSurface.withAlpha(102),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList(
    List<CommentModel> comments,
    CommentProvider commentProvider,
    ColorScheme colorScheme,
  ) {
    // Calculate total count including all replies
    int totalCount = comments.length;
    for (final comment in comments) {
      final replies = commentProvider.repliesCache[comment.id] ?? [];
      totalCount += replies.length;
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildText(
            text: 'Comments ($totalCount)',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          AppDimensions.h16,

          // Comments list
          ...comments.map((comment) {
            return _buildCommentItem(
              comment,
              colorScheme,
              commentProvider,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCommentItem(
    CommentModel comment,
    ColorScheme colorScheme,
    CommentProvider commentProvider,
  ) {
    final userProvider = context.read<UserProvider>();
    final currentUser = userProvider.currentUser;
    final isReply = comment.isReply;
    final isCommentOwner = currentUser?.uid == comment.authorId;
    final postId = widget.thread['post_id'] ?? widget.thread['id'] ?? '';

    // Get replies from cache
    final replies = commentProvider.repliesCache[comment.id] ?? [];

    // Get user's vote type for this comment
    final userVoteType = commentProvider.getVoteStatus(comment.id);

    // Format comment data for CommentCard widget
    final formattedComment = {
      'id': comment.id,
      'authorName': comment.authorName,
      'timestamp': DateFormatter.timeAgo(comment.createdAt),
      'text': comment.content,
      'upvotes': comment.upvoteCount,
      'downvotes': comment.downvoteCount,
      'userImageUrl': comment.authorAvatarUrl,
      'isEdited': comment.isEdited,
    };

    return Column(
      children: [
        CommentCard(
          comment: formattedComment,
          isReply: isReply,
          isOwner: isCommentOwner,
          userVoteType: userVoteType,
          onReply: isReply
              ? null
              : () {
                  commentProvider.startReply(comment.id, comment.authorName);
                  commentProvider.fetchReplies(postId, comment.id);
                },
          onUpvote: currentUser != null
              ? () {
                  commentProvider.voteOnComment(
                    context: context,
                    parentId: postId,
                    commentId: comment.id,
                    userId: currentUser.uid,
                    isUpvote: true,
                  );
                }
              : null,
          onDownvote: currentUser != null
              ? () {
                  commentProvider.voteOnComment(
                    context: context,
                    parentId: postId,
                    commentId: comment.id,
                    userId: currentUser.uid,
                    isUpvote: false,
                  );
                }
              : null,
          onEdit: isCommentOwner
              ? () {
                  commentProvider.startEdit(comment.id, comment.content);
                }
              : null,
          onDelete: isCommentOwner
              ? () {
                  commentProvider.deleteComment(
                    context: context,
                    parentId: postId,
                    commentId: comment.id,
                  );
                }
              : null,
        ),
        // Show replies if loaded
        if (replies.isNotEmpty)
          ...replies.map((reply) {
            return _buildCommentItem(reply, colorScheme, commentProvider);
          }),
      ],
    );
  }

  Widget _buildCommentInput(ColorScheme colorScheme) {
    return Consumer<CommentProvider>(
      builder: (context, commentProvider, child) {
        return CommentInput(
          controller: commentProvider.commentController,
          focusNode: commentProvider.commentFocusNode,
          onSubmit: _submitComment,
          replyToAuthor: commentProvider.replyToAuthor,
          onCancelReply: commentProvider.cancelReply,
          editingCommentAuthor:
              commentProvider.editingCommentId != null ? 'your comment' : null,
          onCancelEdit: commentProvider.editingCommentId != null
              ? commentProvider.cancelEdit
              : null,
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
