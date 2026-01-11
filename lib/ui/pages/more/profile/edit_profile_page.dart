import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/utils/snackbar_helper.dart';
import 'package:campuswhisper/core/utils/validators.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';
import 'package:campuswhisper/ui/widgets/custom_input.dart';
import 'package:campuswhisper/ui/widgets/user_avatar.dart';
import 'package:campuswhisper/providers/user_provider.dart';
import 'package:campuswhisper/models/user_model.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _departmentController;
  late TextEditingController _studentIdController;
  late TextEditingController _batchController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with current user data
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.currentUser;

    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _departmentController = TextEditingController(text: user?.department ?? '');
    _studentIdController = TextEditingController(text: user?.id ?? '');
    _batchController = TextEditingController(text: user?.batch ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _departmentController.dispose();
    _studentIdController.dispose();
    _batchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: DefaultAppBar(title: 'Edit Profile'),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Edit Profile',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.horizontalPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppDimensions.h24,

                // Profile Photo Section
                Center(
                  child: Stack(
                    children: [
                      UserAvatar(
                        imageUrl: null,
                        name: userProvider.userName,
                        size: 100,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _changeProfilePhoto,
                          child: Container(
                            padding: EdgeInsets.all(AppDimensions.space8),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.surface,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Iconsax.camera_outline,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                AppDimensions.h32,

                // Personal Information Section
                BuildText(
                  text: 'Personal Information',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),

                AppDimensions.h16,

                CustomInput(
                  controller: _firstNameController,
                  fieldLabel: 'First Name',
                  hintText: 'Enter your first name',
                  prefixWidget: Icon(Iconsax.user_outline),
                  validation: true,
                  errorMessage: 'Please enter your first name',
                  validatorClass: Validators.required,
                ),

                AppDimensions.h16,

                CustomInput(
                  controller: _lastNameController,
                  fieldLabel: 'Last Name',
                  hintText: 'Enter your last name',
                  prefixWidget: Icon(Iconsax.user_outline),
                  validation: true,
                  errorMessage: 'Please enter your last name',
                  validatorClass: Validators.required,
                ),

                AppDimensions.h16,

                CustomInput(
                  controller: _emailController,
                  fieldLabel: 'Email Address',
                  hintText: 'Enter your email',
                  prefixWidget: Icon(Iconsax.sms_outline),
                  validation: true,
                  errorMessage: 'Please enter a valid email address',
                  validatorClass: Validators.email,
                  inputType: TextInputType.emailAddress,
                  viewOnly: true, // Email cannot be changed
                ),

                AppDimensions.h32,

                // Academic Information Section
                BuildText(
                  text: 'Academic Information',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),

                AppDimensions.h16,

                CustomInput(
                  controller: _departmentController,
                  fieldLabel: 'Department',
                  hintText: 'Enter your department',
                  prefixWidget: Icon(Iconsax.book_outline),
                  validation: true,
                  errorMessage: 'Please enter your department',
                  validatorClass: Validators.required,
                ),

                AppDimensions.h16,

                CustomInput(
                  controller: _studentIdController,
                  fieldLabel: 'Student ID',
                  hintText: 'Enter your student ID',
                  prefixWidget: Icon(Iconsax.card_outline),
                  validation: true,
                  errorMessage: 'Please enter your student ID',
                  validatorClass: Validators.required,
                  inputType: TextInputType.number,
                  viewOnly: true, // Student ID cannot be changed
                ),

                AppDimensions.h16,

                CustomInput(
                  controller: _batchController,
                  fieldLabel: 'Batch',
                  hintText: 'Enter your batch (e.g., Spring 2020)',
                  prefixWidget: Icon(Iconsax.award_outline),
                  validation: true,
                  errorMessage: 'Please enter your batch',
                  validatorClass: Validators.required,
                ),

                AppDimensions.h32,

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
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
                              Icon(Iconsax.tick_circle_outline, size: 20),
                              AppDimensions.w8,
                              BuildText(
                                text: 'Save Changes',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onPrimary,
                              ),
                            ],
                          ),
                  ),
                ),

                AppDimensions.h24,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changeProfilePhoto() {
    // TODO: Implement image picker
    SnackbarHelper.showInfo(context, 'Photo upload coming soon');
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.currentUser;

      if (user == null) {
        throw Exception('User not found');
      }

      // Create updated user model
      final updatedUser = UserModel(
        uid: user.uid,
        id: user.id,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: user.email, // Email cannot be changed
        university: user.university,
        department: _departmentController.text.trim(),
        batch: _batchController.text.trim(),
        xp: user.xp,
        contributions: user.contributions,
        badges: user.badges,
        favoriteCourses: user.favoriteCourses,
        notifyMe: user.notifyMe,
        theme: user.theme,
        role: user.role,
        createdAt: user.createdAt,
        lastLogin: user.lastLogin,
      );

      // Update user in database
      await userProvider.updateUser(context, updatedUser);

      if (!mounted) return;

      // Go back to profile page
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      SnackbarHelper.showError(
        context,
        'Failed to update profile: ${e.toString()}',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
