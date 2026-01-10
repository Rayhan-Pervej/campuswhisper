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

  Color _getStatusColor(BuildContext context, String status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case 'Registration Open':
        return Colors.green;
      case 'Ongoing':
        return colorScheme.secondary;
      case 'Upcoming':
        return colorScheme.primary;
      case 'Ended':
        return colorScheme.onSurface.withAlpha(153);
      default:
        return colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: AppDimensions.space8),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: AppDimensions.horizontalPadding),

            // "All" chip
            _FilterChip(
              key: _chipKeys['All'],
              label: 'All Status',
              isSelected: widget.selectedStatus == null,
              color: Theme.of(context).colorScheme.primary,
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
                  color: _getStatusColor(context, status),
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
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.color,
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
          color: isSelected ? color : colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
          border: Border.all(
            color: isSelected ? color : color.withAlpha(77),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withAlpha(77),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppDimensions.captionFontSize,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? colorScheme.onPrimary : color,
          ),
        ),
      ),
    );
  }
}
