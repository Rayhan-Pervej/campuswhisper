import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/providers/competition_provider.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

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

  final ScrollController _scrollController = ScrollController();

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
    'Upcoming',
    'Active',
    'Ended',
  ];

  @override
  void initState() {
    super.initState();
    // Load initial competitions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompetitionProvider>().loadInitial();
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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<CompetitionProvider>().loadMore();
    }
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
    });

    if (category == null) {
      context.read<CompetitionProvider>().clearFilters();
    }
  }

  void _onStatusSelected(String? status) {
    setState(() {
      _selectedStatus = status;
    });

    final provider = context.read<CompetitionProvider>();
    if (status == null) {
      provider.clearFilters();
    } else {
      provider.filterByStatus(status);
    }
  }

  List<dynamic> _getFilteredCompetitions(List<dynamic> competitions) {
    var filtered = competitions;

    // Filter by category
    if (_selectedCategory != null) {
      filtered = filtered
          .where((comp) => comp.category == _selectedCategory)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((comp) {
        final title = comp.title.toLowerCase();
        final description = comp.description.toLowerCase();
        final organizer = comp.organizerName.toLowerCase();
        final query = _searchQuery.toLowerCase();

        return title.contains(query) ||
            description.contains(query) ||
            organizer.contains(query);
      }).toList();
    }

    // Filter by category when searching
    if (_searchCategoryFilter != null) {
      filtered = filtered
          .where((comp) => comp.category == _searchCategoryFilter)
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
      body: Consumer<CompetitionProvider>(
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
                    'Failed to load competitions',
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
            );
          }

          // Get filtered competitions
          final filteredCompetitions = _getFilteredCompetitions(provider.items);
          final activeCompetitions = filteredCompetitions
              .where((comp) => comp.status != 'Ended')
              .toList();
          final endedCompetitions = filteredCompetitions
              .where((comp) => comp.status == 'Ended')
              .toList();

          // Competitions list
          return RefreshIndicator(
            onRefresh: () => provider.refresh(),
            child: Column(
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
                    onCategorySelected: _onCategorySelected,
                  ),
                  StatusChipFilter(
                    statuses: _statuses,
                    selectedStatus: _selectedStatus,
                    onStatusSelected: _onStatusSelected,
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
                          count: provider.items.length,
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
                          count: provider.items
                              .where((c) => c.isRegistrationOpen)
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
                          label: 'Active',
                          count: provider.items
                              .where((c) => c.isActive)
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
                          count: provider.items.fold<int>(
                            0,
                            (sum, c) => sum + c.participantCount,
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
                          '${filteredCompetitions.length} result${filteredCompetitions.length != 1 ? 's' : ''} found',
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
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Active competitions
                              if (activeCompetitions.isNotEmpty) ...[
                                ...activeCompetitions.map((competition) {
                                  return CompetitionCard(
                                    title: competition.title,
                                    organizer: competition.organizerName,
                                    description: competition.description,
                                    registrationDeadline:
                                        competition.registrationDeadline,
                                    eventDate: competition.competitionDate,
                                    duration:
                                        '${competition.competitionDate.difference(competition.competitionEndDate ?? competition.competitionDate).inDays.abs()} days',
                                    location: competition.location,
                                    category: competition.category,
                                    status: competition.status,
                                    prizePool: competition.prizes.isNotEmpty
                                        ? competition.prizes.first
                                        : null,
                                    participantCount: competition.participantCount,
                                    teamSize: competition.isTeamBased
                                        ? '${competition.teamSize} members'
                                        : 'Individual',
                                    isFeatured: false,
                                    imageUrl: competition.imageUrl,
                                    organizerImageUrl: null,
                                    isRegistered: false, // TODO: Check if current user is registered
                                    isAdmin: _isAdmin,
                                    onRegister: () {
                                      // TODO: Implement registration
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Registration feature coming soon!',
                                          ),
                                        ),
                                      );
                                    },
                                    onShare: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Share feature for "${competition.title}"',
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
                                                  'Edit "${competition.title}"',
                                                ),
                                              ),
                                            );
                                          }
                                        : null,
                                    onDelete: _isAdmin
                                        ? () {
                                            provider.deleteCompetition(
                                              context,
                                              competition.id,
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
                                      title: competition.title,
                                      organizer: competition.organizerName,
                                      description: competition.description,
                                      registrationDeadline:
                                          competition.registrationDeadline,
                                      eventDate: competition.competitionDate,
                                      duration:
                                          '${competition.competitionDate.difference(competition.competitionEndDate ?? competition.competitionDate).inDays.abs()} days',
                                      location: competition.location,
                                      category: competition.category,
                                      status: competition.status,
                                      prizePool: competition.prizes.isNotEmpty
                                          ? competition.prizes.first
                                          : null,
                                      participantCount:
                                          competition.participantCount,
                                      teamSize: competition.isTeamBased
                                          ? '${competition.teamSize} members'
                                          : 'Individual',
                                      isFeatured: false,
                                      imageUrl: competition.imageUrl,
                                      organizerImageUrl: null,
                                      isRegistered: false,
                                      isAdmin: _isAdmin,
                                    ),
                                  );
                                }),
                              ],

                              // Loading more indicator
                              if (provider.isLoadingMore)
                                Padding(
                                  padding: EdgeInsets.all(AppDimensions.space16),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                        colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),

                              // End of list indicator
                              if (!provider.hasMore && provider.items.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.all(AppDimensions.space16),
                                  child: Center(
                                    child: Text(
                                      'No more competitions',
                                      style: TextStyle(
                                        fontSize: AppDimensions.captionFontSize,
                                        color: colorScheme.onSurface.withAlpha(102),
                                      ),
                                    ),
                                  ),
                                ),

                              AppDimensions.h24,
                            ],
                          ),
                        ),
                ),
              ],
            ),
          );
        },
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
                        // TODO: Convert map to CompetitionModel and use provider
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Competition creation not yet implemented'),
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
