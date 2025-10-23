import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF512C7A), 
      onPrimary: Colors.white,
      secondary: Color(0xFFF39C12), 
      onSecondary: Colors.black,
      primaryContainer: Color(0xFFEDE7F6), 
      secondaryContainer: Color(0xFFFFECB3), 
      surface: Color(0xFFFFF9F2), 
      onSurface: Color(0xFF2C2C2C), 
      error: Color(0xFFD32F2F),
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: Color(0xFFFFF9F2),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF512C7A),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: Color(0xFF2C2C2C),
      displayColor: Color(0xFF2C2C2C),
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF7E57C2), 
      onPrimary: Colors.white,
      secondary: Color(0xFFF39C12),
      onSecondary: Colors.black,
      primaryContainer: Color(0xFF1E1E1E),
      secondaryContainer: Color(0xFF512C7A),
      surface: Color(0xFF1B1B1B),
      onSurface: Color(0xFFE0E0E0),
      error: Color(0xFFEF5350),
      onError: Colors.black,
    ),
    scaffoldBackgroundColor: Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF512C7A),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: ThemeData.dark().textTheme.apply(
      bodyColor: Color(0xFFE0E0E0),
      displayColor: Color(0xFFE0E0E0),
    ),
  );
}
