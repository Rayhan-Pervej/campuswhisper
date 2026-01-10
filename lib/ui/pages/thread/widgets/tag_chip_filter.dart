import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';

class TagChipFilter extends StatefulWidget {
  final List<String> tags;
  final String? selectedTag;
  final Function(String?) onTagSelected;

  const TagChipFilter({
    super.key,
    required this.tags,
    this.selectedTag,
    required this.onTagSelected,
  });

  @override
  State<TagChipFilter> createState() => _TagChipFilterState();
}

class _TagChipFilterState extends State<TagChipFilter> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _chipKeys = {};

  @override
  void initState() {
    super.initState();
    // Create keys for each tag including "All"
    _chipKeys['All'] = GlobalKey();
    for (var tag in widget.tags) {
      _chipKeys[tag] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToChip(String tag) {
    final key = _chipKeys[tag];
    if (key?.currentContext != null) {
      final RenderBox renderBox =
          key!.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final chipWidth = renderBox.size.width;

      // Get the scroll view's width
      final scrollViewWidth = _scrollController.position.viewportDimension;
      final currentScroll = _scrollController.offset;

      // Calculate chip edges relative to viewport
      final chipLeftEdge = position.dx;
      final chipRightEdge = chipLeftEdge + chipWidth;

      // Calculate target scroll position with more aggressive scrolling
      double? targetScroll;

      if (chipRightEdge > scrollViewWidth) {
        // Chip is cut off on the right, scroll right more aggressively
        targetScroll =
            currentScroll +
            (chipRightEdge - scrollViewWidth) +
            AppDimensions.space40 * 2;
      } else if (chipLeftEdge < 0) {
        // Chip is cut off on the left, scroll left more aggressively
        targetScroll = currentScroll + chipLeftEdge - AppDimensions.space40 * 2;
      }

      if (targetScroll != null) {
        _scrollController.animateTo(
          targetScroll.clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: AppDimensions.space12),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: AppDimensions.horizontalPadding),

            // "All" chip
            _FilterChip(
              key: _chipKeys['All'],
              label: 'All',
              isSelected: widget.selectedTag == null,
              onTap: () {
                widget.onTagSelected(null);
                Future.delayed(const Duration(milliseconds: 50), () {
                  _scrollToChip('All');
                });
              },
            ),
            SizedBox(width: AppDimensions.space8),

            // Tag chips
            ...widget.tags.map((tag) {
              final isSelected = widget.selectedTag == tag;
              return Padding(
                padding: EdgeInsets.only(right: AppDimensions.space8),
                child: _FilterChip(
                  key: _chipKeys[tag],
                  label: tag,
                  isSelected: isSelected,
                  onTap: () {
                    widget.onTagSelected(tag);
                    Future.delayed(const Duration(milliseconds: 50), () {
                      _scrollToChip(tag);
                    });
                  },
                ),
              );
            }),

            SizedBox(width: AppDimensions.horizontalPadding),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurface.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppDimensions.bodyFontSize,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
