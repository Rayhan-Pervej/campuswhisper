import 'package:campuswhisper/core/theme/app_theme.dart';
import 'package:campuswhisper/core/theme/theme_provider.dart';
import 'package:campuswhisper/providers/login_provider.dart';
import 'package:campuswhisper/providers/sign_up_provider.dart';
import 'package:campuswhisper/providers/user_provider.dart';
import 'package:campuswhisper/providers/post_provider.dart';
import 'package:campuswhisper/providers/event_provider.dart';
import 'package:campuswhisper/providers/club_provider.dart';
import 'package:campuswhisper/providers/competition_provider.dart';
import 'package:campuswhisper/providers/lost_found_provider.dart';
import 'package:campuswhisper/providers/comment_provider.dart';
import 'package:campuswhisper/providers/course_routine_provider.dart';
import 'package:campuswhisper/routing/app_routes.dart';
import 'package:campuswhisper/ui/pages/auth/login_page.dart';
import 'package:campuswhisper/ui/pages/navigation/navigation_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:campuswhisper/core/database/database_service.dart';
import 'package:campuswhisper/core/database/firestore_adapter.dart';

// Global database instance
late final DatabaseService database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize database (Firestore for now)
  database = FirestoreAdapter();
  await database.initialize();

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // // Make system bars transparent
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     systemNavigationBarColor: Colors.transparent,
  //     systemNavigationBarDividerColor: Colors.transparent,
  //     statusBarColor: Colors.transparent,
  //   ),
  // );
  runApp(
    MultiProvider(
      providers: [
        // Auth providers
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),

        // User provider
        ChangeNotifierProvider(create: (_) => UserProvider()),

        // Data providers
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => ClubProvider()),
        ChangeNotifierProvider(create: (_) => CompetitionProvider()),
        ChangeNotifierProvider(create: (_) => LostFoundProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
        ChangeNotifierProvider(create: (_) => CourseRoutineProvider()),
      ],

      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'CampusWhisper',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            onGenerateRoute: AppRoutes.generateRouteWithCustomTransitions,

            // Global keyboard dismissal
            builder: (context, child) {
              return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                behavior: HitTestBehavior.opaque,
                child: child,
              );
            },
            home: Builder(
              builder: (context) {
                return StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasData) {
                      final user = snapshot.data!;

                      // Check if email is verified
                      if (!user.emailVerified) {
                        // Navigate to email verification page
                        return Builder(
                          builder: (context) {
                            // Use WidgetsBinding to navigate after build
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.emailVerification,
                                arguments: {'email': user.email ?? ''},
                              );
                            });
                            return const Scaffold(
                              body: Center(child: CircularProgressIndicator()),
                            );
                          },
                        );
                      }

                      return const NavigationPage();
                    } else {
                      return const Login();
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
