import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/ui/widgets/app_dimensions.dart';
import 'package:campuswhisper/ui/widgets/card_button.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class CgpaPage extends StatelessWidget {
  const CgpaPage({super.key});

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
          child: Column(
            children: [
              SafeArea(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppDimensions.space16),
                  decoration: BoxDecoration(
                    color: color.secondaryContainer,
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                    boxShadow: [
                      BoxShadow(
                        color: color.secondaryContainer.withValues(alpha: 100),
                        blurRadius: AppDimensions.radius4,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildText(
                        text: 'Hi, Rayhan',
                        fontSize: AppDimensions.titleFontSize,
                        color: color.onSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                      BuildText(
                        text: 'Your CGPA is 3.75 till autmn 2023',
                        fontSize: AppDimensions.bodyFontSize,
                        color: color.onSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ),
              AppDimensions.h16,
              Row(
                children: [
                  Expanded(
                    child: CardButton(
                      icon: Iconsax.computing_outline,
                      title: 'CGPA Calculator',
                      onTap: () {
                        Navigator.pushNamed(context, '/cgpa_calculator');
                      },
                    ),
                  ),
                  AppDimensions.w16,
                  Expanded(
                    child: CardButton(
                      icon: Icons.volunteer_activism_outlined,
                      title: 'Check Scholarship',
                      onTap: () {
                        Navigator.pushNamed(context, '/scholarship');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
