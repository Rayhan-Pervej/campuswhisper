import 'package:campuswhisper/routing/app_routes.dart';
import 'package:campuswhisper/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    try {
      setLoading(true);
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = credential.user;

      if (!context.mounted) return;

      // Check if email is verified
      if (user != null && !user.emailVerified) {
        // Navigate to email verification page
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.emailVerification,
          arguments: {'email': user.email ?? emailController.text.trim()},
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please verify your email before logging in"),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Update last login timestamp
      if (user != null) {
        try {
          await _userRepository.updateLastLogin(user.uid);
        } catch (e) {
          // Log the error but don't block login
          debugPrint('Failed to update last login: $e');
        }
      }

      // Show success and navigate
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login Successful"),
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.pushReplacementNamed(
          context,
          AppRoutes.navigation,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No account found with this email';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email address';
            break;
          case 'user-disabled':
            errorMessage = 'This account has been disabled';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many login attempts. Please try again later';
            break;
          default:
            errorMessage = e.message ?? 'Login failed. Please try again';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("An error occurred: ${e.toString()}"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setLoading(false);
    }
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }
}
