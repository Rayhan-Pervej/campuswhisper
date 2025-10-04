import 'package:campuswhisper/models/hack_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HackRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'hacks';

  // POST: Create a new hack
  Future<String> createHack(HackModel hack) async {
    try {
      // Generate a new document ID first
      DocumentReference docRef = _firestore.collection(_collectionName).doc();
      String generatedId = docRef.id;
      
      // Create new hack with the generated ID
      HackModel hackWithId = HackModel(
        id: generatedId,
        text: hack.text,
        tag: hack.tag,
        createdBy: hack.createdBy,
        upvoteCount: hack.upvoteCount,
        createdAt: hack.createdAt,
      );
      
      // Store data in the document with the generated ID
      await docRef.set(hackWithId.toMap());
      
      return generatedId;
    } catch (e) {
      throw Exception('Failed to create hack: $e');
    }
  }

  // POST: Update existing hack
  Future<void> updateHack(HackModel hack) async {
    try {
      await _firestore.collection(_collectionName).doc(hack.id).update(hack.toMap());
    } catch (e) {
      throw Exception('Failed to update hack: $e');
    }
  }

  // FETCH: Get hack by ID
  Future<HackModel?> getHackById(String hackId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collectionName).doc(hackId).get();
      
      if (doc.exists) {
        return HackModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get hack by ID: $e');
    }
  }

  // FETCH: Get all hacks
  Future<List<HackModel>> getAllHacks() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('created_at', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => HackModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all hacks: $e');
    }
  }

  // FETCH: Get hacks by user
  Future<List<HackModel>> getHacksByUser(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('created_by', isEqualTo: userId)
          .orderBy('created_at', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => HackModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get hacks by user: $e');
    }
  }

  // FETCH: Get hacks by tag
  Future<List<HackModel>> getHacksByTag(String tag) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('tag', isEqualTo: tag)
          .orderBy('created_at', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => HackModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get hacks by tag: $e');
    }
  }

  // FETCH: Get most popular hacks (sorted by upvotes)
  Future<List<HackModel>> getPopularHacks({int limit = 10}) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('upvote_count', descending: true)
          .limit(limit)
          .get();
      
      return querySnapshot.docs
          .map((doc) => HackModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get popular hacks: $e');
    }
  }

  // FETCH: Search hacks by text content
  Future<List<HackModel>> searchHacks(String searchTerm) async {
    try {
      // Convert search term to lowercase for case-insensitive search
      String lowerSearchTerm = searchTerm.toLowerCase();
      
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('created_at', descending: true)
          .get();
      
      // Filter results based on text content (client-side filtering)
      List<HackModel> allHacks = querySnapshot.docs
          .map((doc) => HackModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      
      return allHacks.where((hack) => 
          hack.text.toLowerCase().contains(lowerSearchTerm)
      ).toList();
    } catch (e) {
      throw Exception('Failed to search hacks: $e');
    }
  }

  // FETCH: Get recent hacks
  Future<List<HackModel>> getRecentHacks({int limit = 5}) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('created_at', descending: true)
          .limit(limit)
          .get();
      
      return querySnapshot.docs
          .map((doc) => HackModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get recent hacks: $e');
    }
  }

  // FETCH: Get hacks by multiple tags
  Future<List<HackModel>> getHacksByTags(List<String> tags) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('tag', whereIn: tags)
          .orderBy('created_at', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => HackModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get hacks by tags: $e');
    }
  }

  // FETCH: Get all available tags
  Future<List<String>> getAllTags() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection(_collectionName).get();
      
      Set<String> tags = {};
      for (var doc in querySnapshot.docs) {
        HackModel hack = HackModel.fromMap(doc.data() as Map<String, dynamic>);
        tags.add(hack.tag);
      }
      
      return tags.toList()..sort();
    } catch (e) {
      throw Exception('Failed to get all tags: $e');
    }
  }
}