import 'package:campuswhisper/ui/widgets/app_dimensions.dart';
import 'package:campuswhisper/ui/widgets/card_button.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: CardButton(
                        icon: Iconsax.calendar_add_outline,
                        title: 'Course Routine',
                        onTap: () {
                          Navigator.pushNamed(context, '/course_routine');
                        },
                      ),
                    ),
                    AppDimensions.w16,
                    Expanded(
                      child: CardButton(
                        icon: Iconsax.routing_outline,
                        title: 'Course Roadmap',
                        onTap: () {
                          Navigator.pushNamed(context, '/course_plan');
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
