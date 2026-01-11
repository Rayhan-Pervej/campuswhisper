import 'package:campuswhisper/ui/pages/course_routine/widgets/course_card.dart';
import 'package:flutter/material.dart';


class SemesterCard extends StatelessWidget {
  final String semester;
  final List<Map<String, dynamic>> courses;
  final VoidCallback onEdit;
  final VoidCallback onAddCourse;
  final VoidCallback onDelete;
  final Function(String) onDeleteCourse;
  final Function(String) onEditCourse;
  final bool isDeleteMode;

  const SemesterCard({
    super.key,
    required this.semester,
    required this.courses,
    required this.onEdit,
    required this.onAddCourse,
    required this.onDelete,
    required this.onDeleteCourse,
    required this.onEditCourse,
    required this.isDeleteMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.onSurface.withAlpha(60),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Semester Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.primary.withAlpha(30),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    semester,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(
                    Icons.edit_rounded,
                    color: cs.primary,
                    size: 20,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: cs.surface,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: cs.error,
                    size: 20,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: cs.surface,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add Course Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onAddCourse,
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: const Text('Add Course'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                // Courses List
                if (courses.isEmpty) ...[
                  const SizedBox(height: 20),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 48,
                            color: cs.onSurface.withAlpha(102),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No courses added',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: cs.onSurface.withAlpha(153),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                  ...courses.map((course) {
                    final daysList = (course['days'] as List<dynamic>?) ?? [];
                    final days = daysList.isNotEmpty ? daysList.join('-') : 'N/A';
                    return CourseCard(
                      courseId: course['courseId'] ?? course['courseCode'] ?? 'N/A',
                      section: course['section'] ?? 'N/A',
                      room: course['room'] ?? 'N/A',
                      days: days,
                      time: '${course['startTime'] ?? 'N/A'} to ${course['endTime'] ?? 'N/A'}',
                      showDeleteIcon: isDeleteMode,
                      onDelete: () => onDeleteCourse(course['id']),
                      onEdit: () => onEditCourse(course['id']),
                      courseData: course,
                      semesterName: semester,
                    );
                  }).toList(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}