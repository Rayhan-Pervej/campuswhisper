import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/utils/date_formatter.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';
import 'package:campuswhisper/ui/widgets/empty_state.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Unread', 'Events', 'Posts', 'System'];

  // TODO: Replace with actual notifications from database
  final List<Map<String, dynamic>> _sampleNotifications = [];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilter == 'All') {
      return _sampleNotifications;
    } else if (_selectedFilter == 'Unread') {
      return _sampleNotifications.where((n) => !n['isRead']).toList();
    } else {
      return _sampleNotifications
          .where((n) =>
              n['type'].toString().toLowerCase() ==
              _selectedFilter.toLowerCase())
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Notifications',
        actions: [
          if (_sampleNotifications.any((n) => !n['isRead']))
            TextButton(
              onPressed: _markAllAsRead,
              child: BuildText(
                text: 'Mark all read',
                fontSize: 14,
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(vertical: AppDimensions.space8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.horizontalPadding,
              ),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;

                return Padding(
                  padding: EdgeInsets.only(right: AppDimensions.space8),
                  child: FilterChip(
                    selected: isSelected,
                    label: BuildText(
                      text: filter,
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    selectedColor: colorScheme.primary,
                    checkmarkColor: colorScheme.onPrimary,
                    side: BorderSide(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface.withAlpha(51),
                    ),
                  ),
                );
              },
            ),
          ),

          // Notifications List
          Expanded(
            child: _filteredNotifications.isEmpty
                ? EmptyState(
                    icon: Iconsax.notification_outline,
                    message: 'No Notifications',
                    subtitle: _selectedFilter == 'Unread'
                        ? 'You have no unread notifications'
                        : 'No notifications in this category',
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.horizontalPadding,
                      vertical: AppDimensions.space8,
                    ),
                    itemCount: _filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = _filteredNotifications[index];
                      return _buildNotificationCard(
                        context,
                        colorScheme,
                        notification,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    ColorScheme colorScheme,
    Map<String, dynamic> notification,
  ) {
    final isRead = notification['isRead'] as bool;

    return Dismissible(
      key: Key(notification['id']),
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
          _sampleNotifications.remove(notification);
        });
      },
      child: GestureDetector(
        onTap: () => _handleNotificationTap(notification),
        child: Container(
          margin: EdgeInsets.only(bottom: AppDimensions.space12),
          padding: EdgeInsets.all(AppDimensions.space16),
          decoration: BoxDecoration(
            color: isRead
                ? colorScheme.surface
                : colorScheme.primary.withAlpha(13),
            borderRadius: BorderRadius.circular(AppDimensions.radius12),
            border: Border.all(
              color: isRead
                  ? colorScheme.onSurface.withAlpha(26)
                  : colorScheme.primary.withAlpha(51),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(AppDimensions.space8),
                decoration: BoxDecoration(
                  color: isRead
                      ? colorScheme.surfaceContainerHighest
                      : colorScheme.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(AppDimensions.radius8),
                ),
                child: Icon(
                  notification['icon'] as IconData,
                  size: 20,
                  color: isRead
                      ? colorScheme.onSurface.withAlpha(153)
                      : colorScheme.primary,
                ),
              ),

              AppDimensions.w12,

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: BuildText(
                            text: notification['title'],
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: EdgeInsets.only(left: AppDimensions.space8),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    AppDimensions.h4,
                    BuildText(
                      text: notification['message'],
                      fontSize: 13,
                      color: colorScheme.onSurface.withAlpha(153),
                    ),
                    AppDimensions.h8,
                    BuildText(
                      text: DateFormatter.timeAgo(notification['timestamp']),
                      fontSize: 11,
                      color: colorScheme.onSurface.withAlpha(102),
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

  void _handleNotificationTap(Map<String, dynamic> notification) {
    setState(() {
      notification['isRead'] = true;
    });

    // TODO: Navigate to the relevant page based on notification type
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _sampleNotifications) {
        notification['isRead'] = true;
      }
    });
  }
}
