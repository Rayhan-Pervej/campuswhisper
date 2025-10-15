import 'package:flutter/material.dart';

class CustomTimeInput extends StatefulWidget {
  final TextEditingController controller;
  final String fieldLabel;
  final String hintText;
  final bool validation;
  final String errorMessage;
  final bool? needTitle;
  final TextStyle? titleStyle;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validatorClass;

  const CustomTimeInput({
    super.key,
    required this.controller,
    required this.fieldLabel,
    required this.hintText,
    required this.validation,
    required this.errorMessage,
    this.needTitle,
    this.titleStyle,
    this.onTap,
    this.validatorClass,
  });

  @override
  State<CustomTimeInput> createState() => _CustomTimeInputState();
}

class _CustomTimeInputState extends State<CustomTimeInput> {
  late FocusNode _focusNode;
  late ValueNotifier<bool> isFocusedNotifier;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    isFocusedNotifier = ValueNotifier(false);

    _focusNode.addListener(() {
      isFocusedNotifier.value = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    isFocusedNotifier.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: theme.colorScheme.surface,
              hourMinuteTextColor: theme.colorScheme.onSurface,
              dayPeriodTextColor: theme.colorScheme.onSurface,
              dialHandColor: theme.colorScheme.primary,
              dialBackgroundColor: theme.colorScheme.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedTime = picked.format(context);
      widget.controller.text = formattedTime;
      if (widget.onTap != null) {
        widget.onTap!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final onSurface60 = cs.onSurface.withAlpha(153);

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
            TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              readOnly: true,
              autovalidateMode: widget.validation
                  ? AutovalidateMode.onUnfocus
                  : AutovalidateMode.disabled,
              style: theme.textTheme.bodyLarge?.copyWith(color: cs.onSurface),
              onTap: _selectTime,
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.access_time_rounded,
                  color: isFocused ? cs.primary : onSurface60,
                ),
                hintText: widget.hintText,
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: onSurface60,
                ),
                filled: true,
                fillColor: cs.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: cs.onSurface.withAlpha(60),
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: cs.onSurface.withAlpha(60),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: cs.primary, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: cs.error, width: 1.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: cs.error, width: 2),
                ),
              ),
              validator: widget.validation ? widget.validatorClass : null,
            ),
          ],
        );
      },
    );
  }
}