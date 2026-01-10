import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../../core/theme/app_dimensions.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onClose;
  final List<String> categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const SearchBarWidget({
    super.key,
    required this.onSearchChanged,
    required this.onClose,
    required this.categories,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    // Auto-focus the search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleClose() {
    _animationController.reverse().then((_) {
      widget.onClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        color: colorScheme.surface,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.horizontalPadding,
          vertical: AppDimensions.space12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search input field
            Container(
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppDimensions.radius12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.space16,
                    ),
                    child: Icon(
                      Iconsax.search_normal_outline,
                      size: AppDimensions.mediumIconSize,
                      color: colorScheme.primary,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      style: TextStyle(
                        fontSize: AppDimensions.bodyFontSize,
                        color: colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search items by name, description...',
                        hintStyle: TextStyle(
                          fontSize: AppDimensions.bodyFontSize,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: AppDimensions.space16,
                        ),
                      ),
                      onChanged: widget.onSearchChanged,
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        _searchController.clear();
                        widget.onSearchChanged('');
                      },
                      icon: Icon(
                        Icons.clear,
                        size: AppDimensions.mediumIconSize,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  IconButton(
                    onPressed: _handleClose,
                    icon: Icon(
                      Icons.close,
                      size: AppDimensions.mediumIconSize,
                      color: colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
            AppDimensions.h12,

            // Category filter chips
            SizedBox(
              height: AppDimensions.space40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _CategoryChip(
                    label: 'All',
                    isSelected: widget.selectedCategory == null,
                    onTap: () => widget.onCategorySelected(null),
                  ),
                  ...widget.categories.map((category) {
                    return _CategoryChip(
                      label: category,
                      isSelected: widget.selectedCategory == category,
                      onTap: () => widget.onCategorySelected(category),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(right: AppDimensions.space8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.space16,
            vertical: AppDimensions.space8,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.secondary
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radius16),
            border: Border.all(
              color: isSelected
                  ? colorScheme.secondary
                  : colorScheme.onSurface.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppDimensions.captionFontSize,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? colorScheme.onSecondary
                    : colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
