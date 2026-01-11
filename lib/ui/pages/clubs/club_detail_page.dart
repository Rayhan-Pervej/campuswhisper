import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/utils/snackbar_helper.dart';
import 'package:campuswhisper/core/utils/dialog_helper.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';
import 'package:campuswhisper/ui/widgets/user_avatar.dart';
import 'package:campuswhisper/ui/widgets/cached_image.dart';

class ClubDetailPage extends StatefulWidget {
  final Map<String, dynamic> club;

  const ClubDetailPage({
    super.key,
    required this.club,
  });

  @override
  State<ClubDetailPage> createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends State<ClubDetailPage> {
  bool _isMember = false;
  bool _isLoading = false;
  int _memberCount = 0;

  @override
  void initState() {
    super.initState();
    _memberCount = widget.club['memberCount'] ?? 0;
    _isMember = widget.club['isMember'] ?? false;
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Technical':
        return Iconsax.code_outline;
      case 'Cultural':
        return Iconsax.music_outline;
      case 'Sports':
        return Iconsax.cup_outline;
      case 'Academic':
        return Iconsax.book_outline;
      case 'Arts':
        return Iconsax.brush_outline;
      case 'Community Service':
        return Iconsax.heart_outline;
      case 'Social':
        return Iconsax.people_outline;
      default:
        return Iconsax.buildings_outline;
    }
  }

  String get clubInitials {
    final name = widget.club['name'] as String;
    final words = name.split(' ');
    if (words.isEmpty) return '';
    if (words.length == 1) {
      return words[0].isNotEmpty ? words[0][0].toUpperCase() : '';
    }
    final firstInitial = words[0].isNotEmpty ? words[0][0].toUpperCase() : '';
    final lastInitial = words[1].isNotEmpty ? words[1][0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: DefaultAppBar(
        title: widget.club['name'] ?? 'Club Details',
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
            // Cover Image
            widget.club['coverImageUrl'] != null
                ? Hero(
                    tag: 'club_${widget.club['id']}',
                    child: CachedImage(
                      imageUrl: widget.club['coverImageUrl'],
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
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
                        getCategoryIcon(widget.club['category'] ?? ''),
                        size: 100,
                        color: Colors.white.withAlpha(128),
                      ),
                    ),
                  ),

            Padding(
              padding: EdgeInsets.all(AppDimensions.horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppDimensions.h16,

                  // Club logo and basic info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Club logo
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(AppDimensions.radius12),
                          border: Border.all(
                            color: colorScheme.surface,
                            width: 4,
                          ),
                        ),
                        child: widget.club['logoUrl'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(AppDimensions.radius12 - 4),
                                child: CachedImage(
                                  imageUrl: widget.club['logoUrl'],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: BuildText(
                                  text: clubInitials,
                                  fontSize: 32,
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
                              text: widget.club['name'] ?? 'Unknown Club',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            AppDimensions.h8,
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
                                    text: widget.club['category'] ?? 'General',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.secondary,
                                  ),
                                ),
                                AppDimensions.w8,
                                if (widget.club['isActive'] == true)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppDimensions.space8,
                                      vertical: AppDimensions.space4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withAlpha(26),
                                      borderRadius: BorderRadius.circular(AppDimensions.radius8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          size: 8,
                                          color: Colors.green,
                                        ),
                                        AppDimensions.w4,
                                        BuildText(
                                          text: 'Active',
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppDimensions.h24,

                  // Stats row
                  Container(
                    padding: EdgeInsets.all(AppDimensions.space16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppDimensions.radius12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          icon: Iconsax.profile_2user_outline,
                          label: 'Members',
                          value: _memberCount.toString(),
                          color: colorScheme.primary,
                        ),
                        Container(
                          height: 40,
                          width: 1,
                          color: colorScheme.onSurface.withAlpha(51),
                        ),
                        _StatItem(
                          icon: Iconsax.calendar_outline,
                          label: 'Established',
                          value: widget.club['establishedYear']?.toString() ?? 'N/A',
                          color: colorScheme.secondary,
                        ),
                        Container(
                          height: 40,
                          width: 1,
                          color: colorScheme.onSurface.withAlpha(51),
                        ),
                        _StatItem(
                          icon: Iconsax.star_outline,
                          label: 'Events',
                          value: '12',
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                  AppDimensions.h24,

                  // About section
                  BuildText(
                    text: 'About',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  AppDimensions.h12,
                  BuildText(
                    text: widget.club['description'] ?? 'No description available',
                    fontSize: 14,
                    color: colorScheme.onSurface.withAlpha(204),
                    height: 1.6,
                  ),
                  AppDimensions.h24,

                  // Divider
                  Divider(color: colorScheme.onSurface.withAlpha(26)),
                  AppDimensions.h24,

                  // President info
                  BuildText(
                    text: 'Club President',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  AppDimensions.h16,
                  Container(
                    padding: EdgeInsets.all(AppDimensions.space16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppDimensions.radius12),
                    ),
                    child: Row(
                      children: [
                        UserAvatar(
                          imageUrl: widget.club['presidentImageUrl'],
                          name: widget.club['presidentName'] ?? 'Unknown',
                          size: 50,
                        ),
                        AppDimensions.w12,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BuildText(
                                text: widget.club['presidentName'] ?? 'Unknown',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              AppDimensions.h4,
                              BuildText(
                                text: 'Club President',
                                fontSize: 13,
                                color: colorScheme.onSurface.withAlpha(153),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: colorScheme.onSurface.withAlpha(102),
                        ),
                      ],
                    ),
                  ),
                  AppDimensions.h24,

                  // Divider
                  Divider(color: colorScheme.onSurface.withAlpha(26)),
                  AppDimensions.h24,

                  // Contact Information
                  BuildText(
                    text: 'Contact Information',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  AppDimensions.h16,
                  _buildContactRow(
                    colorScheme,
                    Iconsax.sms_outline,
                    'Email',
                    widget.club['contactEmail'] ?? 'N/A',
                  ),
                  if (widget.club['contactPhone'] != null) ...[
                    AppDimensions.h12,
                    _buildContactRow(
                      colorScheme,
                      Iconsax.call_outline,
                      'Phone',
                      widget.club['contactPhone'],
                    ),
                  ],
                  AppDimensions.h24,

                  // Social Links (if available)
                  if (widget.club['facebookUrl'] != null ||
                      widget.club['instagramUrl'] != null ||
                      widget.club['websiteUrl'] != null) ...[
                    Divider(color: colorScheme.onSurface.withAlpha(26)),
                    AppDimensions.h24,
                    BuildText(
                      text: 'Social Media',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    AppDimensions.h16,
                    Row(
                      children: [
                        if (widget.club['facebookUrl'] != null)
                          _SocialButton(
                            icon: Iconsax.link_outline,
                            label: 'Facebook',
                            onTap: () {
                              SnackbarHelper.showInfo(context, 'Opening Facebook...');
                            },
                          ),
                        if (widget.club['instagramUrl'] != null) ...[
                          AppDimensions.w12,
                          _SocialButton(
                            icon: Iconsax.camera_outline,
                            label: 'Instagram',
                            onTap: () {
                              SnackbarHelper.showInfo(context, 'Opening Instagram...');
                            },
                          ),
                        ],
                        if (widget.club['websiteUrl'] != null) ...[
                          AppDimensions.w12,
                          _SocialButton(
                            icon: Iconsax.global_outline,
                            label: 'Website',
                            onTap: () {
                              SnackbarHelper.showInfo(context, 'Opening website...');
                            },
                          ),
                        ],
                      ],
                    ),
                    AppDimensions.h24,
                  ],
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

  Widget _buildContactRow(
    ColorScheme colorScheme,
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.space12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppDimensions.radius8),
      ),
      child: Row(
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
      ),
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
            // Join/Leave button
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _handleJoinLeave,
                icon: Icon(
                  _isMember ? Iconsax.tick_circle_bold : Iconsax.user_add_outline,
                  size: 18,
                ),
                label: Text(_isMember ? 'Member' : 'Join Club'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isMember ? colorScheme.surface : colorScheme.primary,
                  foregroundColor: _isMember ? colorScheme.primary : colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: AppDimensions.space12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                    side: _isMember
                        ? BorderSide(color: colorScheme.primary, width: 2)
                        : BorderSide.none,
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

  void _handleJoinLeave() async {
    if (_isMember) {
      // Leave club - show confirmation
      final confirmed = await DialogHelper.showConfirmation(
        context,
        title: 'Leave Club',
        message: 'Are you sure you want to leave ${widget.club['name']}?',
        confirmText: 'Leave',
        cancelText: 'Cancel',
      );

      if (!confirmed || !mounted) return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      _isMember = !_isMember;
      if (_isMember) {
        _memberCount++;
      } else {
        _memberCount--;
      }
      _isLoading = false;
    });

    if (!mounted) return;

    SnackbarHelper.showSuccess(
      context,
      _isMember ? 'Joined ${widget.club['name']}!' : 'Left ${widget.club['name']}',
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
                  Iconsax.message_outline,
                  'Contact Club',
                  () {
                    Navigator.pop(context);
                    SnackbarHelper.showInfo(context, 'Contact feature coming soon');
                  },
                ),
                _buildOptionItem(
                  colorScheme,
                  Iconsax.calendar_outline,
                  'View Events',
                  () {
                    Navigator.pop(context);
                    SnackbarHelper.showInfo(context, 'Events feature coming soon');
                  },
                ),
                _buildOptionItem(
                  colorScheme,
                  Iconsax.profile_2user_outline,
                  'View Members',
                  () {
                    Navigator.pop(context);
                    SnackbarHelper.showInfo(context, 'Members list coming soon');
                  },
                ),
                _buildOptionItem(
                  colorScheme,
                  Iconsax.flag_outline,
                  'Report Club',
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

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        AppDimensions.h8,
        BuildText(
          text: value,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
        AppDimensions.h4,
        BuildText(
          text: label,
          fontSize: 12,
          color: colorScheme.onSurface.withAlpha(153),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radius8),
        child: Container(
          padding: EdgeInsets.all(AppDimensions.space12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppDimensions.radius8),
          ),
          child: Column(
            children: [
              Icon(icon, size: 24, color: colorScheme.primary),
              AppDimensions.h8,
              BuildText(
                text: label,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
