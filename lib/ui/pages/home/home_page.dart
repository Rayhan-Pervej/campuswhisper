import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/theme/theme_provider.dart';
import 'package:campuswhisper/ui/widgets/user_avatar.dart';
import 'package:campuswhisper/ui/pages/home/widgets/announcement_card.dart';
import 'package:campuswhisper/ui/pages/home/widgets/quick_access_grid.dart';
import 'package:campuswhisper/providers/user_provider.dart';
import 'package:campuswhisper/providers/post_provider.dart';
import 'package:campuswhisper/providers/event_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // Load initial data from providers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      final eventProvider = Provider.of<EventProvider>(context, listen: false);

      // Load data if not already loaded
      if (postProvider.items.isEmpty && !postProvider.isLoading) {
        postProvider.loadInitial();
      }
      if (eventProvider.items.isEmpty && !eventProvider.isLoading) {
        eventProvider.loadInitial();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final postProvider = Provider.of<PostProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(context, colorScheme, themeProvider, userProvider),
            AppDimensions.h24,

            // Quick Stats Cards
            _buildQuickStats(
              context,
              colorScheme,
              userProvider,
              postProvider,
              eventProvider,
            ),
            AppDimensions.h24,

            // Quick Actions
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.horizontalPadding,
              ),
              child: BuildText(
                text: 'Quick Actions',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppDimensions.h16,
            _buildQuickActions(context, colorScheme),
            AppDimensions.h24,

            // Announcements
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.horizontalPadding,
              ),
              child: BuildText(
                text: 'Announcements',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppDimensions.h16,
            _buildAnnouncements(context, colorScheme),
            AppDimensions.h24,
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeProvider themeProvider,
    UserProvider userProvider,
  ) {
    final userName = userProvider.userName;

    return Container(
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.primary.withAlpha(204)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildText(
                        text: 'Welcome Back!',
                        fontSize: 14,
                        color: Colors.white.withAlpha(204),
                      ),
                      AppDimensions.h4,
                      BuildText(
                        text: userName,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      themeProvider.isDarkMode
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      color: Colors.white,
                    ),
                    onPressed: themeProvider.toggleTheme,
                  ),
                  AppDimensions.w8,
                  UserAvatar(name: userName, size: AppDimensions.avatarMedium),
                ],
              ),
            ],
          ),
          AppDimensions.h16,
          // Search Bar
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: AppDimensions.space12,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(26),
              borderRadius: BorderRadius.circular(AppDimensions.radius12),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.search_normal_outline,
                  color: Colors.white.withAlpha(204),
                  size: 20,
                ),
                AppDimensions.w12,
                BuildText(
                  text: 'Search events, posts, clubs...',
                  fontSize: 14,
                  color: Colors.white.withAlpha(204),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(
    BuildContext context,
    ColorScheme colorScheme,
    UserProvider userProvider,
    PostProvider postProvider,
    EventProvider eventProvider,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding,
      ),
      child: Row(
        children: [
          _buildStatCard(
            icon: Iconsax.medal_star_bold,
            label: 'XP Points',
            value: '${userProvider.userXP}',
            color: Colors.amber,
            colorScheme: colorScheme,
          ),
          AppDimensions.w12,
          _buildStatCard(
            icon: Iconsax.crown_bold,
            label: 'Level',
            value: '${userProvider.userLevel}',
            color: Colors.purple,
            colorScheme: colorScheme,
          ),
          AppDimensions.w12,
          _buildStatCard(
            icon: Iconsax.message_bold,
            label: 'Posts',
            value: '${postProvider.items.length}',
            color: Colors.blue,
            colorScheme: colorScheme,
          ),
          AppDimensions.w12,
          _buildStatCard(
            icon: Iconsax.calendar_bold,
            label: 'Events',
            value: '${eventProvider.items.length}',
            color: Colors.green,
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required ColorScheme colorScheme,
  }) {
    return Container(
      width: 120,
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        border: Border.all(color: colorScheme.onSurface.withAlpha(26)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(AppDimensions.space8),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          AppDimensions.h12,
          BuildText(text: value, fontSize: 20, fontWeight: FontWeight.bold),
          AppDimensions.h4,
          BuildText(
            text: label,
            fontSize: 12,
            color: colorScheme.onSurface.withAlpha(153),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, ColorScheme colorScheme) {
    return QuickAccessGrid(
      items: [
        QuickAccessItem(
          icon: Iconsax.calendar_outline,
          label: 'Events',
          color: Colors.blue,
          onTap: () {
            Navigator.pushNamed(context, '/events_page');
          },
        ),
        QuickAccessItem(
          icon: Iconsax.people_outline,
          label: 'Clubs',
          color: Colors.purple,
          onTap: () {
            Navigator.pushNamed(context, '/clubs_page');
          },
        ),
        QuickAccessItem(
          icon: Iconsax.book_outline,
          label: 'Study',
          color: Colors.green,
          onTap: () {
            Navigator.pushNamed(context, '/course_routine');
          },
        ),
        QuickAccessItem(
          icon: Iconsax.location_outline,
          label: 'Lost',
          color: Colors.orange,
          onTap: () {
            Navigator.pushNamed(context, '/lost_and_found_page');
          },
        ),
      ],
    );
  }

  Widget _buildAnnouncements(BuildContext context, ColorScheme colorScheme) {
    final eventProvider = Provider.of<EventProvider>(context);

    // Get upcoming events (max 3) as announcements
    final upcomingEvents = eventProvider.items
        .where((event) => event.isUpcoming && event.isActive)
        .take(3)
        .toList();

    if (upcomingEvents.isEmpty && !eventProvider.isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.horizontalPadding,
        ),
        child: Container(
          padding: EdgeInsets.all(AppDimensions.space16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radius12),
            border: Border.all(color: colorScheme.onSurface.withAlpha(26)),
          ),
          child: Column(
            children: [
              Icon(
                Iconsax.calendar_outline,
                size: 48,
                color: colorScheme.onSurface.withAlpha(77),
              ),
              AppDimensions.h12,
              BuildText(
                text: 'No Upcoming Events',
                fontSize: 14,
                color: colorScheme.onSurface.withAlpha(153),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (eventProvider.isLoading && upcomingEvents.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.horizontalPadding,
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding,
      ),
      child: Column(
        children: upcomingEvents.map((event) {
          // Calculate time until event
          final timeUntil = event.eventDate.difference(DateTime.now());
          String timeText;
          if (timeUntil.inDays > 0) {
            timeText =
                'in ${timeUntil.inDays} ${timeUntil.inDays == 1 ? 'day' : 'days'}';
          } else if (timeUntil.inHours > 0) {
            timeText =
                'in ${timeUntil.inHours} ${timeUntil.inHours == 1 ? 'hour' : 'hours'}';
          } else {
            timeText = 'soon';
          }

          // Get category color
          Color categoryColor = Colors.blue;
          IconData categoryIcon = Iconsax.calendar_bold;
          switch (event.category.toLowerCase()) {
            case 'academic':
              categoryColor = Colors.blue;
              categoryIcon = Iconsax.book_bold;
              break;
            case 'cultural':
              categoryColor = Colors.purple;
              categoryIcon = Iconsax.music_outline;
              break;
            case 'sports':
              categoryColor = Colors.green;
              categoryIcon = Iconsax.cup_bold;
              break;
            case 'technical':
              categoryColor = Colors.orange;
              categoryIcon = Iconsax.code_bold;
              break;
            case 'social':
              categoryColor = Colors.pink;
              categoryIcon = Iconsax.people_bold;
              break;
          }

          return AnnouncementCard(
            title: event.title,
            description: event.description,
            time: timeText,
            icon: categoryIcon,
            color: categoryColor,
            onTap: () {
              Navigator.pushNamed(context, '/event_detail', arguments: event);
            },
          );
        }).toList(),
      ),
    );
  }
}
