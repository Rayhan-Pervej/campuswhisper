import 'dart:async';
import 'package:flutter/material.dart';
import 'package:campuswhisper/core/constants/build_text.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:campuswhisper/core/utils/snackbar_helper.dart';
import 'package:campuswhisper/ui/widgets/default_button.dart';
import 'package:campuswhisper/ui/widgets/default_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campuswhisper/routing/app_routes.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;

  const EmailVerificationPage({
    super.key,
    required this.email,
  });

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool _isResending = false;
  Timer? _timer;
  int _resendCooldown = 0;

  @override
  void initState() {
    super.initState();
    _startVerificationCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startVerificationCheck() {
    // Check verification status every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await _checkEmailVerification();
    });
  }

  Future<void> _checkEmailVerification() async {
    try {
      // Check Firebase email verification status
      final user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      final isVerified = user?.emailVerified ?? false;

      if (isVerified) {
        _timer?.cancel();
        if (!mounted) return;

        SnackbarHelper.showSuccess(
          context,
          'Email verified successfully!',
        );

        // Navigate to home page
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.navigation,
          (route) => false,
        );
      }
    } catch (e) {
      // Silently fail - user can manually resend
    }
  }

  Future<void> _resendVerificationEmail() async {
    if (_resendCooldown > 0) {
      SnackbarHelper.showInfo(
        context,
        'Please wait $_resendCooldown seconds before resending',
      );
      return;
    }

    setState(() => _isResending = true);

    try {
      // Resend verification email via Firebase
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();

      if (!mounted) return;

      SnackbarHelper.showSuccess(
        context,
        'Verification email sent to ${widget.email}',
      );

      // Start cooldown
      setState(() => _resendCooldown = 60);
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_resendCooldown > 0) {
          setState(() => _resendCooldown--);
        } else {
          timer.cancel();
        }
      });
    } catch (e) {
      if (!mounted) return;
      SnackbarHelper.showError(
        context,
        'Failed to resend email. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  void _backToLogin() async {
    // Sign out user
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _backToLogin();
        }
      },
      child: Scaffold(
        appBar: DefaultAppBar(
          title: 'Verify Email',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _backToLogin,
          ),
        ),
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
                    // Email icon
                    Container(
                      padding: EdgeInsets.all(AppDimensions.space24),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withAlpha(26),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.email_outlined,
                        size: 80,
                        color: colorScheme.primary,
                      ),
                    ),
                    AppDimensions.h32,

                    // Title
                    BuildText(
                      textAlign: TextAlign.center,
                      text: "Verify Your Email",
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    AppDimensions.h16,

                    // Description
                    BuildText(
                      textAlign: TextAlign.center,
                      text:
                          "We've sent a verification link to:",
                      fontSize: 14,
                      color: colorScheme.onSurface.withAlpha(153),
                    ),
                    AppDimensions.h8,

                    // Email
                    BuildText(
                      textAlign: TextAlign.center,
                      text: widget.email,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                    AppDimensions.h24,

                    // Instructions
                    Container(
                      padding: EdgeInsets.all(AppDimensions.space16),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(AppDimensions.radius12),
                        border: Border.all(
                          color: colorScheme.onSurface.withAlpha(51),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInstructionItem(
                            colorScheme,
                            "1. Check your inbox (and spam folder)",
                          ),
                          AppDimensions.h8,
                          _buildInstructionItem(
                            colorScheme,
                            "2. Click the verification link in the email",
                          ),
                          AppDimensions.h8,
                          _buildInstructionItem(
                            colorScheme,
                            "3. This page will automatically update",
                          ),
                        ],
                      ),
                    ),
                    AppDimensions.h32,

                    // Resend button
                    _resendCooldown > 0
                        ? Opacity(
                            opacity: 0.5,
                            child: DefaultButton(
                              text: "Resend in ${_resendCooldown}s",
                              press: () {},
                            ),
                          )
                        : DefaultButton(
                            isLoading: _isResending,
                            text: "Resend Verification Email",
                            press: _resendVerificationEmail,
                          ),
                    AppDimensions.h16,

                    // Back to login
                    TextButton(
                      onPressed: _backToLogin,
                      child: BuildText(
                        text: "Back to Login",
                        fontSize: 14,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildInstructionItem(ColorScheme colorScheme, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 20,
          color: colorScheme.primary,
        ),
        AppDimensions.w8,
        Expanded(
          child: BuildText(
            text: text,
            fontSize: 14,
            color: colorScheme.onSurface.withAlpha(179),
          ),
        ),
      ],
    );
  }
}
