import 'dart:io';

import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/models/course_input_model.dart';
import 'package:campuswhisper/providers/cgpa_calculator_provider.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/ui/widgets/custom_dropdown.dart';
import 'package:campuswhisper/ui/widgets/custom_file_input.dart';
import 'package:campuswhisper/ui/widgets/custom_input.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';
import 'package:campuswhisper/ui/widgets/default_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class CgpaCalculatorPage extends StatelessWidget {
  const CgpaCalculatorPage({super.key});

  // Convert GradeOption to DropdownItem
  List<DropdownItem<String>> get gradeOptions {
    return GradeOption.allGrades
        .map((grade) => DropdownItem(value: grade.value, text: grade.text))
        .toList();
  }

  // Convert CreditOption to DropdownItem
  List<DropdownItem<String>> get creditOptions {
    return CreditOption.allCredits
        .map((credit) => DropdownItem(value: credit.value, text: credit.text))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: DefaultAppBar(title: "CGPA Calculator"),
      body: Consumer<CgpaCalculatorProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding,
                  vertical: AppDimensions.space4,
                ),
                child: _buildCgpaDisplayCard(colorScheme, theme, provider),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Error message display
                        if (provider.errorMessage != null) ...[
                          _buildErrorMessage(
                            provider.errorMessage!,
                            colorScheme,
                          ),
                          AppDimensions.h16,
                        ],

                        // File upload
                        CustomFileInput(
                          fieldLabel: 'Upload Transcript',
                          hintText: 'Upload Transcript (PDF)',
                          validation: provider.errorMessage != null,
                          errorMessage:
                              provider.errorMessage ??
                              'Please select a transcript file',
                          fileType: FileType.custom,
                          allowedExtensions: ['pdf'],
                          allowMultiple: false,
                          prefixWidget: Icon(
                            Iconsax.document_upload_outline,
                            color: colorScheme.onSurface.withAlpha(153),
                          ),
                          maxFileSizeInMB: 5,
                          onChanged: (File? file) {
                            if (file != null) {
                              provider.uploadAndProcessTranscript(file);
                            }
                          },
                          onClear: () {
                            provider.clearTranscriptData();
                          },
                        ),

                        AppDimensions.h16,

                        if (provider.isLoading)
                          _buildLoadingIndicator()
                        else ...[
                          _buildSectionHeader(
                            'Regular Courses',
                            colorScheme,
                            theme,
                          ),
                          AppDimensions.h16,

                          // Regular courses using provider's list
                          ...List.generate(provider.regularCourses.length, (
                            index,
                          ) {
                            return Container(
                              key: Key(
                                provider.regularCourses[index].id,
                              ), // Add this line
                              child: _buildCourseRow(
                                index,
                                colorScheme,
                                theme,
                                provider,
                              ),
                            );
                          }),

                          AppDimensions.h16,
                          _buildAddButton(
                            'Add Course',
                            Iconsax.add_circle_outline,
                            () => provider.addRegularCourse(),
                            colorScheme,
                            theme,
                          ),
                          AppDimensions.h16,

                          _buildSectionHeader(
                            'Retake Courses',
                            colorScheme,
                            theme,
                          ),
                          AppDimensions.h16,

                          // Retake courses
                          if (provider.retakeCourses.isEmpty)
                            _buildEmptyRetakeState(colorScheme, theme)
                          else
                            ...List.generate(provider.retakeCourses.length, (
                              index,
                            ) {
                              return Container(
                                key: Key(
                                  provider.retakeCourses[index].id,
                                ), // Add this line
                                child: _buildRetakeCourseRow(
                                  index,
                                  colorScheme,
                                  theme,
                                  provider,
                                ),
                              );
                            }),

                          AppDimensions.h16,
                          _buildAddButton(
                            'Add Retake Course',
                            Iconsax.refresh_circle_outline,
                            () => provider.addRetakeCourse(),
                            colorScheme,
                            theme,
                          ),
                          AppDimensions.h16,

                          // Clear calculations button
                          if (provider.hasValidCalculations) ...[
                            DefaultButton(
                              text: "Clear All Calculations",
                              press: () => provider.clearCalculations(),
                              btnTextColor: colorScheme.error,
                              bgColor: Colors.transparent,
                              borderColor: colorScheme.error,
                            ),
                            AppDimensions.h16,
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorMessage(String message, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radius8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.onErrorContainer,
            size: 20,
          ),
          SizedBox(width: AppDimensions.space8),
          Expanded(
            child: BuildText(
              text: message,
              color: colorScheme.onErrorContainer,
              fontSize: AppDimensions.bodyFontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.space24),
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: AppDimensions.space16),
            BuildText(
              text: "Processing transcript...",
              fontSize: AppDimensions.bodyFontSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyRetakeState(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.space24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        border: Border.all(
          color: colorScheme.onSurface.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Iconsax.refresh_circle_outline,
            size: 48,
            color: colorScheme.onSurface.withOpacity(0.4),
          ),
          AppDimensions.h12,
          Text(
            'No Retake Courses',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          AppDimensions.h8,
          Text(
            'Add retake courses to improve your CGPA',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.4),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRetakeCourseRow(
    int index,
    ColorScheme colorScheme,
    ThemeData theme,
    CgpaCalculatorProvider provider,
  ) {
    final retakeCourse = provider.retakeCourses[index];

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: AppDimensions.space16),
          padding: EdgeInsets.all(AppDimensions.space16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radius12),
            border: Border.all(
              color: colorScheme.secondary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              CustomInput(
                controller: retakeCourse.nameController,
                fieldLabel: 'Course Name (Optional)',
                hintText: 'e.g., CSE101',
                validation: false,
                conentPaddingVertical: 0,
                errorMessage: '',
                prefixWidget: Icon(
                  Iconsax.refresh_circle_outline,
                  color: colorScheme.secondary,
                ),
                onChanged: (_) => provider.updateRetakeCourse(index),
              ),

              AppDimensions.h8,
              CustomDropdown<String>(
                fieldLabel: 'Credit*',
                hintText: 'Select',
                validation: retakeCourse.selectedCredit == null,
                errorMessage: 'Credit is required',
                items: creditOptions,
                selectedValue: retakeCourse.selectedCredit,
                conentPaddingVertical: 10,
                prefixWidget: Icon(
                  Iconsax.medal_outline,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
                onChanged: (value) {
                  retakeCourse.selectedCredit = value;
                  provider.updateRetakeCourse(index);
                },
              ),
              AppDimensions.h8,
              Row(
                children: [
                  Expanded(
                    child: CustomDropdown<String>(
                      fieldLabel: 'Previous Grade*',
                      hintText: 'Select',
                      validation: retakeCourse.selectedPreviousGrade == null,
                      errorMessage: 'Required',
                      items: gradeOptions,
                      conentPaddingVertical: 10,
                      selectedValue: retakeCourse.selectedPreviousGrade,
                      prefixWidget: Icon(
                        Iconsax.backward_outline,
                        color: colorScheme.error.withOpacity(0.7),
                      ),
                      onChanged: (value) {
                        retakeCourse.selectedPreviousGrade = value;
                        provider.updateRetakeCourse(index);
                      },
                    ),
                  ),

                  AppDimensions.w12,

                  Expanded(
                    child: CustomDropdown<String>(
                      fieldLabel: 'New Grade*',
                      hintText: 'Select',
                      validation: retakeCourse.selectedNewGrade == null,
                      errorMessage: 'Required',
                      items: gradeOptions,
                      conentPaddingVertical: 10,
                      selectedValue: retakeCourse.selectedNewGrade,
                      prefixWidget: Icon(
                        Iconsax.star_outline,
                        color: colorScheme.primary,
                      ),
                      onChanged: (value) {
                        retakeCourse.selectedNewGrade = value;
                        provider.updateRetakeCourse(index);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: () => provider.removeRetakeCourse(index),
            icon: Icon(
              Iconsax.trash_outline,
              color: colorScheme.error,
              size: AppDimensions.size16,
            ),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.error.withOpacity(0.1),
              minimumSize: Size.fromRadius(AppDimensions.radius4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(
    String text,
    IconData icon,
    VoidCallback onPressed,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return DefaultButton(
      text: text,
      press: onPressed,
      btnTextColor: colorScheme.primary,
      bgColor: Colors.transparent,
      borderColor: colorScheme.primary,
    );
  }

  Widget _buildCourseRow(
    int index,
    ColorScheme colorScheme,
    ThemeData theme,
    CgpaCalculatorProvider provider,
  ) {
    final course = provider.regularCourses[index];

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: AppDimensions.space16),
          padding: EdgeInsets.all(AppDimensions.space16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radius12),
            border: Border.all(
              color: colorScheme.onSurface.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              CustomInput(
                controller: course.nameController,
                fieldLabel: 'Course Name (Optional)',
                hintText: 'e.g., CSE101',
                validation: false,
                errorMessage: '',
                conentPaddingVertical: 0,
                textInputAction: TextInputAction.done,
                prefixWidget: Icon(
                  Iconsax.book_outline,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
                onChanged: (_) => provider.updateRegularCourse(index),
              ),

              AppDimensions.h8,

              Row(
                children: [
                  Expanded(
                    child: CustomDropdown<String>(
                      fieldLabel: 'Credit*',
                      hintText: 'Select',
                      validation: course.selectedCredit == null,
                      errorMessage: 'Credit is required',
                      items: creditOptions,
                      selectedValue: course.selectedCredit,
                      conentPaddingVertical: 10,
                      prefixWidget: Icon(
                        Iconsax.medal_outline,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      onChanged: (value) {
                        course.selectedCredit = value;
                        provider.updateRegularCourse(index);
                      },
                    ),
                  ),

                  AppDimensions.w8,

                  Expanded(
                    child: CustomDropdown<String>(
                      fieldLabel: 'Grade*',
                      hintText: 'Select',
                      validation: course.selectedGrade == null,
                      errorMessage: 'Grade is required',
                      items: gradeOptions,
                      selectedValue: course.selectedGrade,
                      conentPaddingVertical: 10,
                      prefixWidget: Icon(
                        Iconsax.star_outline,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      onChanged: (value) {
                        course.selectedGrade = value;
                        provider.updateRegularCourse(index);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        if (provider.regularCourses.length > 1)
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () => provider.removeRegularCourse(index),
              icon: Icon(
                Iconsax.trash_outline,
                color: colorScheme.error,
                size: AppDimensions.size16,
              ),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.error.withOpacity(0.1),
                minimumSize: Size.fromRadius(AppDimensions.radius4),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCgpaDisplayCard(
    ColorScheme colorScheme,
    ThemeData theme,
    CgpaCalculatorProvider provider,
  ) {
    // Show calculated CGPA if we have any valid calculations, even without transcript
    bool showCalculated = provider.hasValidCalculations;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withOpacity(0.2),
            blurRadius: AppDimensions.space4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildText(
                text: showCalculated ? 'Calculated CGPA' : 'Current CGPA',
                fontSize: AppDimensions.titleFontSize,
                fontWeight: FontWeight.w500,
              ),
              if (provider.hasTranscriptData && showCalculated) ...[
                BuildText(
                  text: 'Original: ${provider.displayCurrentCgpa}',
                  fontSize: AppDimensions.bodyFontSize * 0.8,
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                ),
              ],
              BuildText(
                text: showCalculated
                    ? provider.displayCalculatedCgpa
                    : (provider.hasTranscriptData
                          ? provider.displayCurrentCgpa
                          : '0.00'),
                color: colorScheme.primary,
                fontSize: AppDimensions.titleFontSize * 1.5,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BuildText(
                text:
                    'Credits: ${showCalculated ? provider.displayTotalCalculatedCredits : (provider.hasTranscriptData ? provider.displayCreditsEarned : "0")}',
                fontSize: AppDimensions.subtitleFontSize,
                fontWeight: FontWeight.w500,
              ),
              AppDimensions.h8,
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.space8,
                  vertical: AppDimensions.space4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(AppDimensions.radius8),
                ),

                child: BuildText(
                  text: showCalculated || provider.hasTranscriptData
                      ? provider.currentAcademicStatus
                      : "N/A",
                  fontSize: AppDimensions.subtitleFontSize,
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        AppDimensions.w12,
        BuildText(
          text: title,
          fontSize: AppDimensions.titleFontSize,
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
