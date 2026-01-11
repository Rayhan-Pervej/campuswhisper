import 'package:flutter/material.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';
import 'package:icons_plus/icons_plus.dart';

class ReportPage extends StatefulWidget {
  final String contentId;
  final String contentType; // 'post', 'comment', 'event', 'user', etc.
  final String? contentTitle;

  const ReportPage({
    super.key,
    required this.contentId,
    required this.contentType,
    this.contentTitle,
  });

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String? _selectedReason;
  final TextEditingController _detailsController = TextEditingController();
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _reportReasons = [
    {
      'value': 'spam',
      'label': 'Spam or misleading',
      'icon': Iconsax.message_remove_outline,
      'description': 'Repetitive or commercial content',
    },
    {
      'value': 'harassment',
      'label': 'Harassment or hate speech',
      'icon': Iconsax.danger_outline,
      'description': 'Abusive or threatening behavior',
    },
    {
      'value': 'inappropriate',
      'label': 'Inappropriate content',
      'icon': Iconsax.close_circle_outline,
      'description': 'Violates community guidelines',
    },
    {
      'value': 'misinformation',
      'label': 'False information',
      'icon': Iconsax.info_circle_outline,
      'description': 'Spreading misinformation',
    },
    {
      'value': 'violence',
      'label': 'Violence or dangerous',
      'icon': Iconsax.warning_2_outline,
      'description': 'Promotes violence or harm',
    },
    {
      'value': 'privacy',
      'label': 'Privacy violation',
      'icon': Iconsax.lock_outline,
      'description': 'Shares private information',
    },
    {
      'value': 'other',
      'label': 'Other',
      'icon': Iconsax.more_circle_outline,
      'description': 'Something else',
    },
  ];

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a reason for reporting'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // TODO: Implement actual report submission to backend
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report submitted successfully. We\'ll review it soon.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Report ${widget.contentType}',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Container(
              padding: EdgeInsets.all(AppDimensions.space16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppDimensions.radius12),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.shield_tick_outline,
                    color: colorScheme.primary,
                    size: AppDimensions.mediumIconSize,
                  ),
                  AppDimensions.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Help us keep CampusWhisper safe',
                          style: TextStyle(
                            fontSize: AppDimensions.subtitleFontSize,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        AppDimensions.h4,
                        Text(
                          'Your report is anonymous and helps us maintain a positive community',
                          style: TextStyle(
                            fontSize: AppDimensions.captionFontSize,
                            color: colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            AppDimensions.h24,

            // Report Reasons Title
            Text(
              'Why are you reporting this?',
              style: TextStyle(
                fontSize: AppDimensions.subtitleFontSize,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),

            AppDimensions.h12,

            // Report Reasons List
            ...List.generate(_reportReasons.length, (index) {
              final reason = _reportReasons[index];
              final isSelected = _selectedReason == reason['value'];

              return Padding(
                padding: EdgeInsets.only(bottom: AppDimensions.space8),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedReason = reason['value'];
                    });
                  },
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  child: Container(
                    padding: EdgeInsets.all(AppDimensions.space16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outline.withAlpha(77),
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(AppDimensions.radius12),
                      color: isSelected
                          ? colorScheme.primary.withAlpha(26)
                          : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          reason['icon'],
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface.withAlpha(153),
                          size: AppDimensions.mediumIconSize,
                        ),
                        AppDimensions.w12,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reason['label'],
                                style: TextStyle(
                                  fontSize: AppDimensions.bodyFontSize,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              AppDimensions.h4,
                              Text(
                                reason['description'],
                                style: TextStyle(
                                  fontSize: AppDimensions.captionFontSize,
                                  color: colorScheme.onSurface.withAlpha(153),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Iconsax.tick_circle_bold,
                            color: colorScheme.primary,
                            size: AppDimensions.mediumIconSize,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            AppDimensions.h24,

            // Additional Details (Optional)
            Text(
              'Additional details (optional)',
              style: TextStyle(
                fontSize: AppDimensions.subtitleFontSize,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),

            AppDimensions.h12,

            TextField(
              controller: _detailsController,
              maxLines: 5,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Provide any additional information that might help us...',
                hintStyle: TextStyle(
                  color: colorScheme.onSurface.withAlpha(102),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  borderSide: BorderSide(color: colorScheme.outline.withAlpha(77)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
                filled: true,
                fillColor: colorScheme.surface,
                contentPadding: EdgeInsets.all(AppDimensions.space16),
              ),
            ),

            AppDimensions.h32,

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: colorScheme.onSurface.withAlpha(31),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? SizedBox(
                        height: AppDimensions.mediumIconSize,
                        width: AppDimensions.mediumIconSize,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Text(
                        'Submit Report',
                        style: TextStyle(
                          fontSize: AppDimensions.bodyFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            AppDimensions.h16,

            // Privacy Note
            Center(
              child: Text(
                'Your report is confidential and anonymous',
                style: TextStyle(
                  fontSize: AppDimensions.captionFontSize,
                  color: colorScheme.onSurface.withAlpha(102),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            AppDimensions.h24,
          ],
        ),
      ),
    );
  }
}
