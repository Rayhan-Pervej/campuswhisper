import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firebase Authentication Service
///
/// Handles all authentication operations including:
/// - Sign up / Sign in / Sign out
/// - Email verification
/// - Password reset
/// - User profile management
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ═══════════════════════════════════════════════════════════════
  // CURRENT USER
  // ═══════════════════════════════════════════════════════════════

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ═══════════════════════════════════════════════════════════════
  // SIGN UP
  // ═══════════════════════════════════════════════════════════════

  /// Sign up with email and password
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
    required String studentId,
    required String department,
    required String batch,
  }) async {
    try {
      // Create user account
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      // Create user document in Firestore
      await _createUserDocument(
        userId: userCredential.user!.uid,
        email: email,
        name: name,
        studentId: studentId,
        department: department,
        batch: batch,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException(
        message: 'Failed to sign up',
        code: 'SIGNUP_FAILED',
        originalError: e,
      );
    }
  }

  /// Create user document in Firestore
  Future<void> _createUserDocument({
    required String userId,
    required String email,
    required String name,
    required String studentId,
    required String department,
    required String batch,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'user_id': userId,
        'email': email,
        'name': name,
        'student_id': studentId,
        'department': department,
        'batch': batch,
        'bio': '',
        'avatar_url': '',
        'cover_url': '',
        'xp': 0,
        'level': 1,
        'badges': [],
        'is_verified': false,
        'is_active': true,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw AuthException(
        message: 'Failed to create user profile',
        code: 'PROFILE_CREATION_FAILED',
        originalError: e,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // SIGN IN
  // ═══════════════════════════════════════════════════════════════

  /// Sign in with email and password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException(
        message: 'Failed to sign in',
        code: 'SIGNIN_FAILED',
        originalError: e,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // SIGN OUT
  // ═══════════════════════════════════════════════════════════════

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException(
        message: 'Failed to sign out',
        code: 'SIGNOUT_FAILED',
        originalError: e,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // EMAIL VERIFICATION
  // ═══════════════════════════════════════════════════════════════

  /// Send email verification
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      throw AuthException(
        message: 'Failed to send verification email',
        code: 'VERIFICATION_FAILED',
        originalError: e,
      );
    }
  }

  /// Check if email is verified
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  /// Reload user to check verification status
  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
    } catch (e) {
      throw AuthException(
        message: 'Failed to reload user',
        code: 'RELOAD_FAILED',
        originalError: e,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // PASSWORD RESET
  // ═══════════════════════════════════════════════════════════════

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException(
        message: 'Failed to send password reset email',
        code: 'PASSWORD_RESET_FAILED',
        originalError: e,
      );
    }
  }

  /// Change password for current user
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw AuthException(
          message: 'No user signed in',
          code: 'NO_USER',
        );
      }

      // Re-authenticate user before changing password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException(
        message: 'Failed to change password',
        code: 'PASSWORD_CHANGE_FAILED',
        originalError: e,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // PROFILE UPDATES
  // ═══════════════════════════════════════════════════════════════

  /// Update display name
  Future<void> updateDisplayName(String displayName) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
    } catch (e) {
      throw AuthException(
        message: 'Failed to update display name',
        code: 'UPDATE_NAME_FAILED',
        originalError: e,
      );
    }
  }

  /// Update photo URL
  Future<void> updatePhotoURL(String photoURL) async {
    try {
      await _auth.currentUser?.updatePhotoURL(photoURL);
    } catch (e) {
      throw AuthException(
        message: 'Failed to update photo',
        code: 'UPDATE_PHOTO_FAILED',
        originalError: e,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ACCOUNT DELETION
  // ═══════════════════════════════════════════════════════════════

  /// Delete user account
  Future<void> deleteAccount({
    required String password,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw AuthException(
          message: 'No user signed in',
          code: 'NO_USER',
        );
      }

      // Re-authenticate user before deletion
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      // Delete user document from Firestore
      await _firestore.collection('users').doc(user.uid).delete();

      // Delete user account
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException(
        message: 'Failed to delete account',
        code: 'ACCOUNT_DELETION_FAILED',
        originalError: e,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ERROR HANDLING
  // ═══════════════════════════════════════════════════════════════

  /// Handle Firebase Auth exceptions
  AuthException _handleAuthException(FirebaseAuthException e) {
    String message;
    String code = e.code;

    switch (e.code) {
      case 'email-already-in-use':
        message = 'This email is already registered';
        break;
      case 'invalid-email':
        message = 'Invalid email address';
        break;
      case 'operation-not-allowed':
        message = 'Email/password accounts are not enabled';
        break;
      case 'weak-password':
        message = 'Password is too weak';
        break;
      case 'user-disabled':
        message = 'This account has been disabled';
        break;
      case 'user-not-found':
        message = 'No account found with this email';
        break;
      case 'wrong-password':
        message = 'Incorrect password';
        break;
      case 'invalid-credential':
        message = 'Invalid credentials';
        break;
      case 'too-many-requests':
        message = 'Too many attempts. Please try again later';
        break;
      case 'network-request-failed':
        message = 'Network error. Check your connection';
        break;
      default:
        message = e.message ?? 'Authentication failed';
    }

    return AuthException(
      message: message,
      code: code,
      originalError: e,
    );
  }
}

/// Authentication exception
class AuthException implements Exception {
  final String message;
  final String code;
  final dynamic originalError;

  AuthException({
    required this.message,
    required this.code,
    this.originalError,
  });

  @override
  String toString() => 'AuthException: $message (Code: $code)';
}
