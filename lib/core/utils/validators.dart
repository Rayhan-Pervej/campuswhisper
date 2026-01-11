import 'package:campuswhisper/core/constants/validation_messages.dart';

class Validators {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationMessages.emailRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return ValidationMessages.emailInvalid;
    }
    return null;
  }

  // Required field validation
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Phone number validation (Bangladesh format)
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationMessages.phoneRequired;
    }
    // Bangladesh phone: 01XXXXXXXXX (11 digits)
    final phoneRegex = RegExp(r'^01[0-9]{9}$');
    if (!phoneRegex.hasMatch(value)) {
      return ValidationMessages.phoneInvalid;
    }
    return null;
  }

  // Minimum length validation
  static String? minLength(String? value, int min, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (value.length < min) {
      return '$fieldName must be at least $min characters';
    }
    return null;
  }

  // Maximum length validation
  static String? maxLength(String? value, int max, {String fieldName = 'This field'}) {
    if (value != null && value.length > max) {
      return '$fieldName must not exceed $max characters';
    }
    return null;
  }

  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationMessages.passwordRequired;
    }
    if (value.length < 6) {
      return ValidationMessages.passwordTooShort;
    }
    return null;
  }

  // Confirm password validation
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return ValidationMessages.confirmPasswordRequired;
    }
    if (value != password) {
      return ValidationMessages.passwordMismatch;
    }
    return null;
  }

  // Number validation
  static String? number(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (double.tryParse(value) == null) {
      return ValidationMessages.numberInvalid;
    }
    return null;
  }

  // URL validation
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$'
    );
    if (!urlRegex.hasMatch(value)) {
      return ValidationMessages.urlInvalid;
    }
    return null;
  }

  // Course Routine Validators
  static String? courseId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationMessages.courseIdRequired;
    }
    return null;
  }

  static String? section(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationMessages.sectionRequired;
    }
    return null;
  }

  static String? room(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationMessages.roomRequired;
    }
    return null;
  }

  static String? startTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationMessages.startTimeRequired;
    }
    return null;
  }

  static String? endTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationMessages.endTimeRequired;
    }
    return null;
  }

  static String? semesterName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationMessages.semesterNameRequired;
    }
    return null;
  }
}
