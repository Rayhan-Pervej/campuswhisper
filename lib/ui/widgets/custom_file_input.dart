import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CustomFileInput extends StatefulWidget {
  final String fieldLabel;
  final String hintText;
  final bool validation;
  final String errorMessage;
  final bool? needTitle;
  final TextStyle? hintTextStyle;
  final Key? itemkey;
  final TextStyle? titleStyle;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final FormFieldValidator<File>? validatorClass;
  final Function(File?)? onChanged;
  final VoidCallback? onTap;
  final bool? showLoading;
  final List<String>? allowedExtensions;
  final FileType fileType;
  final bool allowMultiple;
  final File? initialFile;
  final int? maxFileSizeInMB;
  final VoidCallback? onClear;

  const CustomFileInput({
    super.key,
    required this.fieldLabel,
    required this.hintText,
    required this.validation,
    required this.errorMessage,
    this.needTitle,
    this.hintTextStyle,
    this.itemkey,
    this.titleStyle,
    this.prefixWidget,
    this.suffixWidget,
    this.validatorClass,
    this.onChanged,
    this.onTap,
    this.showLoading,
    this.allowedExtensions,
    this.fileType = FileType.any,
    this.allowMultiple = false,
    this.initialFile,
    this.maxFileSizeInMB,
    this.onClear,
  });

  @override
  State<CustomFileInput> createState() => _CustomFileInputState();
}

class _CustomFileInputState extends State<CustomFileInput> {
  late FocusNode _focusNode;
  late ValueNotifier<bool> isFocusedNotifier;
  late TextEditingController _controller;
  File? _selectedFile;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    isFocusedNotifier = ValueNotifier(false);
    _controller = TextEditingController();
    _selectedFile = widget.initialFile;

    // Set initial text if file is provided
    if (_selectedFile != null) {
      _controller.text = _selectedFile!.path.split('/').last;
    }

    _focusNode.addListener(() {
      isFocusedNotifier.value = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    isFocusedNotifier.dispose();
    _controller.dispose();
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

    // Show clear button if file is selected
    if (_selectedFile != null) {
      return IconButton(
        onPressed: _clearFile,
        icon: Icon(Icons.clear, color: colorScheme.onSurface.withAlpha(153)),
      );
    }

    return widget.suffixWidget ??
        Icon(Icons.attach_file, color: colorScheme.onSurface.withAlpha(153));
  }

  Widget? _buildPrefixWidget() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.prefixWidget != null) {
      return widget.prefixWidget;
    }

    // Default file icon based on file type
    IconData iconData;
    switch (widget.fileType) {
      case FileType.image:
        iconData = Icons.image;
        break;
      case FileType.video:
        iconData = Icons.video_file;
        break;
      case FileType.audio:
        iconData = Icons.audio_file;
        break;
      default:
        iconData = Icons.insert_drive_file;
    }

    return Icon(iconData, color: colorScheme.onSurface.withAlpha(153));
  }

  Future<void> _pickFile() async {
    try {
      setState(() {
        _errorText = null;
      });

      if (widget.onTap != null) {
        widget.onTap!();
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: widget.fileType,
        allowedExtensions: widget.allowedExtensions,
        allowMultiple: widget.allowMultiple,
      );

      if (result != null && result.files.isNotEmpty) {
        final pickedFile = File(result.files.first.path!);

        // Validate file size if specified
        if (widget.maxFileSizeInMB != null) {
          final fileSizeInMB = pickedFile.lengthSync() / (1024 * 1024);
          if (fileSizeInMB > widget.maxFileSizeInMB!) {
            setState(() {
              _errorText =
                  'File size exceeds ${widget.maxFileSizeInMB}MB limit';
            });
            return;
          }
        }

        setState(() {
          _selectedFile = pickedFile;
          _controller.text = result.files.first.name;
        });

        if (widget.onChanged != null) {
          widget.onChanged!(_selectedFile);
        }
      }
    } catch (e) {
      setState(() {
        _errorText = 'Error picking file: ${e.toString()}';
      });
    }
  }

  void _clearFile() {
    setState(() {
      _selectedFile = null;
      _controller.clear();
      _errorText = null;
    });

    if (widget.onChanged != null) {
      widget.onChanged!(null);
    }

    if (widget.onClear != null) {
      widget.onClear!();
    }
  }

  String? _validate(String? value) {
    if (widget.validation) {
      if (widget.validatorClass != null) {
        return widget.validatorClass!(_selectedFile);
      }

      if (_selectedFile == null) {
        return widget.errorMessage;
      }
    }

    return _errorText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Define custom colors with alpha (153 is 60% opacity)
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
              key: widget.itemkey,
              controller: _controller,
              focusNode: _focusNode,
              readOnly: true, // Always read-only since it's a file picker
              onTap: _pickFile,
              autovalidateMode: widget.validation
                  ? AutovalidateMode.onUnfocus
                  : AutovalidateMode.disabled,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: _selectedFile != null ? cs.onSurface : onSurface60,
              ),
              decoration: InputDecoration(
                prefixIcon: _buildPrefixWidget(),
                suffixIcon: _buildSuffixWidget(),
                hintText: widget.hintText,
                hintStyle:
                    widget.hintTextStyle ??
                    theme.textTheme.bodyLarge?.copyWith(color: onSurface60),
                filled: true,
                fillColor: cs.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),

                // Same border states as CustomInput for consistency
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
              validator: widget.validation ? (value) => _validate(value) : null,
            ),

            // Status messages below the field
            if (_selectedFile != null || _errorText != null) ...[
              const SizedBox(height: 8),
              if (_selectedFile != null && _errorText == null) ...[
                // Success message
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: cs.primary, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'File uploaded',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.primary,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else if (_errorText != null) ...[
                // Error message
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error, color: cs.error, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorText!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ],
        );
      },
    );
  }
}
