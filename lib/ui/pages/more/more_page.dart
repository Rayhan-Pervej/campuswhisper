import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/utils/dialog_helper.dart';
import 'package:campuswhisper/routing/app_routes.dart';
import 'package:campuswhisper/ui/widgets/user_avatar.dart';
import 'package:campuswhisper/providers/user_provider.dart';
import 'package:campuswhisper/core/services/auth_service.dart';
import 'package:campuswhisper/core/utils/snackbar_helper.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    final colorScheme = Theme.of(context).colorScheme;
    final userProvider = Provider.of<UserProvider>(context);

    // Show loading state if user data is loading
    if (userProvider.isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(colorScheme.primary),
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(context, userProvider),

            // Menu Sections
            _buildMenuSection(
              context,
              title: 'Account',
              items: [
                _MenuItem(
                  icon: Iconsax.user_outline,
                  title: 'My Profile',
                  subtitle: 'View and edit your profile',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.profile);
                  },
                ),
                _MenuItem(
                  icon: Iconsax.bookmark_outline,
                  title: 'Saved Items',
                  subtitle: 'View your saved posts and events',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.saved);
                  },
                ),
                _MenuItem(
                  icon: Iconsax.medal_star_outline,
                  title: 'Badges & Achievements',
                  subtitle: 'View your earned badges',
                  onTap: () {
                    // TODO: Navigate to badges page
                    _showComingSoon(context);
                  },
                ),
              ],
            ),
            AppDimensions.h16,

            _buildMenuSection(
              context,
              title: 'Preferences',
              items: [
                // Theme toggle hidden - app follows system theme
                _MenuItem(
                  icon: Iconsax.notification_outline,
                  title: 'Notifications',
                  subtitle: 'Manage notification settings',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.notifications);
                  },
                ),
                _MenuItem(
                  icon: Iconsax.setting_2_outline,
                  title: 'Settings',
                  subtitle: 'App preferences and privacy',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.settingsPage);
                  },
                ),
              ],
            ),
            AppDimensions.h16,

            _buildMenuSection(
              context,
              title: 'Support',
              items: [
                _MenuItem(
                  icon: Iconsax.message_question_outline,
                  title: 'Help & FAQs',
                  subtitle: 'Get help and view FAQs',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.about);
                  },
                ),
                _MenuItem(
                  icon: Iconsax.information_outline,
                  title: 'About',
                  subtitle: 'App version and information',
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
                _MenuItem(
                  icon: Iconsax.shield_tick_outline,
                  title: 'Privacy Policy',
                  subtitle: 'View privacy policy',
                  onTap: () {
                    // TODO: Navigate to privacy policy
                    _showComingSoon(context);
                  },
                ),
              ],
            ),
            AppDimensions.h16,

            _buildMenuSection(
              context,
              title: 'Account Actions',
              items: [
                _MenuItem(
                  icon: Iconsax.logout_outline,
                  title: 'Logout',
                  subtitle: 'Sign out of your account',
                  isDestructive: true,
                  onTap: () => _handleLogout(context),
                ),
              ],
            ),
            AppDimensions.h32,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProvider userProvider) {
    final colorScheme = Theme.of(context).colorScheme;
    final userName = userProvider.userName;
    final userEmail =
        userProvider.currentUser?.email ?? 'guest@campuswhisper.com';
    final userXP = userProvider.userXP;
    final userLevel = userProvider.userLevel;

    return Container(
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest),
      child: SafeArea(
        child: Row(
          children: [
            UserAvatar(name: userName, size: AppDimensions.avatarLarge),
            AppDimensions.w16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildText(
                    text: userName,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  AppDimensions.h4,
                  BuildText(
                    text: userEmail,
                    fontSize: 14,
                    color: colorScheme.onSurface.withAlpha(153),
                  ),
                  AppDimensions.h8,
                  Row(
                    children: [
                      _buildStatChip(
                        icon: Iconsax.medal_star_bold,
                        label: '$userXP XP',
                        colorScheme: colorScheme,
                      ),
                      AppDimensions.w8,
                      _buildStatChip(
                        icon: Iconsax.crown_bold,
                        label: 'Level $userLevel',
                        colorScheme: colorScheme,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.editProfile);
              },
              icon: Icon(Iconsax.edit_outline, color: colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.space8,
        vertical: AppDimensions.space4,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary.withAlpha(26),
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.primary),
          AppDimensions.w4,
          BuildText(
            text: label,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context, {
    required String title,
    required List<_MenuItem> items,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface.withAlpha(153),
          ),
          AppDimensions.h12,
          Container(
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
                    _buildMenuItem(context, item),
                    if (!isLast) Divider(height: 1, indent: 56),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = item.isDestructive
        ? colorScheme.error
        : colorScheme.onSurface;

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radius12),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.space16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppDimensions.space8),
              decoration: BoxDecoration(
                color: item.isDestructive
                    ? colorScheme.error.withAlpha(26)
                    : colorScheme.primary.withAlpha(26),
                borderRadius: BorderRadius.circular(AppDimensions.radius8),
              ),
              child: Icon(
                item.icon,
                size: AppDimensions.mediumIconSize,
                color: item.isDestructive
                    ? colorScheme.error
                    : colorScheme.primary,
              ),
            ),
            AppDimensions.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildText(
                    text: item.title,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  if (item.subtitle != null) ...[
                    AppDimensions.h4,
                    BuildText(
                      text: item.subtitle!,
                      fontSize: 12,
                      color: color.withAlpha(153),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: colorScheme.onSurface.withAlpha(77),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    DialogHelper.showAlert(
      context,
      title: 'Coming Soon',
      message: 'This feature is under development and will be available soon!',
    );
  }

  void _showAboutDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Iconsax.information_bold, color: colorScheme.primary),
            AppDimensions.w12,
            const BuildText(
              text: 'About CampusWhisper',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BuildText(
              text: 'CampusWhisper',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            AppDimensions.h8,
            BuildText(
              text: 'Version 1.0.0',
              fontSize: 14,
              color: colorScheme.onSurface.withAlpha(153),
            ),
            AppDimensions.h16,
            const BuildText(
              text:
                  'Your campus companion for staying connected with student life, events, and academic resources.',
              fontSize: 14,
            ),
            AppDimensions.h16,
            BuildText(
              text: '© 2026 CampusWhisper. All rights reserved.',
              fontSize: 12,
              color: colorScheme.onSurface.withAlpha(153),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const BuildText(text: 'Close', fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    final confirmed = await DialogHelper.showConfirmation(
      context,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
    );

    if (confirmed) {
      if (!context.mounted) return;

      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );

        // Sign out from Firebase
        final authService = AuthService();
        await authService.signOut();

        // Clear user data from provider
        if (context.mounted) {
          final userProvider = Provider.of<UserProvider>(
            context,
            listen: false,
          );
          userProvider.clearUser();
        }

        // Close loading dialog
        if (context.mounted) {
          Navigator.pop(context);
        }

        // Navigate to login page and remove all previous routes
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        }

        // Show success message
        if (context.mounted) {
          SnackbarHelper.showSuccess(context, 'Logged out successfully');
        }
      } catch (e) {
        // Close loading dialog if still open
        if (context.mounted) {
          Navigator.pop(context);
        }

        // Show error message
        if (context.mounted) {
          SnackbarHelper.showError(
            context,
            'Failed to logout. Please try again.',
          );
        }
      }
    }
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });
}
