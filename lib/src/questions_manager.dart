import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionsManager {
  static final Map<String, String> gameFiles = {
    'EU NUNCA': 'assets/never_have_i_ever/questions.txt',
    'PARANOIA': 'assets/paranoia/questions.txt',
    'QUEM É MAIS PROVÁVEL': 'assets/who_is_more_likely/questions.txt',
    'TIBITAR': 'assets/tibitar/verbs.txt',
    'PALAVRA PROIBIDA': 'assets/forbidden_word/words.txt',
    'CARTAS': 'assets/cards/challenges.txt',
  };

  // Cache to store modified questions
  static final Map<String, List<String>> _questionsCache = {};
  
  // Load questions for a specific game
  static Future<List<String>> loadQuestions(String gameName) async {
    // Check if already in cache
    if (_questionsCache.containsKey(gameName)) {
      return _questionsCache[gameName]!;
    }
    
    final prefs = await SharedPreferences.getInstance();
    final String? customQuestions = prefs.getString('custom_${gameName.toLowerCase()}');
    
    // If custom questions exist, use them
    if (customQuestions != null && customQuestions.isNotEmpty) {
      final questions = customQuestions.split('\n')
          .where((q) => q.trim().isNotEmpty)
          .toList();
      _questionsCache[gameName] = questions;
      return questions;
    }
    
    // Otherwise, load from assets file
    try {
      final String filePath = gameFiles[gameName]!;
      final String content = await rootBundle.loadString(filePath);
      final questions = content.split('\n')
          .where((q) => q.trim().isNotEmpty)
          .toList();
      _questionsCache[gameName] = questions;
      return questions;
    } catch (e) {
      return [];
    }
  }
  
  // Save custom questions
  static Future<bool> saveQuestions(String gameName, List<String> questions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String content = questions.join('\n');
      await prefs.setString('custom_${gameName.toLowerCase()}', content);
      _questionsCache[gameName] = questions;
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Restore original questions
  static Future<bool> resetToDefault(String gameName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('custom_${gameName.toLowerCase()}');
      _questionsCache.remove(gameName);
      return true;
    } catch (e) {
      return false;
    }
  }
}