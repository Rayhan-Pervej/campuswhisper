import 'package:flutter/material.dart';
import 'package:campuswhisper/core/providers/paginated_provider.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';
import 'package:campuswhisper/models/club_model.dart';
import 'package:campuswhisper/repository/club_repository.dart';
import 'package:campuswhisper/core/database/query_builder.dart';

class ClubProvider extends PaginatedProvider<ClubModel> {
  final ClubRepository _repository = ClubRepository();

  String? _currentCategory;

  // ═══════════════════════════════════════════════════════════════
  // PAGINATION IMPLEMENTATION
  // ═══════════════════════════════════════════════════════════════

  @override
  Future<PaginatedResult<ClubModel>> fetchFirstPage() async {
    if (_currentCategory != null) {
      return await _repository.getByCategory(_currentCategory!, limit: 20);
    } else {
      return await _repository.getAll(
        sorts: [QuerySort.descending('memberCount')],
        limit: 20,
      );
    }
  }

  @override
  Future<PaginatedResult<ClubModel>> fetchNextPage(cursor) async {
    if (_currentCategory != null) {
      return await _repository.getByCategory(
        _currentCategory!,
        limit: 20,
        startAfter: cursor,
      );
    } else {
      return await _repository.getAll(
        sorts: [QuerySort.descending('memberCount')],
        limit: 20,
        startAfter: cursor,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // CRUD OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  Future<void> createClub(BuildContext context, ClubModel club) async {
    final clubId = await safeOperation(
      context,
      operation: () => _repository.create(club),
      successMessage: 'Club created successfully!',
      errorMessage: 'Failed to create club. Please try again.',
    );

    if (clubId != null) {
      addItem(club);
    }
  }

  Future<void> updateClub(BuildContext context, ClubModel club) async {
    await safeOperation(
      context,
      operation: () => _repository.update(club),
      successMessage: 'Club updated successfully!',
      errorMessage: 'Failed to update club. Please try again.',
    );

    updateItem(club, (c) => c.id == club.id);
  }

  Future<void> deleteClub(BuildContext context, String clubId) async {
    await safeOperation(
      context,
      operation: () => _repository.delete(clubId),
      successMessage: 'Club deleted successfully!',
      errorMessage: 'Failed to delete club. Please try again.',
    );

    removeItem((c) => c.id == clubId);
  }

  Future<ClubModel?> getClubById(String clubId) async {
    return await _repository.getById(clubId);
  }

  // ═══════════════════════════════════════════════════════════════
  // CLUB-SPECIFIC OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  Future<void> joinClub(BuildContext context, String clubId, String userId) async {
    // TODO: Implement join logic with backend
    showSuccess(context, 'Successfully joined club!');
  }

  Future<void> leaveClub(BuildContext context, String clubId, String userId) async {
    // TODO: Implement leave logic with backend
    showSuccess(context, 'Left club successfully');
  }

  // ═══════════════════════════════════════════════════════════════
  // FILTER METHODS
  // ═══════════════════════════════════════════════════════════════

  Future<void> filterByCategory(String category) async {
    _currentCategory = category;
    await refresh();
  }

  Future<void> clearFilters() async {
    _currentCategory = null;
    await refresh();
  }

  /// Get clubs that user is a member of
  Future<List<ClubModel>> getUserClubs(String userId) async {
    final result = await _repository.getByMember(userId, limit: 100);
    return result.items;
  }
}
