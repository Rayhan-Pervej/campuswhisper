class ErrorMessages {
  // General Errors
  static const String somethingWentWrong = 'Something went wrong. Please try again.';
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unknown error occurred.';

  // Authentication Errors
  static const String invalidCredentials = 'Invalid email or password.';
  static const String emailAlreadyExists = 'This email is already registered.';
  static const String weakPassword = 'Password is too weak. Use at least 6 characters.';
  static const String userNotFound = 'No account found with this email.';
  static const String emailNotVerified = 'Please verify your email address first.';
  static const String accountDisabled = 'This account has been disabled.';

  // Form Errors
  static const String requiredField = 'This field is required.';
  static const String invalidEmail = 'Please enter a valid email address.';
  static const String invalidPhone = 'Please enter a valid phone number.';
  static const String passwordMismatch = 'Passwords do not match.';
  static const String passwordTooShort = 'Password must be at least 6 characters.';
  static const String invalidUrl = 'Please enter a valid URL.';

  // File Upload Errors
  static const String fileTooLarge = 'File size exceeds the maximum limit.';
  static const String invalidFileType = 'Invalid file type. Please select a valid file.';
  static const String uploadFailed = 'File upload failed. Please try again.';
  static const String noFileSelected = 'No file selected.';

  // Data Errors
  static const String dataNotFound = 'Requested data not found.';
  static const String noDataAvailable = 'No data available at the moment.';
  static const String loadFailed = 'Failed to load data. Please try again.';
  static const String saveFailed = 'Failed to save. Please try again.';
  static const String deleteFailed = 'Failed to delete. Please try again.';
  static const String updateFailed = 'Failed to update. Please try again.';

  // Permission Errors
  static const String permissionDenied = 'Permission denied.';
  static const String cameraPermissionDenied = 'Camera permission is required.';
  static const String storagePermissionDenied = 'Storage permission is required.';
  static const String locationPermissionDenied = 'Location permission is required.';

  // Feature-Specific Errors
  static const String eventNotFound = 'Event not found.';
  static const String competitionNotFound = 'Competition not found.';
  static const String postNotFound = 'Post not found.';
  static const String commentNotFound = 'Comment not found.';
  static const String clubNotFound = 'Club not found.';

  // Action Errors
  static const String alreadyRegistered = 'You are already registered for this event.';
  static const String registrationClosed = 'Registration is closed.';
  static const String eventFull = 'This event is full.';
  static const String cannotDeleteOwnComment = 'Cannot delete your own comment.';
  static const String cannotEditAfterDeadline = 'Cannot edit after the deadline.';

  // Validation Errors
  static const String invalidDateRange = 'Invalid date range.';
  static const String pastDateNotAllowed = 'Past dates are not allowed.';
  static const String invalidInput = 'Invalid input provided.';
  static const String tooManyAttempts = 'Too many attempts. Please try again later.';

  // Search Errors
  static const String searchFailed = 'Search failed. Please try again.';
  static const String noResultsFound = 'No results found.';
  static const String searchQueryTooShort = 'Search query is too short.';

  // ═══════════════════════════════════════════════════════════════
  // SUCCESS MESSAGES
  // ═══════════════════════════════════════════════════════════════

  static const String postCreated = 'Post created successfully!';
  static const String postUpdated = 'Post updated successfully!';
  static const String postDeleted = 'Post deleted successfully!';

  static const String eventCreated = 'Event created successfully!';
  static const String eventUpdated = 'Event updated successfully!';
  static const String eventDeleted = 'Event deleted successfully!';
  static const String eventRegistered = 'Successfully registered for event!';
  static const String eventUnregistered = 'Unregistered from event';

  static const String competitionCreated = 'Competition created successfully!';
  static const String competitionUpdated = 'Competition updated successfully!';
  static const String competitionDeleted = 'Competition deleted successfully!';
  static const String competitionRegistered = 'Successfully registered for competition!';

  static const String clubCreated = 'Club created successfully!';
  static const String clubJoined = 'Successfully joined club!';
  static const String clubLeft = 'Left club';

  static const String itemReported = 'Item reported successfully!';
  static const String itemResolved = 'Item marked as resolved!';

  static const String commentPosted = 'Comment posted!';
  static const String commentUpdated = 'Comment updated!';
  static const String commentDeleted = 'Comment deleted!';

  // ═══════════════════════════════════════════════════════════════
  // WARNING MESSAGES
  // ═══════════════════════════════════════════════════════════════

  static const String eventAlmostFull = 'Event is almost full! Only a few spots left.';
  static const String competitionDeadlineApproaching = 'Registration deadline is approaching!';
  static const String scholarshipChangeWarning = 'Scholarship percentage may change after grade updates.';
  static const String accountNotVerified = 'Your account is not verified yet.';
  static const String unsavedChanges = 'You have unsaved changes. Are you sure you want to leave?';

  // ═══════════════════════════════════════════════════════════════
  // INFO MESSAGES
  // ═══════════════════════════════════════════════════════════════

  static const String pullToRefresh = 'Pull to refresh';
  static const String noMoreItems = 'No more items to load';
  static const String offlineMode = 'You are offline. Some features may not work.';
  static const String loadingMore = 'Loading more...';
  static const String syncInProgress = 'Syncing data...';
}
