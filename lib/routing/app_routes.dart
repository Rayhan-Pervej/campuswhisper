// 1. Create this file: lib/routes/app_routes.dart

import 'package:campuswhisper/providers/cgpa_calculator_provider.dart';
import 'package:campuswhisper/providers/course_roadmap_provider.dart';
import 'package:campuswhisper/providers/scholarship_provider.dart';
import 'package:campuswhisper/routing/custom_transitions.dart';
import 'package:campuswhisper/ui/pages/Home/home_page.dart';
import 'package:campuswhisper/ui/pages/auth/email_verification_page.dart';
import 'package:campuswhisper/ui/pages/auth/forgot_password_page.dart';
import 'package:campuswhisper/ui/pages/auth/sign_up_page.dart';
import 'package:campuswhisper/ui/pages/cgpa_calculator/cgpa_calculator_page.dart';
import 'package:campuswhisper/ui/pages/competitions/competitions_page.dart';
import 'package:campuswhisper/ui/pages/course_roadmap/course_roadmap_page.dart';
import 'package:campuswhisper/ui/pages/course_routine/course_routine_page.dart';
import 'package:campuswhisper/ui/pages/events/events_page.dart';
import 'package:campuswhisper/ui/pages/lost_and_found/lost_and_found_page.dart';
import 'package:campuswhisper/ui/pages/more/more_page.dart';
import 'package:campuswhisper/ui/pages/scholarship/scholarship_page.dart';
import 'package:campuswhisper/ui/pages/thread/thread_detail_page.dart';
import 'package:campuswhisper/ui/pages/course_routine/course_detail_page.dart';
import 'package:campuswhisper/ui/pages/events/event_detail_page.dart';
import 'package:campuswhisper/ui/pages/events/event_attendees_page.dart';
import 'package:campuswhisper/ui/pages/events/event_comments_page.dart';
import 'package:campuswhisper/ui/pages/lost_and_found/item_detail_page.dart';
import 'package:campuswhisper/ui/pages/lost_and_found/contact_poster_page.dart';
import 'package:campuswhisper/ui/pages/clubs/clubs_page.dart';
import 'package:campuswhisper/ui/pages/clubs/club_detail_page.dart';
import 'package:campuswhisper/ui/pages/competitions/competition_detail_page.dart';
import 'package:campuswhisper/ui/pages/competitions/registration_page.dart';
import 'package:campuswhisper/ui/pages/competitions/participants_page.dart';
import 'package:campuswhisper/ui/pages/more/profile/profile_page.dart';
import 'package:campuswhisper/ui/pages/more/profile/edit_profile_page.dart';
import 'package:campuswhisper/ui/pages/more/settings/settings_page.dart';
import 'package:campuswhisper/ui/pages/more/notifications/notifications_page.dart';
import 'package:campuswhisper/ui/pages/more/saved/saved_page.dart';
import 'package:campuswhisper/ui/pages/more/about/about_page.dart';
import 'package:campuswhisper/ui/pages/admin/admin_dummy_data_page.dart';
import 'package:flutter/material.dart';
import 'package:campuswhisper/ui/pages/auth/login_page.dart';
import 'package:campuswhisper/ui/pages/campus/campus_page.dart';
import 'package:campuswhisper/ui/pages/navigation/navigation_page.dart';
import 'package:provider/provider.dart';

class AppRoutes {
  // Route name constants
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String forgotPassword = '/forgot_password';
  static const String emailVerification = '/email_verification';
  static const String navigation = '/navigation';
  static const String home = '/home';
  static const String cgpa = '/campus';
  static const String cgpaCalculator = '/cgpa_calculator';
  static const String scholarship = '/scholarship';
  static const String coursePlan = '/course_plan';
  static const String courseRoutine = '/course_routine';
  static const String eventsPage = '/events_page';
  static const String lostAndFoundPage = '/lost_and_found_page';
  static const String competitionsPage = '/competitions_page';
  static const String threadDetail = '/thread_detail';
  static const String morePage = '/more';
  static const String courseDetail = '/course_detail';
  static const String eventDetail = '/event_detail';
  static const String eventAttendees = '/event_attendees';
  static const String eventComments = '/event_comments';
  static const String itemDetail = '/item_detail';
  static const String contactPoster = '/contact_poster';
  static const String clubsPage = '/clubs_page';
  static const String clubDetail = '/club_detail';
  static const String competitionDetail = '/competition_detail';
  static const String competitionRegistration = '/competition_registration';
  static const String competitionParticipants = '/competition_participants';
  static const String profile = '/profile';
  static const String editProfile = '/edit_profile';
  static const String settingsPage = '/settings';
  static const String notifications = '/notifications';
  static const String saved = '/saved';
  static const String about = '/about';
  static const String adminDummyData = '/admin_dummy_data';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case competitionsPage:
        return MaterialPageRoute(
          builder: (_) => const CompetitionsPage(),
          settings: settings,
        );

      case lostAndFoundPage:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => CourseRoadmapProvider(),
            child: const LostAndFoundPage(),
          ),
          settings: settings,
        );

      case eventsPage:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => CourseRoadmapProvider(),
            child: const EventsPage(),
          ),
          settings: settings,
        );
      case courseRoutine:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => CourseRoadmapProvider(),
            child: const CourseRoutinePage(),
          ),
          settings: settings,
        );
      case coursePlan:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => CourseRoadmapProvider(),
            child: const CourseRoadmapPage(),
          ),
          settings: settings,
        );
      case scholarship:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => ScholarshipProvider(),
            child: const ScholarshipPage(),
          ),
          settings: settings,
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const Login(),
          settings: settings,
        );

      case signUp:
        return MaterialPageRoute(
          builder: (_) => const SignUpPage(),
          settings: settings,
        );

      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordPage(),
          settings: settings,
        );

      case emailVerification:
        final args = settings.arguments as Map<String, dynamic>?;
        final email = args?['email'] ?? '';
        return MaterialPageRoute(
          builder: (_) => EmailVerificationPage(email: email),
          settings: settings,
        );

      case threadDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final thread = args?['thread'] ?? {};
        return MaterialPageRoute(
          builder: (_) => ThreadDetailPage(thread: thread),
          settings: settings,
        );

      case morePage:
        return MaterialPageRoute(
          builder: (_) => const MorePage(),
          settings: settings,
        );

      case courseDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final course = args?['course'] ?? {};
        final semesterName = args?['semesterName'] ?? 'Unknown Semester';
        return MaterialPageRoute(
          builder: (_) => CourseDetailPage(
            course: course,
            semesterName: semesterName,
          ),
          settings: settings,
        );

      case eventDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final event = args?['event'] ?? {};
        return MaterialPageRoute(
          builder: (_) => EventDetailPage(event: event),
          settings: settings,
        );

      case eventAttendees:
        final args = settings.arguments as Map<String, dynamic>?;
        final eventTitle = args?['eventTitle'] ?? 'Event';
        final attendees = args?['attendees'] as List<Map<String, dynamic>>? ?? [];
        return MaterialPageRoute(
          builder: (_) => EventAttendeesPage(
            eventTitle: eventTitle,
            attendees: attendees,
          ),
          settings: settings,
        );

      case eventComments:
        final args = settings.arguments as Map<String, dynamic>?;
        final eventId = args?['eventId'] ?? '';
        final eventTitle = args?['eventTitle'] ?? 'Event';
        return MaterialPageRoute(
          builder: (_) => EventCommentsPage(
            eventId: eventId,
            eventTitle: eventTitle,
          ),
          settings: settings,
        );

      case itemDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final item = args?['item'] ?? {};
        return MaterialPageRoute(
          builder: (_) => ItemDetailPage(item: item),
          settings: settings,
        );

      case contactPoster:
        final args = settings.arguments as Map<String, dynamic>?;
        final item = args?['item'] ?? {};
        return MaterialPageRoute(
          builder: (_) => ContactPosterPage(item: item),
          settings: settings,
        );

      case clubsPage:
        return MaterialPageRoute(
          builder: (_) => const ClubsPage(),
          settings: settings,
        );

      case clubDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final club = args?['club'] ?? {};
        return MaterialPageRoute(
          builder: (_) => ClubDetailPage(club: club),
          settings: settings,
        );

      case competitionDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final competition = args?['competition'] ?? {};
        return MaterialPageRoute(
          builder: (_) => CompetitionDetailPage(competition: competition),
          settings: settings,
        );

      case competitionRegistration:
        final args = settings.arguments as Map<String, dynamic>?;
        final competition = args?['competition'] ?? {};
        return MaterialPageRoute(
          builder: (_) => CompetitionRegistrationPage(competition: competition),
          settings: settings,
        );

      case competitionParticipants:
        final args = settings.arguments as Map<String, dynamic>?;
        final competitionTitle = args?['competitionTitle'] ?? 'Competition';
        final participants = args?['participants'] as List<Map<String, dynamic>>? ?? [];
        return MaterialPageRoute(
          builder: (_) => CompetitionParticipantsPage(
            competitionTitle: competitionTitle,
            participants: participants,
          ),
          settings: settings,
        );

      case navigation:
        return MaterialPageRoute(
          builder: (_) => const NavigationPage(),
          settings: settings,
        );

      case home:
        // Handle the required pageName parameter
        final args = settings.arguments as Map<String, dynamic>?;
        final pageName = args?['pageName'] ?? 'Default Home';
        return MaterialPageRoute(
          builder: (_) => MyHomePage(),
          settings: settings,
        );

      case cgpa:
        return MaterialPageRoute(
          builder: (_) => const CampusPage(),
          settings: settings,
        );

      case cgpaCalculator:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => CgpaCalculatorProvider(),
            child: const CgpaCalculatorPage(),
          ),
          settings: settings,
        );

      case profile:
        return MaterialPageRoute(
          builder: (_) => const ProfilePage(),
          settings: settings,
        );

      case editProfile:
        return MaterialPageRoute(
          builder: (_) => const EditProfilePage(),
          settings: settings,
        );

      case settingsPage:
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
          settings: settings,
        );

      case notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationsPage(),
          settings: settings,
        );

      case saved:
        return MaterialPageRoute(
          builder: (_) => const SavedPage(),
          settings: settings,
        );

      case about:
        return MaterialPageRoute(
          builder: (_) => const AboutPage(),
          settings: settings,
        );

      case adminDummyData:
        return MaterialPageRoute(
          builder: (_) => const AdminDummyDataPage(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Page Not Found')),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    '404 - Page Not Found!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'The page you are looking for does not exist.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          settings: settings,
        );
    }
  }

  static Route<dynamic> generateRouteWithCustomTransitions(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      // case cgpaCalculator:
      //   return CustomPageTransitions.createRoute(
      //     page: const CgpaCalculatorPage(),
      //     transitionType: TransitionType.slideRightToLeft,
      //     settings: settings,
      //     duration: const Duration(milliseconds: 400),
      //     curve: Curves.easeOutCubic,
      //   );

      case cgpa:
        return CustomPageTransitions.createRoute(
          page: const CampusPage(),
          transitionType: TransitionType.slideRightToLeft,
          settings: settings,
        );

      default:
        return generateRoute(settings);
    }
  }
}
