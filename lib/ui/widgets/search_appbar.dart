import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../core/theme/app_dimensions.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool isSearching;
  final VoidCallback onSearchToggle;
  final Function(String) onSearchChanged;
  final String searchQuery;
  final List<Widget>? actions;

  const SearchAppBar({
    super.key,
    required this.title,
    required this.isSearching,
    required this.onSearchToggle,
    required this.onSearchChanged,
    required this.searchQuery,
    this.actions,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

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
  }

  @override
  void didUpdateWidget(SearchAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSearching && !oldWidget.isSearching) {
      _animationController.forward();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    } else if (!widget.isSearching && oldWidget.isSearching) {
      _animationController.reverse();
      _searchController.clear();
    }

    // Keep controller in sync
    if (_searchController.text != widget.searchQuery) {
      _searchController.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      titleSpacing: 0,
      backgroundColor: colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: widget.isSearching
          ? IconButton(
              onPressed: widget.onSearchToggle,
              icon: Icon(
                Iconsax.arrow_left_2_outline,
                color: colorScheme.onSurface,
              ),
            )
          : IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Iconsax.arrow_left_2_outline,
                color: colorScheme.onSurface,
              ),
            ),
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.2, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: widget.isSearching
            ? _buildSearchField(colorScheme)
            : _buildTitle(colorScheme),
      ),
      actions: widget.isSearching
          ? null
          : [
              IconButton(
                onPressed: widget.onSearchToggle,
                icon: Icon(
                  Iconsax.search_normal_outline,
                  color: colorScheme.onSurface,
                ),
              ),
              ...?widget.actions,
            ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
    );
  }

  Widget _buildTitle(ColorScheme colorScheme) {
    return Text(
      widget.title,
      key: const ValueKey('title'),
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
    );
  }

  Widget _buildSearchField(ColorScheme colorScheme) {
    return Container(
      key: const ValueKey('search'),
      height: 50,
      margin: EdgeInsets.only(right: AppDimensions.space16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.onSurface.withAlpha(60),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.space12),
            child: Icon(
              Iconsax.search_normal_outline,
              size: AppDimensions.mediumIconSize,
              color: colorScheme.onSurface.withAlpha(153),
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
                hintText: 'Search items...',
                hintStyle: TextStyle(
                  fontSize: AppDimensions.bodyFontSize,
                  color: colorScheme.onSurface.withAlpha(153),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: AppDimensions.space12,
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
                color: colorScheme.onSurface.withAlpha(153),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          AppDimensions.w8,
        ],
      ),
    );
  }
}
