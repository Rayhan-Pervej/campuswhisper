import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campuswhisper/models/comment_model.dart';
import 'package:campuswhisper/models/comment_vote_model.dart';
import 'package:campuswhisper/core/utils/snackbar_helper.dart';
import 'package:campuswhisper/core/services/notification_service.dart';

/// CommentProvider - Facebook-Style Scalable Architecture
///
/// Uses SUBCOLLECTIONS for maximum scalability:
/// - posts/{postId}/comments/{commentId}
/// - posts/{postId}/comments/{commentId}/votes/{userId}
///
/// Benefits:
/// - Supports 20,000+ comments per post
/// - Supports unlimited votes per comment
/// - When post deleted → ALL comments auto-deleted
/// - No 1MB document size limit
class CommentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();

  // State
  List<CommentModel> _comments = [];
  Map<String, List<CommentModel>> _repliesCache = {};
  Map<String, String?> _userVotes = {}; // commentId -> voteType
  bool _isLoading = true; // Start with loading = true
  String? _error;

  // Comment input state
  final TextEditingController commentController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();
  String? _replyToId;
  String? _replyToAuthor;
  String? _editingCommentId;
  String? _editingCommentOriginalContent;

  // Getters
  List<CommentModel> get comments => _comments;
  Map<String, List<CommentModel>> get repliesCache => _repliesCache;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get replyToId => _replyToId;
  String? get replyToAuthor => _replyToAuthor;
  String? get editingCommentId => _editingCommentId;
  String? get editingCommentOriginalContent => _editingCommentOriginalContent;

  @override
  void dispose() {
    commentController.dispose();
    commentFocusNode.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════
  // FETCH COMMENTS (from subcollection)
  // ═══════════════════════════════════════════════════════════════

  /// Fetch top-level comments for a post
  /// Path: posts/{postId}/comments (subcollection)
  Future<void> fetchComments(String parentId, String parentType) async {
    // Clear old data immediately to prevent showing stale comments
    _comments = [];
    _repliesCache.clear();
    _userVotes.clear();
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch from subcollection: posts/{postId}/comments
      final snapshot = await _firestore
          .collection('posts')
          .doc(parentId)
          .collection('comments')
          .where('isDeleted', isEqualTo: false)
          .where('replyToId', isEqualTo: null)  // Top-level only
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      // Client-side filtering as fallback (in case Firebase index isn't built yet)
      _comments = snapshot.docs
          .map((doc) => CommentModel.fromJson(doc.data()))
          .where((comment) => comment.replyToId == null)  // Double-check: only top-level
          .toList();

      // Auto-load replies for all parent comments
      for (final comment in _comments) {
        if (comment.replyCount > 0) {
          await fetchReplies(parentId, comment.id);
        }
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
      _comments = [];
      print('Error fetching comments: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Fetch replies for a specific comment
  /// Path: posts/{postId}/comments where replyToId == commentId
  Future<List<CommentModel>> fetchReplies(String parentId, String commentId) async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .doc(parentId)
          .collection('comments')
          .where('replyToId', isEqualTo: commentId)
          .where('isDeleted', isEqualTo: false)
          .orderBy('createdAt', descending: false)
          .limit(50)
          .get();

      final replies = snapshot.docs
          .map((doc) => CommentModel.fromJson(doc.data()))
          .toList();

      _repliesCache[commentId] = replies;
      notifyListeners();

      return replies;
    } catch (e) {
      print('Error fetching replies: $e');
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // CREATE COMMENT (in subcollection)
  // ═══════════════════════════════════════════════════════════════

  /// Create a new comment in posts/{postId}/comments subcollection
  Future<void> createComment({
    required BuildContext context,
    required String parentId,
    required String parentType,
    required String content,
    required String authorId,
    required String authorName,
    String? replyToId,
    String? replyToAuthor,
    required Function() onCommentCreated,
  }) async {
    try {
      // Create comment in subcollection
      final commentRef = _firestore
          .collection('posts')
          .doc(parentId)
          .collection('comments')
          .doc();

      final comment = CommentModel(
        id: commentRef.id,
        parentId: parentId,
        parentType: parentType,
        content: content,
        authorId: authorId,
        authorName: authorName,
        replyToId: replyToId,
        replyToAuthor: replyToAuthor,
        upvoteCount: 0,
        downvoteCount: 0,
        replyCount: 0,
        isEdited: false,
        createdAt: DateTime.now(),
        isDeleted: false,
      );

      await commentRef.set(comment.toJson());

      // Update parent comment reply count if this is a reply
      if (replyToId != null) {
        await _firestore
            .collection('posts')
            .doc(parentId)
            .collection('comments')
            .doc(replyToId)
            .update({
          'reply_count': FieldValue.increment(1),
        });
      }

      // Update local state
      if (replyToId == null) {
        // Top-level comment
        _comments.insert(0, comment);
        notifyListeners();
      } else {
        // Reply - refresh replies cache
        await fetchReplies(parentId, replyToId);
      }

      // Send notifications
      await _sendNotifications(
        parentId: parentId,
        replyToId: replyToId,
        authorName: authorName,
        content: content,
      );

      // Notify parent to update PostProvider
      onCommentCreated();

      // Clear input and modes
      commentController.clear();
      cancelReply();

      if (!context.mounted) return;
      SnackbarHelper.showSuccess(
        context,
        replyToId != null ? 'Reply posted!' : 'Comment posted!',
      );
    } catch (e) {
      if (!context.mounted) return;
      SnackbarHelper.showError(context, 'Failed to post comment');
      _error = e.toString();
      notifyListeners();
      print('Error creating comment: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // VOTE ON COMMENTS (using subcollection)
  // ═══════════════════════════════════════════════════════════════

  /// Vote on a comment using subcollection
  /// Path: posts/{postId}/comments/{commentId}/votes/{userId}
  Future<void> voteOnComment({
    required BuildContext context,
    required String parentId,
    required String commentId,
    required String userId,
    required bool isUpvote,
  }) async {
    try {
      final commentRef = _firestore
          .collection('posts')
          .doc(parentId)
          .collection('comments')
          .doc(commentId);

      final voteRef = commentRef.collection('votes').doc(userId);

      // Get current vote
      final voteDoc = await voteRef.get();
      final currentVote = voteDoc.exists ? (voteDoc.data()?['type'] as String?) : null;

      final newVoteType = isUpvote ? 'upvote' : 'downvote';

      // Calculate count changes
      int upvoteChange = 0;
      int downvoteChange = 0;

      if (currentVote == null) {
        // New vote
        if (isUpvote) {
          upvoteChange = 1;
        } else {
          downvoteChange = 1;
        }

        // Add vote
        await voteRef.set(CommentVoteModel(
          userId: userId,
          type: newVoteType,
          timestamp: DateTime.now(),
        ).toJson());
      } else if (currentVote == newVoteType) {
        // Remove vote (toggle off)
        if (isUpvote) {
          upvoteChange = -1;
        } else {
          downvoteChange = -1;
        }

        await voteRef.delete();
      } else {
        // Change vote
        if (isUpvote) {
          upvoteChange = 1;
          downvoteChange = -1;
        } else {
          upvoteChange = -1;
          downvoteChange = 1;
        }

        await voteRef.set(CommentVoteModel(
          userId: userId,
          type: newVoteType,
          timestamp: DateTime.now(),
        ).toJson());
      }

      // Update counts in comment document
      await commentRef.update({
        'upvote_count': FieldValue.increment(upvoteChange),
        'downvote_count': FieldValue.increment(downvoteChange),
      });

      // Update local cache
      _userVotes[commentId] = currentVote == newVoteType ? null : newVoteType;

      // Refresh comment to get updated counts
      final updatedDoc = await commentRef.get();
      if (updatedDoc.exists) {
        final updatedComment = CommentModel.fromJson(updatedDoc.data()!);

        // Update in list
        final index = _comments.indexWhere((c) => c.id == commentId);
        if (index != -1) {
          _comments[index] = updatedComment;
        }

        // Update in replies cache
        _repliesCache.forEach((key, replies) {
          final replyIndex = replies.indexWhere((c) => c.id == commentId);
          if (replyIndex != -1) {
            _repliesCache[key]![replyIndex] = updatedComment;
          }
        });

        notifyListeners();
      }
    } catch (e) {
      if (!context.mounted) return;
      SnackbarHelper.showError(context, 'Failed to vote');
      print('Error voting on comment: $e');
    }
  }

  /// Get user's vote on a comment from subcollection
  Future<String?> getUserVote(String parentId, String commentId, String userId) async {
    // Check cache first
    if (_userVotes.containsKey(commentId)) {
      return _userVotes[commentId];
    }

    try {
      final voteDoc = await _firestore
          .collection('posts')
          .doc(parentId)
          .collection('comments')
          .doc(commentId)
          .collection('votes')
          .doc(userId)
          .get();

      final voteType = voteDoc.exists ? (voteDoc.data()?['type'] as String?) : null;
      _userVotes[commentId] = voteType;
      return voteType;
    } catch (e) {
      print('Error getting user vote: $e');
      return null;
    }
  }

  /// Load user votes for all current comments
  Future<void> loadUserVotes(String parentId, String userId) async {
    for (final comment in _comments) {
      if (!_userVotes.containsKey(comment.id)) {
        await getUserVote(parentId, comment.id, userId);
      }
    }
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════
  // EDIT COMMENT
  // ═══════════════════════════════════════════════════════════════

  /// Edit a comment's content
  /// Updates the content, sets isEdited to true, and updates the timestamp
  Future<void> editComment({
    required BuildContext context,
    required String parentId,
    required String commentId,
    required String newContent,
  }) async {
    try {
      final commentRef = _firestore
          .collection('posts')
          .doc(parentId)
          .collection('comments')
          .doc(commentId);

      // Update the comment
      await commentRef.update({
        'content': newContent,
        'isEdited': true,
        'updatedAt': Timestamp.now(),
      });

      // Fetch updated comment
      final updatedDoc = await commentRef.get();
      if (updatedDoc.exists) {
        final updatedComment = CommentModel.fromJson(updatedDoc.data()!);

        // Update in local state - check both top-level comments and replies
        final index = _comments.indexWhere((c) => c.id == commentId);
        if (index != -1) {
          // It's a top-level comment
          _comments[index] = updatedComment;
        } else {
          // It might be a reply - search in replies cache
          _repliesCache.forEach((key, replies) {
            final replyIndex = replies.indexWhere((c) => c.id == commentId);
            if (replyIndex != -1) {
              _repliesCache[key]![replyIndex] = updatedComment;
            }
          });
        }

        notifyListeners();

        // Clear edit mode and input
        commentController.clear();
        cancelEdit();

        if (!context.mounted) return;
        SnackbarHelper.showSuccess(context, 'Comment updated!');
      }
    } catch (e) {
      if (!context.mounted) return;
      SnackbarHelper.showError(context, 'Failed to update comment');
      _error = e.toString();
      notifyListeners();
      print('Error editing comment: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // DELETE COMMENT
  // ═══════════════════════════════════════════════════════════════

  /// Delete a comment (soft delete)
  /// If it's a parent comment, also deletes all its replies
  Future<void> deleteComment({
    required BuildContext context,
    required String parentId,
    required String commentId,
  }) async {
    try {
      final commentRef = _firestore
          .collection('posts')
          .doc(parentId)
          .collection('comments')
          .doc(commentId);

      // Get the comment to check if it's a reply
      final commentDoc = await commentRef.get();
      final isReply = commentDoc.data()?['replyToId'] != null;

      // Mark the comment as deleted
      await commentRef.update({
        'isDeleted': true,
        'updatedAt': Timestamp.now(),
      });

      // If it's a parent comment, also delete all its replies
      if (!isReply) {
        // Get all replies for this comment
        final repliesSnapshot = await _firestore
            .collection('posts')
            .doc(parentId)
            .collection('comments')
            .where('replyToId', isEqualTo: commentId)
            .where('isDeleted', isEqualTo: false)
            .get();

        // Delete all replies
        for (var replyDoc in repliesSnapshot.docs) {
          await replyDoc.reference.update({
            'isDeleted': true,
            'updatedAt': Timestamp.now(),
          });
        }
      } else {
        // If it's a reply, decrement the parent comment's reply count
        final replyToId = commentDoc.data()?['replyToId'];
        if (replyToId != null) {
          await _firestore
              .collection('posts')
              .doc(parentId)
              .collection('comments')
              .doc(replyToId)
              .update({
            'reply_count': FieldValue.increment(-1),
          });
        }
      }

      // Remove from local state
      _comments.removeWhere((c) => c.id == commentId);

      // Also remove replies from cache if it was a parent comment
      if (!isReply) {
        _repliesCache.remove(commentId);
      }

      notifyListeners();

      if (!context.mounted) return;
      SnackbarHelper.showSuccess(context, 'Comment deleted');
    } catch (e) {
      if (!context.mounted) return;
      SnackbarHelper.showError(context, 'Failed to delete comment');
      print('Error deleting comment: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Clear all comments
  void clearComments() {
    _comments = [];
    _repliesCache = {};
    _userVotes = {};
    _error = null;
    notifyListeners();
  }

  /// Set loading state manually
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Get cached vote status for a comment
  String? getVoteStatus(String commentId) {
    return _userVotes[commentId];
  }

  /// Get total comment count for a post by counting actual comments
  /// This is more reliable than maintaining a comment_count field
  Future<int> getCommentCount(String postId) async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .where('isDeleted', isEqualTo: false)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Error getting comment count: $e');
      return 0;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // COMMENT INPUT STATE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════

  /// Start replying to a comment
  void startReply(String commentId, String authorName) {
    _replyToId = commentId;
    _replyToAuthor = authorName;
    _editingCommentId = null; // Clear edit mode
    _editingCommentOriginalContent = null;
    commentFocusNode.requestFocus();
    notifyListeners();
  }

  /// Cancel reply mode
  void cancelReply() {
    _replyToId = null;
    _replyToAuthor = null;
    notifyListeners();
  }

  /// Start editing a comment
  void startEdit(String commentId, String currentContent) {
    _editingCommentId = commentId;
    _editingCommentOriginalContent = currentContent;
    commentController.text = currentContent;
    _replyToId = null; // Clear reply mode
    _replyToAuthor = null;
    commentFocusNode.requestFocus();
    notifyListeners();
  }

  /// Cancel edit mode
  void cancelEdit() {
    _editingCommentId = null;
    _editingCommentOriginalContent = null;
    commentController.clear();
    notifyListeners();
  }

  /// Initialize for a new post
  /// Call this when navigating to a new post to reset state
  Future<void> initializeForPost(
    String postId,
    String? userId,
  ) async {
    // Clear everything first - this prevents showing old comments
    _comments = [];
    _repliesCache.clear();
    _userVotes.clear();
    _error = null;
    _isLoading = true;

    // Clear input state
    _replyToId = null;
    _replyToAuthor = null;
    _editingCommentId = null;
    _editingCommentOriginalContent = null;
    commentController.clear();

    notifyListeners();

    // Now fetch fresh data
    await fetchComments(postId, 'post');

    // Load user votes if logged in
    if (userId != null) {
      await loadUserVotes(postId, userId);
    }
  }

  /// Submit a comment (create new or edit existing)
  /// This handles all the business logic for submitting comments
  Future<void> submitComment({
    required BuildContext context,
    required String postId,
    required String userId,
    required String authorName,
    required Function() onCommentCreated,
  }) async {
    if (commentController.text.trim().isEmpty) return;

    final commentText = commentController.text.trim();

    // Check if we're editing a comment
    if (_editingCommentId != null) {
      // Edit existing comment
      await editComment(
        context: context,
        parentId: postId,
        commentId: _editingCommentId!,
        newContent: commentText,
      );
      return;
    }

    // Create new comment or reply
    await createComment(
      context: context,
      parentId: postId,
      parentType: 'post',
      content: commentText,
      authorId: userId,
      authorName: authorName,
      replyToId: _replyToId,
      replyToAuthor: _replyToAuthor,
      onCommentCreated: onCommentCreated,
    );
  }

  /// Refresh comments for a post
  Future<void> refreshComments(String postId, String? userId) async {
    await initializeForPost(postId, userId);
  }

  // ═══════════════════════════════════════════════════════════════
  // NOTIFICATION HELPERS
  // ═══════════════════════════════════════════════════════════════

  /// Send notifications when a comment/reply is created
  Future<void> _sendNotifications({
    required String parentId,
    required String? replyToId,
    required String authorName,
    required String content,
  }) async {
    try {
      // Get post data to find post owner
      final postDoc = await _firestore.collection('posts').doc(parentId).get();
      final postOwnerId = postDoc.data()?['created_by'] as String?;

      if (postOwnerId == null) return;

      if (replyToId == null) {
        // This is a top-level comment - notify post owner
        await _notificationService.sendCommentNotification(
          postId: parentId,
          postOwnerId: postOwnerId,
          commenterName: authorName,
          commentText: content,
        );
      } else {
        // This is a reply - get comment owner and notify both
        final commentDoc = await _firestore
            .collection('posts')
            .doc(parentId)
            .collection('comments')
            .doc(replyToId)
            .get();

        final commentOwnerId = commentDoc.data()?['authorId'] as String?;

        if (commentOwnerId != null) {
          await _notificationService.sendReplyNotification(
            postId: parentId,
            postOwnerId: postOwnerId,
            commentOwnerId: commentOwnerId,
            replierName: authorName,
            replyText: content,
          );
        }
      }
    } catch (e) {
      // Silently fail - don't block comment creation if notification fails
      print('Error sending notification: $e');
    }
  }
}
