import 'package:flutter/material.dart';
import 'package:campuswhisper/core/providers/paginated_provider.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';
import 'package:campuswhisper/models/posts_model.dart';
import 'package:campuswhisper/repository/post_repository.dart';
import 'package:campuswhisper/core/database/query_builder.dart';

class PostProvider extends PaginatedProvider<PostModel> {
  final PostRepository _repository = PostRepository();

  // Filter state
  String? _currentType;
  String? _currentCourse;
  String? _currentUser;

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
      // Optimistic UI update
      addItem(post);
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
}
