import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../widgets/card_button.dart';

class CampusPage extends StatelessWidget {
  const CampusPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: color.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding,
          ),
          child: SafeArea(
            child: Column(
              children: [
                AppDimensions.h16,
                Row(
                  children: [
                    Expanded(
                      child: CardButton(
                        icon: Iconsax.calendar_1_outline,
                        title: 'Events',
                        onTap: () {
                          Navigator.pushNamed(context, '/events_page');
                        },
                      ),
                    ),
                    AppDimensions.w16,
                    Expanded(
                      child: CardButton(
                        icon: Iconsax.box_search_outline,
                        title: 'Lost & Found',
                        onTap: () {
                          Navigator.pushNamed(context, '/lost_and_found_page');
                        },
                      ),
                    ),
                  ],
                ),
                AppDimensions.h16,
                Row(
                  children: [
                    Expanded(
                      child: CardButton(
                        icon: Iconsax.people_outline,
                        title: 'Clubs',
                        onTap: () {
                          Navigator.pushNamed(context, '/clubs_page');
                        },
                      ),
                    ),
                    AppDimensions.w16,
                    Expanded(
                      child: CardButton(
                        icon: Iconsax.cup_outline,
                        title: 'Competitions',
                        onTap: () {
                          Navigator.pushNamed(context, '/competitions_page');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
