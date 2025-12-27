import 'package:flutter/material.dart';
import 'package:campuswhisper/ui/widgets/app_dimensions.dart';

import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_input.dart';
import '../../../widgets/default_button.dart';

class AddEvent extends StatefulWidget {
  final List<String> categories;
  final Function(Map<String, dynamic>) onEventCreated;

  const AddEvent({
    super.key,
    required this.categories,
    required this.onEventCreated,
  });

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _organizerController = TextEditingController();

  String? _selectedCategory;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _organizerController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _handleSubmit() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter event title')),
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter event description')),
      );
      return;
    }

    if (_locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter event location')),
      );
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date')),
      );
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time')),
      );
      return;
    }

    // Combine date and time
    final eventDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final newEvent = {
      'eventTitle': _titleController.text.trim(),
      'organizerName': _organizerController.text.isEmpty
          ? 'Anonymous'
          : _organizerController.text.trim(),
      'description': _descriptionController.text.trim(),
      'eventDate': eventDateTime,
      'location': _locationController.text.trim(),
      'category': _selectedCategory!,
      'interestedCount': 0,
      'goingCount': 0,
    };

    widget.onEventCreated(newEvent);
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
          controller: _titleController,
          fieldLabel: 'Event Title',
          hintText: 'Enter event title',
          validation: false,
          errorMessage: '',
          autofocus: false,
          textInputAction: TextInputAction.next,
          inputType: TextInputType.text,
        ),
        AppDimensions.h16,
        CustomInput(
          controller: _organizerController,
          fieldLabel: 'Organizer Name',
          hintText: 'Enter organizer name (optional)',
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
          hintText: 'Describe your event',
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
          hintText: 'Enter event location',
          validation: false,
          errorMessage: '',
          autofocus: false,
          textInputAction: TextInputAction.next,
          inputType: TextInputType.text,
        ),
        AppDimensions.h16,
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        border: Border.all(
                          color: colorScheme.onSurface.withAlpha(60),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: colorScheme.onSurface.withAlpha(153),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedDate == null
                                  ? 'Select date'
                                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: _selectedDate == null
                                    ? colorScheme.onSurface.withAlpha(153)
                                    : colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppDimensions.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectTime(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        border: Border.all(
                          color: colorScheme.onSurface.withAlpha(60),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: colorScheme.onSurface.withAlpha(153),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedTime == null
                                  ? 'Select time'
                                  : _selectedTime!.format(context),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: _selectedTime == null
                                    ? colorScheme.onSurface.withAlpha(153)
                                    : colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
          text: 'Create Event',
          press: _handleSubmit,
          isLoading: _isLoading,
        ),
      ],
    );
  }
}
