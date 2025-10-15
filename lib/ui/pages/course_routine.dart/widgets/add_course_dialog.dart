import 'package:flutter/material.dart';
import 'package:campuswhisper/ui/widgets/custom_input.dart';
import 'package:campuswhisper/ui/widgets/custom_time_input.dart';
import 'package:campuswhisper/ui/widgets/default_button.dart';

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
  final courseIdController = TextEditingController();
  final sectionController = TextEditingController();
  final roomController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();

  final List<String> allDays = ['S', 'M', 'T', 'W', 'R', 'F', 'A'];
  final List<String> selectedDays = [];

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
    if (courseIdController.text.isEmpty ||
        sectionController.text.isEmpty ||
        roomController.text.isEmpty ||
        startTimeController.text.isEmpty ||
        endTimeController.text.isEmpty ||
        selectedDays.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    widget.onSave({
      'courseId': courseIdController.text,
      'section': sectionController.text,
      'room': roomController.text,
      'days': List<String>.from(selectedDays),
      'startTime': startTimeController.text,
      'endTime': endTimeController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomInput(
          controller: courseIdController,
          fieldLabel: 'Course ID',
          hintText: 'e.g., CSE100',
          validation: false,
          errorMessage: '',
        ),
        const SizedBox(height: 16),
        CustomInput(
          controller: sectionController,
          fieldLabel: 'Section',
          hintText: 'e.g., 2',
          validation: false,
          errorMessage: '',
        ),
        const SizedBox(height: 16),
        CustomInput(
          controller: roomController,
          fieldLabel: 'Room',
          hintText: 'e.g., BC6001',
          validation: false,
          errorMessage: '',
        ),
        const SizedBox(height: 16),

        // Days selector
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
              onTap: () => _toggleDay(day),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected ? cs.primary : cs.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? cs.primary : cs.onSurface.withAlpha(60),
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
        const SizedBox(height: 16),

        // Time inputs
        Row(
          children: [
            Expanded(
              child: CustomTimeInput(
                controller: startTimeController,
                fieldLabel: 'Start Time',
                hintText: 'Select time',
                validation: false,
                errorMessage: '',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTimeInput(
                controller: endTimeController,
                fieldLabel: 'End Time',
                hintText: 'Select time',
                validation: false,
                errorMessage: '',
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
    );
  }
}
