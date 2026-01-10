import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../widgets/custom_bottom_dialog.dart';
import '../../widgets/search_appbar.dart';
import 'widgets/add_competition.dart';
import 'widgets/category_chip_filter.dart';
import 'widgets/competition_card.dart';
import 'widgets/status_chip_filter.dart';

class CompetitionsPage extends StatefulWidget {
  const CompetitionsPage({super.key});

  @override
  State<CompetitionsPage> createState() => _CompetitionsPageState();
}

class _CompetitionsPageState extends State<CompetitionsPage> {
  final bool _isAdmin = false; // TODO: Replace with actual admin check
  String? _selectedCategory;
  String? _selectedStatus;
  bool _isSearching = false;
  String _searchQuery = '';
  String? _searchCategoryFilter;

  final List<String> _categories = [
    'Hackathon',
    'Design',
    'Quiz',
    'Sports',
    'Gaming',
    'Academic',
    'Photography',
    'Music',
    'Dance',
    'Debate',
  ];

  final List<String> _statuses = [
    'Registration Open',
    'Upcoming',
    'Ongoing',
    'Ended',
  ];

  final List<Map<String, dynamic>> _allCompetitions = [
    {
      'title': 'National Hackathon 2026',
      'organizer': 'Tech Club',
      'description':
          'Build innovative solutions for real-world problems. 48-hour coding marathon with exciting prizes and mentorship from industry experts.',
      'registrationDeadline': DateTime.now().add(const Duration(days: 5)),
      'eventDate': DateTime.now().add(const Duration(days: 10)),
      'duration': '48 hours',
      'location': 'Main Auditorium & Computer Labs',
      'category': 'Hackathon',
      'status': 'Registration Open',
      'prizePool': '₹50,000',
      'participantCount': 156,
      'teamSize': '3-5 members',
      'isFeatured': true,
    },
    {
      'title': 'UI/UX Design Challenge',
      'organizer': 'Design Society',
      'description':
          'Redesign the campus mobile app with focus on accessibility and user experience. Show your creativity and design thinking skills.',
      'registrationDeadline': DateTime.now().add(const Duration(days: 3)),
      'eventDate': DateTime.now().add(const Duration(days: 7)),
      'duration': '1 week',
      'location': 'Design Studio, Building C',
      'category': 'Design',
      'status': 'Registration Open',
      'prizePool': '₹30,000',
      'participantCount': 89,
      'teamSize': '1-2 members',
      'isFeatured': false,
    },
    {
      'title': 'Inter-College Cricket Tournament',
      'organizer': 'Athletics Department',
      'description':
          'Annual cricket championship featuring teams from different colleges. Join us for thrilling matches and sportsmanship!',
      'registrationDeadline': DateTime.now().add(const Duration(hours: 12)),
      'eventDate': DateTime.now().add(const Duration(days: 2)),
      'duration': '3 days',
      'location': 'Sports Complex Ground',
      'category': 'Sports',
      'status': 'Registration Open',
      'prizePool': '₹75,000',
      'participantCount': 12,
      'teamSize': '11 players + 4 reserves',
      'isFeatured': true,
    },
    {
      'title': 'E-Sports Championship: Valorant',
      'organizer': 'Gaming Club',
      'description':
          'Compete in the ultimate Valorant showdown. Best teams from campus will battle for glory and amazing prizes.',
      'registrationDeadline': DateTime.now().subtract(const Duration(days: 1)),
      'eventDate': DateTime.now().add(const Duration(hours: 6)),
      'duration': '2 days',
      'location': 'Gaming Arena, Student Center',
      'category': 'Gaming',
      'status': 'Ongoing',
      'prizePool': '₹40,000',
      'participantCount': 64,
      'teamSize': '5 members',
      'isFeatured': false,
    },
    {
      'title': 'Brain Quest: Science Quiz',
      'organizer': 'Science Department',
      'description':
          'Test your knowledge in physics, chemistry, biology, and general science. Exciting rapid-fire and buzzer rounds.',
      'registrationDeadline': DateTime.now().add(const Duration(days: 8)),
      'eventDate': DateTime.now().add(const Duration(days: 12)),
      'duration': '4 hours',
      'location': 'Seminar Hall A',
      'category': 'Quiz',
      'status': 'Upcoming',
      'prizePool': '₹15,000',
      'participantCount': 45,
      'teamSize': '2-3 members',
      'isFeatured': false,
    },
    {
      'title': 'Research Paper Competition',
      'organizer': 'Research Committee',
      'description':
          'Present your research work on innovative topics in science and technology. Get feedback from expert panel.',
      'registrationDeadline': DateTime.now().subtract(const Duration(days: 10)),
      'eventDate': DateTime.now().subtract(const Duration(days: 3)),
      'duration': '1 day',
      'location': 'Conference Hall',
      'category': 'Academic',
      'status': 'Ended',
      'prizePool': '₹25,000',
      'participantCount': 78,
      'teamSize': '1-2 members',
      'isFeatured': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredCompetitions {
    var competitions = _allCompetitions;

    // Filter by category
    if (_selectedCategory != null) {
      competitions = competitions
          .where((comp) => comp['category'] == _selectedCategory)
          .toList();
    }

    // Filter by status
    if (_selectedStatus != null) {
      competitions = competitions
          .where((comp) => comp['status'] == _selectedStatus)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      competitions = competitions.where((comp) {
        final title = (comp['title'] as String).toLowerCase();
        final description = (comp['description'] as String).toLowerCase();
        final organizer = (comp['organizer'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();

        return title.contains(query) ||
            description.contains(query) ||
            organizer.contains(query);
      }).toList();
    }

    // Filter by category when searching
    if (_searchCategoryFilter != null) {
      competitions = competitions
          .where((comp) => comp['category'] == _searchCategoryFilter)
          .toList();
    }

    // Sort: Featured first, then by registration deadline
    competitions.sort((a, b) {
      if (a['isFeatured'] == b['isFeatured']) {
        return (a['registrationDeadline'] as DateTime).compareTo(
          b['registrationDeadline'] as DateTime,
        );
      }
      return a['isFeatured'] ? -1 : 1;
    });

    return competitions;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final activeCompetitions = _filteredCompetitions
        .where((comp) => comp['status'] != 'Ended')
        .toList();
    final endedCompetitions = _filteredCompetitions
        .where((comp) => comp['status'] == 'Ended')
        .toList();

    return Scaffold(
      appBar: SearchAppBar(
        title: 'Competitions',
        isSearching: _isSearching,
        searchQuery: _searchQuery,
        onSearchToggle: () {
          setState(() {
            _isSearching = !_isSearching;
            if (!_isSearching) {
              _searchQuery = '';
              _searchCategoryFilter = null;
            }
          });
        },
        onSearchChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
      ),
      body: Column(
        children: [
          // Category filter chips (shown when searching)
          if (_isSearching)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: AppDimensions.space12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: AppDimensions.horizontalPadding),
                    _CategoryChip(
                      label: 'All',
                      isSelected: _searchCategoryFilter == null,
                      onTap: () {
                        setState(() {
                          _searchCategoryFilter = null;
                        });
                      },
                    ),
                    ...(_categories.map((category) {
                      return _CategoryChip(
                        label: category,
                        isSelected: _searchCategoryFilter == category,
                        onTap: () {
                          setState(() {
                            _searchCategoryFilter = category;
                          });
                        },
                      );
                    })),
                    SizedBox(width: AppDimensions.horizontalPadding),
                  ],
                ),
              ),
            ),

          // Category and Status filters (shown when not searching)
          if (!_isSearching) ...[
            CategoryChipFilter(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            StatusChipFilter(
              statuses: _statuses,
              selectedStatus: _selectedStatus,
              onStatusSelected: (status) {
                setState(() {
                  _selectedStatus = status;
                });
              },
            ),
          ],

          // Stats row (shown when not searching)
          if (!_isSearching)
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: AppDimensions.horizontalPadding,
                vertical: AppDimensions.space8,
              ),
              padding: EdgeInsets.all(AppDimensions.space16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary.withAlpha(26),
                    colorScheme.secondary.withAlpha(26),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radius12),
                border: Border.all(
                  color: colorScheme.primary.withAlpha(51),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    icon: Iconsax.cup_outline,
                    label: 'Total',
                    count: _allCompetitions.length,
                    color: colorScheme.primary,
                  ),
                  Container(
                    height: AppDimensions.space32,
                    width: 1,
                    color: colorScheme.onSurface.withAlpha(51),
                  ),
                  _StatItem(
                    icon: Iconsax.tick_circle_outline,
                    label: 'Open',
                    count: _allCompetitions
                        .where((c) => c['status'] == 'Registration Open')
                        .length,
                    color: Colors.green,
                  ),
                  Container(
                    height: AppDimensions.space32,
                    width: 1,
                    color: colorScheme.onSurface.withAlpha(51),
                  ),
                  _StatItem(
                    icon: Iconsax.trend_up_outline,
                    label: 'Ongoing',
                    count: _allCompetitions
                        .where((c) => c['status'] == 'Ongoing')
                        .length,
                    color: colorScheme.secondary,
                  ),
                  Container(
                    height: AppDimensions.space32,
                    width: 1,
                    color: colorScheme.onSurface.withAlpha(51),
                  ),
                  _StatItem(
                    icon: Iconsax.profile_2user_outline,
                    label: 'Participants',
                    count: _allCompetitions.fold<int>(
                      0,
                      (sum, c) => sum + (c['participantCount'] as int),
                    ),
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),

          // Search results count (shown when searching with query)
          if (_isSearching && _searchQuery.isNotEmpty)
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: AppDimensions.horizontalPadding,
                vertical: AppDimensions.space8,
              ),
              padding: EdgeInsets.all(AppDimensions.space12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppDimensions.radius8),
                border: Border.all(
                  color: colorScheme.primary.withAlpha(77),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.search_status_1_outline,
                    size: AppDimensions.mediumIconSize,
                    color: colorScheme.primary,
                  ),
                  AppDimensions.w8,
                  Text(
                    '${_filteredCompetitions.length} result${_filteredCompetitions.length != 1 ? 's' : ''} found',
                    style: TextStyle(
                      fontSize: AppDimensions.bodyFontSize,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                  if (_searchCategoryFilter != null) ...[
                    AppDimensions.w8,
                    Text(
                      'in $_searchCategoryFilter',
                      style: TextStyle(
                        fontSize: AppDimensions.bodyFontSize,
                        color: colorScheme.onSurface.withAlpha(179),
                      ),
                    ),
                  ],
                ],
              ),
            ),

          // Competitions list
          Expanded(
            child: activeCompetitions.isEmpty && endedCompetitions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.cup_outline,
                          size: AppDimensions.largeIconSize * 2,
                          color: colorScheme.onSurface.withAlpha(77),
                        ),
                        AppDimensions.h16,
                        Text(
                          'No competitions found',
                          style: TextStyle(
                            fontSize: AppDimensions.titleFontSize,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                        AppDimensions.h8,
                        Text(
                          _isAdmin
                              ? 'Create the first competition!'
                              : 'Check back soon for new competitions',
                          style: TextStyle(
                            fontSize: AppDimensions.bodyFontSize,
                            color: colorScheme.onSurface.withAlpha(128),
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Active competitions
                        if (activeCompetitions.isNotEmpty) ...[
                          ...activeCompetitions.map((competition) {
                            return CompetitionCard(
                              title: competition['title'],
                              organizer: competition['organizer'],
                              description: competition['description'],
                              registrationDeadline:
                                  competition['registrationDeadline'],
                              eventDate: competition['eventDate'],
                              duration: competition['duration'],
                              location: competition['location'],
                              category: competition['category'],
                              status: competition['status'],
                              prizePool: competition['prizePool'],
                              participantCount: competition['participantCount'],
                              teamSize: competition['teamSize'],
                              isFeatured: competition['isFeatured'] ?? false,
                              imageUrl: competition['imageUrl'],
                              organizerImageUrl:
                                  competition['organizerImageUrl'],
                              isRegistered:
                                  competition['isRegistered'] ?? false,
                              isAdmin: _isAdmin,
                              onRegister: () {
                                setState(() {
                                  competition['isRegistered'] =
                                      !(competition['isRegistered'] ?? false);
                                  if (competition['isRegistered']) {
                                    competition['participantCount'] =
                                        (competition['participantCount'] ?? 0) +
                                        1;
                                  } else {
                                    competition['participantCount'] =
                                        (competition['participantCount'] ?? 1) -
                                        1;
                                  }
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      competition['isRegistered']
                                          ? 'Registered successfully!'
                                          : 'Registration cancelled',
                                    ),
                                  ),
                                );
                              },
                              onShare: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Share feature for "${competition['title']}"',
                                    ),
                                  ),
                                );
                              },
                              onEdit: _isAdmin
                                  ? () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Edit "${competition['title']}"',
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                              onDelete: _isAdmin
                                  ? () {
                                      setState(() {
                                        _allCompetitions.remove(competition);
                                      });
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Competition deleted'),
                                        ),
                                      );
                                    }
                                  : null,
                            );
                          }),
                        ],

                        // Ended competitions section
                        if (endedCompetitions.isNotEmpty) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.horizontalPadding,
                              vertical: AppDimensions.space16,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Iconsax.archive_outline,
                                  size: AppDimensions.mediumIconSize,
                                  color: colorScheme.onSurface.withAlpha(153),
                                ),
                                AppDimensions.w8,
                                Text(
                                  'Ended Competitions',
                                  style: TextStyle(
                                    fontSize: AppDimensions.titleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...endedCompetitions.map((competition) {
                            return Opacity(
                              opacity: 0.6,
                              child: CompetitionCard(
                                title: competition['title'],
                                organizer: competition['organizer'],
                                description: competition['description'],
                                registrationDeadline:
                                    competition['registrationDeadline'],
                                eventDate: competition['eventDate'],
                                duration: competition['duration'],
                                location: competition['location'],
                                category: competition['category'],
                                status: competition['status'],
                                prizePool: competition['prizePool'],
                                participantCount:
                                    competition['participantCount'],
                                teamSize: competition['teamSize'],
                                isFeatured: false,
                                imageUrl: competition['imageUrl'],
                                organizerImageUrl:
                                    competition['organizerImageUrl'],
                                isRegistered:
                                    competition['isRegistered'] ?? false,
                                isAdmin: _isAdmin,
                              ),
                            );
                          }),
                        ],

                        AppDimensions.h24,
                      ],
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: _isAdmin
          ? SizedBox(
              height: AppDimensions.space40 * 1.5,
              width: AppDimensions.space40 * 1.5,
              child: FloatingActionButton(
                onPressed: () {
                  CustomBottomDialog.show(
                    context: context,
                    title: 'Create Competition',
                    child: AddCompetition(
                      categories: _categories,
                      onCompetitionCreated: (newCompetition) {
                        setState(() {
                          _allCompetitions.insert(0, newCompetition);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Competition created successfully!'),
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
            )
          : null,
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(right: AppDimensions.space8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.space16,
            vertical: AppDimensions.space8,
          ),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.secondary : colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radius16),
            border: Border.all(
              color: isSelected
                  ? colorScheme.secondary
                  : colorScheme.onSurface.withAlpha(77),
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppDimensions.captionFontSize,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? colorScheme.onSecondary
                  : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppDimensions.mediumIconSize, color: color),
            AppDimensions.w4,
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: AppDimensions.titleFontSize,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        AppDimensions.h4,
        Text(
          label,
          style: TextStyle(
            fontSize: AppDimensions.captionFontSize,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
          ),
        ),
      ],
    );
  }
}
