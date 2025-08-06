import 'package:flutter/material.dart';

class GameColors {
  static const Color home = Color(0xFF6A0DAD);
  static const Color roulette = Colors.black;
  static const Color cards = Color.fromARGB(255, 0, 189, 196);
  static const Color mostLikely = Color.fromARGB(255, 49, 110, 51);
  static const Color neverHaveIEver = Color.fromARGB(255, 85, 0, 0);
  static const Color wouldYouRather = Color.fromARGB(255, 33, 150, 243);
  static const Color paranoia = Color.fromARGB(255, 124, 0, 93);
  static const Color mysteryVerb = Colors.pink;
  static const Color forbiddenWord = Color.fromARGB(255, 221, 15, 0);
  static const Color medusa = Color.fromARGB(255, 0, 64, 128);
  static const Color truthOrDare = Color.fromARGB(255, 177, 1, 1);
  
  // Common UI colors
  static const Color gameText = Colors.white;
  static const Color cardBackground = Colors.white;
  static const Color shadowColor = Colors.black26;
  static const Color buttonBackground = Colors.white;
  static const Color spinButtonBackground = Colors.red;
}

class GameSizes {
  // Wheel sizes
  static const double defaultWheelSize = 300.0;
  static const double minWheelSize = 200.0;
  static const double maxWheelSize = 350.0;
  
  // Card sizes
  static const double defaultCardWidth = 280.0;
  static const double defaultCardHeight = 420.0;
  static const double minCardSize = 250.0;
  static const double maxCardWidth = 320.0;
  static const double maxCardHeight = 450.0;
  
  // Font sizes
  static const double gameHeaderFontSize = 32.0;
  static const double gameSubtitleFontSize = 24.0;
  static const double gameContentFontSize = 20.0;
  static const double buttonTextFontSize = 18.0;
  static const double medusaTextFontSize = 28.0;
  
  // Icon sizes
  static const double gameIconSize = 80.0;
  static const double appBarIconSize = 33.0;
  
  // Spacing and padding
  static const double defaultPadding = 20.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 60.0;
  static const double cardBorderRadius = 12.0;
  static const double shadowBlurRadius = 8.0;
  static const double shadowSpreadRadius = 4.0;
}

class GameConstants {
  static const int minPlayers = 2;
  static const int maxPlayers = 20;
  static const Duration spinDuration = Duration(seconds: 4);
  static const Duration buttonAnimationDuration = Duration(milliseconds: 70);
}