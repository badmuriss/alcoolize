import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Default text style with fontSize 16
  static const TextStyle defaultText = TextStyle(
    fontSize: 16,
    fontFamily: 'Mesmerize',
  );
  
  static const TextStyle gameTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.gameText,
    fontFamily: 'Mesmerize',
  );
  
  static const TextStyle gameSubtitle = TextStyle(
    fontSize: 24,
    color: AppColors.gameText,
    fontFamily: 'Mesmerize',
  );
  
  static const TextStyle gameContent = TextStyle(
    fontSize: 18,
    color: AppColors.gameText,
    fontFamily: 'Mesmerize',
  );
  
  static const TextStyle cardContent = TextStyle(
    fontSize: 24,
    color: AppColors.onSurface,
    fontFamily: 'Mesmerize',
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Mesmerize',
  );
  
  static const TextStyle homeButton = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: 'Mesmerize',
  );
  
  static const TextStyle dialogContent = TextStyle(
    fontSize: 18,
    fontFamily: 'Mesmerize',
  );
  
  // Responsive text styles factory methods
  static TextStyle responsiveGameTitle(double screenHeight) {
    return gameTitle.copyWith(
      fontSize: (screenHeight * 0.04).clamp(24.0, 36.0),
      fontFamily: 'Mesmerize',
    );
  }
  
  static TextStyle responsiveGameSubtitle(double screenHeight) {
    return gameSubtitle.copyWith(
      fontSize: (screenHeight * 0.028).clamp(18.0, 28.0),
      fontFamily: 'Mesmerize',
    );
  }
  
  static TextStyle responsiveCardContent(double cardHeight) {
    return cardContent.copyWith(
      fontSize: (cardHeight * 0.055).clamp(18.0, 26.0),
      fontFamily: 'Mesmerize',
    );
  }
}