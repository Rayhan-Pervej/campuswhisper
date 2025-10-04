import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../core/constants/build_text.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final List<Widget>? actions;

  final Color? backgroundColor;
  final Color? textColor;
  final double elevation;
  final Widget? leading;
  final Widget? titleWidget;
  final bool centerTitle;
  final bool scrollElevation;

  const DefaultAppBar({
    super.key,
    this.title = '',

    this.actions,

    this.backgroundColor,
    this.textColor,
    this.elevation = 0,
    this.leading,
    this.titleWidget,
    this.centerTitle = false,

    this.scrollElevation = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          titleSpacing: 0,
          backgroundColor: colorScheme.primaryContainer ,
          title:
              titleWidget ??
              BuildText(text: title, fontSize: 16, fontWeight: FontWeight.bold),
          centerTitle: centerTitle,
          elevation: elevation,
          scrolledUnderElevation: scrollElevation ? 2 : 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Iconsax.arrow_left_2_outline),
          ),
          actions: [...?actions],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
