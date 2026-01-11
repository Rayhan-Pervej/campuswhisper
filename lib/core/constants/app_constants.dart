class AppConstants {
  // App Info
  static const String appName = 'CampusWhisper';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your campus social hub';

  // API & Backend (for future use)
  static const String apiUrl = 'https://api.campuswhisper.com';
  static const String baseUrl = 'https://campuswhisper.com';

  // Pagination
  static const int postsPerPage = 20;
  static const int eventsPerPage = 15;
  static const int commentsPerPage = 50;

  // Image/File Limits
  static const int maxImageSizeMB = 5;
  static const int maxImagesPerPost = 5;
  static const int maxVideoSizeMB = 50;

  // Text Limits
  static const int maxPostTitleLength = 100;
  static const int maxPostContentLength = 5000;
  static const int maxCommentLength = 500;
  static const int maxBioLength = 200;
  static const int minPasswordLength = 6;

  // Defaults
  static const String defaultAvatarUrl = 'https://ui-avatars.com/api/?name=User&background=3F51B5&color=fff';
  static const String placeholderImageUrl = 'https://via.placeholder.com/400x300?text=No+Image';

  // Date Formats
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayTimeFormat = 'h:mm a';
  static const String displayDateTimeFormat = 'MMM dd, yyyy \'at\' h:mm a';

  // Tags (for threads/posts)
  static const List<String> postTags = [
    'General',
    'Academic',
    'Social',
    'Events',
    'Sports',
    'Help',
    'Discussion',
    'Question',
  ];

  // Event Categories
  static const List<String> eventCategories = [
    'All',
    'Academic',
    'Cultural',
    'Sports',
    'Workshop',
    'Seminar',
    'Competition',
    'Social',
  ];

  // Competition Categories
  static const List<String> competitionCategories = [
    'All',
    'Programming',
    'Business',
    'Sports',
    'Cultural',
    'Academic',
    'Gaming',
    'Other',
  ];

  // Lost & Found Status
  static const String lostStatus = 'Lost';
  static const String foundStatus = 'Found';
  static const String resolvedStatus = 'Resolved';

  // Competition Status
  static const String upcomingStatus = 'Upcoming';
  static const String activeStatus = 'Active';
  static const String endedStatus = 'Ended';

  // Scholarship Types
  static const List<String> scholarshipTypes = [
    'Merit-based',
    'Need-based',
    'Sports',
    'Cultural',
    'Research',
    'International',
  ];

  // CGPA Grading Scale
  static const Map<String, double> gradePoints = {
    'A+': 4.0,
    'A': 3.75,
    'A-': 3.5,
    'B+': 3.25,
    'B': 3.0,
    'B-': 2.75,
    'C+': 2.5,
    'C': 2.25,
    'D': 2.0,
    'F': 0.0,
  };

  // Support
  static const String supportEmail = 'support@campuswhisper.com';
  static const String feedbackEmail = 'feedback@campuswhisper.com';
  static const String privacyPolicyUrl = 'https://campuswhisper.com/privacy';
  static const String termsOfServiceUrl = 'https://campuswhisper.com/terms';

  // Social Media (example)
  static const String facebookUrl = 'https://facebook.com/campuswhisper';
  static const String twitterUrl = 'https://twitter.com/campuswhisper';
  static const String instagramUrl = 'https://instagram.com/campuswhisper';

  // Notification Settings
  static const Duration snackbarDuration = Duration(seconds: 3);
  static const Duration errorSnackbarDuration = Duration(seconds: 4);
  static const Duration loadingDebounce = Duration(milliseconds: 300);

  // Search
  static const int minSearchLength = 2;
  static const Duration searchDebounce = Duration(milliseconds: 500);
}
