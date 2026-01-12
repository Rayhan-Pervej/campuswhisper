// import 'package:campuswhisper/ui/pages/course_routine/widgets/add_course_dialog.dart';
// import 'package:campuswhisper/ui/pages/course_routine/widgets/semseter_card.dart';
// import 'package:campuswhisper/core/theme/app_dimensions.dart';
// import 'package:campuswhisper/ui/widgets/custom_file_input.dart';
// import 'package:campuswhisper/ui/widgets/custom_input.dart';
// import 'package:campuswhisper/ui/widgets/default_appbar.dart';
// import 'package:campuswhisper/ui/widgets/custom_bottom_dialog.dart';
// import 'package:campuswhisper/ui/widgets/default_button.dart';
// import 'package:campuswhisper/providers/course_routine_provider.dart';
// import 'package:campuswhisper/core/constants/validation_messages.dart';
// import 'package:campuswhisper/core/utils/validators.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class CourseRoutinePage extends StatefulWidget {
//   const CourseRoutinePage({super.key});

//   @override
//   State<CourseRoutinePage> createState() => _CourseRoutinePageState();
// }

// class _CourseRoutinePageState extends State<CourseRoutinePage> {
//   bool isDeleteMode = false;

//   @override
//   void initState() {
//     super.initState();
//     // Load initial data
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final provider = Provider.of<CourseRoutineProvider>(context, listen: false);
//       if (provider.items.isEmpty && !provider.isLoading) {
//         provider.loadInitial();
//       }
//     });
//   }

//   void _showAddSemesterDialog() {
//     final semesterController = TextEditingController();
//     bool hasError = false;

//     CustomBottomDialog.show(
//       context: context,
//       title: 'Add Semester',
//       child: StatefulBuilder(
//         builder: (context, setState) {
//           return Column(
//             children: [
//               CustomInput(
//                 controller: semesterController,
//                 fieldLabel: 'Semester Name',
//                 hintText: 'e.g., Summer 2025',
//                 validation: hasError,
//                 errorMessage: 'Semester name is required',
//                 onChanged: (value) {
//                   if (hasError && value.trim().isNotEmpty) {
//                     setState(() => hasError = false);
//                   }
//                 },
//               ),
//               const SizedBox(height: 16),
//               DefaultButton(
//                 text: "Add Semester",
//                 press: () async {
//                   if (semesterController.text.trim().isEmpty) {
//                     setState(() => hasError = true);
//                     return;
//                   }
//                   final provider = Provider.of<CourseRoutineProvider>(context, listen: false);
//                   await provider.addSemester(semesterController.text.trim());
//                   if (context.mounted) {
//                     Navigator.of(context).pop();
//                   }
//                 },
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   void _showEditSemesterDialog(String semesterId) {
//     final provider = Provider.of<CourseRoutineProvider>(context, listen: false);
//     final semester = provider.getSemesterById(semesterId);
//     if (semester == null) return;

//     final semesterController = TextEditingController(
//       text: semester.semesterName,
//     );
//     bool hasError = false;

//     CustomBottomDialog.show(
//       context: context,
//       title: 'Edit Semester',
//       child: StatefulBuilder(
//         builder: (context, setState) {
//           return Column(
//             children: [
//               CustomInput(
//                 controller: semesterController,
//                 fieldLabel: 'Semester Name',
//                 hintText: 'e.g., Summer 2025',
//                 validation: hasError,
//                 errorMessage: ValidationMessages.semesterNameRequired,
//                 validatorClass: Validators.semesterName,
//                 onChanged: (value) {
//                   if (hasError && value.trim().isNotEmpty) {
//                     setState(() => hasError = false);
//                   }
//                 },
//               ),
//               const SizedBox(height: 16),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     if (semesterController.text.trim().isEmpty) {
//                       setState(() => hasError = true);
//                       return;
//                     }
//                     await provider.updateSemester(semesterId, semesterController.text.trim());
//                     if (context.mounted) {
//                       Navigator.of(context).pop();
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(72),
//                     ),
//                   ),
//                   child: const Text('Update Semester'),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   void _deleteSemester(String semesterId) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Semester'),
//         content: const Text(
//           'Are you sure you want to delete this semester and all its courses?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               final provider = Provider.of<CourseRoutineProvider>(context, listen: false);
//               await provider.deleteSemester(semesterId);
//               if (context.mounted) {
//                 Navigator.pop(context);
//               }
//             },
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showAddCourseDialog(String semesterId) {
//     CustomBottomDialog.show(
//       context: context,
//       title: 'Add Course',
//       child: AddCourseDialogContent(
//         onSave: (courseData) async {
//           final provider = Provider.of<CourseRoutineProvider>(context, listen: false);

//           // Transform days, startTime, endTime into schedule array
//           final days = courseData['days'] as List<dynamic>? ?? [];
//           final startTime = courseData['startTime'] as String? ?? '';
//           final endTime = courseData['endTime'] as String? ?? '';

//           final schedule = days.map((day) => {
//             'day': day,
//             'startTime': startTime,
//             'endTime': endTime,
//           }).toList();

//           // Create the complete course data with schedule and required fields
//           final completeData = {
//             'courseId': courseData['courseId'],
//             'courseCode': courseData['courseId'], // Use courseId as courseCode
//             'courseName': courseData['courseId'], // Use courseId as courseName for now
//             'section': courseData['section'],
//             'room': courseData['room'],
//             'instructor': 'TBA', // Default instructor
//             'credit': 3.0, // Default credit
//             'notes': null,
//             'schedule': schedule,
//           };

//           await provider.addCourse(
//             semesterId: semesterId,
//             courseData: completeData,
//           );
//           if (context.mounted) {
//             Navigator.of(context).pop();
//           }
//         },
//       ),
//     );
//   }

//   void _showEditCourseDialog(String semesterId, String courseId) {
//     final provider = Provider.of<CourseRoutineProvider>(context, listen: false);
//     final semester = provider.getSemesterById(semesterId);
//     if (semester == null) return;

//     final course = semester.courses.firstWhere((c) => c.id == courseId);

//     // Extract schedule information
//     final days = course.schedule.isNotEmpty
//         ? course.schedule.map((s) => s.day).toList()
//         : <String>[];
//     final startTime = course.schedule.isNotEmpty
//         ? course.schedule.first.startTime
//         : '';
//     final endTime = course.schedule.isNotEmpty
//         ? course.schedule.first.endTime
//         : '';

//     CustomBottomDialog.show(
//       context: context,
//       title: 'Edit Course',
//       child: AddCourseDialogContent(
//         existingCourse: {
//           'id': course.id,
//           'courseId': course.courseCode,
//           'courseName': course.courseName,
//           'courseCode': course.courseCode,
//           'instructor': course.instructor,
//           'section': course.section,
//           'credit': course.credit,
//           'room': course.room,
//           'notes': course.notes,
//           'days': days,
//           'startTime': startTime,
//           'endTime': endTime,
//         },
//         onSave: (courseData) async {
//           // Transform days, startTime, endTime into schedule array
//           final days = courseData['days'] as List<dynamic>? ?? [];
//           final startTime = courseData['startTime'] as String? ?? '';
//           final endTime = courseData['endTime'] as String? ?? '';

//           final schedule = days.map((day) => {
//             'day': day,
//             'startTime': startTime,
//             'endTime': endTime,
//           }).toList();

//           // Create the complete course data with schedule and preserve existing fields
//           final completeData = {
//             'courseId': courseData['courseId'],
//             'courseCode': courseData['courseId'], // Update courseCode with new courseId
//             'courseName': courseData['courseId'], // Update courseName with new courseId
//             'section': courseData['section'],
//             'room': courseData['room'],
//             'instructor': course.instructor, // Preserve original instructor
//             'credit': course.credit, // Preserve original credit
//             'notes': course.notes, // Preserve original notes
//             'schedule': schedule,
//           };

//           await provider.updateCourse(
//             semesterId: semesterId,
//             courseId: courseId,
//             courseData: completeData,
//           );
//           if (context.mounted) {
//             Navigator.of(context).pop();
//           }
//         },
//       ),
//     );
//   }

//   void _deleteCourse(String semesterId, String courseId) async {
//     final provider = Provider.of<CourseRoutineProvider>(context, listen: false);
//     await provider.deleteCourse(
//       semesterId: semesterId,
//       courseId: courseId,
//     );
//   }

//   void _toggleDeleteMode() {
//     setState(() {
//       isDeleteMode = !isDeleteMode;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final cs = theme.colorScheme;

//     return Scaffold(
//       appBar: DefaultAppBar(title: 'Course Routine'),
//       body: Consumer<CourseRoutineProvider>(
//         builder: (context, provider, child) {
//           // Loading state
//           if (provider.isLoading && provider.items.isEmpty) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           // Error state
//           if (provider.hasError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.error_outline, size: 64, color: cs.error),
//                   const SizedBox(height: 16),
//                   Text(
//                     provider.errorMessage ?? 'An error occurred',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: cs.error),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () => provider.refresh(),
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: AppDimensions.horizontalPadding,
//                 vertical: AppDimensions.verticalPadding,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // File upload section
//                   CustomFileInput(
//                     fieldLabel: "Create Routine",
//                     hintText: "Upload your registration pdf...",
//                     validation: false,
//                     errorMessage: "",
//                   ),
//                   const SizedBox(height: 24),

//                   // Divider with text
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Divider(
//                           thickness: 1,
//                           color: cs.onSurface.withAlpha(60),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         child: Text(
//                           'OR',
//                           style: theme.textTheme.bodyLarge?.copyWith(
//                             color: cs.onSurface.withAlpha(153),
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Divider(
//                           thickness: 1,
//                           color: cs.onSurface.withAlpha(60),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),

//                   // Header with action buttons
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'My Routines',
//                         style: theme.textTheme.headlineSmall?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: cs.onSurface,
//                         ),
//                       ),
//                       if (provider.hasAnyCourses)
//                         ElevatedButton.icon(
//                           onPressed: _toggleDeleteMode,
//                           icon: Icon(
//                             isDeleteMode
//                                 ? Icons.close_rounded
//                                 : Icons.remove_circle_outline_rounded,
//                             size: 18,
//                           ),
//                           label: Text(isDeleteMode ? 'Cancel' : 'Remove'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: isDeleteMode ? cs.error : cs.secondary,
//                             foregroundColor: isDeleteMode
//                                 ? cs.onError
//                                 : cs.onSecondary,
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 10,
//                               horizontal: 12,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),

//                   // Semesters list
//                   if (provider.items.isEmpty)
//                     Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(40),
//                         child: Column(
//                           children: [
//                             Icon(
//                               Icons.calendar_month_outlined,
//                               size: 80,
//                               color: cs.onSurface.withAlpha(102),
//                             ),
//                             const SizedBox(height: 20),
//                             Text(
//                               'No semesters added yet',
//                               style: theme.textTheme.titleLarge?.copyWith(
//                                 color: cs.onSurface.withAlpha(153),
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             Text(
//                               'Click the + button below to add your first semester',
//                               style: theme.textTheme.bodyMedium?.copyWith(
//                                 color: cs.onSurface.withAlpha(102),
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   // else
//                   //   ...provider.items.map((semester) {
//                   //     return SemesterCard(
//                   //       semester: semester.semesterName,
//                   //       courses: semester.courses.map((course) {
//                   //         // Extract days and times from schedule
//                   //         final days = course.schedule.isNotEmpty
//                   //             ? course.schedule.map((s) => s.day).toList()
//                   //             : <String>[];
//                   //         final startTime = course.schedule.isNotEmpty
//                   //             ? course.schedule.first.startTime
//                   //             : 'N/A';
//                   //         final endTime = course.schedule.isNotEmpty
//                   //             ? course.schedule.first.endTime
//                   //             : 'N/A';

//                   //         return {
//                   //           'id': course.id,
//                   //           'courseId': course.courseCode,
//                   //           'courseName': course.courseName,
//                   //           'courseCode': course.courseCode,
//                   //           'instructor': course.instructor,
//                   //           'section': course.section,
//                   //           'credit': course.credit,
//                   //           'room': course.room ?? 'N/A',
//                   //           'notes': course.notes,
//                   //           'days': days,
//                   //           'startTime': startTime,
//                   //           'endTime': endTime,
//                   //         };
//                   //       }).toList(),
//                   //       onEdit: () => _showEditSemesterDialog(semester.id),
//                   //       onDelete: () => _deleteSemester(semester.id),
//                   //       onAddCourse: () => _showAddCourseDialog(semester.id),
//                   //       onDeleteCourse: (courseId) =>
//                   //           _deleteCourse(semester.id, courseId),
//                   //       onEditCourse: (courseId) =>
//                   //           _showEditCourseDialog(semester.id, courseId),
//                   //       isDeleteMode: isDeleteMode,
//                   //     );
//                   //   }).toList(),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showAddSemesterDialog,
//         backgroundColor: cs.primary,
//         child: Icon(Icons.add_rounded, color: cs.onPrimary),
//       ),
//     );
//   }
// }
