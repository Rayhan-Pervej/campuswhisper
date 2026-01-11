import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';
import 'package:campuswhisper/ui/widgets/user_avatar.dart';
import 'package:campuswhisper/ui/widgets/empty_state.dart';

class CompetitionParticipantsPage extends StatelessWidget {
  final String competitionTitle;
  final List<Map<String, dynamic>> participants;

  const CompetitionParticipantsPage({
    super.key,
    required this.competitionTitle,
    required this.participants,
  });

  // Sample data for demonstration
  List<Map<String, dynamic>> get _sampleParticipants => [
        {
          'name': 'Alex Johnson',
          'avatar': null,
          'department': 'Computer Science',
          'year': '3rd Year',
          'teamName': 'Code Warriors',
        },
        {
          'name': 'Sarah Williams',
          'avatar': null,
          'department': 'Information Technology',
          'year': '4th Year',
          'teamName': 'Tech Titans',
        },
        {
          'name': 'Michael Chen',
          'avatar': null,
          'department': 'Computer Engineering',
          'year': '2nd Year',
          'teamName': null,
        },
        {
          'name': 'Emma Davis',
          'avatar': null,
          'department': 'Software Engineering',
          'year': '3rd Year',
          'teamName': 'Innovators',
        },
        {
          'name': 'David Lee',
          'avatar': null,
          'department': 'Computer Science',
          'year': '4th Year',
          'teamName': 'Debug Squad',
        },
        {
          'name': 'Priya Patel',
          'avatar': null,
          'department': 'Information Technology',
          'year': '3rd Year',
          'teamName': 'Code Masters',
        },
        {
          'name': 'James Wilson',
          'avatar': null,
          'department': 'Computer Engineering',
          'year': '2nd Year',
          'teamName': null,
        },
        {
          'name': 'Olivia Brown',
          'avatar': null,
          'department': 'Computer Science',
          'year': '4th Year',
          'teamName': 'Binary Beasts',
        },
      ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayParticipants =
        participants.isEmpty ? _sampleParticipants : participants;

    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Participants (${displayParticipants.length})',
      ),
      body: displayParticipants.isEmpty
          ? EmptyState(
              icon: Iconsax.profile_2user_outline,
              message: 'No Participants Yet',
              subtitle: 'Be the first to register for this competition!',
            )
          : Column(
              children: [
                // Stats header
                Container(
                  margin: EdgeInsets.all(AppDimensions.horizontalPadding),
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
                    border: Border.all(
                      color: colorScheme.primary.withAlpha(51),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                        icon: Iconsax.profile_2user_outline,
                        label: 'Total',
                        value: displayParticipants.length.toString(),
                        color: colorScheme.primary,
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: colorScheme.onSurface.withAlpha(51),
                      ),
                      _StatItem(
                        icon: Iconsax.people_outline,
                        label: 'Teams',
                        value: displayParticipants
                            .where((p) => p['teamName'] != null)
                            .map((p) => p['teamName'])
                            .toSet()
                            .length
                            .toString(),
                        color: colorScheme.secondary,
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: colorScheme.onSurface.withAlpha(51),
                      ),
                      _StatItem(
                        icon: Iconsax.user_outline,
                        label: 'Solo',
                        value: displayParticipants
                            .where((p) => p['teamName'] == null)
                            .length
                            .toString(),
                        color: colorScheme.primary,
                      ),
                    ],
                  ),
                ),

                // Participants list
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.horizontalPadding,
                      vertical: AppDimensions.space8,
                    ),
                    itemCount: displayParticipants.length,
                    separatorBuilder: (context, index) => Divider(
                      color: colorScheme.onSurface.withAlpha(26),
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final participant = displayParticipants[index];
                      return _ParticipantCard(
                        participant: participant,
                        colorScheme: colorScheme,
                      );
                    },
                  ),
                ),
              ],
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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            AppDimensions.w4,
            BuildText(
              text: value,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ],
        ),
        AppDimensions.h4,
        BuildText(
          text: label,
          fontSize: 12,
          color: colorScheme.onSurface.withAlpha(179),
        ),
      ],
    );
  }
}

class _ParticipantCard extends StatelessWidget {
  final Map<String, dynamic> participant;
  final ColorScheme colorScheme;

  const _ParticipantCard({
    required this.participant,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        vertical: AppDimensions.space8,
        horizontal: AppDimensions.space4,
      ),
      leading: UserAvatar(
        imageUrl: participant['avatar'],
        name: participant['name'] ?? 'User',
        size: 50,
      ),
      title: BuildText(
        text: participant['name'] ?? 'Unknown User',
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (participant['department'] != null) ...[
            AppDimensions.h4,
            Row(
              children: [
                Icon(
                  Iconsax.book_outline,
                  size: 14,
                  color: colorScheme.onSurface.withAlpha(153),
                ),
                AppDimensions.w4,
                BuildText(
                  text:
                      '${participant['department']} - ${participant['year'] ?? 'N/A'}',
                  fontSize: 13,
                  color: colorScheme.onSurface.withAlpha(153),
                ),
              ],
            ),
          ],
          if (participant['teamName'] != null) ...[
            AppDimensions.h4,
            Row(
              children: [
                Icon(
                  Iconsax.people_outline,
                  size: 14,
                  color: colorScheme.primary,
                ),
                AppDimensions.w4,
                BuildText(
                  text: 'Team: ${participant['teamName']}',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ],
        ],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: colorScheme.onSurface.withAlpha(102),
      ),
      onTap: () {
        // Navigate to user profile (later)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile for ${participant['name']}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}
