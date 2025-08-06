import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionsManager {
  static final Map<String, String> gameFiles = {
    'NEVER_HAVE_I_EVER': 'assets/never_have_i_ever/questions.txt',
    'PARANOIA': 'assets/paranoia/questions.txt',
    'MOST_LIKELY_TO': 'assets/most_likely_to/questions.txt',
    'MYSTERY_VERB': 'assets/mystery_verb/verbs.txt',
    'FORBIDDEN_WORD': 'assets/forbidden_word/words.txt',
    'CARDS': 'assets/cards/challenges.txt',
    'TRUTH_OR_DARE_TRUTHS': 'assets/truth_or_dare/truths.txt',
    'TRUTH_OR_DARE_DARES': 'assets/truth_or_dare/dares.txt',
  };

  static final Map<String, Map<String, String>> languageGameFiles = {
    'en': {
      'NEVER_HAVE_I_EVER': 'assets/never_have_i_ever/en/questions.txt',
      'PARANOIA': 'assets/paranoia/en/questions.txt',
      'MOST_LIKELY_TO': 'assets/most_likely_to/en/questions.txt',
      'MYSTERY_VERB': 'assets/mystery_verb/en/verbs.txt',
      'FORBIDDEN_WORD': 'assets/forbidden_word/en/words.txt',
      'CARDS': 'assets/cards/en/challenges.txt',
      'TRUTH_OR_DARE_TRUTHS': 'assets/truth_or_dare/en/truths.txt',
      'TRUTH_OR_DARE_DARES': 'assets/truth_or_dare/en/dares.txt',
    },
    'pt': {
      'NEVER_HAVE_I_EVER': 'assets/never_have_i_ever/pt/questions.txt',
      'PARANOIA': 'assets/paranoia/pt/questions.txt',
      'MOST_LIKELY_TO': 'assets/most_likely_to/pt/questions.txt',
      'MYSTERY_VERB': 'assets/mystery_verb/pt/verbs.txt',
      'FORBIDDEN_WORD': 'assets/forbidden_word/pt/words.txt',
      'CARDS': 'assets/cards/pt/challenges.txt',
      'TRUTH_OR_DARE_TRUTHS': 'assets/truth_or_dare/pt/truths.txt',
      'TRUTH_OR_DARE_DARES': 'assets/truth_or_dare/pt/dares.txt',
    },
    'es': {
      'NEVER_HAVE_I_EVER': 'assets/never_have_i_ever/es/questions.txt',
      'PARANOIA': 'assets/paranoia/es/questions.txt',
      'MOST_LIKELY_TO': 'assets/most_likely_to/es/questions.txt',
      'MYSTERY_VERB': 'assets/mystery_verb/es/verbs.txt',
      'FORBIDDEN_WORD': 'assets/forbidden_word/es/words.txt',
      'CARDS': 'assets/cards/es/challenges.txt',
      'TRUTH_OR_DARE_TRUTHS': 'assets/truth_or_dare/es/truths.txt',
      'TRUTH_OR_DARE_DARES': 'assets/truth_or_dare/es/dares.txt',
    },
  };

  // Cache to store modified questions
  static final Map<String, List<String>> _questionsCache = {};
  
  // Clear cache when language changes
  static void clearCache() {
    _questionsCache.clear();
  }
  
  // Load questions for a specific game
  static Future<List<String>> loadQuestions(String gameName) async {
    final prefs = await SharedPreferences.getInstance();
    final String language = prefs.getString('selected_language') ?? 'pt';
    final String cacheKey = '${gameName}_$language';
    
    // Check if already in cache
    if (_questionsCache.containsKey(cacheKey)) {
      return _questionsCache[cacheKey]!;
    }
    
    final String? customQuestions = prefs.getString('custom_${gameName.toLowerCase()}_$language');
    
    // If custom questions exist, use them
    if (customQuestions != null && customQuestions.isNotEmpty) {
      final questions = customQuestions.split('\n')
          .where((q) => q.trim().isNotEmpty)
          .toList();
      _questionsCache[cacheKey] = questions;
      return questions;
    }
    
    // Otherwise, load from language-specific assets file
    try {
      String filePath;
      if (languageGameFiles.containsKey(language) && 
          languageGameFiles[language]!.containsKey(gameName)) {
        filePath = languageGameFiles[language]![gameName]!;
      } else {
        // Fallback to original files if language-specific file not found
        filePath = gameFiles[gameName]!;
      }
      
      final String content = await rootBundle.loadString(filePath);
      final questions = content.split('\n')
          .where((q) => q.trim().isNotEmpty)
          .toList();
      _questionsCache[cacheKey] = questions;
      return questions;
    } catch (e) {
      // If language-specific file fails, try fallback
      try {
        final String fallbackPath = gameFiles[gameName]!;
        final String content = await rootBundle.loadString(fallbackPath);
        final questions = content.split('\n')
            .where((q) => q.trim().isNotEmpty)
            .toList();
        _questionsCache[cacheKey] = questions;
        return questions;
      } catch (e) {
        return [];
      }
    }
  }
  
  // Save custom questions (language-specific)
  static Future<bool> saveQuestions(String gameName, List<String> questions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String language = prefs.getString('selected_language') ?? 'pt';
      final String content = questions.join('\n');
      final String cacheKey = '${gameName}_$language';
      
      await prefs.setString('custom_${gameName.toLowerCase()}_$language', content);
      _questionsCache[cacheKey] = questions;
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Restore original questions (language-specific)
  static Future<bool> resetToDefault(String gameName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String language = prefs.getString('selected_language') ?? 'pt';
      final String cacheKey = '${gameName}_$language';
      
      await prefs.remove('custom_${gameName.toLowerCase()}_$language');
      _questionsCache.remove(cacheKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}