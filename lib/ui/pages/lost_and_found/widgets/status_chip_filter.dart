import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';

class StatusChipFilter extends StatefulWidget {
  final List<String> statuses;
  final String? selectedStatus;
  final Function(String?) onStatusSelected;

  const StatusChipFilter({
    super.key,
    required this.statuses,
    this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  State<StatusChipFilter> createState() => _StatusChipFilterState();
}

class _StatusChipFilterState extends State<StatusChipFilter> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _chipKeys = {};

  @override
  void initState() {
    super.initState();
    // Create keys for each status including "All"
    _chipKeys['All'] = GlobalKey();
    for (var status in widget.statuses) {
      _chipKeys[status] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToChip(String status) {
    final key = _chipKeys[status];
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

      // Calculate target scroll position
      double? targetScroll;

      if (chipRightEdge > scrollViewWidth) {
        // Chip is cut off on the right
        targetScroll =
            currentScroll +
            (chipRightEdge - scrollViewWidth) +
            AppDimensions.space40 * 2;
      } else if (chipLeftEdge < 0) {
        // Chip is cut off on the left
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
              label: 'All Items',
              isSelected: widget.selectedStatus == null,
              onTap: () {
                widget.onStatusSelected(null);
                Future.delayed(const Duration(milliseconds: 50), () {
                  _scrollToChip('All');
                });
              },
            ),
            SizedBox(width: AppDimensions.space8),

            // Status chips
            ...widget.statuses.map((status) {
              final isSelected = widget.selectedStatus == status;
              return Padding(
                padding: EdgeInsets.only(right: AppDimensions.space8),
                child: _FilterChip(
                  key: _chipKeys[status],
                  label: status,
                  isSelected: isSelected,
                  onTap: () {
                    widget.onStatusSelected(status);
                    Future.delayed(const Duration(milliseconds: 50), () {
                      _scrollToChip(status);
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
    final isLost = label == 'Lost';
    final isFound = label == 'Found';

    // Set color based on status
    Color chipColor = colorScheme.primary;
    if (isLost) {
      chipColor = colorScheme.error;
    } else if (isFound) {
      chipColor = colorScheme.primary;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
          border: Border.all(
            color: isSelected
                ? chipColor
                : colorScheme.onSurface.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: chipColor.withValues(alpha: 0.3),
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
