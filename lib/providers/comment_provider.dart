import 'package:flutter/material.dart';
import 'package:campuswhisper/core/providers/paginated_provider.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';
import 'package:campuswhisper/models/comment_model.dart';
import 'package:campuswhisper/repository/comment_repository.dart';

class CommentProvider extends PaginatedProvider<CommentModel> {
  final CommentRepository _repository = CommentRepository();

  String? _currentParentId;
  String? _currentParentType;
  bool _showTopLevelOnly = true;

  // ═══════════════════════════════════════════════════════════════
  // PAGINATION IMPLEMENTATION
  // ═══════════════════════════════════════════════════════════════

  @override
  Future<PaginatedResult<CommentModel>> fetchFirstPage() async {
    if (_currentParentId != null && _currentParentType != null) {
      if (_showTopLevelOnly) {
        return await _repository.getTopLevel(
          _currentParentId!,
          _currentParentType!,
          limit: 20,
        );
      } else {
        return await _repository.getByParent(
          _currentParentId!,
          _currentParentType!,
          limit: 20,
        );
      }
    } else {
      // Return empty result if no parent is set
      return PaginatedResult<CommentModel>(
        items: [],
        cursor: null,
        hasMore: false,
      );
    }
  }

  @override
  Future<PaginatedResult<CommentModel>> fetchNextPage(cursor) async {
    if (_currentParentId != null && _currentParentType != null) {
      if (_showTopLevelOnly) {
        return await _repository.getTopLevel(
          _currentParentId!,
          _currentParentType!,
          limit: 20,
          startAfter: cursor,
        );
      } else {
        return await _repository.getByParent(
          _currentParentId!,
          _currentParentType!,
          limit: 20,
          startAfter: cursor,
        );
      }
    } else {
      return PaginatedResult<CommentModel>(
        items: [],
        cursor: null,
        hasMore: false,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // CRUD OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  Future<void> createComment(BuildContext context, CommentModel comment) async {
    final commentId = await safeOperation(
      context,
      operation: () => _repository.create(comment),
      successMessage: 'Comment posted successfully!',
      errorMessage: 'Failed to post comment. Please try again.',
    );

    if (commentId != null) {
      addItem(comment);
    }
  }

  Future<void> updateComment(BuildContext context, CommentModel comment) async {
    await safeOperation(
      context,
      operation: () => _repository.update(comment),
      successMessage: 'Comment updated successfully!',
      errorMessage: 'Failed to update comment. Please try again.',
    );

    updateItem(comment, (c) => c.id == comment.id);
  }

  Future<void> deleteComment(BuildContext context, String commentId) async {
    await safeOperation(
      context,
      operation: () => _repository.delete(commentId),
      successMessage: 'Comment deleted successfully!',
      errorMessage: 'Failed to delete comment. Please try again.',
    );

    removeItem((c) => c.id == commentId);
  }

  Future<CommentModel?> getCommentById(String commentId) async {
    return await _repository.getById(commentId);
  }

  // ═══════════════════════════════════════════════════════════════
  // COMMENT-SPECIFIC OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Load comments for a specific parent (post, event, competition)
  Future<void> loadCommentsFor(String parentId, String parentType) async {
    _currentParentId = parentId;
    _currentParentType = parentType;
    _showTopLevelOnly = true;
    await refresh();
  }

  /// Load replies for a specific comment
  Future<List<CommentModel>> loadReplies(String commentId) async {
    final result = await _repository.getReplies(commentId, limit: 100);
    return result.items;
  }

  /// Get comments by user
  Future<List<CommentModel>> getUserComments(String userId) async {
    final result = await _repository.getByUser(userId, limit: 100);
    return result.items;
  }

  // ═══════════════════════════════════════════════════════════════
  // FILTER METHODS
  // ═══════════════════════════════════════════════════════════════

  Future<void> showTopLevelOnly() async {
    _showTopLevelOnly = true;
    await refresh();
  }

  Future<void> showAllComments() async {
    _showTopLevelOnly = false;
    await refresh();
  }

  Future<void> clearContext() async {
    _currentParentId = null;
    _currentParentType = null;
    _showTopLevelOnly = true;
    clearItems();
  }
}
