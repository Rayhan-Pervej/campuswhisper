import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/utils/snackbar_helper.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: DefaultAppBar(
        title: 'About',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppDimensions.h32,

            // App Logo/Icon
            Container(
              padding: EdgeInsets.all(AppDimensions.space24),
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.messages_2_bold,
                size: 80,
                color: colorScheme.primary,
              ),
            ),

            AppDimensions.h24,

            // App Name
            BuildText(
              text: 'CampusWhisper',
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),

            AppDimensions.h8,

            // Version
            BuildText(
              text: 'Version 1.0.0',
              fontSize: 14,
              color: colorScheme.onSurface.withAlpha(153),
            ),

            AppDimensions.h32,

            // Description
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.horizontalPadding,
              ),
              child: BuildText(
                text:
                    'Your campus companion for staying connected with student life, events, and academic resources. Share ideas, find lost items, join clubs, and never miss an event!',
                fontSize: 15,
                color: colorScheme.onSurface.withAlpha(180),
                height: 1.6,
                textAlign: TextAlign.center,
              ),
            ),

            AppDimensions.h32,

            // Features Section
            _buildSection(
              context,
              colorScheme,
              title: 'Features',
              items: [
                _FeatureItem(
                  icon: Iconsax.message_text_outline,
                  title: 'Discussions',
                  description: 'Engage in campus-wide conversations',
                ),
                _FeatureItem(
                  icon: Iconsax.calendar_outline,
                  title: 'Events',
                  description: 'Discover and join campus events',
                ),
                _FeatureItem(
                  icon: Iconsax.box_outline,
                  title: 'Lost & Found',
                  description: 'Find your lost items or help others',
                ),
                _FeatureItem(
                  icon: Iconsax.people_outline,
                  title: 'Clubs',
                  description: 'Join clubs and communities',
                ),
                _FeatureItem(
                  icon: Iconsax.cup_outline,
                  title: 'Competitions',
                  description: 'Participate in contests and hackathons',
                ),
                _FeatureItem(
                  icon: Iconsax.book_outline,
                  title: 'Study Hub',
                  description: 'Academic tools and resources',
                ),
              ],
            ),

            AppDimensions.h24,

            // Links Section
            _buildSection(
              context,
              colorScheme,
              title: 'More Information',
              items: [
                _buildLinkTile(
                  colorScheme,
                  icon: Iconsax.document_text_outline,
                  title: 'Terms of Service',
                  onTap: () => _openLink(context, 'Terms of Service'),
                ),
                _buildLinkTile(
                  colorScheme,
                  icon: Iconsax.shield_tick_outline,
                  title: 'Privacy Policy',
                  onTap: () => _openLink(context, 'Privacy Policy'),
                ),
                _buildLinkTile(
                  colorScheme,
                  icon: Iconsax.message_question_outline,
                  title: 'Help & FAQ',
                  onTap: () => _openLink(context, 'Help & FAQ'),
                ),
                _buildLinkTile(
                  colorScheme,
                  icon: Iconsax.code_outline,
                  title: 'Licenses',
                  onTap: () => _showLicenses(context),
                ),
              ],
            ),

            AppDimensions.h24,

            // Contact Section
            _buildSection(
              context,
              colorScheme,
              title: 'Contact Us',
              items: [
                _buildLinkTile(
                  colorScheme,
                  icon: Iconsax.sms_outline,
                  title: 'support@campuswhisper.com',
                  onTap: () => _openLink(context, 'Email'),
                ),
                _buildLinkTile(
                  colorScheme,
                  icon: Iconsax.global_outline,
                  title: 'www.campuswhisper.com',
                  onTap: () => _openLink(context, 'Website'),
                ),
              ],
            ),

            AppDimensions.h32,

            // Footer
            BuildText(
              text: '© 2026 CampusWhisper. All rights reserved.',
              fontSize: 12,
              color: colorScheme.onSurface.withAlpha(102),
            ),

            AppDimensions.h8,

            BuildText(
              text: 'Made with ❤️ for students',
              fontSize: 12,
              color: colorScheme.onSurface.withAlpha(102),
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
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

  Widget _buildLinkTile(
    ColorScheme colorScheme, {
    required IconData icon,
    required String title,
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
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: colorScheme.onSurface.withAlpha(102),
      ),
    );
  }

  void _openLink(BuildContext context, String type) {
    // TODO: Open actual links
    SnackbarHelper.showInfo(context, '$type link coming soon');
  }

  void _showLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'CampusWhisper',
      applicationVersion: '1.0.0',
      applicationIcon: Padding(
        padding: EdgeInsets.all(AppDimensions.space16),
        child: Icon(
          Iconsax.messages_2_bold,
          size: 48,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(AppDimensions.space16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppDimensions.space12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(AppDimensions.radius8),
            ),
            child: Icon(
              icon,
              size: 24,
              color: colorScheme.primary,
            ),
          ),
          AppDimensions.w16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildText(
                  text: title,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                AppDimensions.h4,
                BuildText(
                  text: description,
                  fontSize: 13,
                  color: colorScheme.onSurface.withAlpha(153),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
