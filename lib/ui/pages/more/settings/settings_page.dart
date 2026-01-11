import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/utils/snackbar_helper.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _eventReminders = true;
  bool _messageNotifications = true;
  bool _postUpdates = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Settings',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppDimensions.h16,

            // Appearance Section - Hidden: App follows system theme

            // Notifications Section
            _buildSection(
              context,
              colorScheme,
              title: 'Notifications',
              items: [
                _buildSwitchTile(
                  colorScheme,
                  icon: Iconsax.notification_outline,
                  title: 'Push Notifications',
                  subtitle: 'Receive push notifications',
                  value: _pushNotifications,
                  onChanged: (value) {
                    setState(() => _pushNotifications = value);
                  },
                ),
                _buildSwitchTile(
                  colorScheme,
                  icon: Iconsax.sms_notification_outline,
                  title: 'Email Notifications',
                  subtitle: 'Receive notifications via email',
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() => _emailNotifications = value);
                  },
                ),
                _buildSwitchTile(
                  colorScheme,
                  icon: Iconsax.calendar_tick_outline,
                  title: 'Event Reminders',
                  subtitle: 'Get reminders for upcoming events',
                  value: _eventReminders,
                  onChanged: (value) {
                    setState(() => _eventReminders = value);
                  },
                ),
                _buildSwitchTile(
                  colorScheme,
                  icon: Iconsax.message_outline,
                  title: 'Message Notifications',
                  subtitle: 'Get notified of new messages',
                  value: _messageNotifications,
                  onChanged: (value) {
                    setState(() => _messageNotifications = value);
                  },
                ),
                _buildSwitchTile(
                  colorScheme,
                  icon: Iconsax.document_text_outline,
                  title: 'Post Updates',
                  subtitle: 'Updates on posts you follow',
                  value: _postUpdates,
                  onChanged: (value) {
                    setState(() => _postUpdates = value);
                  },
                ),
              ],
            ),

            AppDimensions.h16,

            // Privacy Section
            _buildSection(
              context,
              colorScheme,
              title: 'Privacy & Security',
              items: [
                _buildTile(
                  colorScheme,
                  icon: Iconsax.lock_outline,
                  title: 'Change Password',
                  subtitle: 'Update your password',
                  onTap: () {
                    // TODO: Navigate to change password
                    SnackbarHelper.showInfo(context, 'Coming soon');
                  },
                ),
                _buildTile(
                  colorScheme,
                  icon: Iconsax.eye_outline,
                  title: 'Privacy Settings',
                  subtitle: 'Manage who can see your activity',
                  onTap: () {
                    // TODO: Navigate to privacy settings
                    SnackbarHelper.showInfo(context, 'Coming soon');
                  },
                ),
                _buildTile(
                  colorScheme,
                  icon: Iconsax.shield_tick_outline,
                  title: 'Blocked Users',
                  subtitle: 'Manage blocked users',
                  onTap: () {
                    // TODO: Navigate to blocked users
                    SnackbarHelper.showInfo(context, 'Coming soon');
                  },
                ),
              ],
            ),

            AppDimensions.h16,

            // Data Section
            _buildSection(
              context,
              colorScheme,
              title: 'Data & Storage',
              items: [
                _buildTile(
                  colorScheme,
                  icon: Iconsax.data_outline,
                  title: 'Data Usage',
                  subtitle: 'View app data usage',
                  onTap: () {
                    // TODO: Show data usage
                    SnackbarHelper.showInfo(context, 'Coming soon');
                  },
                ),
                _buildTile(
                  colorScheme,
                  icon: Iconsax.trash_outline,
                  title: 'Clear Cache',
                  subtitle: 'Free up storage space',
                  onTap: () => _clearCache(),
                ),
              ],
            ),

            AppDimensions.h16,

            // Support Section
            _buildSection(
              context,
              colorScheme,
              title: 'Support',
              items: [
                _buildTile(
                  colorScheme,
                  icon: Iconsax.message_question_outline,
                  title: 'Help Center',
                  subtitle: 'Get help and support',
                  onTap: () {
                    // TODO: Navigate to help center
                    SnackbarHelper.showInfo(context, 'Coming soon');
                  },
                ),
                _buildTile(
                  colorScheme,
                  icon: Iconsax.message_favorite_outline,
                  title: 'Send Feedback',
                  subtitle: 'Share your thoughts',
                  onTap: () {
                    // TODO: Navigate to feedback
                    SnackbarHelper.showInfo(context, 'Coming soon');
                  },
                ),
              ],
            ),

            AppDimensions.h32,
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    ColorScheme colorScheme, {
    required String title,
    required List<Widget> items,
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
            border: Border.all(
              color: colorScheme.onSurface.withAlpha(26),
            ),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;

              return Column(
                children: [
                  item,
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

  Widget _buildTile(
    ColorScheme colorScheme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: EdgeInsets.all(AppDimensions.space8),
        decoration: BoxDecoration(
          color: colorScheme.primary.withAlpha(26),
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: colorScheme.primary,
        ),
      ),
      title: BuildText(
        text: title,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      subtitle: BuildText(
        text: subtitle,
        fontSize: 12,
        color: colorScheme.onSurface.withAlpha(153),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: colorScheme.onSurface.withAlpha(102),
      ),
    );
  }

  Widget _buildSwitchTile(
    ColorScheme colorScheme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(AppDimensions.space8),
        decoration: BoxDecoration(
          color: colorScheme.primary.withAlpha(26),
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: colorScheme.primary,
        ),
      ),
      title: BuildText(
        text: title,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      subtitle: BuildText(
        text: subtitle,
        fontSize: 12,
        color: colorScheme.onSurface.withAlpha(153),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: colorScheme.primary,
      ),
    );
  }

  void _clearCache() async {
    // TODO: Implement cache clearing
    SnackbarHelper.showSuccess(context, 'Cache cleared successfully!');
  }
}
