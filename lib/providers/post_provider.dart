import 'package:flutter/material.dart';
import 'package:campuswhisper/core/providers/paginated_provider.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';
import 'package:campuswhisper/models/posts_model.dart';
import 'package:campuswhisper/models/vote_model.dart';
import 'package:campuswhisper/models/comment_model.dart';
import 'package:campuswhisper/repository/post_repository.dart';
import 'package:campuswhisper/core/database/query_builder.dart';

class PostProvider extends PaginatedProvider<PostModel> {
  final PostRepository _repository = PostRepository();

  // Filter state
  String? _currentType;
  String? _currentCourse;
  String? _currentUser;

  // Vote state tracking: postId -> voteType
  final Map<String, String?> _userVotes = {};

  // ═══════════════════════════════════════════════════════════════
  // PAGINATION IMPLEMENTATION
  // ═══════════════════════════════════════════════════════════════

  @override
  Future<PaginatedResult<PostModel>> fetchFirstPage() async {
    // Apply filters if any
    if (_currentType != null) {
      return await _repository.getByType(_currentType!, limit: 20);
    } else if (_currentCourse != null) {
      return await _repository.getByCourse(_currentCourse!, limit: 20);
    } else if (_currentUser != null) {
      return await _repository.getByUser(_currentUser!, limit: 20);
    } else {
      return await _repository.getAll(
        sorts: [QuerySort.descending('created_at')],
        limit: 20,
      );
    }
  }

  @override
  Future<PaginatedResult<PostModel>> fetchNextPage(cursor) async {
    if (_currentType != null) {
      return await _repository.getByType(
        _currentType!,
        limit: 20,
        startAfter: cursor,
      );
    } else if (_currentCourse != null) {
      return await _repository.getByCourse(
        _currentCourse!,
        limit: 20,
        startAfter: cursor,
      );
    } else if (_currentUser != null) {
      return await _repository.getByUser(
        _currentUser!,
        limit: 20,
        startAfter: cursor,
      );
    } else {
      return await _repository.getAll(
        sorts: [QuerySort.descending('created_at')],
        limit: 20,
        startAfter: cursor,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // CRUD OPERATIONS (with user feedback)
  // ═══════════════════════════════════════════════════════════════

  /// Create a new post
  Future<void> createPost(BuildContext context, PostModel post) async {
    final postId = await safeOperation(
      context,
      operation: () => _repository.create(post),
      successMessage: 'Post created successfully!',
      errorMessage: 'Failed to create post. Please try again.',
    );

    if (postId != null) {
      // Update the post with the generated ID
      final updatedPost = PostModel(
        postId: postId,
        type: post.type,
        createdBy: post.createdBy,
        createdByName: post.createdByName,
        content: post.content,
        createdAt: post.createdAt,
        courseId: post.courseId,
        title: post.title,
        upvoteCount: post.upvoteCount,
        downvoteCount: post.downvoteCount,
        commentCount: post.commentCount,
        updatedAt: post.updatedAt,
      );

      // Update in Firestore with the proper ID
      await _repository.update(updatedPost);

      // Refresh the list to get the newly created post with its proper ID from Firestore
      await refresh();
    }
  }

  /// Update existing post
  Future<void> updatePost(BuildContext context, PostModel post) async {
    await safeOperation(
      context,
      operation: () => _repository.update(post),
      successMessage: 'Post updated successfully!',
      errorMessage: 'Failed to update post. Please try again.',
    );

    // Update in list
    updateItem(post, (p) => p.postId == post.postId);
  }

  /// Delete post
  Future<void> deletePost(BuildContext context, String postId) async {
    await safeOperation(
      context,
      operation: () => _repository.delete(postId),
      successMessage: 'Post deleted successfully!',
      errorMessage: 'Failed to delete post. Please try again.',
    );

    // Remove from list
    removeItem((p) => p.postId == postId);
  }

  /// Get post by ID
  Future<PostModel?> getPostById(String postId) async {
    return await _repository.getById(postId);
  }

  // ═══════════════════════════════════════════════════════════════
  // FILTER METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Filter posts by type (review, hack, faq)
  Future<void> filterByType(String type) async {
    _currentType = type;
    _currentCourse = null;
    _currentUser = null;
    await refresh();
  }

  /// Filter posts by course
  Future<void> filterByCourse(String courseId) async {
    _currentCourse = courseId;
    _currentType = null;
    _currentUser = null;
    await refresh();
  }

  /// Filter posts by user
  Future<void> filterByUser(String userId) async {
    _currentUser = userId;
    _currentType = null;
    _currentCourse = null;
    await refresh();
  }

  /// Clear all filters
  Future<void> clearFilters() async {
    _currentType = null;
    _currentCourse = null;
    _currentUser = null;
    await refresh();
  }

  // ═══════════════════════════════════════════════════════════════
  // SPECIALIZED QUERIES
  // ═══════════════════════════════════════════════════════════════

  /// Load trending posts
  Future<void> loadTrending() async {
    setLoading();

    try {
      final result = await _repository.getTrending(limit: 10);
      setItems(result.items);
      setLoaded();
    } catch (e) {
      setError(e.toString());
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // VOTING OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Upvote a post
  Future<void> upvotePost(String postId, String userId) async {
    // Validate inputs
    if (postId.isEmpty || userId.isEmpty) {
      return;
    }

    try {
      final currentVote = _userVotes[postId];

      // Optimistic UI update
      final postIndex = items.indexWhere((p) => p.postId == postId);
      if (postIndex != -1) {
        final post = items[postIndex];
        int newUpvoteCount = post.upvoteCount;
        int newDownvoteCount = post.downvoteCount;

        if (currentVote == 'upvote') {
          // Remove upvote
          newUpvoteCount -= 1;
          _userVotes[postId] = null;
        } else if (currentVote == 'downvote') {
          // Change from downvote to upvote
          newUpvoteCount += 1;
          newDownvoteCount -= 1;
          _userVotes[postId] = 'upvote';
        } else {
          // Add new upvote
          newUpvoteCount += 1;
          _userVotes[postId] = 'upvote';
        }

        final updatedPost = PostModel(
          postId: post.postId,
          type: post.type,
          createdBy: post.createdBy,
          createdByName: post.createdByName,
          content: post.content,
          createdAt: post.createdAt,
          courseId: post.courseId,
          title: post.title,
          upvoteCount: newUpvoteCount,
          downvoteCount: newDownvoteCount,
          commentCount: post.commentCount,
          updatedAt: post.updatedAt,
        );
        updateItem(updatedPost, (p) => p.postId == postId);
      }

      // Perform actual upvote
      await _repository.upvote(postId, userId);
    } catch (e) {
      // Revert on error
      await refresh();
      rethrow;
    }
  }

  /// Downvote a post
  Future<void> downvotePost(String postId, String userId) async {
    // Validate inputs
    if (postId.isEmpty || userId.isEmpty) {
      return;
    }

    try {
      final currentVote = _userVotes[postId];

      // Optimistic UI update
      final postIndex = items.indexWhere((p) => p.postId == postId);
      if (postIndex != -1) {
        final post = items[postIndex];
        int newUpvoteCount = post.upvoteCount;
        int newDownvoteCount = post.downvoteCount;

        if (currentVote == 'downvote') {
          // Remove downvote
          newDownvoteCount -= 1;
          _userVotes[postId] = null;
        } else if (currentVote == 'upvote') {
          // Change from upvote to downvote
          newUpvoteCount -= 1;
          newDownvoteCount += 1;
          _userVotes[postId] = 'downvote';
        } else {
          // Add new downvote
          newDownvoteCount += 1;
          _userVotes[postId] = 'downvote';
        }

        final updatedPost = PostModel(
          postId: post.postId,
          type: post.type,
          createdBy: post.createdBy,
          createdByName: post.createdByName,
          content: post.content,
          createdAt: post.createdAt,
          courseId: post.courseId,
          title: post.title,
          upvoteCount: newUpvoteCount,
          downvoteCount: newDownvoteCount,
          commentCount: post.commentCount,
          updatedAt: post.updatedAt,
        );
        updateItem(updatedPost, (p) => p.postId == postId);
      }

      // Perform actual downvote
      await _repository.downvote(postId, userId);
    } catch (e) {
      // Revert on error
      await refresh();
      rethrow;
    }
  }

  /// Get user's vote on a post (with caching)
  Future<String?> getUserVote(String postId, String userId) async {
    // Check cache first
    if (_userVotes.containsKey(postId)) {
      return _userVotes[postId];
    }

    // Fetch from repository
    final voteType = await _repository.getUserVote(postId, userId);
    _userVotes[postId] = voteType;
    return voteType;
  }

  /// Get cached vote state for a post
  String? getCachedVote(String postId) {
    return _userVotes[postId];
  }

  /// Load user votes for current posts
  Future<void> loadUserVotes(String userId) async {
    for (final post in items) {
      if (!_userVotes.containsKey(post.postId)) {
        final voteType = await _repository.getUserVote(post.postId, userId);
        _userVotes[post.postId] = voteType;
      }
    }
    notifyListeners();
  }

  /// Get all votes for a post
  Future<List<VoteModel>> getVotes(String postId) async {
    return await _repository.getVotes(postId);
  }

  /// Get upvoters for a post
  Future<List<VoteModel>> getUpvoters(String postId) async {
    return await _repository.getUpvoters(postId);
  }

  /// Get downvoters for a post
  Future<List<VoteModel>> getDownvoters(String postId) async {
    return await _repository.getDownvoters(postId);
  }

  // ═══════════════════════════════════════════════════════════════
  // COMMENT OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Get comments for a post
  Future<List<CommentModel>> getComments(String postId) async {
    return await _repository.getComments(postId);
  }

  /// Add a comment to a post
  Future<void> addComment(
    BuildContext context,
    String postId,
    CommentModel comment,
  ) async {
    await safeOperation(
      context,
      operation: () => _repository.addComment(postId, comment),
      successMessage: 'Comment added successfully!',
      errorMessage: 'Failed to add comment. Please try again.',
    );

    // Update comment count in the post
    final postIndex = items.indexWhere((p) => p.postId == postId);
    if (postIndex != -1) {
      final post = items[postIndex];
      final updatedPost = PostModel(
        postId: post.postId,
        type: post.type,
        createdBy: post.createdBy,
        createdByName: post.createdByName,
        content: post.content,
        createdAt: post.createdAt,
        courseId: post.courseId,
        title: post.title,
        upvoteCount: post.upvoteCount,
        downvoteCount: post.downvoteCount,
        commentCount: post.commentCount + 1,
        updatedAt: post.updatedAt,
      );
      updateItem(updatedPost, (p) => p.postId == postId);
    }
  }

  /// Delete a comment from a post
  Future<void> deleteComment(
    BuildContext context,
    String postId,
    String commentId,
  ) async {
    await safeOperation(
      context,
      operation: () => _repository.deleteComment(postId, commentId),
      successMessage: 'Comment deleted successfully!',
      errorMessage: 'Failed to delete comment. Please try again.',
    );

    // Update comment count in the post
    final postIndex = items.indexWhere((p) => p.postId == postId);
    if (postIndex != -1) {
      final post = items[postIndex];
      final updatedPost = PostModel(
        postId: post.postId,
        type: post.type,
        createdBy: post.createdBy,
        createdByName: post.createdByName,
        content: post.content,
        createdAt: post.createdAt,
        courseId: post.courseId,
        title: post.title,
        upvoteCount: post.upvoteCount,
        downvoteCount: post.downvoteCount,
        commentCount: post.commentCount > 0 ? post.commentCount - 1 : 0,
        updatedAt: post.updatedAt,
      );
      updateItem(updatedPost, (p) => p.postId == postId);
    }
  }
}
