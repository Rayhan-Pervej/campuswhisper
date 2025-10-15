import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/ui/widgets/app_dimensions.dart';
import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final Color? shadowColor;
  final double? iconSize;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool enabled;
  final Widget? customIcon;
  final String? subtitle;

  const CardButton({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,

    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.shadowColor,
    this.iconSize,
    this.fontSize,
    this.fontWeight,
    this.enabled = true,
    this.customIcon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    final color = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppDimensions.space16),
        decoration: BoxDecoration(
          color: color.primary,
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          boxShadow: [
            BoxShadow(
              color: color.primary.withValues(alpha: 20),
              blurRadius: AppDimensions.radius4,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(icon, color: color.onPrimary, size: AppDimensions.size32),
            AppDimensions.h8,
            BuildText(
              text: title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color.onPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
