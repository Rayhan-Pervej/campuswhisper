import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/utils/date_formatter.dart';
import 'package:campuswhisper/ui/widgets/empty_state.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // TODO: Replace with actual saved data from database
  final List<Map<String, dynamic>> _savedPosts = [];
  final List<Map<String, dynamic>> _savedEvents = [];
  final List<Map<String, dynamic>> _savedItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: BuildText(
          text: 'Saved Items',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_2_outline),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurface.withAlpha(153),
          indicatorColor: colorScheme.primary,
          tabs: [
            Tab(text: 'All (${_getAllCount()})'),
            Tab(text: 'Posts (${_savedPosts.length})'),
            Tab(text: 'Events (${_savedEvents.length})'),
            Tab(text: 'Items (${_savedItems.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllTab(colorScheme),
          _buildPostsTab(colorScheme),
          _buildEventsTab(colorScheme),
          _buildItemsTab(colorScheme),
        ],
      ),
    );
  }

  int _getAllCount() {
    return _savedPosts.length + _savedEvents.length + _savedItems.length;
  }

  Widget _buildAllTab(ColorScheme colorScheme) {
    if (_getAllCount() == 0) {
      return EmptyState(
        icon: Iconsax.save_2_outline,
        message: 'No Saved Items',
        subtitle: 'Items you save will appear here',
      );
    }

    final allItems = [
      ..._savedPosts.map((p) => {...p, 'itemType': 'post'}),
      ..._savedEvents.map((e) => {...e, 'itemType': 'event'}),
      ..._savedItems.map((i) => {...i, 'itemType': 'item'}),
    ]..sort((a, b) => b['savedAt'].compareTo(a['savedAt']));

    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.horizontalPadding),
      itemCount: allItems.length,
      itemBuilder: (context, index) {
        final item = allItems[index];
        return _buildSavedCard(colorScheme, item);
      },
    );
  }

  Widget _buildPostsTab(ColorScheme colorScheme) {
    if (_savedPosts.isEmpty) {
      return EmptyState(
        icon: Iconsax.message_text_outline,
        message: 'No Saved Posts',
        subtitle: 'Save posts to read them later',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.horizontalPadding),
      itemCount: _savedPosts.length,
      itemBuilder: (context, index) {
        return _buildSavedCard(colorScheme, {
          ..._savedPosts[index],
          'itemType': 'post',
        });
      },
    );
  }

  Widget _buildEventsTab(ColorScheme colorScheme) {
    if (_savedEvents.isEmpty) {
      return EmptyState(
        icon: Iconsax.calendar_outline,
        message: 'No Saved Events',
        subtitle: 'Save events you want to attend',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.horizontalPadding),
      itemCount: _savedEvents.length,
      itemBuilder: (context, index) {
        return _buildSavedCard(colorScheme, {
          ..._savedEvents[index],
          'itemType': 'event',
        });
      },
    );
  }

  Widget _buildItemsTab(ColorScheme colorScheme) {
    if (_savedItems.isEmpty) {
      return EmptyState(
        icon: Iconsax.box_outline,
        message: 'No Saved Items',
        subtitle: 'Save lost and found items',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.horizontalPadding),
      itemCount: _savedItems.length,
      itemBuilder: (context, index) {
        return _buildSavedCard(colorScheme, {
          ..._savedItems[index],
          'itemType': 'item',
        });
      },
    );
  }

  Widget _buildSavedCard(ColorScheme colorScheme, Map<String, dynamic> item) {
    IconData icon;
    Color iconColor;

    switch (item['itemType']) {
      case 'post':
        icon = Iconsax.message_text_outline;
        iconColor = colorScheme.primary;
        break;
      case 'event':
        icon = Iconsax.calendar_outline;
        iconColor = colorScheme.secondary;
        break;
      case 'item':
        icon = Iconsax.box_outline;
        iconColor = colorScheme.tertiary;
        break;
      default:
        icon = Iconsax.save_2_outline;
        iconColor = colorScheme.primary;
    }

    return Dismissible(
      key: Key('${item['itemType']}_${item['id']}'),
      background: Container(
        margin: EdgeInsets.only(bottom: AppDimensions.space12),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: AppDimensions.space16),
        child: Icon(
          Iconsax.trash_outline,
          color: colorScheme.onError,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          if (item['itemType'] == 'post') {
            _savedPosts.removeWhere((p) => p['id'] == item['id']);
          } else if (item['itemType'] == 'event') {
            _savedEvents.removeWhere((e) => e['id'] == item['id']);
          } else if (item['itemType'] == 'item') {
            _savedItems.removeWhere((i) => i['id'] == item['id']);
          }
        });
      },
      child: Card(
        margin: EdgeInsets.only(bottom: AppDimensions.space12),
        elevation: AppDimensions.elevation1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
        ),
        child: InkWell(
          onTap: () {
            // TODO: Navigate to detail page
          },
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.space16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(AppDimensions.space8),
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(AppDimensions.radius8),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: iconColor,
                  ),
                ),
                AppDimensions.w12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildText(
                        text: item['title'] ?? item['itemName'] ?? 'Unknown',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      AppDimensions.h4,
                      if (item['content'] != null)
                        BuildText(
                          text: item['content'],
                          fontSize: 13,
                          color: colorScheme.onSurface.withAlpha(153),
                          maxLines: 2,
                        ),
                      if (item['location'] != null) ...[
                        AppDimensions.h4,
                        Row(
                          children: [
                            Icon(
                              Iconsax.location_outline,
                              size: 14,
                              color: colorScheme.onSurface.withAlpha(153),
                            ),
                            AppDimensions.w4,
                            BuildText(
                              text: item['location'],
                              fontSize: 12,
                              color: colorScheme.onSurface.withAlpha(153),
                            ),
                          ],
                        ),
                      ],
                      AppDimensions.h8,
                      BuildText(
                        text: 'Saved ${DateFormatter.timeAgo(item['savedAt'])}',
                        fontSize: 11,
                        color: colorScheme.onSurface.withAlpha(102),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Iconsax.save_2_bold,
                  size: 16,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
