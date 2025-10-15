import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String fieldLabel;
  final String hintText;
  final bool validation;
  final String errorMessage;
  final bool? needTitle;
  final TextStyle? hintTextStyle;
  final TextStyle? selectedTextStyle;
  final Key? itemkey;
  final TextStyle? titleStyle;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final FormFieldValidator<T>? validatorClass;
  final Function(T?)? onChanged;
  final VoidCallback? onTap;
  final bool? showLoading;
  final List<DropdownItem<T>> items;
  final T? selectedValue;
  final bool? enabled;
  final double? conentPaddingHorizontal;
  final double? conentPaddingVertical;

  const CustomDropdown({
    super.key,
    required this.fieldLabel,
    required this.hintText,
    required this.validation,
    required this.errorMessage,
    required this.items,
    this.needTitle,
    this.hintTextStyle,
    this.selectedTextStyle,
    this.itemkey,
    this.titleStyle,
    this.prefixWidget,
    this.suffixWidget,
    this.validatorClass,
    this.onChanged,
    this.onTap,
    this.showLoading,
    this.selectedValue,
    this.enabled,
    this.conentPaddingHorizontal,
    this.conentPaddingVertical,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  late FocusNode _focusNode;
  late ValueNotifier<bool> isFocusedNotifier;
  T? _selectedValue;
  bool _isDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    isFocusedNotifier = ValueNotifier(false);
    _selectedValue = widget.selectedValue;

    _focusNode.addListener(() {
      isFocusedNotifier.value = _focusNode.hasFocus;
    });
  }

  @override
  void didUpdateWidget(CustomDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      _selectedValue = widget.selectedValue;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    isFocusedNotifier.dispose();
    super.dispose();
  }

  Widget? _buildSuffixWidget() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.showLoading == true) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colorScheme.primary,
          ),
        ),
      );
    }

    return widget.suffixWidget ??
        Icon(
          Icons.keyboard_arrow_down,
          color: colorScheme.onSurface.withAlpha(153),
        );
  }

  String? _validate(T? value) {
    if (widget.validation) {
      if (widget.validatorClass != null) {
        return widget.validatorClass!(value);
      }

      if (value == null) {
        return widget.errorMessage;
      }
    }

    return null;
  }

  void _showDropdownDialog() async {
    if (widget.enabled == false) return;
    FocusManager.instance.primaryFocus?.unfocus();
    if (widget.onTap != null) {
      widget.onTap!();
    }

    setState(() {
      _isDialogOpen = true;
    });

    final result = await showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        final cs = theme.colorScheme;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 400),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.fieldLabel,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: cs.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close, color: cs.onSurface),
                      ),
                    ],
                  ),
                ),

                Divider(height: 1, color: cs.onSurface.withAlpha(60)),

                // Items list
                Flexible(
                  child: widget.items.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'No items available',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurface.withAlpha(153),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: widget.items.length,
                          itemBuilder: (context, index) {
                            final item = widget.items[index];
                            final isSelected = item.value == _selectedValue;

                            return InkWell(
                              onTap: () {
                                Navigator.of(context).pop(item.value);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? cs.primary.withAlpha(30)
                                      : Colors.transparent,
                                ),
                                child: Row(
                                  children: [
                                    if (item.icon != null) ...[
                                      item.icon!,
                                      const SizedBox(width: 12),
                                    ],
                                    Expanded(
                                      child: Text(
                                        item.text,
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                              color: isSelected
                                                  ? cs.primary
                                                  : cs.onSurface,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                            ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check,
                                        color: cs.primary,
                                        size: 20,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );

    setState(() {
      _isDialogOpen = false;
    });

    FocusManager.instance.primaryFocus?.unfocus();

    if (result != null) {
      setState(() {
        _selectedValue = result;
      });

      if (widget.onChanged != null) {
        widget.onChanged!(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Define custom colors with alpha (153 is 60% opacity)
    final onSurface60 = cs.onSurface.withAlpha(153);
    final isEnabled = widget.enabled ?? true;

    // Find selected item text safely
    DropdownItem<T>? selectedItem;
    try {
      selectedItem = widget.items.firstWhere(
        (item) => item.value == _selectedValue,
      );
    } catch (e) {
      selectedItem = null; // No matching item found
    }

    return ValueListenableBuilder<bool>(
      valueListenable: isFocusedNotifier,
      builder: (context, isFocused, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.needTitle ?? true) ...[
              Text(
                widget.fieldLabel,
                style:
                    widget.titleStyle ??
                    theme.textTheme.titleMedium?.copyWith(color: cs.onSurface),
              ),
              const SizedBox(height: 8),
            ],
            FormField<T>(
              key: widget.itemkey,
              initialValue: _selectedValue,
              autovalidateMode: widget.validation
                  ? AutovalidateMode.onUnfocus
                  : AutovalidateMode.disabled,
              validator: _validate,
              builder: (FormFieldState<T> field) {
                // Check if dialog is open or field is focused for border color
                final isActive = _isDialogOpen || isFocused;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: isEnabled ? _showDropdownDialog : null,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.conentPaddingHorizontal ?? 16,
                          vertical: widget.conentPaddingVertical ?? 14,
                        ),
                        decoration: BoxDecoration(
                          color: isEnabled
                              ? cs.surface
                              : cs.surface.withAlpha(128),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: field.hasError
                                ? cs.error
                                : isActive // Dialog open or focused
                                ? cs.primary
                                : cs.onSurface.withAlpha(60),
                            width: field.hasError
                                ? 1.5
                                : isActive // Dialog open or focused
                                ? 2
                                : 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            if (widget.prefixWidget != null) ...[
                              widget.prefixWidget!,
                              const SizedBox(width: 12),
                            ],
                            if (selectedItem?.icon != null &&
                                _selectedValue != null) ...[
                              selectedItem!.icon!,
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                              child: Text(
                                _selectedValue != null && selectedItem != null
                                    ? selectedItem.text
                                    : widget.hintText,
                                style: _selectedValue != null
                                    ? widget.selectedTextStyle ??
                                          theme.textTheme.bodyLarge?.copyWith(
                                            color: isEnabled
                                                ? cs.onSurface
                                                : onSurface60,
                                          )
                                    : widget.hintTextStyle ??
                                          theme.textTheme.bodyLarge?.copyWith(
                                            color: onSurface60,
                                          ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 12),
                            _buildSuffixWidget() ?? const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                    if (field.hasError) ...[
                      const SizedBox(height: 6),
                      Text(
                        field.errorText!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.error,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}

// Helper class for dropdown items (same as before)
class DropdownItem<T> {
  final T value;
  final String text;
  final Widget? icon;

  const DropdownItem({required this.value, required this.text, this.icon});
}
