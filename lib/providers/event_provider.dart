import 'package:flutter/material.dart';
import 'package:campuswhisper/core/providers/paginated_provider.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';
import 'package:campuswhisper/models/event_model.dart';
import 'package:campuswhisper/repository/event_repository.dart';
import 'package:campuswhisper/core/database/query_builder.dart';

class EventProvider extends PaginatedProvider<EventModel> {
  final EventRepository _repository = EventRepository();

  String? _currentCategory;
  bool _showUpcomingOnly = true;

  // ═══════════════════════════════════════════════════════════════
  // PAGINATION IMPLEMENTATION
  // ═══════════════════════════════════════════════════════════════

  @override
  Future<PaginatedResult<EventModel>> fetchFirstPage() async {
    if (_currentCategory != null) {
      return await _repository.getByCategory(_currentCategory!, limit: 20);
    } else if (_showUpcomingOnly) {
      return await _repository.getUpcoming(limit: 20);
    } else {
      return await _repository.getAll(
        sorts: [QuerySort.descending('eventDate')],
        limit: 20,
      );
    }
  }

  @override
  Future<PaginatedResult<EventModel>> fetchNextPage(cursor) async {
    if (_currentCategory != null) {
      return await _repository.getByCategory(
        _currentCategory!,
        limit: 20,
        startAfter: cursor,
      );
    } else if (_showUpcomingOnly) {
      return await _repository.getUpcoming(limit: 20, startAfter: cursor);
    } else {
      return await _repository.getAll(
        sorts: [QuerySort.descending('eventDate')],
        limit: 20,
        startAfter: cursor,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // CRUD OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  Future<void> createEvent(BuildContext context, EventModel event) async {
    final eventId = await safeOperation(
      context,
      operation: () => _repository.create(event),
      successMessage: 'Event created successfully!',
      errorMessage: 'Failed to create event. Please try again.',
    );

    if (eventId != null) {
      addItem(event);
    }
  }

  Future<void> updateEvent(BuildContext context, EventModel event) async {
    await safeOperation(
      context,
      operation: () => _repository.update(event),
      successMessage: 'Event updated successfully!',
      errorMessage: 'Failed to update event. Please try again.',
    );

    updateItem(event, (e) => e.id == event.id);
  }

  Future<void> deleteEvent(BuildContext context, String eventId) async {
    await safeOperation(
      context,
      operation: () => _repository.delete(eventId),
      successMessage: 'Event deleted successfully!',
      errorMessage: 'Failed to delete event. Please try again.',
    );

    removeItem((e) => e.id == eventId);
  }

  // ═══════════════════════════════════════════════════════════════
  // EVENT-SPECIFIC OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  Future<void> registerForEvent(BuildContext context, String eventId, String userId) async {
    // TODO: Implement registration logic with user feedback
    showSuccess(context, 'Successfully registered for event!');
  }

  Future<void> unregisterFromEvent(BuildContext context, String eventId, String userId) async {
    // TODO: Implement unregistration logic with user feedback
    showSuccess(context, 'Unregistered from event');
  }

  // ═══════════════════════════════════════════════════════════════
  // FILTER METHODS
  // ═══════════════════════════════════════════════════════════════

  Future<void> filterByCategory(String category) async {
    _currentCategory = category;
    await refresh();
  }

  Future<void> showUpcoming() async {
    _showUpcomingOnly = true;
    _currentCategory = null;
    await refresh();
  }

  Future<void> showPast() async {
    _showUpcomingOnly = false;
    _currentCategory = null;
    await refresh();
  }

  Future<void> clearFilters() async {
    _currentCategory = null;
    _showUpcomingOnly = true;
    await refresh();
  }
}
