import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/utils/date_formatter.dart';
import 'package:campuswhisper/core/utils/snackbar_helper.dart';
import 'package:campuswhisper/core/utils/dialog_helper.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';
import 'package:campuswhisper/ui/widgets/cached_image.dart';
import 'package:campuswhisper/ui/widgets/user_avatar.dart';
import 'package:campuswhisper/routing/app_routes.dart';

class CompetitionDetailPage extends StatefulWidget {
  final Map<String, dynamic> competition;

  const CompetitionDetailPage({
    super.key,
    required this.competition,
  });

  @override
  State<CompetitionDetailPage> createState() => _CompetitionDetailPageState();
}

class _CompetitionDetailPageState extends State<CompetitionDetailPage> {
  bool _isRegistered = false;
  bool _isLoading = false;
  int _participantCount = 0;

  @override
  void initState() {
    super.initState();
    _participantCount = widget.competition['participantCount'] ?? 0;
    _isRegistered = widget.competition['isRegistered'] ?? false;
  }

  Color getStatusColor(String? status) {
    switch (status) {
      case 'Registration Open':
        return Colors.green;
      case 'Ongoing':
        return Theme.of(context).colorScheme.secondary;
      case 'Upcoming':
        return Theme.of(context).colorScheme.primary;
      case 'Ended':
        return Theme.of(context).colorScheme.onSurface.withAlpha(153);
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final status = widget.competition['status'] ?? 'Upcoming';
    final statusColor = getStatusColor(status);

    return Scaffold(
      appBar: DefaultAppBar(
        title: widget.competition['title'] ?? 'Competition Details',
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              SnackbarHelper.showInfo(context, 'Share feature coming soon');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Competition Image
            Hero(
              tag: 'competition_${widget.competition['title']}',
              child: widget.competition['imageUrl'] != null
                  ? CachedImage(
                      imageUrl: widget.competition['imageUrl'],
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Iconsax.cup_outline,
                          size: 120,
                          color: Colors.white.withAlpha(128),
                        ),
                      ),
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
                          color: statusColor.withAlpha(26),
                          borderRadius: BorderRadius.circular(AppDimensions.radius8),
                          border: Border.all(
                            color: statusColor.withAlpha(77),
                            width: 1.5,
                          ),
                        ),
                        child: BuildText(
                          text: status,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
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
                          borderRadius: BorderRadius.circular(AppDimensions.radius8),
                        ),
                        child: BuildText(
                          text: widget.competition['category'] ?? 'General',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  AppDimensions.h16,

                  // Competition Title
                  BuildText(
                    text: widget.competition['title'] ?? 'Competition',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  AppDimensions.h8,

                  // Organizer
                  Row(
                    children: [
                      BuildText(
                        text: 'Organized by ',
                        fontSize: 14,
                        color: colorScheme.onSurface.withAlpha(153),
                      ),
                      BuildText(
                        text: widget.competition['organizer'] ?? 'Unknown',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ],
                  ),
                  AppDimensions.h24,

                  // Key info cards
                  _buildInfoRow(
                    colorScheme,
                    Iconsax.calendar_outline,
                    'Competition Date',
                    widget.competition['eventDate'] != null
                        ? DateFormatter.formatDateTime(widget.competition['eventDate'])
                        : 'TBA',
                  ),
                  AppDimensions.h12,
                  _buildInfoRow(
                    colorScheme,
                    Iconsax.timer_outline,
                    'Duration',
                    widget.competition['duration'] ?? 'N/A',
                  ),
                  AppDimensions.h12,
                  _buildInfoRow(
                    colorScheme,
                    Iconsax.location_outline,
                    'Location',
                    widget.competition['location'] ?? 'TBA',
                  ),
                  AppDimensions.h12,
                  _buildInfoRow(
                    colorScheme,
                    Iconsax.profile_2user_outline,
                    'Team Size',
                    widget.competition['teamSize'] ?? 'Individual',
                  ),
                  AppDimensions.h24,

                  // Registration deadline (if open)
                  if (status == 'Registration Open' &&
                      widget.competition['registrationDeadline'] != null)
                    Container(
                      padding: EdgeInsets.all(AppDimensions.space16),
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(26),
                        borderRadius: BorderRadius.circular(AppDimensions.radius12),
                        border: Border.all(
                          color: Colors.green.withAlpha(77),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.clock_outline,
                            color: Colors.green,
                            size: 24,
                          ),
                          AppDimensions.w12,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BuildText(
                                  text: 'Registration Deadline',
                                  fontSize: 12,
                                  color: colorScheme.onSurface.withAlpha(153),
                                ),
                                AppDimensions.h4,
                                BuildText(
                                  text: DateFormatter.formatDateTime(
                                      widget.competition['registrationDeadline']),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (status == 'Registration Open') AppDimensions.h24,

                  // Prize pool and participants
                  Container(
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
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Icon(
                                Iconsax.cup_outline,
                                color: colorScheme.primary,
                                size: 32,
                              ),
                              AppDimensions.h8,
                              BuildText(
                                text: widget.competition['prizePool'] ?? '₹0',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                              AppDimensions.h4,
                              BuildText(
                                text: 'Prize Pool',
                                fontSize: 12,
                                color: colorScheme.onSurface.withAlpha(153),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 60,
                          width: 1,
                          color: colorScheme.onSurface.withAlpha(51),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Icon(
                                Iconsax.profile_2user_outline,
                                color: colorScheme.secondary,
                                size: 32,
                              ),
                              AppDimensions.h8,
                              BuildText(
                                text: _participantCount.toString(),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.secondary,
                              ),
                              AppDimensions.h4,
                              BuildText(
                                text: 'Participants',
                                fontSize: 12,
                                color: colorScheme.onSurface.withAlpha(153),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppDimensions.h24,

                  // Divider
                  Divider(color: colorScheme.onSurface.withAlpha(26)),
                  AppDimensions.h24,

                  // Description
                  BuildText(
                    text: 'About',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  AppDimensions.h12,
                  BuildText(
                    text: widget.competition['description'] ?? 'No description available',
                    fontSize: 14,
                    color: colorScheme.onSurface.withAlpha(204),
                    height: 1.6,
                  ),
                  AppDimensions.h24,

                  // Rules (if available)
                  if (widget.competition['rules'] != null) ...[
                    Divider(color: colorScheme.onSurface.withAlpha(26)),
                    AppDimensions.h24,
                    BuildText(
                      text: 'Rules & Guidelines',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    AppDimensions.h12,
                    BuildText(
                      text: widget.competition['rules'],
                      fontSize: 14,
                      color: colorScheme.onSurface.withAlpha(204),
                      height: 1.6,
                    ),
                    AppDimensions.h24,
                  ],

                  // Prizes (if available)
                  if (widget.competition['prizes'] != null) ...[
                    Divider(color: colorScheme.onSurface.withAlpha(26)),
                    AppDimensions.h24,
                    BuildText(
                      text: 'Prizes',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    AppDimensions.h12,
                    BuildText(
                      text: widget.competition['prizes'],
                      fontSize: 14,
                      color: colorScheme.onSurface.withAlpha(204),
                      height: 1.6,
                    ),
                    AppDimensions.h24,
                  ],

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
                        imageUrl: widget.competition['organizerImageUrl'],
                        name: widget.competition['organizer'] ?? 'Organizer',
                        size: 50,
                      ),
                      AppDimensions.w12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BuildText(
                              text: widget.competition['organizer'] ?? 'Unknown Organizer',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            AppDimensions.h4,
                            BuildText(
                              text: 'Competition Organizer',
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
      bottomNavigationBar: _buildActionBar(colorScheme, status),
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

  Widget _buildActionBar(ColorScheme colorScheme, String status) {
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
            // Register/View button
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: status == 'Ended'
                    ? null
                    : (status == 'Ongoing'
                        ? () {
                            SnackbarHelper.showInfo(context, 'Competition is ongoing');
                          }
                        : _handleRegister),
                icon: Icon(
                  status == 'Ongoing'
                      ? Iconsax.eye_outline
                      : status == 'Ended'
                          ? Iconsax.medal_star_outline
                          : _isRegistered
                              ? Iconsax.tick_circle_bold
                              : Iconsax.tick_circle_outline,
                  size: 18,
                ),
                label: Text(
                  status == 'Ongoing'
                      ? 'View Live'
                      : status == 'Ended'
                          ? 'View Results'
                          : _isRegistered
                              ? 'Registered'
                              : 'Register Now',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: status == 'Ongoing'
                      ? colorScheme.secondaryContainer
                      : status == 'Ended'
                          ? colorScheme.surfaceContainerHighest
                          : _isRegistered
                              ? colorScheme.surface
                              : colorScheme.primary,
                  foregroundColor: status == 'Ongoing'
                      ? colorScheme.onSecondaryContainer
                      : status == 'Ended'
                          ? colorScheme.onSurface
                          : _isRegistered
                              ? colorScheme.primary
                              : colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: AppDimensions.space12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                    side: _isRegistered && status != 'Ongoing' && status != 'Ended'
                        ? BorderSide(color: colorScheme.primary, width: 2)
                        : BorderSide.none,
                  ),
                ),
              ),
            ),
            AppDimensions.w12,

            // View Participants button
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.competitionParticipants,
                  arguments: {
                    'competitionTitle': widget.competition['title'],
                    'participants': [],
                  },
                );
              },
              icon: const Icon(Iconsax.profile_2user_outline),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.surfaceContainerHighest,
                padding: EdgeInsets.all(AppDimensions.space12),
              ),
            ),
            AppDimensions.w8,

            // More options
            IconButton(
              onPressed: _showMoreOptions,
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

  void _handleRegister() async {
    if (_isRegistered) {
      // Cancel registration - show confirmation
      final confirmed = await DialogHelper.showConfirmation(
        context,
        title: 'Cancel Registration',
        message: 'Are you sure you want to cancel your registration for ${widget.competition['title']}?',
        confirmText: 'Cancel Registration',
        cancelText: 'Keep Registration',
      );

      if (!confirmed || !mounted) return;
    } else {
      // Navigate to registration page
      final result = await Navigator.pushNamed(
        context,
        AppRoutes.competitionRegistration,
        arguments: {
          'competition': widget.competition,
        },
      );

      if (result == true && mounted) {
        setState(() {
          _isRegistered = true;
          _participantCount++;
        });
        return;
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      _isRegistered = !_isRegistered;
      if (_isRegistered) {
        _participantCount++;
      } else {
        _participantCount--;
      }
      _isLoading = false;
    });

    if (!mounted) return;

    SnackbarHelper.showSuccess(
      context,
      _isRegistered ? 'Registered successfully!' : 'Registration cancelled',
    );
  }

  void _showMoreOptions() {
    final colorScheme = Theme.of(context).colorScheme;

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
                  Iconsax.share_outline,
                  'Share Competition',
                  () {
                    Navigator.pop(context);
                    SnackbarHelper.showInfo(context, 'Share feature coming soon');
                  },
                ),
                _buildOptionItem(
                  colorScheme,
                  Iconsax.calendar_add_outline,
                  'Add to Calendar',
                  () {
                    Navigator.pop(context);
                    SnackbarHelper.showSuccess(context, 'Added to calendar!');
                  },
                ),
                _buildOptionItem(
                  colorScheme,
                  Iconsax.location_outline,
                  'Open in Maps',
                  () {
                    Navigator.pop(context);
                    SnackbarHelper.showInfo(context, 'Opening in maps...');
                  },
                ),
                _buildOptionItem(
                  colorScheme,
                  Iconsax.flag_outline,
                  'Report Competition',
                  () {
                    Navigator.pop(context);
                    SnackbarHelper.showWarning(context, 'Report feature coming soon');
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
