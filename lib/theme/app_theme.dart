import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF6A5AE0);
  static const Color secondaryColor = Color(0xFF61CAFF);
  static const Color accentColor = Color(0xFFFF7F5C);
  static const Color backgroundColor = Color(0xFFF5F5FA);
  static const Color darkBackgroundColor = Color(0xFF1E1E2E);
  static const Color cardDarkColor = Color(0xFF2A2A3C);

  // Common Styles
  static const double borderRadiusValue = 16.0;
  static const double cardElevation = 4.0;

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      background: backgroundColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
    ),
    fontFamily: 'Poppins',
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      background: darkBackgroundColor,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackgroundColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: cardDarkColor,
      elevation: cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
    ),
    fontFamily: 'Poppins',
  );
}