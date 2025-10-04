import 'package:campuswhisper/models/posts_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'posts';

  // POST: Create a new post
  Future<String> createPost(PostModel post) async {
    try {
      // Generate a new document ID first
      DocumentReference docRef = _firestore.collection(_collectionName).doc();
      String generatedId = docRef.id;

      // Create new post with the generated ID
      PostModel postWithId = PostModel(
        postId: generatedId,
        type: post.type,
        createdBy: post.createdBy,
        content: post.content,
        createdAt: post.createdAt,
        courseId: post.courseId,
        title: post.title,
        upvoteCount: post.upvoteCount,
        downvoteCount: post.downvoteCount,
        updatedAt: post.updatedAt,
      );

      // Store data in the document with the generated ID
      await docRef.set(postWithId.toMap());

      return generatedId;
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  // POST: Update existing post
  Future<void> updatePost(PostModel post) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(post.postId)
          .update(post.toMap());
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }

  // FETCH: Get post by ID
  Future<PostModel?> getPostById(String postId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_collectionName)
          .doc(postId)
          .get();

      if (doc.exists) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get post by ID: $e');
    }
  }

  // FETCH: Get all posts
  Future<List<PostModel>> getAllPosts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('created_at', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all posts: $e');
    }
  }

  // FETCH: Get posts by type (review, hack, faq)
  Future<List<PostModel>> getPostsByType(String type) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('type', isEqualTo: type)
          .orderBy('created_at', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get posts by type: $e');
    }
  }

  // FETCH: Get posts by course
  Future<List<PostModel>> getPostsByCourse(String courseId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('course_id', isEqualTo: courseId)
          .orderBy('created_at', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get posts by course: $e');
    }
  }

  // FETCH: Get posts by user
  Future<List<PostModel>> getPostsByUser(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('created_by', isEqualTo: userId)
          .orderBy('created_at', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get posts by user: $e');
    }
  }
}
