import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';
import 'package:campuswhisper/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_bottom_dialog.dart';
import 'widgets/add_event.dart';
import 'widgets/category_chip_filter.dart';
import 'widgets/event_card.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  String? _selectedCategory;
  final List<String> _categories = [
    'Academic',
    'Social',
    'Sports',
    'Cultural',
    'Workshop',
    'Career',
    'Competition',
    'Conference',
  ];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load initial events
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().loadInitial();
    });

    // Setup infinite scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      context.read<EventProvider>().loadMore();
    }
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
    });

    final provider = context.read<EventProvider>();
    if (category == null) {
      provider.clearFilters();
    } else {
      provider.filterByCategory(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: DefaultAppBar(title: 'Events'),
      body: Consumer<EventProvider>(
        builder: (context, provider, child) {
          // Loading state (first load)
          if (provider.isLoading && provider.items.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(colorScheme.primary),
              ),
            );
          }

          // Error state
          if (provider.hasError && provider.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.danger_outline,
                    size: AppDimensions.largeIconSize * 2,
                    color: colorScheme.error,
                  ),
                  AppDimensions.h16,
                  Text(
                    'Failed to load events',
                    style: TextStyle(
                      fontSize: AppDimensions.subtitleFontSize,
                      color: colorScheme.onSurface.withAlpha(153),
                    ),
                  ),
                  AppDimensions.h8,
                  Text(
                    provider.errorMessage ?? 'Please try again',
                    style: TextStyle(
                      fontSize: AppDimensions.bodyFontSize,
                      color: colorScheme.onSurface.withAlpha(102),
                    ),
                  ),
                  AppDimensions.h16,
                  ElevatedButton.icon(
                    onPressed: () => provider.refresh(),
                    icon: Icon(Iconsax.refresh_outline),
                    label: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (provider.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.calendar_outline,
                    size: AppDimensions.largeIconSize * 2,
                    color: colorScheme.onSurface.withAlpha(77),
                  ),
                  AppDimensions.h16,
                  Text(
                    'No events yet',
                    style: TextStyle(
                      fontSize: AppDimensions.subtitleFontSize,
                      color: colorScheme.onSurface.withAlpha(153),
                    ),
                  ),
                  AppDimensions.h8,
                  Text(
                    'Be the first to create an event!',
                    style: TextStyle(
                      fontSize: AppDimensions.bodyFontSize,
                      color: colorScheme.onSurface.withAlpha(102),
                    ),
                  ),
                ],
              ),
            );
          }

          // Events list
          return RefreshIndicator(
            onRefresh: () => provider.refresh(),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  CategoryChipFilter(
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onCategorySelected: _onCategorySelected,
                  ),

                  // Events
                  ...provider.items.map((event) {
                    return EventCard(
                      eventTitle: event.title,
                      organizerName: event.organizerName,
                      description: event.description,
                      eventDate: event.eventDate,
                      location: event.location,
                      category: event.category,
                      interestedCount: 0, // TODO: Implement interested tracking
                      goingCount: event.attendeeCount,
                      eventImageUrl: event.imageUrl,
                      organizerImageUrl: null,
                      isInterested: false, // TODO: Track user's interested status
                      isGoing: false, // TODO: Check if current user is in attendeeIds
                      onInterested: () {
                        // TODO: Implement interested functionality
                        print('Interested clicked for ${event.id}');
                      },
                      onGoing: () {
                        // TODO: Implement registration/unregistration
                        print('Going clicked for ${event.id}');
                      },
                      onShare: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Share feature for "${event.title}"'),
                          ),
                        );
                      },
                    );
                  }),

                  // Loading more indicator
                  if (provider.isLoadingMore)
                    Padding(
                      padding: EdgeInsets.all(AppDimensions.space16),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                      ),
                    ),

                  // End of list indicator
                  if (!provider.hasMore && provider.items.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.all(AppDimensions.space16),
                      child: Text(
                        'No more events',
                        style: TextStyle(
                          fontSize: AppDimensions.captionFontSize,
                          color: colorScheme.onSurface.withAlpha(102),
                        ),
                      ),
                    ),

                  AppDimensions.h12,
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: SizedBox(
        height: AppDimensions.space40 * 1.5,
        width: AppDimensions.space40 * 1.5,
        child: FloatingActionButton(
          onPressed: () {
            CustomBottomDialog.show(
              context: context,
              title: 'Create New Event',
              child: AddEvent(
                categories: _categories,
                onEventCreated: (newEvent) {
                  // Create event using provider
                  // TODO: Convert newEvent map to EventModel and use provider.createEvent()
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Event creation not yet implemented'),
                    ),
                  );
                },
              ),
            );
          },
          backgroundColor: colorScheme.primary,
          child: Icon(
            Iconsax.add_outline,
            color: colorScheme.onPrimary,
            size: AppDimensions.space32,
          ),
        ),
      ),
    );
  }
}
