import 'package:campuswhisper/ui/pages/course_routine/widgets/add_course_dialog.dart';
import 'package:campuswhisper/ui/pages/course_routine/widgets/semseter_card.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/ui/widgets/custom_file_input.dart';
import 'package:campuswhisper/ui/widgets/custom_input.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';
import 'package:campuswhisper/ui/widgets/custom_bottom_dialog.dart';
import 'package:campuswhisper/ui/widgets/default_button.dart';
import 'package:flutter/material.dart';

class CourseRoutinePage extends StatefulWidget {
  const CourseRoutinePage({super.key});

  @override
  State<CourseRoutinePage> createState() => _CourseRoutinePageState();
}

class _CourseRoutinePageState extends State<CourseRoutinePage> {
  // Temporary state - will be moved to provider later
  List<Map<String, dynamic>> semesters = [];
  bool isDeleteMode = false;

  void _showAddSemesterDialog() {
    final semesterController = TextEditingController();

    CustomBottomDialog.show(
      context: context,
      title: 'Add Semester',
      child: Column(
        children: [
          CustomInput(
            controller: semesterController,
            fieldLabel: 'Semester Name',
            hintText: 'e.g., Summer 2025',
            validation: false,
            errorMessage: '',
          ),
          const SizedBox(height: 16),
          DefaultButton(
            text: "Add Semester",
            press: () {
              if (semesterController.text.isNotEmpty) {
                setState(() {
                  semesters.add({
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'semester': semesterController.text,
                    'courses':
                        <
                          Map<String, dynamic>
                        >[], // FIX: Explicitly type the list
                  });
                });
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showEditSemesterDialog(String semesterId) {
    final semester = semesters.firstWhere((s) => s['id'] == semesterId);
    final semesterController = TextEditingController(
      text: semester['semester'],
    );

    CustomBottomDialog.show(
      context: context,
      title: 'Edit Semester',
      child: Column(
        children: [
          CustomInput(
            controller: semesterController,
            fieldLabel: 'Semester Name',
            hintText: 'e.g., Summer 2025',
            validation: false,
            errorMessage: '',
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (semesterController.text.isNotEmpty) {
                  setState(() {
                    final index = semesters.indexWhere(
                      (s) => s['id'] == semesterId,
                    );
                    semesters[index]['semester'] = semesterController.text;
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(72),
                ),
              ),
              child: const Text('Update Semester'),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteSemester(String semesterId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Semester'),
        content: const Text(
          'Are you sure you want to delete this semester and all its courses?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                semesters.removeWhere((s) => s['id'] == semesterId);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddCourseDialog(String semesterId) {
    CustomBottomDialog.show(
      context: context,
      title: 'Add Course',
      child: AddCourseDialogContent(
        onSave: (courseData) {
          setState(() {
            final semesterIndex = semesters.indexWhere(
              (s) => s['id'] == semesterId,
            );
            final courses =
                semesters[semesterIndex]['courses']
                    as List<Map<String, dynamic>>;
            courses.add({
              ...courseData,
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
            });
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showEditCourseDialog(String semesterId, String courseId) {
    final semester = semesters.firstWhere((s) => s['id'] == semesterId);
    final courses = semester['courses'] as List<Map<String, dynamic>>;
    final course = courses.firstWhere((c) => c['id'] == courseId);

    CustomBottomDialog.show(
      context: context,
      title: 'Edit Course',
      child: AddCourseDialogContent(
        existingCourse: course,
        onSave: (courseData) {
          setState(() {
            final semesterIndex = semesters.indexWhere(
              (s) => s['id'] == semesterId,
            );
            final courses = semesters[semesterIndex]['courses'] as List;
            final courseIndex = courses.indexWhere((c) => c['id'] == courseId);
            courses[courseIndex] = {...courseData, 'id': courseId};
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _deleteCourse(String semesterId, String courseId) {
    setState(() {
      final semesterIndex = semesters.indexWhere((s) => s['id'] == semesterId);
      final courses = semesters[semesterIndex]['courses'] as List;
      courses.removeWhere((c) => c['id'] == courseId);
    });
  }

  void _toggleDeleteMode() {
    setState(() {
      isDeleteMode = !isDeleteMode;
    });
  }

  bool get hasAnyCourses {
    return semesters.any((semester) {
      final courses = semester['courses'] as List;
      return courses.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: DefaultAppBar(title: 'Course Routine'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding,
            vertical: AppDimensions.verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // File upload section
              CustomFileInput(
                fieldLabel: "Create Routine",
                hintText: "Upload your registration pdf...",
                validation: false,
                errorMessage: "",
              ),
              const SizedBox(height: 24),

              // Divider with text
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: cs.onSurface.withAlpha(60),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.onSurface.withAlpha(153),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: cs.onSurface.withAlpha(60),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Header with action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Routines',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  if (hasAnyCourses)
                    ElevatedButton.icon(
                      onPressed: _toggleDeleteMode,
                      icon: Icon(
                        isDeleteMode
                            ? Icons.close_rounded
                            : Icons.remove_circle_outline_rounded,
                        size: 18,
                      ),
                      label: Text(isDeleteMode ? 'Cancel' : 'Remove'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDeleteMode ? cs.error : cs.secondary,
                        foregroundColor: isDeleteMode
                            ? cs.onError
                            : cs.onSecondary,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),

              // Semesters list
              if (semesters.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 80,
                          color: cs.onSurface.withAlpha(102),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No semesters added yet',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: cs.onSurface.withAlpha(153),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Click the + button below to add your first semester',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onSurface.withAlpha(102),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...semesters.map((semester) {
                  final courses =
                      semester['courses'] as List<Map<String, dynamic>>;
                  return SemesterCard(
                    semester: semester['semester'],
                    courses: courses,
                    onEdit: () => _showEditSemesterDialog(semester['id']),
                    onDelete: () => _deleteSemester(semester['id']),
                    onAddCourse: () => _showAddCourseDialog(semester['id']),
                    onDeleteCourse: (courseId) =>
                        _deleteCourse(semester['id'], courseId),
                    onEditCourse: (courseId) =>
                        _showEditCourseDialog(semester['id'], courseId),
                    isDeleteMode: isDeleteMode,
                  );
                }).toList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSemesterDialog,
        backgroundColor: cs.primary,
        child: Icon(Icons.add_rounded, color: cs.onPrimary),
      ),
    );
  }
}
