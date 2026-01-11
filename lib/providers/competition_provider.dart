import 'package:flutter/material.dart';
import 'package:campuswhisper/core/providers/paginated_provider.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';
import 'package:campuswhisper/models/competition_model.dart';
import 'package:campuswhisper/repository/competition_repository.dart';
import 'package:campuswhisper/core/database/query_builder.dart';

class CompetitionProvider extends PaginatedProvider<CompetitionModel> {
  final CompetitionRepository _repository = CompetitionRepository();

  String? _currentStatus;
  bool _showRegistrationOpen = false;

  // ═══════════════════════════════════════════════════════════════
  // PAGINATION IMPLEMENTATION
  // ═══════════════════════════════════════════════════════════════

  @override
  Future<PaginatedResult<CompetitionModel>> fetchFirstPage() async {
    if (_showRegistrationOpen) {
      return await _repository.getRegistrationOpen(limit: 20);
    } else if (_currentStatus != null) {
      return await _repository.getByStatus(_currentStatus!, limit: 20);
    } else {
      return await _repository.getAll(
        sorts: [QuerySort.descending('createdAt')],
        limit: 20,
      );
    }
  }

  @override
  Future<PaginatedResult<CompetitionModel>> fetchNextPage(cursor) async {
    if (_showRegistrationOpen) {
      return await _repository.getRegistrationOpen(
        limit: 20,
        startAfter: cursor,
      );
    } else if (_currentStatus != null) {
      return await _repository.getByStatus(
        _currentStatus!,
        limit: 20,
        startAfter: cursor,
      );
    } else {
      return await _repository.getAll(
        sorts: [QuerySort.descending('createdAt')],
        limit: 20,
        startAfter: cursor,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // CRUD OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  Future<void> createCompetition(BuildContext context, CompetitionModel competition) async {
    final competitionId = await safeOperation(
      context,
      operation: () => _repository.create(competition),
      successMessage: 'Competition created successfully!',
      errorMessage: 'Failed to create competition. Please try again.',
    );

    if (competitionId != null) {
      addItem(competition);
    }
  }

  Future<void> updateCompetition(BuildContext context, CompetitionModel competition) async {
    await safeOperation(
      context,
      operation: () => _repository.update(competition),
      successMessage: 'Competition updated successfully!',
      errorMessage: 'Failed to update competition. Please try again.',
    );

    updateItem(competition, (c) => c.id == competition.id);
  }

  Future<void> deleteCompetition(BuildContext context, String competitionId) async {
    await safeOperation(
      context,
      operation: () => _repository.delete(competitionId),
      successMessage: 'Competition deleted successfully!',
      errorMessage: 'Failed to delete competition. Please try again.',
    );

    removeItem((c) => c.id == competitionId);
  }

  Future<CompetitionModel?> getCompetitionById(String competitionId) async {
    return await _repository.getById(competitionId);
  }

  // ═══════════════════════════════════════════════════════════════
  // COMPETITION-SPECIFIC OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  Future<void> registerForCompetition(
    BuildContext context,
    String competitionId,
    String userId,
    Map<String, dynamic> registrationData,
  ) async {
    // TODO: Implement registration logic with backend
    showSuccess(context, 'Successfully registered for competition!');
  }

  Future<void> unregisterFromCompetition(
    BuildContext context,
    String competitionId,
    String userId,
  ) async {
    // TODO: Implement unregistration logic with backend
    showSuccess(context, 'Unregistered from competition');
  }

  // ═══════════════════════════════════════════════════════════════
  // FILTER METHODS
  // ═══════════════════════════════════════════════════════════════

  Future<void> filterByStatus(String status) async {
    _currentStatus = status;
    _showRegistrationOpen = false;
    await refresh();
  }

  Future<void> showOnlyRegistrationOpen() async {
    _showRegistrationOpen = true;
    _currentStatus = null;
    await refresh();
  }

  Future<void> clearFilters() async {
    _currentStatus = null;
    _showRegistrationOpen = false;
    await refresh();
  }

  /// Get competitions organized by user
  Future<List<CompetitionModel>> getOrganizerCompetitions(String organizerId) async {
    final result = await _repository.getByOrganizer(organizerId, limit: 100);
    return result.items;
  }
}
