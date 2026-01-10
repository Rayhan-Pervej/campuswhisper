import 'dart:io';

import 'package:campuswhisper/ui/widgets/default_appbar.dart';
import 'package:campuswhisper/ui/widgets/faq_tile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/build_text.dart';
import '../../../models/scholarship_result_model.dart';
import '../../../providers/scholarship_provider.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../widgets/custom_file_input.dart';

class ScholarshipPage extends StatelessWidget {
  const ScholarshipPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: DefaultAppBar(title: "Scholarship"),
      body: Consumer<ScholarshipProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.horizontalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppDimensions.h16,
                  _buildHeader(colorScheme, theme, provider),
                  AppDimensions.h16,

                  // Error message display
                  if (provider.errorMessage != null) ...[
                    _buildErrorMessage(provider.errorMessage!, colorScheme),
                    AppDimensions.h16,
                  ],

                  // File upload section
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
                    onClear: () => provider.resetData(),
                  ),

                  // AppDimensions.h16,

                  // DefaultButton(
                  //   isLoading: provider.isLoading,
                  //   text: "Check Scholarship",
                  //   press: () {
                  //     // Show file picker manually if needed
                  //     _showFilePicker(context, provider);
                  //   },
                  // ),
                  AppDimensions.h16,

                  // Scholarship results
                  if (provider.hasScholarshipResult) ...[
                    _buildScholarshipResults(provider, colorScheme),
                    AppDimensions.h16,
                  ],

                  _buildScholarshipDescription(provider),
                  AppDimensions.h16,
                  _buildFaq(provider),
                  AppDimensions.h16,
                ],
              ),
            ),
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

  Widget _buildScholarshipResults(
    ScholarshipProvider provider,
    ColorScheme colorScheme,
  ) {
    final result = provider.scholarshipResult!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: .2),
            blurRadius: AppDimensions.space4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                result.isEligible ? Icons.check_circle : Icons.cancel,
                color: result.isEligible
                    ? colorScheme.primary
                    : colorScheme.error,
                size: 24,
              ),
              SizedBox(width: AppDimensions.space8),
              Expanded(
                child: BuildText(
                  text: result.isEligible
                      ? "Scholarship Eligible!"
                      : "Not Eligible",
                  fontSize: AppDimensions.titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: result.isEligible
                      ? colorScheme.primary
                      : colorScheme.error,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.space12),
          BuildText(
            text: result.summaryMessage,
            fontSize: AppDimensions.bodyFontSize,
            color: result.isEligible
                ? colorScheme.onSurface
                : colorScheme.error,
          ),

          if (result.isEligible) ...[
            SizedBox(height: AppDimensions.space16),
            _buildMaintenanceRequirements(result, colorScheme),
          ],

          if (result.requirementsUnmet.isNotEmpty) ...[
            SizedBox(height: AppDimensions.space16),
            _buildUnmetRequirements(result, colorScheme),
          ],
        ],
      ),
    );
  }

  Widget _buildMaintenanceRequirements(
    ScholarshipResult result,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.space12),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(AppDimensions.radius8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildText(
            text: "Maintenance Requirements:",
            fontSize: AppDimensions.subtitleFontSize,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          SizedBox(height: AppDimensions.space8),
          BuildText(
            text: result.maintenanceRequirement.description,
            fontSize: AppDimensions.bodyFontSize,
            color: colorScheme.onSurface,
          ),
        ],
      ),
    );
  }

  Widget _buildUnmetRequirements(
    ScholarshipResult result,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildText(
          text: "Requirements to meet:",
          fontSize: AppDimensions.subtitleFontSize,
          fontWeight: FontWeight.w600,
          color: colorScheme.error,
        ),
        SizedBox(height: AppDimensions.space8),
        ...result.requirementsUnmet.map(
          (requirement) => Padding(
            padding: EdgeInsets.only(bottom: AppDimensions.space4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildText(
                  text: "• ",
                  fontSize: AppDimensions.bodyFontSize,
                  color: colorScheme.error,
                ),
                Expanded(
                  child: BuildText(
                    text: requirement,
                    fontSize: AppDimensions.bodyFontSize * 0.9,
                    color: colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFaq(ScholarshipProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildText(
          text: "Frequently Asked Questions",
          fontSize: AppDimensions.titleFontSize,
          fontWeight: FontWeight.w500,
        ),
        AppDimensions.h16,
        FaqTile(
          question: "How many credits do I have to take for Scholarship?",
          answer:
              "You have to maintain minimum 12 credits each semester for scholarship. You also need to complete at least 36 credit hours before becoming eligible.",
          isExpanded: provider.isExpand,
          onTap: provider.expandFaq,
        ),
        AppDimensions.h8,
        FaqTile(
          question: "What CGPA do I need for merit scholarship?",
          answer:
              "CGPA 3.70-3.79: 30%, CGPA 3.80-3.85: 50%, CGPA 3.86-3.94: 75%, CGPA 3.95-4.00: 100% tuition fee waiver.",
          isExpanded: provider.isExpand,
          onTap: provider.expandFaq,
        ),
        AppDimensions.h8,
        FaqTile(
          question: "If I drop a semester, will my scholarship be gone?",
          answer:
              "Your scholarship will be discontinued if you drop courses and your credits fall below the minimum requirement of 12 credits per semester, unless it's for medical reasons with proper documentation.",
          isExpanded: provider.isExpand,
          onTap: provider.expandFaq,
        ),
        AppDimensions.h8,
        FaqTile(
          question:
              "When does merit scholarship based on semester result apply?",
          answer:
              "This scholarship is applicable for all undergraduates from Autumn 2022 onwards, after completion of 36 credit hours with the required CGPA.",
          isExpanded: provider.isExpand,
          onTap: provider.expandFaq,
        ),
      ],
    );
  }

  Widget _buildScholarshipDescription(ScholarshipProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildText(
          text: "Scholarship Information",
          fontSize: AppDimensions.titleFontSize,
          fontWeight: FontWeight.w500,
        ),
        AppDimensions.h8,
        if (provider.hasScholarshipResult &&
            provider.scholarshipResult!.isEligible)
          BuildText(
            text: provider.scholarshipResult!.scholarshipType,
            fontSize: AppDimensions.subtitleFontSize,
            fontWeight: FontWeight.w500,
          )
        else
          BuildText(
            text: "Upload transcript to check eligibility",
            fontSize: AppDimensions.subtitleFontSize,
            fontWeight: FontWeight.w400,
          ),
      ],
    );
  }

  Widget _buildHeader(
    ColorScheme colorScheme,
    ThemeData theme,
    ScholarshipProvider provider,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: .2),
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
                text: 'Scholarship',
                fontSize: AppDimensions.titleFontSize,
                fontWeight: FontWeight.w500,
              ),
              BuildText(
                text: 'Approximate',
                fontSize: AppDimensions.bodyFontSize * .7,
                fontWeight: FontWeight.w400,
              ),
              BuildText(
                text: provider.displayScholarshipPercentage,
                color:
                    provider.hasScholarshipResult &&
                        provider.scholarshipResult!.isEligible
                    ? colorScheme.primary
                    : colorScheme.outline,
                fontSize:
                    provider.hasScholarshipResult &&
                        provider.scholarshipResult!.isEligible
                    ? AppDimensions.titleFontSize * 1.5
                    : AppDimensions.titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BuildText(
                text: 'Credits Earned: ${provider.displayCreditsEarned}',
                fontSize: AppDimensions.subtitleFontSize,
                fontWeight: FontWeight.w500,
              ),
              BuildText(
                text: 'CGPA: ${provider.displayCGPA}',
                fontSize: AppDimensions.subtitleFontSize,
                fontWeight: FontWeight.w500,
              ),
              if (provider.hasValidTranscript) ...[
                SizedBox(height: AppDimensions.space4),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.space8,
                    vertical: AppDimensions.space4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(AppDimensions.radius8),
                  ),
                  child: BuildText(
                    text: 'Verified',
                    fontSize: AppDimensions.bodyFontSize * 0.8,
                    color: colorScheme.onSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
