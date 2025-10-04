import 'package:campuswhisper/ui/pages/cgpa/cgpa_page.dart';
import 'package:campuswhisper/ui/pages/course/course_page.dart';
import 'package:campuswhisper/ui/widgets/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  static int _currentIndex = 0;

  final List<Widget> _pages = [
    const Center(
      child: Text(
        'Home Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),

    const Center(
      child: Text(
        'Search Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),

    const CoursePage(),

    const CgpaPage(),

    const Center(
      child: Text(
        'More',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
  ];

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
            label: 'Course',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.medal_outline),
            activeIcon: Icon(Iconsax.medal_bold),
            label: 'CGPA',
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
