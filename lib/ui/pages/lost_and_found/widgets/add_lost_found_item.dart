import 'package:flutter/material.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';

import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_input.dart';
import '../../../widgets/default_button.dart';

class AddLostFoundItem extends StatefulWidget {
  final List<String> categories;
  final Function(Map<String, dynamic>) onItemCreated;

  const AddLostFoundItem({
    super.key,
    required this.categories,
    required this.onItemCreated,
  });

  @override
  State<AddLostFoundItem> createState() => _AddLostFoundItemState();
}

class _AddLostFoundItemState extends State<AddLostFoundItem> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  String? _selectedCategory;
  String? _selectedStatus;
  final List<String> _statuses = ['Lost', 'Found'];
  final bool _isLoading = false;

  @override
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_itemNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter item name')),
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter item description')),
      );
      return;
    }

    if (_locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter location')),
      );
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    if (_selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select status (Lost/Found)')),
      );
      return;
    }

    final newItem = {
      'itemName': _itemNameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'location': _locationController.text.trim(),
      'category': _selectedCategory!,
      'status': _selectedStatus!,
      'contactInfo': _contactController.text.trim().isNotEmpty
          ? _contactController.text.trim()
          : null,
      'datePosted': DateTime.now(),
      'posterName': 'Current User', // Replace with actual user data later
      'isResolved': false,
    };

    widget.onItemCreated(newItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomInput(
          controller: _itemNameController,
          fieldLabel: 'Item Name',
          hintText: 'What did you lose/find?',
          validation: false,
          errorMessage: '',
          autofocus: false,
          textInputAction: TextInputAction.next,
          inputType: TextInputType.text,
        ),
        AppDimensions.h16,
        CustomInput(
          controller: _descriptionController,
          fieldLabel: 'Description',
          hintText: 'Describe the item in detail',
          validation: false,
          errorMessage: '',
          maxLines: 4,
          minLines: 3,
          autofocus: false,
          textInputAction: TextInputAction.newline,
          inputType: TextInputType.multiline,
        ),
        AppDimensions.h16,
        CustomInput(
          controller: _locationController,
          fieldLabel: 'Location',
          hintText: 'Where was it lost/found?',
          validation: false,
          errorMessage: '',
          autofocus: false,
          textInputAction: TextInputAction.next,
          inputType: TextInputType.text,
        ),
        AppDimensions.h16,
        CustomInput(
          controller: _contactController,
          fieldLabel: 'Contact Info (Optional)',
          hintText: 'Phone or email',
          validation: false,
          errorMessage: '',
          autofocus: false,
          textInputAction: TextInputAction.next,
          inputType: TextInputType.text,
        ),
        AppDimensions.h16,

        // Status Selection (Lost/Found)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppDimensions.h8,
            Row(
              children: _statuses.map((status) {
                final isSelected = _selectedStatus == status;
                final isLost = status == 'Lost';

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: status == _statuses.first ? AppDimensions.space8 : 0,
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedStatus = status;
                        });
                      },
                      borderRadius: BorderRadius.circular(AppDimensions.radius12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          vertical: AppDimensions.space16,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isLost ? colorScheme.error : colorScheme.primary)
                              : colorScheme.surface,
                          borderRadius: BorderRadius.circular(AppDimensions.radius12),
                          border: Border.all(
                            color: isSelected
                                ? (isLost ? colorScheme.error : colorScheme.primary)
                                : colorScheme.onSurface.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: AppDimensions.bodyFontSize,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        AppDimensions.h16,

        CustomDropdown<String>(
          fieldLabel: 'Category',
          hintText: 'Choose a category',
          validation: true,
          errorMessage: 'Please select a category',
          items: widget.categories
              .map((category) => DropdownItem(value: category, text: category))
              .toList(),
          selectedValue: _selectedCategory,
          onChanged: (value) {
            setState(() {
              _selectedCategory = value;
            });
          },
        ),
        AppDimensions.h24,
        DefaultButton(
          text: 'Post Item',
          press: _handleSubmit,
          isLoading: _isLoading,
        ),
      ],
    );
  }
}
