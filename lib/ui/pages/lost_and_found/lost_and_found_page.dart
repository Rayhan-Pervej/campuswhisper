import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

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

  final List<Map<String, dynamic>> _allItems = [
    {
      'itemName': 'Black Leather Wallet',
      'description':
          'Black leather wallet with multiple card slots. Contains student ID and some cash. Lost near the library entrance.',
      'datePosted': DateTime.now().subtract(const Duration(hours: 2)),
      'location': 'Main Library Entrance',
      'category': 'Accessories',
      'status': 'Lost',
      'posterName': 'John Smith',
      'isResolved': false,
    },
    {
      'itemName': 'iPhone 13 Pro',
      'description':
          'Space gray iPhone 13 Pro with a clear case. Has a small crack on the bottom right corner. Found in the cafeteria.',
      'datePosted': DateTime.now().subtract(const Duration(hours: 5)),
      'location': 'Student Cafeteria',
      'category': 'Electronics',
      'status': 'Found',
      'posterName': 'Sarah Johnson',
      'isResolved': false,
    },
    {
      'itemName': 'Blue Nike Backpack',
      'description':
          'Medium-sized blue Nike backpack with gray accents. Contains some textbooks and a water bottle. Found near the basketball court.',
      'datePosted': DateTime.now().subtract(const Duration(days: 1)),
      'location': 'Basketball Court',
      'category': 'Bags',
      'status': 'Found',
      'posterName': 'Mike Chen',
      'isResolved': false,
    },
    {
      'itemName': 'Silver Laptop Charger',
      'description':
          'MacBook Pro 16-inch charger with USB-C cable. Lost in Computer Lab 3 during evening class.',
      'datePosted': DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      'location': 'Computer Lab 3, IT Building',
      'category': 'Electronics',
      'status': 'Lost',
      'posterName': 'Emily Davis',
      'isResolved': false,
    },
    {
      'itemName': 'Set of Dorm Keys',
      'description':
          'Key ring with 3 keys and a small Eiffel Tower keychain. Found near the dormitory parking lot.',
      'datePosted': DateTime.now().subtract(const Duration(days: 2)),
      'location': 'Dormitory Parking Lot',
      'category': 'Keys',
      'status': 'Found',
      'posterName': 'Alex Martinez',
      'isResolved': false,
    },
    {
      'itemName': 'Calculus Textbook',
      'description':
          'Calculus: Early Transcendentals 8th Edition. Has my name written inside. Lost in Math Building Room 205.',
      'datePosted': DateTime.now().subtract(const Duration(days: 2, hours: 8)),
      'location': 'Math Building, Room 205',
      'category': 'Books',
      'status': 'Lost',
      'posterName': 'Lisa Wang',
      'isResolved': false,
    },
    {
      'itemName': 'Wireless Earbuds',
      'description':
          'White Apple AirPods Pro with charging case. Found in the gym locker room.',
      'datePosted': DateTime.now().subtract(const Duration(days: 3)),
      'location': 'Gym Locker Room',
      'category': 'Electronics',
      'status': 'Found',
      'posterName': 'David Brown',
      'isResolved': true,
    },
    {
      'itemName': 'Red Winter Jacket',
      'description':
          'North Face red puffer jacket, size medium. Lost during the basketball game last week.',
      'datePosted': DateTime.now().subtract(const Duration(days: 5)),
      'location': 'Sports Complex',
      'category': 'Clothing',
      'status': 'Lost',
      'posterName': 'Jessica Lee',
      'isResolved': true,
    },
    {
      'itemName': 'Student ID Card',
      'description':
          'Student ID for Jessica Taylor, Computer Science major. Found near the main gate.',
      'datePosted': DateTime.now().subtract(const Duration(days: 4)),
      'location': 'Main Campus Gate',
      'category': 'Documents',
      'status': 'Found',
      'posterName': 'Tom Wilson',
      'isResolved': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredItems {
    var items = _allItems;

    // Filter by status (Lost/Found)
    if (_selectedStatus != null) {
      items = items.where((item) => item['status'] == _selectedStatus).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      items = items.where((item) {
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
      items = items
          .where((item) => item['category'] == _searchCategoryFilter)
          .toList();
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Separate items into active and resolved
    final activeItems = _filteredItems.where((item) => !item['isResolved']).toList();
    final resolvedItems = _filteredItems.where((item) => item['isResolved']).toList();

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

          // Status filter chips (shown when not searching)
          if (!_isSearching)
            StatusChipFilter(
              statuses: _statuses,
              selectedStatus: _selectedStatus,
              onStatusSelected: (status) {
                setState(() {
                  _selectedStatus = status;
                });
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
                  count: _allItems.where((item) => item['status'] == 'Lost' && !item['isResolved']).length,
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
                  count: _allItems.where((item) => item['status'] == 'Found' && !item['isResolved']).length,
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
                  count: _allItems.where((item) => item['isResolved']).length,
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
                    '${_filteredItems.length} result${_filteredItems.length != 1 ? 's' : ''} found',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Active items
                        if (activeItems.isNotEmpty) ...[
                          ...activeItems.map((item) {
                            return LostAndFoundItemCard(
                              itemName: item['itemName'],
                              description: item['description'],
                              datePosted: item['datePosted'],
                              location: item['location'],
                              category: item['category'],
                              status: item['status'],
                              posterName: item['posterName'],
                              imageUrl: item['imageUrl'],
                              posterImageUrl: item['posterImageUrl'],
                              contactInfo: item['contactInfo'],
                              isResolved: item['isResolved'],
                              onContact: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Contact feature for "${item['itemName']}"',
                                    ),
                                  ),
                                );
                              },
                              onMarkResolved: () {
                                setState(() {
                                  item['isResolved'] = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Item marked as resolved!'),
                                  ),
                                );
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
                            return Opacity(
                              opacity: 0.6,
                              child: LostAndFoundItemCard(
                                itemName: item['itemName'],
                                description: item['description'],
                                datePosted: item['datePosted'],
                                location: item['location'],
                                category: item['category'],
                                status: item['status'],
                                posterName: item['posterName'],
                                imageUrl: item['imageUrl'],
                                posterImageUrl: item['posterImageUrl'],
                                contactInfo: item['contactInfo'],
                                isResolved: item['isResolved'],
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
                  setState(() {
                    _allItems.insert(0, newItem);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Item posted successfully!'),
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
