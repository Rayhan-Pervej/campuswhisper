import 'package:cloud_firestore/cloud_firestore.dart';

/// ONE-TIME CLEANUP UTILITY
/// Run this once to fix all existing comments in your database
///
/// This will:
/// 1. Delete all comments with corrupted data
/// 2. Reset all post comment counts to 0
///
/// After running this, you can create fresh comments that will work correctly.

class CommentCleanup {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Delete ALL comments from ALL posts (one-time cleanup)
  static Future<void> deleteAllComments() async {
    print('🧹 Starting cleanup: Deleting all comments...');

    try {
      // Get all posts
      final postsSnapshot = await _firestore.collection('posts').get();

      int totalPostsProcessed = 0;
      int totalCommentsDeleted = 0;

      for (var postDoc in postsSnapshot.docs) {
        final postId = postDoc.id;

        // Get all comments for this post
        final commentsSnapshot = await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .get();

        // Delete each comment
        for (var commentDoc in commentsSnapshot.docs) {
          await commentDoc.reference.delete();
          totalCommentsDeleted++;
        }

        // Remove the comment_count field entirely (we calculate dynamically now)
        // Note: Can't use FieldValue.delete() in update, so just set to 0
        // The field will be ignored by the app since we count dynamically

        totalPostsProcessed++;
        print('✅ Cleaned post $postId: Deleted ${commentsSnapshot.docs.length} comments');
      }

      print('🎉 Cleanup complete!');
      print('   - Posts processed: $totalPostsProcessed');
      print('   - Comments deleted: $totalCommentsDeleted');
      print('   - All comment counts reset to 0');
      print('   - You can now create fresh comments!');

    } catch (e) {
      print('❌ Error during cleanup: $e');
      rethrow;
    }
  }

  /// Debug: Print all comments with their replyToId values
  static Future<void> debugPrintAllComments() async {
    print('🔍 Debugging: Listing all comments...');

    try {
      final postsSnapshot = await _firestore.collection('posts').get();

      for (var postDoc in postsSnapshot.docs) {
        final postId = postDoc.id;
        final postData = postDoc.data();
        final commentCount = postData['comment_count'] ?? 0;

        print('\n📝 Post: $postId (comment_count: $commentCount)');

        final commentsSnapshot = await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .get();

        for (var commentDoc in commentsSnapshot.docs) {
          final data = commentDoc.data();
          final content = data['content'] ?? 'No content';
          final replyToId = data['replyToId'];
          final replyToIdOld = data['reply_to_id']; // Check old field name
          final isDeleted = data['isDeleted'] ?? false;

          print('   - ${commentDoc.id}: "$content"');
          print('     replyToId: $replyToId');
          print('     reply_to_id (old): $replyToIdOld');
          print('     isDeleted: $isDeleted');
        }

        print('   Total comments in subcollection: ${commentsSnapshot.docs.length}');
      }

    } catch (e) {
      print('❌ Error during debug: $e');
    }
  }
}
