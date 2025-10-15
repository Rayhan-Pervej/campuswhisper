// 1. Create this file: lib/routes/app_routes.dart

import 'package:campuswhisper/providers/cgpa_calculator_provider.dart';
import 'package:campuswhisper/providers/course_roadmap_provider.dart';
import 'package:campuswhisper/providers/scholarship_provider.dart';
import 'package:campuswhisper/routing/custom_transitions.dart';
import 'package:campuswhisper/ui/pages/Home/home_page.dart';
import 'package:campuswhisper/ui/pages/auth/sign_up_page.dart';
import 'package:campuswhisper/ui/pages/cgpa_calculator/cgpa_calculator_page.dart';
import 'package:campuswhisper/ui/pages/course_roadmap/course_roadmap_page.dart';
import 'package:campuswhisper/ui/pages/course_routine.dart/course_routine_page.dart';
import 'package:campuswhisper/ui/pages/scholarship/scholarship_page.dart';
import 'package:flutter/material.dart';
import 'package:campuswhisper/ui/pages/auth/login_page.dart';
import 'package:campuswhisper/ui/pages/campus/campus_page.dart';
import 'package:campuswhisper/ui/pages/navigation/navigation_page.dart';
import 'package:provider/provider.dart';

class AppRoutes {
  // Route name constants
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String navigation = '/navigation';
  static const String home = '/home';
  static const String cgpa = '/campus';
  static const String cgpaCalculator = '/cgpa_calculator';
  static const String scholarship = '/scholarship';
  static const String coursePlan = '/course_plan';
  static const String courseRoutine = '/course_routine';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
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
          builder: (_) => MyHomePage(pageName: pageName),
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
