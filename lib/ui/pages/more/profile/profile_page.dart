import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/utils/date_formatter.dart';
import 'package:campuswhisper/routing/app_routes.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';
import 'package:campuswhisper/ui/widgets/user_avatar.dart';
import 'package:campuswhisper/providers/user_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;

    return Scaffold(
      appBar: DefaultAppBar(
        title: 'My Profile',
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.editProfile);
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header
                  _buildProfileHeader(context, colorScheme, user, userProvider),

                  AppDimensions.h24,

                  // Stats Section
                  _buildStatsSection(colorScheme, user, userProvider),

                  AppDimensions.h24,

                  // Info Sections
                  _buildInfoSection(
                    context,
                    colorScheme,
                    title: 'Personal Information',
                    items: [
                      _InfoItem(
                        icon: Iconsax.user_outline,
                        label: 'Full Name',
                        value: '${user.firstName} ${user.lastName}',
                      ),
                      _InfoItem(
                        icon: Iconsax.sms_outline,
                        label: 'Email',
                        value: user.email,
                      ),
                    ],
                  ),

                  AppDimensions.h16,

                  _buildInfoSection(
                    context,
                    colorScheme,
                    title: 'Academic Information',
                    items: [
                      _InfoItem(
                        icon: Iconsax.building_outline,
                        label: 'University',
                        value: user.university,
                      ),
                      _InfoItem(
                        icon: Iconsax.book_outline,
                        label: 'Department',
                        value: user.department,
                      ),
                      _InfoItem(
                        icon: Iconsax.award_outline,
                        label: 'Student ID',
                        value: user.id,
                      ),
                      _InfoItem(
                        icon: Iconsax.medal_outline,
                        label: 'Batch',
                        value: user.batch ?? 'N/A',
                      ),
                    ],
                  ),

                  AppDimensions.h16,

                  _buildInfoSection(
                    context,
                    colorScheme,
                    title: 'Gamification',
                    items: [
                      _InfoItem(
                        icon: Iconsax.medal_star_outline,
                        label: 'Total XP',
                        value: '${user.xp} XP',
                      ),
                      _InfoItem(
                        icon: Iconsax.crown_outline,
                        label: 'Level',
                        value: 'Level ${userProvider.userLevel}',
                      ),
                      _InfoItem(
                        icon: Iconsax.award_outline,
                        label: 'Badges',
                        value: '${user.badges?.length ?? 0} Badges',
                      ),
                      _InfoItem(
                        icon: Iconsax.chart_outline,
                        label: 'Contributions',
                        value: '${user.contributions}',
                      ),
                    ],
                  ),

                  AppDimensions.h16,

                  _buildInfoSection(
                    context,
                    colorScheme,
                    title: 'Account',
                    items: [
                      _InfoItem(
                        icon: Iconsax.calendar_1_outline,
                        label: 'Member Since',
                        value: DateFormatter.formatDate(
                          user.createdAt ?? DateTime.now(),
                        ),
                      ),
                      _InfoItem(
                        icon: Iconsax.clock_outline,
                        label: 'Last Login',
                        value: user.lastLogin != null
                            ? DateFormatter.formatDate(user.lastLogin!)
                            : 'Never',
                      ),
                      _InfoItem(
                        icon: Iconsax.shield_tick_outline,
                        label: 'Role',
                        value: user.role.toUpperCase(),
                      ),
                    ],
                  ),

                  AppDimensions.h32,
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    ColorScheme colorScheme,
    dynamic user,
    UserProvider userProvider,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.horizontalPadding),
        child: Column(
          children: [
            AppDimensions.h24,

            // Profile Avatar
            UserAvatar(imageUrl: null, name: userProvider.userName, size: 100),

            AppDimensions.h16,

            // User Name
            BuildText(
              text: userProvider.userName,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),

            AppDimensions.h8,

            // User Email
            BuildText(
              text: user.email,
              fontSize: 15,
              color: colorScheme.onSurface.withAlpha(153),
            ),

            AppDimensions.h12,

            // Department Badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.space16,
                vertical: AppDimensions.space8,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(26),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorScheme.primary.withAlpha(77)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.book_outline, size: 16, color: colorScheme.primary),
                  AppDimensions.w8,
                  BuildText(
                    text: '${user.department} • ${user.batch}',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),

            AppDimensions.h24,
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(
    ColorScheme colorScheme,
    dynamic user,
    UserProvider userProvider,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding),
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        border: Border.all(color: colorScheme.onSurface.withAlpha(26)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Level',
            '${userProvider.userLevel}',
            Iconsax.crown_bold,
            colorScheme,
          ),
          Container(
            height: 40,
            width: 1,
            color: colorScheme.onSurface.withAlpha(51),
          ),
          _buildStatItem(
            'Contributions',
            '${user.contributions}',
            Iconsax.chart_bold,
            colorScheme,
          ),
          Container(
            height: 40,
            width: 1,
            color: colorScheme.onSurface.withAlpha(51),
          ),
          _buildStatItem(
            'XP',
            '${user.xp}',
            Iconsax.medal_star_bold,
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: [
        Icon(icon, size: 24, color: colorScheme.primary),
        AppDimensions.h8,
        BuildText(
          text: value,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
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

  Widget _buildInfoSection(
    BuildContext context,
    ColorScheme colorScheme, {
    required String title,
    required List<_InfoItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding,
          ),
          child: BuildText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface.withAlpha(153),
          ),
        ),
        AppDimensions.h12,
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radius12),
            border: Border.all(color: colorScheme.onSurface.withAlpha(26)),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;

              return Column(
                children: [
                  _buildInfoRow(context, colorScheme, item),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 56,
                      color: colorScheme.onSurface.withAlpha(26),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    ColorScheme colorScheme,
    _InfoItem item,
  ) {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.space16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppDimensions.space8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(AppDimensions.radius8),
            ),
            child: Icon(item.icon, size: 20, color: colorScheme.primary),
          ),
          AppDimensions.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildText(
                  text: item.label,
                  fontSize: 12,
                  color: colorScheme.onSurface.withAlpha(153),
                ),
                AppDimensions.h4,
                BuildText(
                  text: item.value,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: item.valueColor ?? colorScheme.onSurface,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });
}
