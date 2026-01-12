import 'package:campuswhisper/core/repositories/base_repository.dart';
import 'package:campuswhisper/models/posts_model.dart';
import 'package:campuswhisper/models/vote_model.dart';
import 'package:campuswhisper/models/comment_model.dart';
import 'package:campuswhisper/core/database/query_builder.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostRepository extends BaseRepository<PostModel> {
  @override
  String get collectionName => 'posts';

  @override
  PostModel fromJson(Map<String, dynamic> json) => PostModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(PostModel model) => model.toJson();

  @override
  String getId(PostModel model) => model.postId;

  // ═══════════════════════════════════════════════════════════════
  // SPECIALIZED QUERIES (beyond base CRUD)
  // ═══════════════════════════════════════════════════════════════

  /// Get posts by type (with pagination)
  Future<PaginatedResult<PostModel>> getByType(
    String type, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('type', type)],
      sorts: [QuerySort.descending('created_at')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get posts by course (with pagination)
  Future<PaginatedResult<PostModel>> getByCourse(
    String courseId, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('course_id', courseId)],
      sorts: [QuerySort.descending('created_at')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get posts by user (with pagination)
  Future<PaginatedResult<PostModel>> getByUser(
    String userId, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('created_by', userId)],
      sorts: [QuerySort.descending('created_at')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get trending posts (high upvote count)
  Future<PaginatedResult<PostModel>> getTrending({
    int limit = 10,
    dynamic startAfter,
  }) async {
    return query(
      sorts: [QuerySort.descending('upvote_count')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // VOTING OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Upvote a post
  Future<void> upvote(String postId, String userId) async {
    final firestore = FirebaseFirestore.instance;

    final postRef = firestore.collection(collectionName).doc(postId);
    final voteRef = postRef.collection('votes').doc(userId);

    await firestore.runTransaction((transaction) async {
      final voteDoc = await transaction.get(voteRef);
      final postDoc = await transaction.get(postRef);

      if (!postDoc.exists) return;

      final currentUpvotes = postDoc.data()?['upvote_count'] ?? 0;
      final currentDownvotes = postDoc.data()?['downvote_count'] ?? 0;

      if (voteDoc.exists) {
        final currentVote = voteDoc.data()?['vote_type'];

        if (currentVote == 'upvote') {
          // Remove upvote
          transaction.delete(voteRef);
          transaction.update(postRef, {'upvote_count': currentUpvotes - 1});
        } else if (currentVote == 'downvote') {
          // Change from downvote to upvote
          transaction.update(voteRef, {
            'user_id': userId,
            'vote_type': 'upvote',
            'created_at': FieldValue.serverTimestamp()
          });
          transaction.update(postRef, {
            'upvote_count': currentUpvotes + 1,
            'downvote_count': currentDownvotes - 1,
          });
        }
      } else {
        // Add new upvote
        transaction.set(voteRef, {
          'user_id': userId,
          'vote_type': 'upvote',
          'created_at': FieldValue.serverTimestamp()
        });
        transaction.update(postRef, {'upvote_count': currentUpvotes + 1});
      }
    });
  }

  /// Downvote a post
  Future<void> downvote(String postId, String userId) async {
    final firestore = FirebaseFirestore.instance;

    final postRef = firestore.collection(collectionName).doc(postId);
    final voteRef = postRef.collection('votes').doc(userId);

    await firestore.runTransaction((transaction) async {
      final voteDoc = await transaction.get(voteRef);
      final postDoc = await transaction.get(postRef);

      if (!postDoc.exists) return;

      final currentUpvotes = postDoc.data()?['upvote_count'] ?? 0;
      final currentDownvotes = postDoc.data()?['downvote_count'] ?? 0;

      if (voteDoc.exists) {
        final currentVote = voteDoc.data()?['vote_type'];

        if (currentVote == 'downvote') {
          // Remove downvote
          transaction.delete(voteRef);
          transaction.update(postRef, {'downvote_count': currentDownvotes - 1});
        } else if (currentVote == 'upvote') {
          // Change from upvote to downvote
          transaction.update(voteRef, {
            'user_id': userId,
            'vote_type': 'downvote',
            'created_at': FieldValue.serverTimestamp()
          });
          transaction.update(postRef, {
            'upvote_count': currentUpvotes - 1,
            'downvote_count': currentDownvotes + 1,
          });
        }
      } else {
        // Add new downvote
        transaction.set(voteRef, {
          'user_id': userId,
          'vote_type': 'downvote',
          'created_at': FieldValue.serverTimestamp()
        });
        transaction.update(postRef, {'downvote_count': currentDownvotes + 1});
      }
    });
  }

  /// Get user's vote on a post
  Future<String?> getUserVote(String postId, String userId) async {
    final firestore = FirebaseFirestore.instance;

    final voteDoc = await firestore
        .collection(collectionName)
        .doc(postId)
        .collection('votes')
        .doc(userId)
        .get();

    if (voteDoc.exists) {
      return voteDoc.data()?['vote_type'] as String?;
    }
    return null;
  }

  /// Get all votes for a post
  Future<List<VoteModel>> getVotes(String postId) async {
    final firestore = FirebaseFirestore.instance;

    final votesSnapshot = await firestore
        .collection(collectionName)
        .doc(postId)
        .collection('votes')
        .get();

    return votesSnapshot.docs
        .map((doc) => VoteModel.fromJson(doc.data()))
        .toList();
  }

  /// Get upvoters for a post
  Future<List<VoteModel>> getUpvoters(String postId) async {
    final firestore = FirebaseFirestore.instance;

    final votesSnapshot = await firestore
        .collection(collectionName)
        .doc(postId)
        .collection('votes')
        .where('vote_type', isEqualTo: 'upvote')
        .get();

    return votesSnapshot.docs
        .map((doc) => VoteModel.fromJson(doc.data()))
        .toList();
  }

  /// Get downvoters for a post
  Future<List<VoteModel>> getDownvoters(String postId) async {
    final firestore = FirebaseFirestore.instance;

    final votesSnapshot = await firestore
        .collection(collectionName)
        .doc(postId)
        .collection('votes')
        .where('vote_type', isEqualTo: 'downvote')
        .get();

    return votesSnapshot.docs
        .map((doc) => VoteModel.fromJson(doc.data()))
        .toList();
  }

  // ═══════════════════════════════════════════════════════════════
  // COMMENT OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Get comments for a post (from subcollection)
  Future<List<CommentModel>> getComments(String postId) async {
    final firestore = FirebaseFirestore.instance;

    final commentsSnapshot = await firestore
        .collection(collectionName)
        .doc(postId)
        .collection('comments')
        .orderBy('created_at', descending: true)
        .get();

    return commentsSnapshot.docs
        .map((doc) => CommentModel.fromJson(doc.data()))
        .toList();
  }

  /// Get count of ALL comments (top-level + replies) for a post
  Future<int> getTotalCommentCount(String postId) async {
    final firestore = FirebaseFirestore.instance;

    final commentsSnapshot = await firestore
        .collection(collectionName)
        .doc(postId)
        .collection('comments')
        .where('isDeleted', isEqualTo: false)
        .get();

    return commentsSnapshot.docs.length;
  }

  /// Add a comment to a post
  Future<void> addComment(String postId, CommentModel comment) async {
    final firestore = FirebaseFirestore.instance;

    final postRef = firestore.collection(collectionName).doc(postId);
    final commentRef = postRef.collection('comments').doc(comment.id);

    await firestore.runTransaction((transaction) async {
      final postDoc = await transaction.get(postRef);

      if (!postDoc.exists) return;

      final currentCommentCount = postDoc.data()?['comment_count'] ?? 0;

      // Add comment to subcollection
      transaction.set(commentRef, comment.toJson());

      // Increment comment count on post
      transaction.update(postRef, {'comment_count': currentCommentCount + 1});
    });
  }

  /// Delete a comment from a post
  Future<void> deleteComment(String postId, String commentId) async {
    final firestore = FirebaseFirestore.instance;

    final postRef = firestore.collection(collectionName).doc(postId);
    final commentRef = postRef.collection('comments').doc(commentId);

    await firestore.runTransaction((transaction) async {
      final postDoc = await transaction.get(postRef);

      if (!postDoc.exists) return;

      final currentCommentCount = postDoc.data()?['comment_count'] ?? 0;

      // Delete comment from subcollection
      transaction.delete(commentRef);

      // Decrement comment count on post (don't go below 0)
      transaction.update(postRef, {
        'comment_count': currentCommentCount > 0 ? currentCommentCount - 1 : 0
      });
    });
  }
}
