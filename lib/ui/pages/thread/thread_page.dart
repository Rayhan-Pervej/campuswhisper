import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/routing/app_routes.dart';
import 'package:campuswhisper/providers/post_provider.dart';
import 'package:campuswhisper/core/utils/date_formatter.dart';
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
  final List<String> _tags = [
    'Food & Dining',
    'Academics',
    'Campus Life',
    'Events',
    'Housing',
    'Sports',
    'Technology',
    'Career',
    'Health',
    'Transportation',
  ];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load initial posts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().loadInitial();
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
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
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
      // Filter by type based on tag
      // You can map tags to types if needed
      provider.filterByType(tag);
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
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(colorScheme.primary),
              ),
            );
          }

          // Error state
          if (provider.hasError && provider.items.isEmpty) {
            return Center(
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
            );
          }

          // Empty state
          if (provider.isEmpty) {
            return Center(
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
                    'No posts yet',
                    style: TextStyle(
                      fontSize: AppDimensions.subtitleFontSize,
                      color: colorScheme.onSurface.withAlpha(153),
                    ),
                  ),
                  AppDimensions.h8,
                  Text(
                    'Be the first to create a post!',
                    style: TextStyle(
                      fontSize: AppDimensions.bodyFontSize,
                      color: colorScheme.onSurface.withAlpha(102),
                    ),
                  ),
                ],
              ),
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
                        userName: post.createdBy,
                        content: post.content,
                        tag: post.type,
                        time: DateFormatter.timeAgo(post.createdAt),
                        upvoteCount: post.upvoteCount,
                        downvoteCount: post.downvoteCount,
                        commentCount: 0, // TODO: Add comment count to PostModel
                        onUpvote: () {
                          // TODO: Implement upvote functionality
                          print('Upvote clicked for ${post.postId}');
                        },
                        onDownvote: () {
                          // TODO: Implement downvote functionality
                          print('Downvote clicked for ${post.postId}');
                        },
                        onComment: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.threadDetail,
                            arguments: {'post': post},
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
      // floatingActionButton: SizedBox(
      //   height: AppDimensions.space40 * 1.5,
      //   width: AppDimensions.space40 * 1.5,
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       CustomBottomDialog.show(
      //         context: context,
      //         title: 'Create New Post',
      //         child: AddPost(
      //           tags: _tags,
      //           onPostCreated: (newPost) {
      //             // Create post using provider
      //             context.read<PostProvider>().createPost(context, newPost);
      //           },
      //         ),
      //       );
      //     },
      //
      //     backgroundColor: colorScheme.primaryContainer,
      //
      //     child: Icon(
      //       Iconsax.add_outline,
      //       color: colorScheme.primary,
      //       size: AppDimensions.space40,
      //     ),
      //   ),
      // ),
    );
  }
}
