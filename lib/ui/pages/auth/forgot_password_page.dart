import 'package:flutter/material.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/utils/snackbar_helper.dart';
import 'package:campuswhisper/ui/widgets/custom_input.dart';
import 'package:campuswhisper/ui/widgets/default_button.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Send Firebase password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      if (!mounted) return;

      SnackbarHelper.showSuccess(
        context,
        'Password reset link sent to ${_emailController.text}',
      );

      // Go back to login
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests. Please try again later';
          break;
        default:
          errorMessage = 'Failed to send reset email. Please try again.';
      }

      SnackbarHelper.showError(context, errorMessage);
    } catch (e) {
      if (!mounted) return;
      SnackbarHelper.showError(
        context,
        'Failed to send reset email. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const DefaultAppBar(title: 'Forgot Password'),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding,
                  vertical: AppDimensions.space24,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.lock_reset_rounded,
                      size: 80,
                      color: colorScheme.primary,
                    ),
                    AppDimensions.h24,
                    BuildText(
                      textAlign: TextAlign.center,
                      text: "Reset Your Password",
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    AppDimensions.h16,
                    BuildText(
                      textAlign: TextAlign.center,
                      text:
                          "Enter your IUB email address and we'll send you a link to reset your password.",
                      fontSize: 14,
                      color: colorScheme.onSurface.withAlpha(153),
                    ),
                    AppDimensions.h32,
                    Form(
                      key: _formKey,
                      child: CustomInput(
                        controller: _emailController,
                        fieldLabel: "Email",
                        hintText: "Enter your IUB email",
                        validation: true,
                        validatorClass: (value) {
                          final regex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@iub\.edu\.bd$',
                          );

                          if (value == null || value.isEmpty) {
                            return "Email is required";
                          } else if (!regex.hasMatch(value)) {
                            return "Enter a valid IUB email (example@iub.edu.bd)";
                          }

                          return null;
                        },
                        errorMessage: "Email is invalid",
                      ),
                    ),
                    AppDimensions.h24,
                    DefaultButton(
                      isLoading: _isLoading,
                      text: "Send Reset Link",
                      press: _resetPassword,
                    ),
                    AppDimensions.h24,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BuildText(
                          text: "Remember your password? ",
                          fontSize: 14,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: BuildText(
                            color: colorScheme.primary,
                            text: "Login",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
