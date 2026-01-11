import 'package:flutter/material.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';
import 'package:campuswhisper/ui/widgets/user_avatar.dart';
import 'package:campuswhisper/ui/widgets/empty_state.dart';

class EventAttendeesPage extends StatelessWidget {
  final String eventTitle;
  final List<Map<String, dynamic>> attendees;

  const EventAttendeesPage({
    super.key,
    required this.eventTitle,
    required this.attendees,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Attendees (${attendees.length})',
      ),
      body: attendees.isEmpty
          ? EmptyState(
              icon: Icons.people_outline,
              message: 'No Attendees Yet',
              subtitle: 'Be the first to register for this event!',
            )
          : ListView.separated(
              padding: EdgeInsets.all(AppDimensions.horizontalPadding),
              itemCount: attendees.length,
              separatorBuilder: (context, index) => Divider(
                color: colorScheme.onSurface.withAlpha(26),
                height: 1,
              ),
              itemBuilder: (context, index) {
                final user = attendees[index];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: AppDimensions.space8,
                    horizontal: AppDimensions.space4,
                  ),
                  leading: UserAvatar(
                    imageUrl: user['avatar'],
                    name: user['name'] ?? 'User',
                    size: 50,
                  ),
                  title: BuildText(
                    text: user['name'] ?? 'Unknown User',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  subtitle: user['department'] != null
                      ? Padding(
                          padding: EdgeInsets.only(top: AppDimensions.space4),
                          child: BuildText(
                            text: user['department'],
                            fontSize: 13,
                            color: colorScheme.onSurface.withAlpha(153),
                          ),
                        )
                      : null,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colorScheme.onSurface.withAlpha(102),
                  ),
                  onTap: () {
                    // Navigate to user profile (later)
                    // For now, just show a message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Profile for ${user['name']}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
