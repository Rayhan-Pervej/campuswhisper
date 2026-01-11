import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/ui/widgets/search_appbar.dart';
import 'package:campuswhisper/routing/app_routes.dart';
import 'package:campuswhisper/providers/club_provider.dart';
import 'package:campuswhisper/models/club_model.dart';

class ClubsPage extends StatefulWidget {
  const ClubsPage({super.key});

  @override
  State<ClubsPage> createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage> {
  bool _isSearching = false;
  String _searchQuery = '';
  String? _selectedCategory;

  final List<String> _categories = [
    'Academic',
    'Cultural',
    'Sports',
    'Social',
  ];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load initial clubs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClubProvider>().loadInitial();
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
      context.read<ClubProvider>().loadMore();
    }
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
    });

    final provider = context.read<ClubProvider>();
    if (category == null) {
      provider.clearFilters();
    } else {
      provider.filterByCategory(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: SearchAppBar(
        title: 'Clubs',
        isSearching: _isSearching,
        searchQuery: _searchQuery,
        onSearchToggle: () {
          setState(() {
            _isSearching = !_isSearching;
            if (!_isSearching) {
              _searchQuery = '';
            }
          });
        },
        onSearchChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
      ),
      body: Consumer<ClubProvider>(
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
                    size: 80,
                    color: colorScheme.error,
                  ),
                  AppDimensions.h16,
                  BuildText(
                    text: 'Failed to load clubs',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withAlpha(153),
                  ),
                  AppDimensions.h8,
                  BuildText(
                    text: provider.errorMessage ?? 'Please try again',
                    fontSize: 14,
                    color: colorScheme.onSurface.withAlpha(102),
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
                    Iconsax.buildings_outline,
                    size: 80,
                    color: colorScheme.onSurface.withAlpha(77),
                  ),
                  AppDimensions.h16,
                  BuildText(
                    text: 'No clubs found',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withAlpha(153),
                  ),
                  AppDimensions.h8,
                  BuildText(
                    text: 'Check back soon for new clubs',
                    fontSize: 14,
                    color: colorScheme.onSurface.withAlpha(128),
                  ),
                ],
              ),
            );
          }

          // Filter clubs by search query locally
          List<ClubModel> filteredClubs = provider.items;
          if (_searchQuery.isNotEmpty) {
            filteredClubs = provider.items.where((club) {
              final name = club.name.toLowerCase();
              final description = club.description.toLowerCase();
              final category = club.category.toLowerCase();
              final query = _searchQuery.toLowerCase();

              return name.contains(query) ||
                  description.contains(query) ||
                  category.contains(query);
            }).toList();
          }

          final totalMembers = provider.items.fold<int>(0, (sum, club) => sum + club.memberCount);

          // Clubs list with RefreshIndicator
          return RefreshIndicator(
            onRefresh: () => provider.refresh(),
            child: Column(
              children: [
                // Category filter chips
                if (!_isSearching)
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
                            isSelected: _selectedCategory == null,
                            onTap: () => _onCategorySelected(null),
                          ),
                          ...(_categories.map((category) {
                            return _CategoryChip(
                              label: category,
                              isSelected: _selectedCategory == category,
                              onTap: () => _onCategorySelected(category),
                            );
                          })),
                          SizedBox(width: AppDimensions.horizontalPadding),
                        ],
                      ),
                    ),
                  ),

                // Stats row
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
                          icon: Iconsax.buildings_outline,
                          label: 'Total Clubs',
                          count: provider.items.length,
                          color: colorScheme.primary,
                        ),
                        Container(
                          height: AppDimensions.space32,
                          width: 1,
                          color: colorScheme.onSurface.withAlpha(51),
                        ),
                        _StatItem(
                          icon: Iconsax.profile_2user_outline,
                          label: 'Members',
                          count: totalMembers,
                          color: colorScheme.secondary,
                        ),
                        Container(
                          height: AppDimensions.space32,
                          width: 1,
                          color: colorScheme.onSurface.withAlpha(51),
                        ),
                        _StatItem(
                          icon: Iconsax.category_outline,
                          label: 'Categories',
                          count: _categories.length,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ),

                // Search results count
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
                          size: 20,
                          color: colorScheme.primary,
                        ),
                        AppDimensions.w8,
                        BuildText(
                          text: '${filteredClubs.length} club${filteredClubs.length != 1 ? 's' : ''} found',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ),

                // Clubs list
                Expanded(
                  child: filteredClubs.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.buildings_outline,
                                size: 80,
                                color: colorScheme.onSurface.withAlpha(77),
                              ),
                              AppDimensions.h16,
                              BuildText(
                                text: 'No clubs found',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface.withAlpha(153),
                              ),
                              AppDimensions.h8,
                              BuildText(
                                text: _isSearching
                                    ? 'Try a different search term'
                                    : 'Check back soon for new clubs',
                                fontSize: 14,
                                color: colorScheme.onSurface.withAlpha(128),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.horizontalPadding,
                            vertical: AppDimensions.space8,
                          ),
                          itemCount: filteredClubs.length + (_isSearching ? 0 : (provider.isLoadingMore ? 1 : (provider.hasMore ? 0 : 1))),
                          itemBuilder: (context, index) {
                            if (index < filteredClubs.length) {
                              final club = filteredClubs[index];
                              return _ClubCard(
                                club: club,
                                colorScheme: colorScheme,
                              );
                            } else {
                              // Loading more indicator
                              if (provider.isLoadingMore) {
                                return Padding(
                                  padding: EdgeInsets.all(AppDimensions.space16),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                                    ),
                                  ),
                                );
                              }
                              // End of list indicator
                              if (!provider.hasMore && provider.items.isNotEmpty) {
                                return Padding(
                                  padding: EdgeInsets.all(AppDimensions.space16),
                                  child: Center(
                                    child: BuildText(
                                      text: 'No more clubs',
                                      fontSize: 12,
                                      color: colorScheme.onSurface.withAlpha(102),
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
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
              color: isSelected ? colorScheme.secondary : colorScheme.onSurface.withAlpha(77),
              width: 1.5,
            ),
          ),
          child: BuildText(
            text: label,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? colorScheme.onSecondary : colorScheme.onSurface,
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
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            AppDimensions.w4,
            BuildText(
              text: count.toString(),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ],
        ),
        AppDimensions.h4,
        BuildText(
          text: label,
          fontSize: 12,
          color: colorScheme.onSurface.withAlpha(179),
        ),
      ],
    );
  }
}

class _ClubCard extends StatelessWidget {
  final ClubModel club;
  final ColorScheme colorScheme;

  const _ClubCard({
    required this.club,
    required this.colorScheme,
  });

  String get clubInitials {
    final name = club.name;
    final words = name.split(' ');
    if (words.isEmpty) return '';
    if (words.length == 1) {
      return words[0].isNotEmpty ? words[0][0].toUpperCase() : '';
    }
    final firstInitial = words[0].isNotEmpty ? words[0][0].toUpperCase() : '';
    final lastInitial = words[1].isNotEmpty ? words[1][0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Academic':
        return Iconsax.book_outline;
      case 'Cultural':
        return Iconsax.music_outline;
      case 'Sports':
        return Iconsax.cup_outline;
      case 'Social':
        return Iconsax.people_outline;
      default:
        return Iconsax.buildings_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.clubDetail,
          arguments: {'club': club},
        );
      },
      borderRadius: BorderRadius.circular(AppDimensions.radius12),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: AppDimensions.space8),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Club header with logo and info
              Row(
                children: [
                  // Club logo/avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppDimensions.radius12),
                    ),
                    child: club.logoUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(AppDimensions.radius12),
                            child: Image.network(
                              club.logoUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: BuildText(
                              text: clubInitials,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                  ),
                  AppDimensions.w16,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BuildText(
                          text: club.name,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        AppDimensions.h4,
                        Row(
                          children: [
                            Icon(
                              Iconsax.profile_2user_outline,
                              size: 14,
                              color: colorScheme.onSurface.withAlpha(153),
                            ),
                            AppDimensions.w4,
                            BuildText(
                              text: '${club.memberCount} members',
                              fontSize: 12,
                              color: colorScheme.onSurface.withAlpha(153),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Category icon
                  Container(
                    padding: EdgeInsets.all(AppDimensions.space8),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer.withAlpha(51),
                      borderRadius: BorderRadius.circular(AppDimensions.radius8),
                    ),
                    child: Icon(
                      getCategoryIcon(club.category),
                      size: 24,
                      color: colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              AppDimensions.h16,

              // Description
              BuildText(
                text: club.description,
                fontSize: 14,
                color: colorScheme.onSurface.withAlpha(204),
                height: 1.5,
              ),
              AppDimensions.h12,

              // Category tag and established year
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.space12,
                      vertical: AppDimensions.space4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer.withAlpha(51),
                      borderRadius: BorderRadius.circular(AppDimensions.radius8),
                    ),
                    child: BuildText(
                      text: club.category,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.secondary,
                    ),
                  ),
                  if (club.establishedDate != null) ...[
                    AppDimensions.w8,
                    Icon(
                      Iconsax.calendar_outline,
                      size: 14,
                      color: colorScheme.onSurface.withAlpha(153),
                    ),
                    AppDimensions.w4,
                    BuildText(
                      text: 'Est. ${club.establishedDate!.year}',
                      fontSize: 12,
                      color: colorScheme.onSurface.withAlpha(153),
                    ),
                  ],
                ],
              ),
              AppDimensions.h16,

              // President info
              Container(
                padding: EdgeInsets.all(AppDimensions.space12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppDimensions.radius8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.user_outline,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    AppDimensions.w8,
                    BuildText(
                      text: 'President: ${club.presidentName}',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
