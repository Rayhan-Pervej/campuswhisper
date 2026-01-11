/// Application-wide configuration
///
/// Centralizes all hardcoded values for easy modification
/// Change these values without touching the code!
class AppConfig {
  // ═══════════════════════════════════════════════════════════════
  // UNIVERSITY & DEPARTMENT
  // ═══════════════════════════════════════════════════════════════

  static const List<String> universities = [
    'Independent University, Bangladesh',
    'BRAC University',
    'North South University',
    'East West University',
    'American International University-Bangladesh',
  ];

  static const List<String> departments = [
    'CSE',
    'EEE',
    'BBA',
    'Economics',
    'English',
    'Law',
    'Civil Engineering',
    'Pharmacy',
    'Architecture',
  ];

  // ═══════════════════════════════════════════════════════════════
  // GAMIFICATION - XP AMOUNTS
  // ═══════════════════════════════════════════════════════════════

  static const Map<String, int> xpAmounts = {
    'post_contribution': 20,
    'post_upvote': 5,
    'comment': 10,
    'hack_upvote': 3,
    'review_upvote': 5,
    'faq_upvote': 3,
    'event_registration': 15,
    'club_join': 10,
    'daily_login': 2,
  };

  // ═══════════════════════════════════════════════════════════════
  // GAMIFICATION - BADGE THRESHOLDS
  // ═══════════════════════════════════════════════════════════════

  static const Map<String, int> badgeThresholds = {
    'XP Rookie': 100,
    'XP Champion': 500,
    'XP Master': 1000,
    'XP Legend': 5000,
    'Contributor': 5,
    'Top Reviewer': 20,
    'Campus Legend': 50,
    'Social Butterfly': 100,
  };

  // ═══════════════════════════════════════════════════════════════
  // SCHOLARSHIP CONFIGURATION
  // ═══════════════════════════════════════════════════════════════

  static const int minimumCreditsForScholarship = 36;

  static const Map<String, Map<String, dynamic>> scholarshipTiers = {
    'Full Waiver': {
      'minCGPA': 3.95,
      'minCredits': 36,
      'percentage': 100,
    },
    '75% Waiver': {
      'minCGPA': 3.85,
      'minCredits': 36,
      'percentage': 75,
    },
    '50% Waiver': {
      'minCGPA': 3.70,
      'minCredits': 36,
      'percentage': 50,
    },
    '25% Waiver': {
      'minCGPA': 3.50,
      'minCredits': 36,
      'percentage': 25,
    },
  };

  /// Get scholarship percentage based on CGPA and credits
  static int getScholarshipPercentage(double cgpa, int creditsEarned) {
    if (creditsEarned < minimumCreditsForScholarship) {
      return 0;
    }

    if (cgpa >= 3.95) return 100;
    if (cgpa >= 3.85) return 75;
    if (cgpa >= 3.70) return 50;
    if (cgpa >= 3.50) return 25;
    return 0;
  }

  // ═══════════════════════════════════════════════════════════════
  // PAGINATION LIMITS
  // ═══════════════════════════════════════════════════════════════

  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int trendingPageSize = 10;
  static const int recentPageSize = 5;

  // ═══════════════════════════════════════════════════════════════
  // EVENT CONFIGURATION
  // ═══════════════════════════════════════════════════════════════

  static const List<String> eventCategories = [
    'Academic',
    'Cultural',
    'Sports',
    'Workshop',
    'Seminar',
    'Club Activity',
    'Competition',
    'Career Fair',
    'Other',
  ];

  static const int eventRegistrationWarningThreshold = 10; // Show warning when spots < 10

  // ═══════════════════════════════════════════════════════════════
  // COMPETITION CONFIGURATION
  // ═══════════════════════════════════════════════════════════════

  static const List<String> competitionTypes = [
    'Programming',
    'Hackathon',
    'Design',
    'Business',
    'Sports',
    'Cultural',
    'Other',
  ];

  static const List<String> competitionStatuses = [
    'Registration Open',
    'Registration Closed',
    'Ongoing',
    'Completed',
    'Cancelled',
  ];

  // ═══════════════════════════════════════════════════════════════
  // CLUB CONFIGURATION
  // ═══════════════════════════════════════════════════════════════

  static const List<String> clubCategories = [
    'Academic',
    'Cultural',
    'Sports',
    'Social Service',
    'Technology',
    'Business',
    'Arts',
    'Other',
  ];

  // ═══════════════════════════════════════════════════════════════
  // LOST & FOUND CONFIGURATION
  // ═══════════════════════════════════════════════════════════════

  static const List<String> lostFoundCategories = [
    'Electronics',
    'Books',
    'Accessories',
    'ID/Cards',
    'Clothing',
    'Keys',
    'Other',
  ];

  static const List<String> lostFoundStatuses = [
    'Active',
    'Resolved',
    'Expired',
  ];

  // ═══════════════════════════════════════════════════════════════
  // FEATURE FLAGS
  // ═══════════════════════════════════════════════════════════════

  static const bool enableGamification = true;
  static const bool enableNotifications = true;
  static const bool enableEvents = true;
  static const bool enableCompetitions = true;
  static const bool enableClubs = true;
  static const bool enableLostFound = true;
  static const bool enableScholarshipFinder = true;
  static const bool enableCGPACalculator = true;
  static const bool enableCourseRoadmap = true;

  // ═══════════════════════════════════════════════════════════════
  // APP METADATA
  // ═══════════════════════════════════════════════════════════════

  static const String appName = 'CampusWhisper';
  static const String appVersion = '1.0.0';
  static const String supportEmail = 'support@campuswhisper.com';
}
