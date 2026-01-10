import 'package:flutter/material.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';

import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_input.dart';
import '../../../widgets/default_button.dart';

class AddCompetition extends StatefulWidget {
  final List<String> categories;
  final Function(Map<String, dynamic>) onCompetitionCreated;

  const AddCompetition({
    super.key,
    required this.categories,
    required this.onCompetitionCreated,
  });

  @override
  State<AddCompetition> createState() => _AddCompetitionState();
}

class _AddCompetitionState extends State<AddCompetition> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _organizerController = TextEditingController();
  final TextEditingController _prizePoolController = TextEditingController();
  final TextEditingController _teamSizeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  String? _selectedCategory;
  String? _selectedStatus;
  DateTime? _registrationDeadline;
  DateTime? _eventDate;
  TimeOfDay? _eventTime;
  final bool _isLoading = false;

  final List<String> _statuses = [
    'Registration Open',
    'Upcoming',
    'Ongoing',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _organizerController.dispose();
    _prizePoolController.dispose();
    _teamSizeController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _selectRegistrationDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _registrationDeadline = picked;
      });
    }
  }

  Future<void> _selectEventDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _registrationDeadline ?? DateTime.now(),
      firstDate: _registrationDeadline ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _eventDate = picked;
      });
    }
  }

  Future<void> _selectEventTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _eventTime = picked;
      });
    }
  }

  void _handleSubmit() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter competition title')),
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter description')),
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
        const SnackBar(content: Text('Please select a status')),
      );
      return;
    }

    if (_registrationDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select registration deadline')),
      );
      return;
    }

    if (_eventDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select event date')),
      );
      return;
    }

    if (_eventTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select event time')),
      );
      return;
    }

    if (_prizePoolController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter prize pool')),
      );
      return;
    }

    if (_teamSizeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter team size')),
      );
      return;
    }

    if (_durationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter duration')),
      );
      return;
    }

    // Combine event date and time
    final eventDateTime = DateTime(
      _eventDate!.year,
      _eventDate!.month,
      _eventDate!.day,
      _eventTime!.hour,
      _eventTime!.minute,
    );

    final newCompetition = {
      'title': _titleController.text.trim(),
      'organizer': _organizerController.text.isEmpty
          ? 'Admin'
          : _organizerController.text.trim(),
      'description': _descriptionController.text.trim(),
      'registrationDeadline': _registrationDeadline!,
      'eventDate': eventDateTime,
      'duration': _durationController.text.trim(),
      'location': _locationController.text.trim(),
      'category': _selectedCategory!,
      'status': _selectedStatus!,
      'prizePool': _prizePoolController.text.trim(),
      'participantCount': 0,
      'teamSize': _teamSizeController.text.trim(),
      'isFeatured': false,
    };

    widget.onCompetitionCreated(newCompetition);
    Navigator.of(context).pop();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not selected';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Not selected';
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomInput(
            controller: _titleController,
            fieldLabel: 'Competition Title',
            hintText: 'Enter competition title',
            validation: false,
            errorMessage: '',
            textInputAction: TextInputAction.next,
            inputType: TextInputType.text,
          ),
          AppDimensions.h16,
          CustomInput(
            controller: _descriptionController,
            fieldLabel: 'Description',
            hintText: 'Enter competition description',
            validation: false,
            errorMessage: '',
            maxLines: 4,
            minLines: 3,
            textInputAction: TextInputAction.newline,
            inputType: TextInputType.multiline,
          ),
          AppDimensions.h16,
          CustomInput(
            controller: _organizerController,
            fieldLabel: 'Organizer Name (Optional)',
            hintText: 'Enter organizer name',
            validation: false,
            errorMessage: '',
            textInputAction: TextInputAction.next,
            inputType: TextInputType.text,
          ),
          AppDimensions.h16,
          CustomDropdown(
            fieldLabel: 'Category',
            hintText: 'Select category',
            validation: false,
            errorMessage: '',
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
          AppDimensions.h16,
          CustomDropdown(
            fieldLabel: 'Status',
            hintText: 'Select status',
            validation: false,
            errorMessage: '',
            items: _statuses
                .map((status) => DropdownItem(value: status, text: status))
                .toList(),
            selectedValue: _selectedStatus,
            onChanged: (value) {
              setState(() {
                _selectedStatus = value;
              });
            },
          ),
          AppDimensions.h16,
          GestureDetector(
            onTap: () => _selectRegistrationDeadline(context),
            child: Container(
              padding: EdgeInsets.all(AppDimensions.space16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radius12),
                border: Border.all(
                  color: colorScheme.onSurface.withAlpha(60),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Registration Deadline',
                        style: TextStyle(
                          fontSize: AppDimensions.captionFontSize,
                          color: colorScheme.onSurface.withAlpha(153),
                        ),
                      ),
                      AppDimensions.h4,
                      Text(
                        _formatDate(_registrationDeadline),
                        style: TextStyle(
                          fontSize: AppDimensions.bodyFontSize,
                          color: _registrationDeadline == null
                              ? colorScheme.onSurface.withAlpha(153)
                              : colorScheme.onSurface,
                          fontWeight: _registrationDeadline == null
                              ? FontWeight.normal
                              : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.calendar_today,
                    size: AppDimensions.mediumIconSize,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          AppDimensions.h16,
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectEventDate(context),
                  child: Container(
                    padding: EdgeInsets.all(AppDimensions.space16),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radius12),
                      border: Border.all(
                        color: colorScheme.onSurface.withAlpha(60),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Event Date',
                              style: TextStyle(
                                fontSize: AppDimensions.captionFontSize,
                                color: colorScheme.onSurface.withAlpha(153),
                              ),
                            ),
                            AppDimensions.h4,
                            Text(
                              _formatDate(_eventDate),
                              style: TextStyle(
                                fontSize: AppDimensions.captionFontSize,
                                color: _eventDate == null
                                    ? colorScheme.onSurface.withAlpha(153)
                                    : colorScheme.onSurface,
                                fontWeight: _eventDate == null
                                    ? FontWeight.normal
                                    : FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.calendar_today,
                          size: AppDimensions.mediumIconSize,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AppDimensions.w12,
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectEventTime(context),
                  child: Container(
                    padding: EdgeInsets.all(AppDimensions.space16),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radius12),
                      border: Border.all(
                        color: colorScheme.onSurface.withAlpha(60),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time',
                              style: TextStyle(
                                fontSize: AppDimensions.captionFontSize,
                                color: colorScheme.onSurface.withAlpha(153),
                              ),
                            ),
                            AppDimensions.h4,
                            Text(
                              _formatTime(_eventTime),
                              style: TextStyle(
                                fontSize: AppDimensions.captionFontSize,
                                color: _eventTime == null
                                    ? colorScheme.onSurface.withAlpha(153)
                                    : colorScheme.onSurface,
                                fontWeight: _eventTime == null
                                    ? FontWeight.normal
                                    : FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.access_time,
                          size: AppDimensions.mediumIconSize,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppDimensions.h16,
          CustomInput(
            controller: _durationController,
            fieldLabel: 'Duration',
            hintText: 'e.g., 2 days, 48 hours, 1 week',
            validation: false,
            errorMessage: '',
            textInputAction: TextInputAction.next,
            inputType: TextInputType.text,
          ),
          AppDimensions.h16,
          CustomInput(
            controller: _locationController,
            fieldLabel: 'Location',
            hintText: 'Enter event location',
            validation: false,
            errorMessage: '',
            textInputAction: TextInputAction.next,
            inputType: TextInputType.text,
          ),
          AppDimensions.h16,
          CustomInput(
            controller: _prizePoolController,
            fieldLabel: 'Prize Pool',
            hintText: 'e.g., ₹50,000',
            validation: false,
            errorMessage: '',
            textInputAction: TextInputAction.next,
            inputType: TextInputType.text,
          ),
          AppDimensions.h16,
          CustomInput(
            controller: _teamSizeController,
            fieldLabel: 'Team Size',
            hintText: 'e.g., 3-5 members, Solo, 11 players',
            validation: false,
            errorMessage: '',
            textInputAction: TextInputAction.done,
            inputType: TextInputType.text,
          ),
          AppDimensions.h24,
          DefaultButton(
            text: 'Create Competition',
            press: _handleSubmit,
            isLoading: _isLoading,
          ),
          AppDimensions.h16,
        ],
      ),
    );
  }
}
