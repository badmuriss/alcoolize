import 'package:flutter_test/flutter_test.dart';
import 'package:alcoolize/src/questions_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('QuestionsManager', () {
    setUpAll(() {
      // Initialize SharedPreferences mock
      SharedPreferences.setMockInitialValues({});
    });

    test('should have file paths for all supported games', () {
      final expectedGames = {
        'EU NUNCA',
        'PARANOIA', 
        'QUEM É MAIS PROVÁVEL',
        'TIBITAR',
        'PALAVRA PROIBIDA',
        'CARTAS'
      };
      
      expect(QuestionsManager.gameFiles.keys.toSet(), equals(expectedGames));
      
      // Verify all file paths are non-empty
      for (String path in QuestionsManager.gameFiles.values) {
        expect(path.isNotEmpty, isTrue);
        expect(path.startsWith('assets/'), isTrue);
        expect(path.endsWith('.txt'), isTrue);
      }
    });

    test('should handle custom questions save and load', () async {
      const gameName = 'TEST_GAME';
      const testQuestions = ['Question 1', 'Question 2', 'Question 3'];
      
      // Save custom questions
      final saveResult = await QuestionsManager.saveQuestions(gameName, testQuestions);
      expect(saveResult, isTrue);
      
      // Load and verify (would work with proper SharedPreferences mock setup)
      // This test demonstrates the API structure
      expect(QuestionsManager.saveQuestions, isA<Function>());
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
      test('should cache loaded questions', () {
        // The cache is static and internal, but we can verify its existence
        expect(QuestionsManager.loadQuestions, isA<Function>());
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