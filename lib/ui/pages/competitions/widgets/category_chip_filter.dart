import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';

class CategoryChipFilter extends StatefulWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const CategoryChipFilter({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<CategoryChipFilter> createState() => _CategoryChipFilterState();
}

class _CategoryChipFilterState extends State<CategoryChipFilter> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _chipKeys = {};

  @override
  void initState() {
    super.initState();
    _chipKeys['All'] = GlobalKey();
    for (var category in widget.categories) {
      _chipKeys[category] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToChip(String category) {
    final key = _chipKeys[category];
    if (key?.currentContext != null) {
      final RenderBox renderBox =
          key!.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final chipWidth = renderBox.size.width;

      final scrollViewWidth = _scrollController.position.viewportDimension;
      final currentScroll = _scrollController.offset;

      final chipLeftEdge = position.dx;
      final chipRightEdge = chipLeftEdge + chipWidth;

      double? targetScroll;

      if (chipRightEdge > scrollViewWidth) {
        targetScroll =
            currentScroll +
            (chipRightEdge - scrollViewWidth) +
            AppDimensions.space40 * 2;
      } else if (chipLeftEdge < 0) {
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
              label: 'All Categories',
              isSelected: widget.selectedCategory == null,
              onTap: () {
                widget.onCategorySelected(null);
                Future.delayed(const Duration(milliseconds: 50), () {
                  _scrollToChip('All');
                });
              },
            ),
            SizedBox(width: AppDimensions.space8),

            // Category chips
            ...widget.categories.map((category) {
              final isSelected = widget.selectedCategory == category;
              return Padding(
                padding: EdgeInsets.only(right: AppDimensions.space8),
                child: _FilterChip(
                  key: _chipKeys[category],
                  label: category,
                  isSelected: isSelected,
                  onTap: () {
                    widget.onCategorySelected(category);
                    Future.delayed(const Duration(milliseconds: 50), () {
                      _scrollToChip(category);
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
                : colorScheme.onSurface.withAlpha(77),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withAlpha(77),
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
