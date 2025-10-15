import 'package:campuswhisper/ui/widgets/app_dimensions.dart';
import 'package:campuswhisper/ui/widgets/card_button.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class StudyPage extends StatelessWidget {
  const StudyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              AppDimensions.h16,
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CardButton(
                        icon: Iconsax.calendar_add_outline,
                        title: 'Routine',
                        onTap: () {
                          Navigator.pushNamed(context, '/course_routine');
                        },
                      ),
                    ),
                    AppDimensions.w16,
                    Expanded(
                      child: CardButton(
                        icon: Iconsax.routing_outline,
                        title: 'Roadmap',
                        onTap: () {
                          Navigator.pushNamed(context, '/course_plan');
                        },
                      ),
                    ),
                  ],
                ),
              ),

              AppDimensions.h16,

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CardButton(
                        icon: Iconsax.computing_outline,
                        title: 'Calculator',
                        onTap: () {
                          Navigator.pushNamed(context, '/cgpa_calculator');
                        },
                      ),
                    ),
                    AppDimensions.w16,
                    Expanded(
                      child: CardButton(
                        icon: Icons.volunteer_activism_outlined,
                        title: 'Scholarship',
                        onTap: () {
                          Navigator.pushNamed(context, '/scholarship');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
