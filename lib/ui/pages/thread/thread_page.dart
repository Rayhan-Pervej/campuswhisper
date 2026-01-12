import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/routing/app_routes.dart';
import 'package:campuswhisper/providers/post_provider.dart';
import 'package:campuswhisper/core/utils/date_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_bottom_dialog.dart';
import 'widgets/add_post.dart';
import 'widgets/tag_chip_filter.dart';
import 'widgets/thread_card.dart';

class ThreadPage extends StatefulWidget {
  const ThreadPage({super.key});

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  String? _selectedTag;
  final List<String> _tags = ['Questions', 'Discussions', 'Announcements'];

  // Map display names to database types
  String _getPostType(String displayTag) {
    switch (displayTag) {
      case 'Questions':
        return 'question';
      case 'Discussions':
        return 'discussion';
      case 'Announcements':
        return 'announcement';
      default:
        return displayTag.toLowerCase();
    }
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load initial posts
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await context.read<PostProvider>().loadInitial();

      // Load user votes after posts are loaded
      if (!mounted) return;
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        context.read<PostProvider>().loadUserVotes(currentUser.uid);
      }
    });

    // Setup infinite scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<PostProvider>().loadMore();
    }
  }

  void _onTagSelected(String? tag) {
    setState(() {
      _selectedTag = tag;
    });

    final provider = context.read<PostProvider>();
    if (tag == null) {
      provider.clearFilters();
    } else {
      // Convert display tag to database post type
      final postType = _getPostType(tag);
      provider.filterByType(postType);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Consumer<PostProvider>(
        builder: (context, provider, child) {
          // Loading state (first load)
          if (provider.isLoading && provider.items.isEmpty) {
            return Column(
              children: [
                SafeArea(
                  child: TagChipFilter(
                    tags: _tags,
                    selectedTag: _selectedTag,
                    onTagSelected: _onTagSelected,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                    ),
                  ),
                ),
              ],
            );
          }

          // Error state
          if (provider.hasError && provider.items.isEmpty) {
            return Column(
              children: [
                SafeArea(
                  child: TagChipFilter(
                    tags: _tags,
                    selectedTag: _selectedTag,
                    onTagSelected: _onTagSelected,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.danger_outline,
                          size: AppDimensions.largeIconSize * 2,
                          color: colorScheme.error,
                        ),
                        AppDimensions.h16,
                        Text(
                          'Failed to load posts',
                          style: TextStyle(
                            fontSize: AppDimensions.subtitleFontSize,
                            color: colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                        AppDimensions.h8,
                        Text(
                          provider.errorMessage ?? 'Please try again',
                          style: TextStyle(
                            fontSize: AppDimensions.bodyFontSize,
                            color: colorScheme.onSurface.withAlpha(102),
                          ),
                        ),
                        AppDimensions.h16,
                        ElevatedButton.icon(
                          onPressed: () => provider.refresh(),
                          icon: Icon(Iconsax.refresh_outline),
                          label: Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          // Empty state
          if (provider.isEmpty) {
            return Column(
              children: [
                SafeArea(
                  child: TagChipFilter(
                    tags: _tags,
                    selectedTag: _selectedTag,
                    onTagSelected: _onTagSelected,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.message_text_outline,
                          size: AppDimensions.largeIconSize * 2,
                          color: colorScheme.onSurface.withAlpha(77),
                        ),
                        AppDimensions.h16,
                        Text(
                          _selectedTag == null
                              ? 'No posts yet'
                              : 'No posts in $_selectedTag',
                          style: TextStyle(
                            fontSize: AppDimensions.subtitleFontSize,
                            color: colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                        AppDimensions.h8,
                        Text(
                          _selectedTag == null
                              ? 'Be the first to create a post!'
                              : 'Try selecting a different filter',
                          style: TextStyle(
                            fontSize: AppDimensions.bodyFontSize,
                            color: colorScheme.onSurface.withAlpha(102),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          // Posts list
          return RefreshIndicator(
            onRefresh: () => provider.refresh(),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SafeArea(
                    child: TagChipFilter(
                      tags: _tags,
                      selectedTag: _selectedTag,
                      onTagSelected: _onTagSelected,
                    ),
                  ),

                  // Posts
                  ...provider.items.map((post) {
                    final currentUser = FirebaseAuth.instance.currentUser;
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.threadDetail,
                          arguments: {'post': post},
                        );
                      },
                      child: ThreadCard(
                        firstName: '',
                        lastName: '',
                        userName: post.createdByName ?? post.createdBy,
                        content: post.content,
                        tag: post.type,
                        time: DateFormatter.timeAgo(post.createdAt),
                        upvoteCount: post.upvoteCount,
                        downvoteCount: post.downvoteCount,
                        commentCount: post.commentCount < 0 ? 0 : post.commentCount,
                        userVoteType: provider.getCachedVote(post.postId),
                        postId: post.postId,
                        createdBy: post.createdBy,
                        currentUserId: currentUser?.uid ?? '',
                        onUpvote: () {
                          if (currentUser != null) {
                            context.read<PostProvider>().upvotePost(
                              post.postId,
                              currentUser.uid,
                            );
                          }
                        },
                        onDownvote: () {
                          if (currentUser != null) {
                            context.read<PostProvider>().downvotePost(
                              post.postId,
                              currentUser.uid,
                            );
                          }
                        },
                        onComment: () {
                          // Don't navigate if post doesn't have a valid ID yet
                          if (post.postId.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please wait while the post is being saved...'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }

                          Navigator.pushNamed(
                            context,
                            AppRoutes.threadDetail,
                            arguments: {'post': post},
                          );
                        },
                        onEdit: () {
                          // Show edit dialog
                          CustomBottomDialog.show(
                            context: context,
                            title: 'Edit Post',
                            child: AddPost(
                              tags: _tags,
                              existingPost: post,
                              onPostCreated: (updatedPost) {
                                context.read<PostProvider>().updatePost(
                                  context,
                                  updatedPost,
                                );
                              },
                            ),
                          );
                        },
                        onDelete: () {
                          // Delete the post
                          context.read<PostProvider>().deletePost(
                            context,
                            post.postId,
                          );
                        },
                      ),
                    );
                  }),

                  // Loading more indicator
                  if (provider.isLoadingMore)
                    Padding(
                      padding: EdgeInsets.all(AppDimensions.space16),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                      ),
                    ),

                  // End of list indicator
                  if (!provider.hasMore && provider.items.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.all(AppDimensions.space16),
                      child: Text(
                        'No more posts',
                        style: TextStyle(
                          fontSize: AppDimensions.captionFontSize,
                          color: colorScheme.onSurface.withAlpha(102),
                        ),
                      ),
                    ),

                  AppDimensions.h12,
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: SizedBox(
        height: AppDimensions.space40,
        width: AppDimensions.space40,
        child: FloatingActionButton(
          onPressed: () {
            CustomBottomDialog.show(
              context: context,
              title: 'Create New Post',
              child: AddPost(
                tags: _tags,
                onPostCreated: (newPost) {
                  // Create post using provider
                  context.read<PostProvider>().createPost(context, newPost);
                },
              ),
            );
          },
          backgroundColor: colorScheme.primary,
          child: Icon(
            Iconsax.add_outline,
            color: Colors.white,
            size: AppDimensions.space40 * 0.6,
          ),
        ),
      ),
    );
  }
}
