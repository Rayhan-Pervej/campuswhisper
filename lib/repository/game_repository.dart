import 'package:campuswhisper/core/repositories/base_repository.dart';
import 'package:campuswhisper/models/badges_history_model.dart';
import 'package:campuswhisper/models/xp_history_model.dart';
import 'package:campuswhisper/core/database/query_builder.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';
import 'package:campuswhisper/core/config/app_config.dart';

/// Special repository for gamification features
///
/// Manages two collections: xp_history, badges_history
/// Plus custom gamification logic
///
/// Note: Votes are now handled as subcollections under posts.
/// Use PostRepository for vote operations.
class GameRepository {
  // Sub-repositories for each model type
  final _xpHistoryRepo = _XpHistoryRepository();
  final _badgeHistoryRepo = _BadgeHistoryRepository();

  // ═══════════════════════════════════════════════════════════════
  // XP HISTORY METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Add XP history entry
  Future<String> addXpHistory(XpHistoryModel xpHistory) async {
    return await _xpHistoryRepo.create(xpHistory);
  }

  /// Get XP history by user (with pagination)
  Future<PaginatedResult<XpHistoryModel>> getXpHistoryByUser(
    String userId, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return _xpHistoryRepo.getByUser(userId, limit: limit, startAfter: startAfter);
  }

  /// Get all XP history (with pagination)
  Future<PaginatedResult<XpHistoryModel>> getAllXpHistory({
    int limit = 20,
    dynamic startAfter,
  }) async {
    return _xpHistoryRepo.getAll(
      sorts: [QuerySort.descending('timestamp')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // BADGE HISTORY METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Award badge to user
  Future<String> awardBadge(BadgeHistoryModel badgeHistory) async {
    return await _badgeHistoryRepo.create(badgeHistory);
  }

  /// Get badge history by user (with pagination)
  Future<PaginatedResult<BadgeHistoryModel>> getBadgeHistoryByUser(
    String userId, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return _badgeHistoryRepo.getByUser(userId, limit: limit, startAfter: startAfter);
  }

  /// Get all badge history (with pagination)
  Future<PaginatedResult<BadgeHistoryModel>> getAllBadgeHistory({
    int limit = 20,
    dynamic startAfter,
  }) async {
    return _badgeHistoryRepo.getAll(
      sorts: [QuerySort.descending('awarded_at')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // GAMIFICATION LOGIC
  // ═══════════════════════════════════════════════════════════════

  /// Calculate XP amount based on action type
  int calculateXpAmount(String actionType) {
    return AppConfig.xpAmounts[actionType.toLowerCase()] ?? 1;
  }

  /// Check if user qualifies for new badges
  Future<List<String>> checkBadgeEligibility(
    String userId,
    int totalXp,
    int totalContributions,
  ) async {
    List<String> newBadges = [];

    // Get existing badges to avoid duplicates
    final existingBadges = await getBadgeHistoryByUser(userId, limit: 100);
    final existingBadgeNames = existingBadges.items.map((b) => b.badgeName).toList();

    // Check all badge thresholds from AppConfig
    AppConfig.badgeThresholds.forEach((badgeName, threshold) {
      if (!existingBadgeNames.contains(badgeName)) {
        // XP-based badges
        if (badgeName.contains('XP') && totalXp >= threshold) {
          newBadges.add(badgeName);
        }
        // Contribution-based badges
        else if (!badgeName.contains('XP') && totalContributions >= threshold) {
          newBadges.add(badgeName);
        }
      }
    });

    return newBadges;
  }
}

// ═══════════════════════════════════════════════════════════════
// INTERNAL SUB-REPOSITORIES
// ═══════════════════════════════════════════════════════════════

class _XpHistoryRepository extends BaseRepository<XpHistoryModel> {
  @override
  String get collectionName => 'xp_history';

  @override
  XpHistoryModel fromJson(Map<String, dynamic> json) => XpHistoryModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(XpHistoryModel model) => model.toJson();

  @override
  String getId(XpHistoryModel model) => model.id;

  Future<PaginatedResult<XpHistoryModel>> getByUser(
    String userId, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('user_id', userId)],
      sorts: [QuerySort.descending('timestamp')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  Future<PaginatedResult<XpHistoryModel>> getByType(
    String type, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('type', type)],
      sorts: [QuerySort.descending('timestamp')],
      limit: limit,
      startAfter: startAfter,
    );
  }
}

class _BadgeHistoryRepository extends BaseRepository<BadgeHistoryModel> {
  @override
  String get collectionName => 'badges_history';

  @override
  BadgeHistoryModel fromJson(Map<String, dynamic> json) => BadgeHistoryModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(BadgeHistoryModel model) => model.toJson();

  @override
  String getId(BadgeHistoryModel model) => model.id;

  Future<PaginatedResult<BadgeHistoryModel>> getByUser(
    String userId, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('user_id', userId)],
      sorts: [QuerySort.descending('awarded_at')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  Future<PaginatedResult<BadgeHistoryModel>> getByBadge(
    String badgeName, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('badge_name', badgeName)],
      sorts: [QuerySort.descending('awarded_at')],
      limit: limit,
      startAfter: startAfter,
    );
  }
}
