import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/utils/snackbar_helper.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';

class CompetitionRegistrationPage extends StatefulWidget {
  final Map<String, dynamic> competition;

  const CompetitionRegistrationPage({
    super.key,
    required this.competition,
  });

  @override
  State<CompetitionRegistrationPage> createState() =>
      _CompetitionRegistrationPageState();
}

class _CompetitionRegistrationPageState
    extends State<CompetitionRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamMembersController = TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();
  bool _isLoading = false;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _teamNameController.dispose();
    _teamMembersController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  bool get isTeamBased =>
      widget.competition['isTeamBased'] == true ||
      (widget.competition['teamSize'] as String?)?.toLowerCase().contains('team') == true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Register',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.horizontalPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppDimensions.h16,

              // Competition info card
              Container(
                padding: EdgeInsets.all(AppDimensions.space16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withAlpha(51),
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  border: Border.all(
                    color: colorScheme.primary.withAlpha(77),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.cup_outline,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    AppDimensions.w12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BuildText(
                            text: widget.competition['title'] ?? 'Competition',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          AppDimensions.h4,
                          BuildText(
                            text: 'Fill the form below to register',
                            fontSize: 13,
                            color: colorScheme.onSurface.withAlpha(153),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppDimensions.h24,

              // Personal Information Section
              BuildText(
                text: 'Personal Information',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              AppDimensions.h16,

              // Full Name
              BuildText(
                text: 'Full Name',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              AppDimensions.h8,
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your full name',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withAlpha(102),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(AppDimensions.space16),
                  prefixIcon: Icon(
                    Iconsax.user_outline,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              AppDimensions.h16,

              // Email
              BuildText(
                text: 'Email Address',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              AppDimensions.h8,
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'your.email@example.com',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withAlpha(102),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(AppDimensions.space16),
                  prefixIcon: Icon(
                    Iconsax.sms_outline,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              AppDimensions.h16,

              // Phone
              BuildText(
                text: 'Phone Number',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              AppDimensions.h8,
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '+1234567890',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withAlpha(102),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(AppDimensions.space16),
                  prefixIcon: Icon(
                    Iconsax.call_outline,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              AppDimensions.h24,

              // Team Information (if team-based)
              if (isTeamBased) ...[
                Divider(color: colorScheme.onSurface.withAlpha(26)),
                AppDimensions.h24,
                BuildText(
                  text: 'Team Information',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                AppDimensions.h16,

                // Team Name
                BuildText(
                  text: 'Team Name',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                AppDimensions.h8,
                TextFormField(
                  controller: _teamNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your team name',
                    hintStyle: TextStyle(
                      color: colorScheme.onSurface.withAlpha(102),
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radius12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(AppDimensions.space16),
                    prefixIcon: Icon(
                      Iconsax.profile_2user_outline,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter team name';
                    }
                    return null;
                  },
                ),
                AppDimensions.h16,

                // Team Members
                BuildText(
                  text: 'Team Members',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                AppDimensions.h8,
                BuildText(
                  text: 'Enter names separated by commas',
                  fontSize: 12,
                  color: colorScheme.onSurface.withAlpha(153),
                ),
                AppDimensions.h8,
                TextFormField(
                  controller: _teamMembersController,
                  decoration: InputDecoration(
                    hintText: 'John Doe, Jane Smith, ...',
                    hintStyle: TextStyle(
                      color: colorScheme.onSurface.withAlpha(102),
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radius12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(AppDimensions.space16),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter team members';
                    }
                    return null;
                  },
                ),
                AppDimensions.h24,
              ],

              // Additional Information
              Divider(color: colorScheme.onSurface.withAlpha(26)),
              AppDimensions.h24,
              BuildText(
                text: 'Additional Information',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              AppDimensions.h8,
              BuildText(
                text: 'Any relevant experience or information (optional)',
                fontSize: 12,
                color: colorScheme.onSurface.withAlpha(153),
              ),
              AppDimensions.h8,
              TextField(
                controller: _additionalInfoController,
                decoration: InputDecoration(
                  hintText: 'Tell us about yourself...',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withAlpha(102),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(AppDimensions.space16),
                ),
                maxLines: 5,
              ),
              AppDimensions.h24,

              // Terms and Conditions
              Container(
                padding: EdgeInsets.all(AppDimensions.space16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreedToTerms = value ?? false;
                        });
                      },
                      activeColor: colorScheme.primary,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _agreedToTerms = !_agreedToTerms;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: AppDimensions.space12),
                          child: BuildText(
                            text:
                                'I agree to the competition terms and conditions, and confirm that the information provided is accurate.',
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppDimensions.h32,

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding:
                        EdgeInsets.symmetric(vertical: AppDimensions.space16),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radius12),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Iconsax.tick_circle_outline, size: 18),
                            AppDimensions.w8,
                            const Text(
                              'Complete Registration',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              AppDimensions.h24,

              // Info note
              Container(
                padding: EdgeInsets.all(AppDimensions.space12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppDimensions.radius8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.info_circle_outline,
                      size: 16,
                      color: colorScheme.onSurface.withAlpha(153),
                    ),
                    AppDimensions.w8,
                    Expanded(
                      child: BuildText(
                        text:
                            'You will receive a confirmation email after successful registration',
                        fontSize: 11,
                        color: colorScheme.onSurface.withAlpha(153),
                      ),
                    ),
                  ],
                ),
              ),
              AppDimensions.h24,
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      SnackbarHelper.showWarning(context, 'Please fill all required fields');
      return;
    }

    if (!_agreedToTerms) {
      SnackbarHelper.showWarning(
          context, 'Please agree to the terms and conditions');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    SnackbarHelper.showSuccess(
      context,
      'Registration successful!',
    );

    // Wait a bit then pop with success result
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    Navigator.pop(context, true);
  }
}
