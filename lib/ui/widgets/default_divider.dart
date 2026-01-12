import 'package:flutter/material.dart';

class DefaultDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final Color? color;

  const DefaultDivider({
    super.key,
    this.height,
    this.thickness,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Divider(
      height: height ?? 1,
      thickness: thickness ?? 1,
      color: color ?? colorScheme.onSurface.withAlpha(26),
    );
  }
}
