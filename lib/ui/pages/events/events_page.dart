import 'package:campuswhisper/ui/widgets/app_dimensions.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

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

  final List<Map<String, dynamic>> _allEvents = [
    {
      'eventTitle': 'Tech Talk: Future of AI',
      'organizerName': 'CS Department',
      'description':
          'Join us for an engaging discussion about the future of artificial intelligence and its impact on our daily lives. Industry experts will share insights.',
      'eventDate': DateTime.now().add(const Duration(days: 2, hours: 5)),
      'location': 'Main Auditorium, Building A',
      'category': 'Academic',
      'interestedCount': 45,
      'goingCount': 28,
    },
    {
      'eventTitle': 'Campus Music Festival',
      'organizerName': 'Student Council',
      'description':
          'Annual music festival featuring local bands and student performances. Food trucks, games, and great music all day long!',
      'eventDate': DateTime.now().add(const Duration(days: 7)),
      'location': 'Central Campus Ground',
      'category': 'Cultural',
      'interestedCount': 156,
      'goingCount': 89,
    },
    {
      'eventTitle': 'Basketball Championship Finals',
      'organizerName': 'Athletics Department',
      'description':
          'Don\'t miss the exciting finals of our inter-college basketball championship. Support your team!',
      'eventDate': DateTime.now().add(const Duration(days: 1, hours: 3)),
      'location': 'Sports Complex',
      'category': 'Sports',
      'interestedCount': 78,
      'goingCount': 52,
    },
    {
      'eventTitle': 'Career Fair 2025',
      'organizerName': 'Placement Cell',
      'description':
          'Meet recruiters from top companies. Bring your resumes and dress professionally. Great networking opportunity!',
      'eventDate': DateTime.now().add(const Duration(days: 14)),
      'location': 'Convention Center',
      'category': 'Career',
      'interestedCount': 234,
      'goingCount': 187,
    },
    {
      'eventTitle': 'Python Workshop for Beginners',
      'organizerName': 'Coding Club',
      'description':
          'Learn Python from scratch in this hands-on workshop. Perfect for beginners. Laptops required.',
      'eventDate': DateTime.now().add(const Duration(days: 5, hours: 2)),
      'location': 'Computer Lab 3, IT Building',
      'category': 'Workshop',
      'interestedCount': 67,
      'goingCount': 45,
    },
    {
      'eventTitle': 'International Food Festival',
      'organizerName': 'Cultural Committee',
      'description':
          'Experience cuisines from around the world prepared by our international students. Free entry!',
      'eventDate': DateTime.now().add(const Duration(days: 10)),
      'location': 'Student Cafeteria Lawn',
      'category': 'Social',
      'interestedCount': 189,
      'goingCount': 124,
    },
  ];

  List<Map<String, dynamic>> get _filteredEvents {
    if (_selectedCategory == null) {
      return _allEvents;
    }
    return _allEvents
        .where((event) => event['category'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: DefaultAppBar(title: 'Events'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CategoryChipFilter(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),

            ..._filteredEvents.map((event) {
              return EventCard(
                eventTitle: event['eventTitle'],
                organizerName: event['organizerName'],
                description: event['description'],
                eventDate: event['eventDate'],
                location: event['location'],
                category: event['category'],
                interestedCount: event['interestedCount'],
                goingCount: event['goingCount'],
                eventImageUrl: event['eventImageUrl'],
                organizerImageUrl: event['organizerImageUrl'],
                isInterested: event['isInterested'] ?? false,
                isGoing: event['isGoing'] ?? false,
                onInterested: () {
                  setState(() {
                    event['isInterested'] = !(event['isInterested'] ?? false);
                    if (event['isInterested']) {
                      event['interestedCount'] =
                          (event['interestedCount'] ?? 0) + 1;
                    } else {
                      event['interestedCount'] =
                          (event['interestedCount'] ?? 1) - 1;
                    }
                  });
                },
                onGoing: () {
                  setState(() {
                    event['isGoing'] = !(event['isGoing'] ?? false);
                    if (event['isGoing']) {
                      event['goingCount'] = (event['goingCount'] ?? 0) + 1;
                    } else {
                      event['goingCount'] = (event['goingCount'] ?? 1) - 1;
                    }
                  });
                },
                onShare: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Share feature for "${event['eventTitle']}"',
                      ),
                    ),
                  );
                },
              );
            }),
            AppDimensions.h12,
          ],
        ),
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
                  setState(() {
                    _allEvents.insert(0, newEvent);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Event created successfully!'),
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
