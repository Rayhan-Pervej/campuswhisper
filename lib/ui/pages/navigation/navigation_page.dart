import 'package:campuswhisper/ui/pages/Home/home_page.dart';
import 'package:campuswhisper/ui/pages/campus/campus_page.dart';
import 'package:campuswhisper/ui/pages/more/more_page.dart';
import 'package:campuswhisper/ui/pages/study/study_page.dart';
import 'package:campuswhisper/ui/pages/thread/thread_page.dart';
import 'package:campuswhisper/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campuswhisper/providers/user_provider.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  static int _currentIndex = 0;

  final List<Widget> _pages = [
    const MyHomePage(),
    const ThreadPage(),
    const StudyPage(),
    const CampusPage(),
    const MorePage(),
  ];

  @override
  void initState() {
    super.initState();
    // Load current user data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null && userProvider.currentUser == null) {
        // Get student ID from email (e.g., 2022078@iub.edu.bd -> 2022078)
        final email = currentUser.email ?? '';
        final studentId = email.split('@').first;

        if (studentId.isNotEmpty) {
          await userProvider.loadUser(studentId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(
          context,
        ).colorScheme.onSurface.withOpacity(0.6),
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home_2_outline),
            activeIcon: Icon(Iconsax.home_2_bold),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.message_2_outline),
            activeIcon: Icon(Iconsax.message_2_bold),
            label: 'Thread',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.book_outline),
            activeIcon: Icon(Iconsax.book_bold),
            label: 'Study',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.building_outline),
            activeIcon: Icon(Iconsax.building_bold),
            label: 'Campus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.more_square_outline),
            activeIcon: Icon(Iconsax.more_square_bold),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
