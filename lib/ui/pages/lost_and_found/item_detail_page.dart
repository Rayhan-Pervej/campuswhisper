import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/utils/date_formatter.dart';
import 'package:campuswhisper/core/utils/snackbar_helper.dart';
import 'package:campuswhisper/core/utils/dialog_helper.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';
import 'package:campuswhisper/ui/widgets/user_avatar.dart';
import 'package:campuswhisper/routing/app_routes.dart';

class ItemDetailPage extends StatefulWidget {
  final Map<String, dynamic> item;

  const ItemDetailPage({
    super.key,
    required this.item,
  });

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  bool _isSaved = false;
  bool _isResolved = false;

  @override
  void initState() {
    super.initState();
    _isResolved = widget.item['isResolved'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final status = widget.item['status'] ?? 'Lost';
    final isLost = status == 'Lost';

    return Scaffold(
      appBar: DefaultAppBar(
        title: widget.item['itemName'] ?? 'Item Details',
        actions: [
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: _isSaved ? colorScheme.primary : null,
            ),
            onPressed: () {
              setState(() {
                _isSaved = !_isSaved;
              });
              SnackbarHelper.showSuccess(
                context,
                _isSaved ? 'Item saved' : 'Item unsaved',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Image (placeholder for now)
            Container(
              height: 250,
              width: double.infinity,
              color: colorScheme.surfaceContainerHighest,
              child: Icon(
                _getCategoryIcon(widget.item['category']),
                size: 80,
                color: colorScheme.primary.withAlpha(102),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(AppDimensions.horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppDimensions.h16,

                  // Status and Category chips
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.space12,
                          vertical: AppDimensions.space8,
                        ),
                        decoration: BoxDecoration(
                          color: (isLost ? colorScheme.error : colorScheme.primary)
                              .withAlpha(26),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radius8),
                          border: Border.all(
                            color: (isLost
                                    ? colorScheme.error
                                    : colorScheme.primary)
                                .withAlpha(77),
                          ),
                        ),
                        child: BuildText(
                          text: status,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isLost ? colorScheme.error : colorScheme.primary,
                        ),
                      ),
                      AppDimensions.w8,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.space12,
                          vertical: AppDimensions.space8,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer.withAlpha(51),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radius8),
                        ),
                        child: BuildText(
                          text: widget.item['category'] ?? 'Other',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.secondary,
                        ),
                      ),
                      if (_isResolved) ...[
                        AppDimensions.w8,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.space12,
                            vertical: AppDimensions.space8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withAlpha(26),
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radius8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 14,
                                color: Colors.green,
                              ),
                              AppDimensions.w4,
                              BuildText(
                                text: 'Resolved',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  AppDimensions.h16,

                  // Item Name
                  BuildText(
                    text: widget.item['itemName'] ?? 'Unknown Item',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  AppDimensions.h24,

                  // Location
                  _buildInfoRow(
                    colorScheme,
                    Iconsax.location_outline,
                    'Location',
                    widget.item['location'] ?? 'Unknown',
                  ),
                  AppDimensions.h16,

                  // Date Posted
                  _buildInfoRow(
                    colorScheme,
                    Iconsax.calendar_outline,
                    'Date Posted',
                    widget.item['datePosted'] != null
                        ? DateFormatter.formatDateTime(
                            widget.item['datePosted'])
                        : 'Unknown',
                  ),
                  AppDimensions.h24,

                  // Divider
                  Divider(color: colorScheme.onSurface.withAlpha(26)),
                  AppDimensions.h24,

                  // Description
                  BuildText(
                    text: 'Description',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  AppDimensions.h12,
                  BuildText(
                    text: widget.item['description'] ??
                        'No description provided',
                    fontSize: 14,
                    color: colorScheme.onSurface.withAlpha(180),
                    height: 1.6,
                  ),
                  AppDimensions.h24,

                  // Divider
                  Divider(color: colorScheme.onSurface.withAlpha(26)),
                  AppDimensions.h24,

                  // Posted By
                  BuildText(
                    text: 'Posted By',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  AppDimensions.h16,
                  Row(
                    children: [
                      UserAvatar(
                        imageUrl: widget.item['posterAvatar'],
                        name: widget.item['posterName'] ?? 'Unknown',
                        size: 50,
                      ),
                      AppDimensions.w12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BuildText(
                              text:
                                  widget.item['posterName'] ?? 'Unknown User',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            AppDimensions.h4,
                            BuildText(
                              text: 'Posted ${widget.item['datePosted'] != null ? DateFormatter.timeAgo(widget.item['datePosted']) : 'recently'}',
                              fontSize: 12,
                              color: colorScheme.onSurface.withAlpha(153),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppDimensions.h24,

                  // Bottom padding for action buttons
                  SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildActionBar(colorScheme),
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category) {
      case 'Electronics':
        return Iconsax.mobile_outline;
      case 'Documents':
        return Iconsax.document_outline;
      case 'Accessories':
        return Iconsax.bag_outline;
      case 'Books':
        return Iconsax.book_outline;
      case 'Clothing':
        return Iconsax.bag_2_outline;
      case 'Keys':
        return Iconsax.key_outline;
      case 'Bags':
        return Iconsax.bag_outline;
      default:
        return Iconsax.box_outline;
    }
  }

  Widget _buildInfoRow(
    ColorScheme colorScheme,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(AppDimensions.space8),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withAlpha(77),
            borderRadius: BorderRadius.circular(AppDimensions.radius8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: colorScheme.primary,
          ),
        ),
        AppDimensions.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildText(
                text: label,
                fontSize: 12,
                color: colorScheme.onSurface.withAlpha(153),
              ),
              AppDimensions.h4,
              BuildText(
                text: value,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionBar(ColorScheme colorScheme) {
    if (_isResolved) {
      return Container(
        padding: EdgeInsets.all(AppDimensions.space16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(AppDimensions.space16),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(26),
              borderRadius: BorderRadius.circular(AppDimensions.radius12),
              border: Border.all(color: Colors.green),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                AppDimensions.w8,
                BuildText(
                  text: 'This item has been resolved',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Contact Poster button
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.contactPoster,
                    arguments: {
                      'item': widget.item,
                    },
                  );
                },
                icon: Icon(Iconsax.message_outline, size: 18),
                label: const Text('Contact Poster'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding:
                      EdgeInsets.symmetric(vertical: AppDimensions.space12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  ),
                ),
              ),
            ),
            AppDimensions.w12,

            // Share button
            IconButton(
              onPressed: () {
                SnackbarHelper.showInfo(context, 'Share feature coming soon');
              },
              icon: const Icon(Icons.share_outlined),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.surfaceContainerHighest,
                padding: EdgeInsets.all(AppDimensions.space12),
              ),
            ),
            AppDimensions.w8,

            // More options
            IconButton(
              onPressed: () => _showMoreOptions(colorScheme),
              icon: const Icon(Icons.more_vert),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.surfaceContainerHighest,
                padding: EdgeInsets.all(AppDimensions.space12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMarkResolved(BuildContext context) async {
    Navigator.pop(context);
    final confirmed = await DialogHelper.showConfirmation(
      context,
      title: 'Mark as Resolved',
      message: 'Have you successfully claimed/returned this item?',
      confirmText: 'Yes, Resolved',
      cancelText: 'Cancel',
    );

    if (!confirmed || !mounted) return;

    setState(() {
      _isResolved = true;
    });
    SnackbarHelper.showSuccess(
      context,
      'Item marked as resolved',
    );
  }

  void _showMoreOptions(ColorScheme colorScheme) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radius16),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.space16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: AppDimensions.space16),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withAlpha(77),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                _buildOptionItem(
                  colorScheme,
                  Iconsax.tick_circle_outline,
                  'Mark as Resolved',
                  () => _handleMarkResolved(context),
                ),
                _buildOptionItem(
                  colorScheme,
                  Iconsax.flag_outline,
                  'Report Item',
                  () {
                    Navigator.pop(context);
                    SnackbarHelper.showWarning(
                      context,
                      'Report feature coming soon',
                    );
                  },
                  isDestructive: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionItem(
    ColorScheme colorScheme,
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radius12),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppDimensions.space12,
          horizontal: AppDimensions.space8,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? colorScheme.error : colorScheme.onSurface,
              size: 24,
            ),
            AppDimensions.w16,
            BuildText(
              text: label,
              fontSize: 16,
              color: isDestructive ? colorScheme.error : colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}
