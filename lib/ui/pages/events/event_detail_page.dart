import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/utils/date_formatter.dart';
import 'package:campuswhisper/core/utils/snackbar_helper.dart';
import 'package:campuswhisper/core/utils/dialog_helper.dart';
import 'package:campuswhisper/ui/widgets/cached_image.dart';
import 'package:campuswhisper/ui/widgets/user_avatar.dart';
import 'package:campuswhisper/routing/app_routes.dart';

class EventDetailPage extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventDetailPage({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool _isGoing = false;
  bool _isInterested = false;
  bool _isLoading = false;
  int _goingCount = 0;
  int _interestedCount = 0;

  @override
  void initState() {
    super.initState();
    _isGoing = widget.event['isGoing'] ?? false;
    _isInterested = widget.event['isInterested'] ?? false;
    _goingCount = widget.event['goingCount'] ?? 0;
    _interestedCount = widget.event['interestedCount'] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final eventDate = widget.event['eventDate'] as DateTime;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with hero image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'event_${widget.event['eventTitle']}',
                child: widget.event['eventImageUrl'] != null
                    ? CachedImage(
                        imageUrl: widget.event['eventImageUrl']!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: colorScheme.primaryContainer,
                        child: Icon(
                          Iconsax.gallery_outline,
                          size: 80,
                          color: colorScheme.primary,
                        ),
                      ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {
                  SnackbarHelper.showInfo(
                    context,
                    'Share feature coming soon',
                  );
                },
              ),
            ],
          ),

          // Event details
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppDimensions.h16,

                  // Category chip
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.space12,
                      vertical: AppDimensions.space8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer.withAlpha(51),
                      borderRadius: BorderRadius.circular(AppDimensions.radius8),
                      border: Border.all(
                        color: colorScheme.secondary.withAlpha(77),
                      ),
                    ),
                    child: BuildText(
                      text: widget.event['category'] ?? 'General',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.secondary,
                    ),
                  ),
                  AppDimensions.h16,

                  // Title
                  BuildText(
                    text: widget.event['eventTitle'] ?? 'Event',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  AppDimensions.h24,

                  // Date with icon
                  _buildInfoRow(
                    colorScheme,
                    Iconsax.calendar_outline,
                    'Date & Time',
                    DateFormatter.formatDateTime(eventDate),
                  ),
                  AppDimensions.h16,

                  // Location with icon
                  _buildInfoRow(
                    colorScheme,
                    Iconsax.location_outline,
                    'Location',
                    widget.event['location'] ?? 'TBA',
                  ),
                  AppDimensions.h16,

                  // Attendees info
                  _buildInfoRow(
                    colorScheme,
                    Iconsax.people_outline,
                    'Attendees',
                    '$_goingCount going • $_interestedCount interested',
                  ),
                  AppDimensions.h24,

                  // Divider
                  Divider(color: colorScheme.onSurface.withAlpha(26)),
                  AppDimensions.h24,

                  // Description
                  BuildText(
                    text: 'About Event',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  AppDimensions.h12,
                  BuildText(
                    text: widget.event['description'] ?? 'No description available',
                    fontSize: 14,
                    color: colorScheme.onSurface.withAlpha(180),
                    height: 1.6,
                  ),
                  AppDimensions.h24,

                  // Divider
                  Divider(color: colorScheme.onSurface.withAlpha(26)),
                  AppDimensions.h24,

                  // Organizer info
                  BuildText(
                    text: 'Organizer',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  AppDimensions.h16,
                  Row(
                    children: [
                      UserAvatar(
                        imageUrl: widget.event['organizerImageUrl'],
                        name: widget.event['organizerName'] ?? 'Unknown',
                        size: 50,
                      ),
                      AppDimensions.w12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BuildText(
                              text: widget.event['organizerName'] ?? 'Unknown Organizer',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            AppDimensions.h4,
                            BuildText(
                              text: 'Event Organizer',
                              fontSize: 12,
                              color: colorScheme.onSurface.withAlpha(153),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Iconsax.message_outline,
                          color: colorScheme.primary,
                        ),
                        onPressed: () {
                          SnackbarHelper.showInfo(
                            context,
                            'Message feature coming soon',
                          );
                        },
                      ),
                    ],
                  ),
                  AppDimensions.h24,

                  // Bottom padding for action bar
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildActionBar(colorScheme),
    );
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
            // Interested button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isLoading ? null : _handleInterested,
                icon: Icon(
                  _isInterested ? Iconsax.heart_bold : Iconsax.heart_outline,
                  size: 18,
                ),
                label: Text(_isInterested ? 'Interested' : 'Interest'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _isInterested
                      ? colorScheme.error
                      : colorScheme.onSurface.withAlpha(180),
                  side: BorderSide(
                    color: _isInterested
                        ? colorScheme.error
                        : colorScheme.onSurface.withAlpha(77),
                  ),
                  padding: EdgeInsets.symmetric(vertical: AppDimensions.space12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  ),
                ),
              ),
            ),
            AppDimensions.w12,

            // Going button
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _handleGoing,
                icon: Icon(
                  _isGoing ? Iconsax.tick_circle_bold : Iconsax.tick_circle_outline,
                  size: 18,
                ),
                label: Text(_isGoing ? 'Going' : 'I\'m Going'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isGoing
                      ? colorScheme.primary
                      : colorScheme.primaryContainer,
                  foregroundColor: _isGoing
                      ? colorScheme.onPrimary
                      : colorScheme.primary,
                  padding: EdgeInsets.symmetric(vertical: AppDimensions.space12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  ),
                ),
              ),
            ),
            AppDimensions.w12,

            // More options button
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

  void _handleInterested() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    setState(() {
      _isInterested = !_isInterested;
      if (_isInterested) {
        _interestedCount++;
      } else {
        _interestedCount--;
      }
      _isLoading = false;
    });

    SnackbarHelper.showSuccess(
      context,
      _isInterested
          ? 'Marked as interested'
          : 'Removed from interested',
    );
  }

  void _handleGoing() async {
    final confirmed = await DialogHelper.showConfirmation(
      context,
      title: _isGoing ? 'Cancel Registration' : 'Confirm Registration',
      message: _isGoing
          ? 'Are you sure you want to cancel your registration for this event?'
          : 'Are you sure you want to register for this event?',
      confirmText: _isGoing ? 'Cancel' : 'Register',
      cancelText: 'Back',
    );

    if (!confirmed || !mounted) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      _isGoing = !_isGoing;
      if (_isGoing) {
        _goingCount++;
      } else {
        _goingCount--;
      }
      _isLoading = false;
    });

    SnackbarHelper.showSuccess(
      context,
      _isGoing
          ? 'Successfully registered for the event'
          : 'Registration cancelled',
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
                  Iconsax.people_outline,
                  'View Attendees',
                  () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      AppRoutes.eventAttendees,
                      arguments: {
                        'eventTitle': widget.event['eventTitle'],
                        'attendees': [], // Will be fetched from backend
                      },
                    );
                  },
                ),
                _buildOptionItem(
                  colorScheme,
                  Iconsax.message_text_outline,
                  'View Comments',
                  () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      AppRoutes.eventComments,
                      arguments: {
                        'eventId': widget.event['eventTitle'], // Use proper ID later
                        'eventTitle': widget.event['eventTitle'],
                      },
                    );
                  },
                ),
                _buildOptionItem(
                  colorScheme,
                  Iconsax.calendar_add_outline,
                  'Add to Calendar',
                  () {
                    Navigator.pop(context);
                    SnackbarHelper.showInfo(
                      context,
                      'Calendar feature coming soon',
                    );
                  },
                ),
                _buildOptionItem(
                  colorScheme,
                  Iconsax.location_outline,
                  'Open in Maps',
                  () {
                    Navigator.pop(context);
                    SnackbarHelper.showInfo(
                      context,
                      'Maps integration coming soon',
                    );
                  },
                ),
                _buildOptionItem(
                  colorScheme,
                  Iconsax.flag_outline,
                  'Report Event',
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
