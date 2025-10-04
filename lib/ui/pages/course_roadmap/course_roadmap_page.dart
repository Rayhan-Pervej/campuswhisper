import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/department_roadmap_model.dart';
import '../../../providers/course_roadmap_provider.dart';
import '../../widgets/app_dimensions.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/default_appbar.dart';

class CourseRoadmapPage extends StatefulWidget {
  const CourseRoadmapPage({super.key});

  @override
  State<CourseRoadmapPage> createState() => _CourseRoadmapPageState();
}

class _CourseRoadmapPageState extends State<CourseRoadmapPage> {
  @override
  void initState() {
    super.initState();
    // Load data when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseRoadmapProvider>().loadRoadmapData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: "Course Roadmap"),
      body: Consumer<CourseRoadmapProvider>(
        builder: (context, provider, child) {
          // Loading state
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    provider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadRoadmapData(),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // No data state
          if (!provider.hasData) {
            return const Center(child: Text('No roadmap data available'));
          }

          return Column(
            children: [
              // Department Selector
              _buildDepartmentSelector(provider),

              // Roadmap Content
              Expanded(
                child: provider.selectedDepartment == null
                    ? _buildEmptyState()
                    : _buildRoadmapContent(provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDepartmentSelector(CourseRoadmapProvider provider) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding,
        vertical: AppDimensions.verticalPadding,
      ),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDropdown(
            fieldLabel: "Department*",
            hintText: "Select Department...",
            validation: false,
            errorMessage: '',
            items: provider.departmentOptions.map((dept) {
              return DropdownItem(
                value: dept['code']!,
                text: '${dept['code']} - ${dept['name']}',
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                provider.selectDepartment(value);
              }
            },
          ),

          // Show summary if department is selected
          if (provider.selectedDepartment != null) ...[
            SizedBox(height: AppDimensions.space12),
            _buildDepartmentSummary(provider),
          ],
        ],
      ),
    );
  }

  Widget _buildDepartmentSummary(CourseRoadmapProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSummaryCard(
          'Semesters',
          provider.totalSemesters.toString(),
          Icons.calendar_today,
        ),
        _buildSummaryCard(
          'Total Credits',
          provider.totalCredits.toString(),
          Icons.school,
        ),
        _buildSummaryCard(
          'Courses',
          provider.selectedDepartment!.roadmap
              .fold(0, (sum, sem) => sum + sem.items.length)
              .toString(),
          Icons.book,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String label, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.space12),
        child: Column(
          children: [
            Icon(icon, size: AppDimensions.mediumIconSize),
            SizedBox(height: AppDimensions.space4),
            Text(
              value,
              style: TextStyle(
                fontSize: AppDimensions.subtitleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: AppDimensions.captionFontSize,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school_outlined, size: 80, color: Colors.grey),
          SizedBox(height: AppDimensions.space16),
          Text(
            'Select a department to view roadmap',
            style: TextStyle(
              fontSize: AppDimensions.bodyFontSize,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapContent(CourseRoadmapProvider provider) {
    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.space16),
      itemCount: provider.selectedDepartment!.roadmap.length,
      itemBuilder: (context, index) {
        final semester = provider.selectedDepartment!.roadmap[index];
        return _buildSemesterCard(semester, provider);
      },
    );
  }

  Widget _buildSemesterCard(
    CourseRoadmap semester,
    CourseRoadmapProvider provider,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: AppDimensions.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Semester Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppDimensions.space16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radius12),
                topRight: Radius.circular(AppDimensions.radius12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  semester.semester,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppDimensions.subtitleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.space12,
                    vertical: AppDimensions.space4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppDimensions.radius8),
                  ),
                  child: Text(
                    '${semester.credits} Credits',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppDimensions.captionFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Course List
          Padding(
            padding: EdgeInsets.all(AppDimensions.space12),
            child: Column(
              children: semester.items.map((course) {
                return _buildCourseItem(course, provider);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseItem(RoadmapItem course, CourseRoadmapProvider provider) {
    final typeColor = _getTypeColor(course.type);
    final isSelected = provider.selectedCourse?.id == course.id;

    return GestureDetector(
      onTap: () => provider.selectCourse(course),
      child: Container(
        margin: EdgeInsets.only(bottom: AppDimensions.space8),
        padding: EdgeInsets.all(AppDimensions.space12),
        decoration: BoxDecoration(
          color: isSelected
              ? typeColor.withOpacity(0.2)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
          border: Border.all(
            color: isSelected ? typeColor : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Type Indicator
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color: typeColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: AppDimensions.space12),

            // Course Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        course.id,
                        style: TextStyle(
                          fontSize: AppDimensions.captionFontSize,
                          fontWeight: FontWeight.bold,
                          color: typeColor,
                        ),
                      ),
                      if (course.lab) ...[
                        SizedBox(width: AppDimensions.space8),
                        Icon(
                          Icons.science,
                          size: AppDimensions.smallIconSize,
                          color: Colors.orange,
                        ),
                      ],
                      if (course.isPlaceholder) ...[
                        SizedBox(width: AppDimensions.space8),
                        Icon(
                          Icons.help_outline,
                          size: AppDimensions.smallIconSize,
                          color: Colors.grey,
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: AppDimensions.space4),
                  Text(
                    course.title,
                    style: TextStyle(
                      fontSize: AppDimensions.bodyFontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (course.hasPrerequisites) ...[
                    SizedBox(height: AppDimensions.space4),
                    Text(
                      'Prerequisites: ${course.prerequisitesDisplay}',
                      style: TextStyle(
                        fontSize: AppDimensions.captionFontSize,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Credit Badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.space8,
                vertical: AppDimensions.space4,
              ),
              decoration: BoxDecoration(
                color: typeColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppDimensions.radius8),
              ),
              child: Text(
                '${course.credit} CR',
                style: TextStyle(
                  fontSize: AppDimensions.captionFontSize,
                  fontWeight: FontWeight.bold,
                  color: typeColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (type.toLowerCase()) {
      case 'foundation':
        return isDark ? Colors.blue.shade300 : Colors.blue.shade600;
      case 'software':
        return isDark ? Colors.green.shade300 : Colors.green.shade600;
      case 'hardware':
        return isDark ? Colors.orange.shade300 : Colors.orange.shade600;
      case 'math':
        return isDark ? Colors.purple.shade300 : Colors.purple.shade600;
      case 'specialization':
        return isDark ? Colors.pink.shade300 : Colors.pink.shade600;
      default:
        return Colors.grey;
    }
  }
}
