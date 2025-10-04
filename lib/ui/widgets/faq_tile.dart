import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:flutter/material.dart';

class FaqTile extends StatelessWidget {
  final String question;
  final String answer;
  final bool isExpanded;
  final VoidCallback onTap;

  const FaqTile({
    super.key,
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: isExpanded
                    ? Radius.circular(0)
                    : Radius.circular(8),
                bottomRight: isExpanded
                    ? Radius.circular(0)
                    : Radius.circular(8),
              ),
              border: Border.all(
                color: colorScheme.onSurface.withAlpha(60),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: BuildText(
                    text: question,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isExpanded
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: isExpanded
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded && answer.isNotEmpty)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.onSurface.withAlpha(60),
                  width: 1.5,
                ),
                left: BorderSide(
                  color: colorScheme.onSurface.withAlpha(60),
                  width: 1.5,
                ),
                right: BorderSide(
                  color: colorScheme.onSurface.withAlpha(60),
                  width: 1.5,
                ),
              ),

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: BuildText(
              text: answer,
              fontSize: 14,
              color: colorScheme.onSurface,
            ),
          ),
      ],
    );
  }
}
