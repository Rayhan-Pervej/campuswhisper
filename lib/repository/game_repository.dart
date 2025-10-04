import 'package:campuswhisper/models/badges_history_model.dart';
import 'package:campuswhisper/models/vote_model.dart';
import 'package:campuswhisper/models/xp_history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class GameRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _xpHistoryCollection = 'xp_history';
  final String _badgeHistoryCollection = 'badges_history';
  final String _votesCollection = 'votes';

  // ==================== XP HISTORY METHODS ====================

  // POST: Add XP history entry
  Future<String> addXpHistory(XpHistoryModel xpHistory) async {
    try {
      // Generate a new document ID first
      DocumentReference docRef = _firestore.collection(_xpHistoryCollection).doc();
      String generatedId = docRef.id;
      
      // Create XP history with the generated ID
      XpHistoryModel xpWithId = XpHistoryModel(
        id: generatedId,
        userId: xpHistory.userId,
        type: xpHistory.type,
        amount: xpHistory.amount,
        timestamp: xpHistory.timestamp,
        relatedPost: xpHistory.relatedPost,
      );
      
      // Store data in the document with the generated ID
      await docRef.set(xpWithId.toMap());
      
      return generatedId;
    } catch (e) {
      throw Exception('Failed to add XP history: $e');
    }
  }

  // FETCH: Get XP history by user
  Future<List<XpHistoryModel>> getXpHistoryByUser(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_xpHistoryCollection)
          .where('user_id', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => XpHistoryModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get XP history by user: $e');
    }
  }

  // FETCH: Get all XP history
  Future<List<XpHistoryModel>> getAllXpHistory() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_xpHistoryCollection)
          .orderBy('timestamp', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => XpHistoryModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all XP history: $e');
    }
  }

  // ==================== BADGE HISTORY METHODS ====================

  // POST: Award badge to user
  Future<String> awardBadge(BadgeHistoryModel badgeHistory) async {
    try {
      // Generate a new document ID first
      DocumentReference docRef = _firestore.collection(_badgeHistoryCollection).doc();
      String generatedId = docRef.id;
      
      // Create badge history with the generated ID
      BadgeHistoryModel badgeWithId = BadgeHistoryModel(
        id: generatedId,
        userId: badgeHistory.userId,
        badgeName: badgeHistory.badgeName,
        awardedAt: badgeHistory.awardedAt,
      );
      
      // Store data in the document with the generated ID
      await docRef.set(badgeWithId.toMap());
      
      return generatedId;
    } catch (e) {
      throw Exception('Failed to award badge: $e');
    }
  }

  // FETCH: Get badge history by user
  Future<List<BadgeHistoryModel>> getBadgeHistoryByUser(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_badgeHistoryCollection)
          .where('user_id', isEqualTo: userId)
          .orderBy('awarded_at', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => BadgeHistoryModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get badge history by user: $e');
    }
  }

  // FETCH: Get all badge history
  Future<List<BadgeHistoryModel>> getAllBadgeHistory() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_badgeHistoryCollection)
          .orderBy('awarded_at', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => BadgeHistoryModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all badge history: $e');
    }
  }

  // ==================== VOTE METHODS ====================

  // POST: Create vote
  Future<String> createVote(VoteModel vote) async {
    try {
      // Generate a new document ID first
      DocumentReference docRef = _firestore.collection(_votesCollection).doc();
      String generatedId = docRef.id;
      
      // Create vote with the generated ID
      VoteModel voteWithId = VoteModel(
        voteId: generatedId,
        postId: vote.postId,
        voterId: vote.voterId,
        voteType: vote.voteType,
        createdAt: vote.createdAt,
      );
      
      // Store data in the document with the generated ID
      await docRef.set(voteWithId.toMap());
      
      return generatedId;
    } catch (e) {
      throw Exception('Failed to create vote: $e');
    }
  }

  // FETCH: Get votes by post
  Future<List<VoteModel>> getVotesByPost(String postId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_votesCollection)
          .where('post_id', isEqualTo: postId)
          .get();
      
      return querySnapshot.docs
          .map((doc) => VoteModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get votes by post: $e');
    }
  }

  // FETCH: Get votes by user
  Future<List<VoteModel>> getVotesByUser(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_votesCollection)
          .where('voter_id', isEqualTo: userId)
          .orderBy('created_at', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => VoteModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get votes by user: $e');
    }
  }

  // FETCH: Get specific user vote for a post (to prevent duplicate voting)
  Future<VoteModel?> getUserVoteForPost(String userId, String postId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_votesCollection)
          .where('voter_id', isEqualTo: userId)
          .where('post_id', isEqualTo: postId)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        return VoteModel.fromMap(querySnapshot.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user vote for post: $e');
    }
  }

  // ==================== GAMIFICATION LOGIC METHODS ====================

  // Helper: Calculate XP amount based on action type
  int calculateXpAmount(String actionType) {
    switch (actionType.toLowerCase()) {
      case 'post_contribution':
        return 20;
      case 'post_upvote':
        return 5;
      case 'comment':
        return 10;
      case 'hack_upvote':
        return 3;
      case 'review_upvote':
        return 5;
      default:
        return 1;
    }
  }

  // Helper: Check if user qualifies for badge
  Future<List<String>> checkBadgeEligibility(String userId, int totalXp, int totalContributions) async {
    List<String> newBadges = [];
    
    // Get existing badges to avoid duplicates
    List<BadgeHistoryModel> existingBadges = await getBadgeHistoryByUser(userId);
    List<String> existingBadgeNames = existingBadges.map((b) => b.badgeName).toList();
    
    // XP-based badges
    if (totalXp >= 100 && !existingBadgeNames.contains('XP Rookie')) {
      newBadges.add('XP Rookie');
    }
    if (totalXp >= 500 && !existingBadgeNames.contains('XP Champion')) {
      newBadges.add('XP Champion');
    }
    if (totalXp >= 1000 && !existingBadgeNames.contains('XP Master')) {
      newBadges.add('XP Master');
    }
    
    // Contribution-based badges
    if (totalContributions >= 5 && !existingBadgeNames.contains('Contributor')) {
      newBadges.add('Contributor');
    }
    if (totalContributions >= 20 && !existingBadgeNames.contains('Top Reviewer')) {
      newBadges.add('Top Reviewer');
    }
    if (totalContributions >= 50 && !existingBadgeNames.contains('Campus Legend')) {
      newBadges.add('Campus Legend');
    }
    
    return newBadges;
  }
}