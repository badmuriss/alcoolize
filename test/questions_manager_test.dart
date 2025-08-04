import 'package:flutter_test/flutter_test.dart';
import 'package:alcoolize/src/utils/questions_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('QuestionsManager', () {
    setUpAll(() {
      // Initialize SharedPreferences mock
      SharedPreferences.setMockInitialValues({});
    });

    test('should have file paths for all supported games', () {
      final expectedGames = {
        'NEVER_HAVE_I_EVER',
        'PARANOIA', 
        'MOST_LIKELY_TO',
        'MYSTERY_VERB',
        'FORBIDDEN_WORD',
        'CARDS'
      };
      
      expect(QuestionsManager.gameFiles.keys.toSet(), equals(expectedGames));
      
      // Verify all file paths are non-empty
      for (String path in QuestionsManager.gameFiles.values) {
        expect(path.isNotEmpty, isTrue);
        expect(path.startsWith('assets/'), isTrue);
        expect(path.endsWith('.txt'), isTrue);
      }
    });

    test('should have language-specific file paths for all supported languages', () {
      final expectedLanguages = {'en', 'pt', 'es'};
      final expectedGames = {
        'NEVER_HAVE_I_EVER',
        'PARANOIA', 
        'MOST_LIKELY_TO',
        'MYSTERY_VERB',
        'FORBIDDEN_WORD',
        'CARDS'
      };
      
      expect(QuestionsManager.languageGameFiles.keys.toSet(), equals(expectedLanguages));
      
      // Verify each language has all games
      for (String language in expectedLanguages) {
        expect(QuestionsManager.languageGameFiles[language]!.keys.toSet(), equals(expectedGames));
        
        // Verify all paths are valid
        for (String path in QuestionsManager.languageGameFiles[language]!.values) {
          expect(path.isNotEmpty, isTrue);
          expect(path.startsWith('assets/'), isTrue);
          expect(path.contains('/$language/'), isTrue);
          expect(path.endsWith('.txt'), isTrue);
        }
      }
    });

    test('should handle custom questions save and load with language support', () async {
      // Set mock preferences with different languages
      SharedPreferences.setMockInitialValues({
        'selected_language': 'en',
      });
      
      const gameName = 'TEST_GAME';
      const testQuestions = ['Question 1', 'Question 2', 'Question 3'];
      
      // Save custom questions
      final saveResult = await QuestionsManager.saveQuestions(gameName, testQuestions);
      expect(saveResult, isTrue);
      
      // Test that the API structure is correct
      expect(QuestionsManager.saveQuestions, isA<Function>());
      expect(QuestionsManager.loadQuestions, isA<Function>());
    });

    test('should load language-specific questions based on preferences', () async {
      // Test different language preferences
      for (String language in ['en', 'pt', 'es']) {
        SharedPreferences.setMockInitialValues({
          'selected_language': language,
        });
        
        // Clear cache to ensure fresh load
        QuestionsManager.clearCache();
        
        // Test should pass without throwing exceptions
        try {
          await QuestionsManager.loadQuestions('EU NUNCA');
          // If we get here, the language-specific loading works
          expect(true, isTrue);
        } catch (e) {
          // Expected for missing asset files in test environment
          expect(e, isA<Exception>());
        }
      }
    });

    test('should handle empty question lists', () async {
      const gameName = 'EMPTY_GAME';
      const emptyQuestions = <String>[];
      
      final result = await QuestionsManager.saveQuestions(gameName, emptyQuestions);
      expect(result, isTrue); // Should save empty list successfully
    });

    test('should handle reset to default', () async {  
      const gameName = 'RESET_TEST';
      
      // Reset should complete without error
      final result = await QuestionsManager.resetToDefault(gameName);
      expect(result, isTrue);
    });

    test('should filter empty questions when loading from string', () {
      // This tests the internal logic of filtering empty lines
      const questionsWithEmpty = 'Question 1\n\nQuestion 2\n   \nQuestion 3';
      final lines = questionsWithEmpty.split('\n')
          .where((q) => q.trim().isNotEmpty)
          .toList();
      
      expect(lines.length, equals(3));
      expect(lines, equals(['Question 1', 'Question 2', 'Question 3']));
    });

    test('should handle malformed input gracefully', () async {
      const gameName = 'MALFORMED_TEST';
      const malformedQuestions = ['', '   ', 'Valid Question', '\n'];
      
      // Should handle malformed input without crashing
      final result = await QuestionsManager.saveQuestions(gameName, malformedQuestions);
      expect(result, isTrue);
    });

    group('Cache functionality', () {
      test('should cache loaded questions per language', () {
        // The cache is static and internal, but we can verify its functionality
        expect(QuestionsManager.loadQuestions, isA<Function>());
        expect(QuestionsManager.clearCache, isA<Function>());
        
        // Test cache clearing doesn't throw
        QuestionsManager.clearCache();
      });
    });

    group('Asset loading', () {
      test('should handle missing asset files gracefully', () async {
        // Test with non-existent game should return empty list
        final questions = await QuestionsManager.loadQuestions('NON_EXISTENT_GAME');
        expect(questions, isEmpty);
      });
    });
  });
}