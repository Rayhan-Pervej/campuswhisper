import 'package:campuswhisper/models/faq_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FAQRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'faqs';

  // POST: Create a new FAQ
  Future<String> createFAQ(FAQModel faq) async {
    try {
      // Generate a new document ID first
      DocumentReference docRef = _firestore.collection(_collectionName).doc();
      String generatedId = docRef.id;
      
      // Create new FAQ with the generated ID
      FAQModel faqWithId = FAQModel(
        id: generatedId,
        question: faq.question,
        answer: faq.answer,
        createdBy: faq.createdBy,
        upvoteCount: faq.upvoteCount,
        createdAt: faq.createdAt,
      );
      
      // Store data in the document with the generated ID
      await docRef.set(faqWithId.toMap());
      
      return generatedId;
    } catch (e) {
      throw Exception('Failed to create FAQ: $e');
    }
  }

  // POST: Update existing FAQ
  Future<void> updateFAQ(FAQModel faq) async {
    try {
      await _firestore.collection(_collectionName).doc(faq.id).update(faq.toMap());
    } catch (e) {
      throw Exception('Failed to update FAQ: $e');
    }
  }

  // FETCH: Get FAQ by ID
  Future<FAQModel?> getFAQById(String faqId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collectionName).doc(faqId).get();
      
      if (doc.exists) {
        return FAQModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get FAQ by ID: $e');
    }
  }

  // FETCH: Get all FAQs
  Future<List<FAQModel>> getAllFAQs() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('created_at', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => FAQModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all FAQs: $e');
    }
  }

  // FETCH: Get FAQs by user
  Future<List<FAQModel>> getFAQsByUser(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('created_by', isEqualTo: userId)
          .orderBy('created_at', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => FAQModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get FAQs by user: $e');
    }
  }

  // FETCH: Search FAQs by question content
  Future<List<FAQModel>> searchFAQs(String searchTerm) async {
    try {
      // Convert search term to lowercase for case-insensitive search
      String lowerSearchTerm = searchTerm.toLowerCase();
      
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('created_at', descending: true)
          .get();
      
      // Filter results based on question content (client-side filtering)
      List<FAQModel> allFAQs = querySnapshot.docs
          .map((doc) => FAQModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      
      return allFAQs.where((faq) => 
          faq.question.toLowerCase().contains(lowerSearchTerm) ||
          faq.answer.toLowerCase().contains(lowerSearchTerm)
      ).toList();
    } catch (e) {
      throw Exception('Failed to search FAQs: $e');
    }
  }

  // FETCH: Get most popular FAQs (sorted by upvotes)
  Future<List<FAQModel>> getPopularFAQs({int limit = 10}) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('upvote_count', descending: true)
          .limit(limit)
          .get();
      
      return querySnapshot.docs
          .map((doc) => FAQModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get popular FAQs: $e');
    }
  }

  // FETCH: Get recent FAQs
  Future<List<FAQModel>> getRecentFAQs({int limit = 5}) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('created_at', descending: true)
          .limit(limit)
          .get();
      
      return querySnapshot.docs
          .map((doc) => FAQModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get recent FAQs: $e');
    }
  }
}