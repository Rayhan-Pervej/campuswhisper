import 'package:flutter/material.dart';
import 'package:campuswhisper/ui/widgets/custom_input.dart';
import 'package:campuswhisper/ui/widgets/custom_time_input.dart';
import 'package:campuswhisper/ui/widgets/default_button.dart';
import 'package:campuswhisper/core/constants/validation_messages.dart';
import 'package:campuswhisper/core/utils/validators.dart';

class AddCourseDialogContent extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic>? existingCourse;

  const AddCourseDialogContent({
    super.key,
    required this.onSave,
    this.existingCourse,
  });

  @override
  State<AddCourseDialogContent> createState() => _AddCourseDialogContentState();
}

class _AddCourseDialogContentState extends State<AddCourseDialogContent> {
  final _formKey = GlobalKey<FormState>();
  final courseIdController = TextEditingController();
  final sectionController = TextEditingController();
  final roomController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();

  final List<String> allDays = ['S', 'M', 'T', 'W', 'R', 'F', 'A'];
  final List<String> selectedDays = [];

  // Days validation state
  bool daysError = false;

  @override
  void initState() {
    super.initState();

    // Populate fields if editing existing course
    if (widget.existingCourse != null) {
      courseIdController.text = widget.existingCourse!['courseId'] ?? '';
      sectionController.text = widget.existingCourse!['section'] ?? '';
      roomController.text = widget.existingCourse!['room'] ?? '';
      startTimeController.text = widget.existingCourse!['startTime'] ?? '';
      endTimeController.text = widget.existingCourse!['endTime'] ?? '';

      if (widget.existingCourse!['days'] != null) {
        selectedDays.addAll(List<String>.from(widget.existingCourse!['days']));
      }
    }
  }

  @override
  void dispose() {
    courseIdController.dispose();
    sectionController.dispose();
    roomController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  void _toggleDay(String day) {
    setState(() {
      if (selectedDays.contains(day)) {
        selectedDays.remove(day);
      } else {
        selectedDays.add(day);
      }
    });
  }

  void _handleSave() {
    // Check days validation
    if (selectedDays.isEmpty) {
      setState(() => daysError = true);
      return;
    }

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.onSave({
      'courseId': courseIdController.text.trim(),
      'section': sectionController.text.trim(),
      'room': roomController.text.trim(),
      'days': List<String>.from(selectedDays),
      'startTime': startTimeController.text.trim(),
      'endTime': endTimeController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        CustomInput(
          controller: courseIdController,
          fieldLabel: 'Course ID',
          hintText: 'e.g., CSE100',
          validation: true,
          errorMessage: ValidationMessages.courseIdRequired,
          validatorClass: Validators.courseId,
        ),
        const SizedBox(height: 16),
        CustomInput(
          controller: sectionController,
          fieldLabel: 'Section',
          hintText: 'e.g., 2',
          validation: true,
          errorMessage: ValidationMessages.sectionRequired,
          validatorClass: Validators.section,
        ),
        const SizedBox(height: 16),
        CustomInput(
          controller: roomController,
          fieldLabel: 'Room',
          hintText: 'e.g., BC6001',
          validation: true,
          errorMessage: ValidationMessages.roomRequired,
          validatorClass: Validators.room,
        ),
        const SizedBox(height: 16),

        // Days selector
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Days',
              style: theme.textTheme.titleMedium?.copyWith(color: cs.onSurface),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allDays.map((day) {
                final isSelected = selectedDays.contains(day);
                return GestureDetector(
                  onTap: () {
                    _toggleDay(day);
                    if (daysError && selectedDays.isNotEmpty) {
                      setState(() => daysError = false);
                    }
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSelected ? cs.primary : cs.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: daysError
                            ? cs.error
                            : isSelected
                                ? cs.primary
                                : cs.onSurface.withAlpha(60),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        day,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isSelected ? cs.onPrimary : cs.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            if (daysError)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 4),
                child: Text(
                  ValidationMessages.daysRequired,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.error,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // Time inputs
        Row(
          children: [
            Expanded(
              child: CustomTimeInput(
                controller: startTimeController,
                fieldLabel: 'Start Time',
                hintText: 'Select time',
                validation: true,
                errorMessage: ValidationMessages.startTimeRequired,
                validatorClass: Validators.startTime,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTimeInput(
                controller: endTimeController,
                fieldLabel: 'End Time',
                hintText: 'Select time',
                validation: true,
                errorMessage: ValidationMessages.endTimeRequired,
                validatorClass: Validators.endTime,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Save button
        DefaultButton(
          text: widget.existingCourse != null ? 'Update Course' : 'Add Course',
          press: _handleSave,
        ),
      ],
      ),
    );
  }
}
