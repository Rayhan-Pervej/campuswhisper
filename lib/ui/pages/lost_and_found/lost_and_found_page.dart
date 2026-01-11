import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/providers/lost_found_provider.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_bottom_dialog.dart';
import '../../widgets/search_appbar.dart';
import 'widgets/add_lost_found_item.dart';
import 'widgets/lost_and_found_item_card.dart';
import 'widgets/status_chip_filter.dart';

class LostAndFoundPage extends StatefulWidget {
  const LostAndFoundPage({super.key});

  @override
  State<LostAndFoundPage> createState() => _LostAndFoundPageState();
}

class _LostAndFoundPageState extends State<LostAndFoundPage> {
  String? _selectedStatus;
  final List<String> _statuses = ['Lost', 'Found'];
  bool _isSearching = false;
  String _searchQuery = '';
  String? _searchCategoryFilter;

  final List<String> _categories = [
    'Electronics',
    'Documents',
    'Accessories',
    'Books',
    'Clothing',
    'Keys',
    'Bags',
    'Other',
  ];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load initial lost & found items
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LostFoundProvider>().loadInitial();
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
      context.read<LostFoundProvider>().loadMore();
    }
  }

  List<Map<String, dynamic>> _filterItems(List<dynamic> items) {
    // Convert models to map format for filtering
    var filteredItems = items.map((item) {
      return {
        'model': item,
        'itemName': item.itemName,
        'description': item.description,
        'location': item.location,
        'category': item.category,
        'status': item.type,
        'isResolved': item.isResolved,
      };
    }).toList();

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filteredItems = filteredItems.where((item) {
        final itemName = (item['itemName'] as String).toLowerCase();
        final description = (item['description'] as String).toLowerCase();
        final location = (item['location'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();

        return itemName.contains(query) ||
            description.contains(query) ||
            location.contains(query);
      }).toList();
    }

    // Filter by category (when searching)
    if (_searchCategoryFilter != null) {
      filteredItems = filteredItems
          .where((item) => item['category'] == _searchCategoryFilter)
          .toList();
    }

    return filteredItems;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: SearchAppBar(
        title: 'Lost & Found',
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
      body: Consumer<LostFoundProvider>(
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
                    'Failed to load items',
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
                    Iconsax.search_status_outline,
                    size: AppDimensions.largeIconSize * 2,
                    color: colorScheme.onSurface.withAlpha(77),
                  ),
                  AppDimensions.h16,
                  Text(
                    'No items found',
                    style: TextStyle(
                      fontSize: AppDimensions.subtitleFontSize,
                      color: colorScheme.onSurface.withAlpha(153),
                    ),
                  ),
                  AppDimensions.h8,
                  Text(
                    'Be the first to post!',
                    style: TextStyle(
                      fontSize: AppDimensions.bodyFontSize,
                      color: colorScheme.onSurface.withAlpha(102),
                    ),
                  ),
                ],
              ),
            );
          }

          // Filter items for search
          final filteredItems = _filterItems(provider.items);

          // Separate items into active and resolved
          final activeItems = filteredItems.where((item) => !item['isResolved']).toList();
          final resolvedItems = filteredItems.where((item) => item['isResolved']).toList();

          // Items list
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

                // Status filter chips (shown when not searching)
                if (!_isSearching)
                  StatusChipFilter(
                    statuses: _statuses,
                    selectedStatus: _selectedStatus,
                    onStatusSelected: (status) {
                      setState(() {
                        _selectedStatus = status;
                      });
                      // Apply filter through provider
                      if (status == null) {
                        provider.clearFilters();
                      } else {
                        provider.filterByType(status);
                      }
                    },
                  ),

                // Stats row (always visible)
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
                          colorScheme.primary.withValues(alpha: 0.1),
                          colorScheme.secondary.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppDimensions.radius12),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          icon: Iconsax.search_status_1_outline,
                          label: 'Lost Items',
                          count: provider.items.where((item) => item.isLost && item.isActive).length,
                          color: colorScheme.error,
                        ),
                        Container(
                          height: AppDimensions.space32,
                          width: 1,
                          color: colorScheme.onSurface.withValues(alpha: 0.2),
                        ),
                        _StatItem(
                          icon: Iconsax.lovely_outline,
                          label: 'Found Items',
                          count: provider.items.where((item) => item.isFound && item.isActive).length,
                          color: colorScheme.primary,
                        ),
                        Container(
                          height: AppDimensions.space32,
                          width: 1,
                          color: colorScheme.onSurface.withValues(alpha: 0.2),
                        ),
                        _StatItem(
                          icon: Iconsax.tick_circle_outline,
                          label: 'Resolved',
                          count: provider.items.where((item) => item.isResolved).length,
                          color: Colors.green,
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
                        color: colorScheme.primary.withValues(alpha: 0.3),
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
                          '${filteredItems.length} result${filteredItems.length != 1 ? 's' : ''} found',
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
                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                // Items list
                Expanded(
                  child: activeItems.isEmpty && resolvedItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.search_status_outline,
                                size: AppDimensions.largeIconSize * 2,
                                color: colorScheme.onSurface.withValues(alpha: 0.3),
                              ),
                              AppDimensions.h16,
                              Text(
                                'No items found',
                                style: TextStyle(
                                  fontSize: AppDimensions.titleFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                              AppDimensions.h8,
                              Text(
                                _selectedStatus == null
                                    ? 'Be the first to post!'
                                    : 'No ${_selectedStatus?.toLowerCase()} items',
                                style: TextStyle(
                                  fontSize: AppDimensions.bodyFontSize,
                                  color: colorScheme.onSurface.withValues(alpha: 0.5),
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
                              // Active items
                              if (activeItems.isNotEmpty) ...[
                                ...activeItems.map((item) {
                                  final model = item['model'];
                                  return LostAndFoundItemCard(
                                    itemName: model.itemName,
                                    description: model.description,
                                    datePosted: model.date,
                                    location: model.location,
                                    category: model.category,
                                    status: model.type,
                                    posterName: model.posterName,
                                    imageUrl: model.hasImages ? model.imageUrls.first : null,
                                    posterImageUrl: null,
                                    contactInfo: model.contactInfo,
                                    isResolved: model.isResolved,
                                    onContact: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Contact: ${model.contactInfo}',
                                          ),
                                        ),
                                      );
                                    },
                                    onMarkResolved: () {
                                      provider.markAsResolved(context, model.id);
                                    },
                                  );
                                }),
                              ],

                              // Resolved items section
                              if (resolvedItems.isNotEmpty) ...[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppDimensions.horizontalPadding,
                                    vertical: AppDimensions.space16,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Iconsax.tick_circle_bold,
                                        size: AppDimensions.mediumIconSize,
                                        color: Colors.green,
                                      ),
                                      AppDimensions.w8,
                                      Text(
                                        'Resolved Items',
                                        style: TextStyle(
                                          fontSize: AppDimensions.titleFontSize,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...resolvedItems.map((item) {
                                  final model = item['model'];
                                  return Opacity(
                                    opacity: 0.6,
                                    child: LostAndFoundItemCard(
                                      itemName: model.itemName,
                                      description: model.description,
                                      datePosted: model.date,
                                      location: model.location,
                                      category: model.category,
                                      status: model.type,
                                      posterName: model.posterName,
                                      imageUrl: model.hasImages ? model.imageUrls.first : null,
                                      posterImageUrl: null,
                                      contactInfo: model.contactInfo,
                                      isResolved: model.isResolved,
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
                                      valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                                    ),
                                  ),
                                ),

                              // End of list indicator
                              if (!provider.hasMore && provider.items.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.all(AppDimensions.space16),
                                  child: Center(
                                    child: Text(
                                      'No more items',
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
      floatingActionButton: SizedBox(
        height: AppDimensions.space40 * 1.5,
        width: AppDimensions.space40 * 1.5,
        child: FloatingActionButton(
          onPressed: () {
            CustomBottomDialog.show(
              context: context,
              title: 'Report Lost/Found Item',
              child: AddLostFoundItem(
                categories: _categories,
                onItemCreated: (newItem) {
                  // TODO: Convert newItem map to LostFoundItemModel and use provider.createLostFoundItem()
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Item creation not yet implemented'),
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
                  : colorScheme.onSurface.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppDimensions.captionFontSize,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? colorScheme.onSecondary : colorScheme.onSurface,
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
            Icon(
              icon,
              size: AppDimensions.mediumIconSize,
              color: color,
            ),
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
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
